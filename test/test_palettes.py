import importlib.util
import json
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
ROOT = pathlib.Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('generator', ROOT / 'tools/generate-palettes.py')
g = importlib.util.module_from_spec(spec)
spec.loader.exec_module(g)

class PaletteTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.source = json.loads((ROOT / 'data/madoromi.json').read_text())

    def test_all_flavours_slots_and_ansi(self):
        out = g.render(self.source)
        self.assertEqual(len(self.source['flavours']), 8)
        self.assertEqual(out.count('("selection" .'), 8)
        self.assertEqual(out.count('. ["#'), 8)
        for f in self.source['flavours'].values():
            self.assertEqual(len(f['ansi']), 16)

    def test_washes_match_independent_upstream_reference(self):
        reference = json.loads((ROOT / 'test/wash-reference.json').read_text())
        output = g.render(self.source)
        for flavour, washes in reference['washes'].items():
            start = output.index(f'    ({flavour} . (')
            next_flavour = output.find('\n    (', start + 5)
            block = output[start:next_flavour if next_flavour >= 0 else len(output)]
            for key, expected in washes.items():
                match = re.search(f'''\\("{re.escape(key)}" \\. "(#[0-9a-f]{{6}})"\\)''', block)
                self.assertIsNotNone(match, f'missing {flavour}/{key}')
                self.assertEqual(match.group(1), expected, f'{flavour}/{key}')

    def test_deterministic_and_check(self):
        self.assertEqual(g.render(self.source), g.render(self.source))
        r = subprocess.run([sys.executable, str(ROOT / 'tools/generate-palettes.py'), '--check'], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)

    def test_invalid_data_rejected(self):
        bad = json.loads(json.dumps(self.source))
        bad['flavours']['haru-hiru']['ansi'].pop()
        with self.assertRaisesRegex(ValueError, '16 hex'):
            g.validate(bad)

    def test_invalid_palette_data_is_rejected(self):
        cases = []
        missing = json.loads(json.dumps(self.source))
        del missing['flavours']['haru-hiru']['colours']['kami']
        cases.append((missing, 'missing slot'))
        bad_hex = json.loads(json.dumps(self.source))
        bad_hex['flavours']['haru-hiru']['colours']['kami']['hex'] = 'not-a-colour'
        cases.append((bad_hex, 'hex'))
        bad_lch = json.loads(json.dumps(self.source))
        bad_lch['flavours']['haru-hiru']['colours']['kami']['oklch'][0] = float('nan')
        cases.append((bad_lch, 'finite'))
        bad_names = json.loads(json.dumps(self.source))
        bad_names['flavours']['fake'] = bad_names['flavours'].pop('haru-hiru')
        cases.append((bad_names, 'flavour'))
        bad_dark = json.loads(json.dumps(self.source))
        bad_dark['flavours']['haru-hiru']['dark'] = True
        cases.append((bad_dark, 'dark'))
        for data, message in cases:
            with self.subTest(message=message), self.assertRaises(ValueError):
                g.validate(data)

    def test_bad_source_does_not_clobber_generated_file(self):
        original = (ROOT / 'madoromi-palette.el').read_bytes()
        with tempfile.TemporaryDirectory() as directory:
            bad = pathlib.Path(directory) / 'bad.json'
            bad.write_text('{}')
            result = subprocess.run([sys.executable, str(ROOT / 'tools/generate-palettes.py'), '--source', str(bad)], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertIn('palette generation failed', result.stderr)
        self.assertEqual((ROOT / 'madoromi-palette.el').read_bytes(), original)

    def test_check_rejects_missing_output(self):
        with tempfile.TemporaryDirectory() as d:
            root = pathlib.Path(d)
            (root / 'tools').mkdir()
            (root / 'data').mkdir()
            (root / 'tools/generate-palettes.py').write_text((ROOT / 'tools/generate-palettes.py').read_text())
            (root / 'data/madoromi.json').write_text(json.dumps(self.source))
            r = subprocess.run([sys.executable, str(root / 'tools/generate-palettes.py'), '--check'], capture_output=True, text=True)
            self.assertEqual(r.returncode, 1)
            self.assertIn('stale', r.stderr)

    def test_preserves_every_source_slot_and_ansi_value(self):
        output = g.render(self.source)
        for flavour, source in self.source["flavours"].items():
            with self.subTest(flavour=flavour):
                start = output.index(f"    ({flavour} . (")
                end = output.find("\n    (", start + 5)
                block = output[start:end if end >= 0 else len(output)]
                for slot in g.SLOTS:
                    self.assertIn(f'("{slot}" . "{source["colours"][slot]["hex"]}")', block)
                ansi = " ".join(f'"{value}"' for value in source["ansi"])
                self.assertIn(f"({flavour} . [{ansi}])", output)

    def test_generation_ignores_json_object_key_order(self):
        reordered = json.loads(json.dumps(self.source))
        reordered["flavours"] = dict(reversed(list(reordered["flavours"].items())))
        self.assertEqual(g.render(reordered), g.render(self.source))

    def test_non_object_sources_are_rejected(self):
        for source in (None, [], "invalid"):
            with self.subTest(source=source), self.assertRaisesRegex(ValueError, "object"):
                g.validate(source)

    def test_invalid_oklch_and_flavour_objects_are_rejected(self):
        for value in (True, float("inf"), -1, 2):
            source = json.loads(json.dumps(self.source))
            source["flavours"]["haru-hiru"]["colours"]["kami"]["oklch"][0] = value
            with self.subTest(value=value), self.assertRaises(ValueError):
                g.validate(source)
        source = json.loads(json.dumps(self.source))
        source["flavours"]["haru-hiru"] = None
        with self.assertRaisesRegex(ValueError, "object"):
            g.validate(source)

    def test_check_rejects_existing_stale_output(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            (root / "tools").mkdir()
            (root / "data").mkdir()
            shutil.copyfile(ROOT / "tools/generate-palettes.py", root / "tools/generate-palettes.py")
            shutil.copyfile(ROOT / "data/madoromi.json", root / "data/madoromi.json")
            target = root / "madoromi-palette.el"
            target.write_text("stale palette")
            result = subprocess.run(
                [sys.executable, str(root / "tools/generate-palettes.py"), "--check"],
                capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn("stale", result.stderr)
            self.assertEqual(target.read_text(), "stale palette")

    def test_gamut_and_rounding_match_upstream_typescript(self):
        # Evaluated with the original color.ts toSrgbGamut + oklabToHex.
        cases = [
            ((0.6, 0.5, 0.5), "#cf5500"),
            ((0.5, -0.4, 0.4), "#3a7400"),
            ((1.2, 0.1, 0.1), "#ffffff"),
            ((-0.2, 0.1, 0.1), "#000000"),
            ((0.5, 0, 0), "#636363"),
        ]
        for lab, expected in cases:
            with self.subTest(lab=lab):
                self.assertEqual(g.lab_hex(lab), expected)

if __name__ == '__main__':
    unittest.main()
