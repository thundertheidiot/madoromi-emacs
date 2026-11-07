#!/usr/bin/env python3
"""Generate standalone Emacs Lisp palettes from vendored MPL-2.0 palette data.

Color conversion follows madoromi/src/core/color.ts at SOURCE_COMMIT.
No external packages, Bun, or source ink scans are required.
"""

import argparse
import json
import math
import os
from pathlib import Path
import re
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE_COMMIT = "f8bcc5aa1ec3f731fcba9471be7caa5df1ab5695"
SLOTS = (
    "kami hyoshi chitsu nijimi0 nijimi1 nijimi2 kasure0 kasure1 kasure2 "
    "usuzumi0 usuzumi1 sumi sakura nadeshiko botan fuji kikyo beni akane "
    "kaki yamabuki wakaba tokiwa sora ruri ai"
).split()
FLAVOURS = tuple(
    f"{season}-{mode}"
    for mode in ("hiru", "yoru")
    for season in ("haru", "natsu", "aki", "fuyu")
)
EXPECTED_FLAVOURS = set(FLAVOURS)
HEX_RE = re.compile(r"#[0-9a-fA-F]{6}")
WASHES = {
    "selection": ("nijimi2", 0.575),
    "cursor-line": ("nijimi0", 0.45),
    "search": ("kaki", 0.35),
    "search-other": ("kaki", 0.18),
    "diff-add-bg": ("wakaba", 0.10),
    "diff-del-bg": ("beni", 0.10),
    "diff-chg-bg": ("ai", 0.12),
    "diff-add-text-bg": ("wakaba", 0.18),
    "diff-del-text-bg": ("beni", 0.18),
    "diff-chg-text-bg": ("ai", 0.28),
    "error-bg": ("beni", 0.10),
    "warning-bg": ("yamabuki", 0.10),
    "info-bg": ("sora", 0.10),
    "hint-bg": ("tokiwa", 0.10),
}


def oklab_to_linear(lightness, a, b):
    """Convert OKLab to linear sRGB using the upstream matrix."""
    l = (lightness + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (lightness - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (lightness - 0.0894841775 * a - 1.291485548 * b) ** 3
    return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s,
    )


def in_gamut(rgb):
    return all(-1e-4 <= channel <= 1.0001 for channel in rgb)


def lab_hex(lab):
    """Gamut-map at constant lightness/hue, then encode with JS rounding."""
    lightness, a, b = lab
    lightness = min(1.0, max(0.0, lightness))
    rgb = oklab_to_linear(lightness, a, b)
    if not in_gamut(rgb):
        low, high = 0.0, 1.0
        for _ in range(16):
            middle = (low + high) / 2
            if in_gamut(oklab_to_linear(lightness, a * middle, b * middle)):
                low = middle
            else:
                high = middle
        rgb = oklab_to_linear(lightness, a * low, b * low)

    def encode(channel):
        channel = min(1.0, max(0.0, channel))
        srgb = (12.92 * channel if channel <= 0.0031308
                else 1.055 * channel ** (1 / 2.4) - 0.055)
        return math.floor(srgb * 255 + 0.5)

    return "#" + "".join(f"{encode(channel):02x}" for channel in rgb)


def lab_from_lch(lch):
    lightness, chroma, hue = lch
    radians = math.radians(hue % 360)
    return lightness, chroma * math.cos(radians), chroma * math.sin(radians)


def valid_hex(value):
    return isinstance(value, str) and HEX_RE.fullmatch(value) is not None


def validate(source):
    """Reject malformed source before producing or replacing any output."""
    if not isinstance(source, dict):
        raise ValueError("palette source must be an object")
    flavours = source.get("flavours")
    if not isinstance(flavours, dict) or set(flavours) != EXPECTED_FLAVOURS:
        raise ValueError("flavours must contain exactly the eight expected names")
    for name, flavour in flavours.items():
        if not isinstance(flavour, dict):
            raise ValueError(f"{name}: flavour must be an object")
        colours = flavour.get("colours")
        if not isinstance(colours, dict):
            raise ValueError(f"{name}: colours must be an object")
        for slot in SLOTS:
            colour = colours.get(slot)
            if not isinstance(colour, dict):
                raise ValueError(f"{name}: missing slot {slot}")
            if not valid_hex(colour.get("hex")):
                raise ValueError(f"{name}/{slot}: invalid hex colour")
            lch = colour.get("oklch")
            if (not isinstance(lch, list) or len(lch) != 3 or any(
                isinstance(value, bool) or not isinstance(value, (int, float))
                or not math.isfinite(value) for value in lch
            )):
                raise ValueError(f"{name}/{slot}: OKLCH must be three finite numbers")
            if not (0 <= lch[0] <= 1 and 0 <= lch[1] <= 1):
                raise ValueError(f"{name}/{slot}: OKLCH lightness/chroma out of range")
        ansi = flavour.get("ansi")
        if (not isinstance(ansi, list) or len(ansi) != 16
                or not all(valid_hex(value) for value in ansi)):
            raise ValueError(f"{name}: ANSI palette must contain 16 hex colours")
        if flavour.get("dark") is not name.endswith("-yoru"):
            raise ValueError(f"{name}: dark flag does not match flavour mode")
        season, mode = name.split("-")
        if flavour.get("season") != season or flavour.get("mode") != mode:
            raise ValueError(f"{name}: season/mode do not match flavour name")


def render(source):
    """Render palettes in stable order, preserving upstream slot/ANSI hex values."""
    validate(source)
    lines = [
        ";;; madoromi-palette.el --- Generated Madoromi palettes -*- lexical-binding: t; -*-",
        ";; SPDX-License-Identifier: MPL-2.0",
        ";; Palette design/data: samhain / the-moonwitch, madoromi.",
        ";; https://github.com/the-moonwitch/madoromi",
        f";; Source commit: {SOURCE_COMMIT}; see data/MPL-2.0.txt and NOTICE.",
        ";; Generated by tools/generate-palettes.py; do not edit.",
        "", ";;; Commentary:",
        ";; Literal palette values and preblended OKLab washes for eight flavours.",
        ";; Ink provenance is preserved in data/madoromi.json.",
        "", ";;; Code:", "", "(defconst madoromi--palettes", "  '(",
    ]
    for name in FLAVOURS:
        colours = source["flavours"][name]["colours"]
        entries = [(slot, colours[slot]["hex"]) for slot in SLOTS]
        paper = lab_from_lch(colours["kami"]["oklch"])
        for key, (slot, amount) in WASHES.items():
            ink = lab_from_lch(colours[slot]["oklch"])
            wash = lab_hex([bg + (fg - bg) * amount for bg, fg in zip(paper, ink)])
            entries.append((key, wash))
        lines.append(f"    ({name} . (" + "\n       ".join(
            f'("{key}" . "{value}")' for key, value in entries
        ) + "))")
    lines.extend([
        "    )", '  "Palettes keyed by flavour symbols; values use string slot keys.")',
        "", "(defconst madoromi--ansi-palettes", "  '(",
    ])
    for name in FLAVOURS:
        ansi = " ".join(f'"{value}"' for value in source["flavours"][name]["ansi"])
        lines.append(f"    ({name} . [{ansi}])")
    lines.extend([
        "    )", '  "Sixteen ANSI colours per flavour, normal then bright.")',
        "", "(defun madoromi-palette (flavour)",
        '  "Return the palette for FLAVOUR, or signal an error if unknown."',
        "  (or (alist-get flavour madoromi--palettes)",
        '      (error "Unknown Madoromi flavour: %S" flavour)))',
        "", "(provide 'madoromi-palette)", "", ";;; madoromi-palette.el ends here", "",
    ])
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="fail on generated drift")
    parser.add_argument("--source", type=Path, help="alternate upstream palette JSON")
    args = parser.parse_args()
    source = args.source or ROOT / "data/madoromi.json"
    target = ROOT / "madoromi-palette.el"
    temporary = None
    try:
        output = render(json.loads(source.read_text(encoding="utf-8")))
        if args.check:
            if not target.exists() or target.read_text(encoding="utf-8") != output:
                print(f"generated file is stale: {target}", file=sys.stderr)
                return 1
        else:
            with tempfile.NamedTemporaryFile(
                mode="w", encoding="utf-8", dir=target.parent, delete=False
            ) as stream:
                temporary = Path(stream.name)
                stream.write(output)
            os.chmod(temporary, 0o644)
            os.replace(temporary, target)
        return 0
    except (OSError, ValueError, KeyError, TypeError, OverflowError) as error:
        print(f"palette generation failed: {error}", file=sys.stderr)
        return 1
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()


if __name__ == "__main__":
    raise SystemExit(main())
