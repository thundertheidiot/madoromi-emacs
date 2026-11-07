;;; madoromi.el --- Madoromi color themes -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Bozhidar Batsov

;; Author: Bozhidar Batsov (original Batppuccin engine)
;; Derived from Batppuccin; palette design by samhain / the-moonwitch.
;; URL: https://github.com/the-moonwitch/madoromi
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: faces themes

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Shared color palettes and face-setting infrastructure for the Madoromi
;; family of themes.  This file is not a theme itself -- it is required by
;; the individual theme files (madoromi-haru-hiru-theme.el, etc.).
;;
;; Madoromi is an independent seasonal palette family derived from
;; Batppuccin Emacs by Bozhidar Batsov; its face coverage and customization
;; behavior retain the upstream foundation.

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defgroup madoromi nil
  "Madoromi theme family."
  :group 'faces
  :prefix "madoromi-"
  :link '(url-link :tag "GitHub" "https://github.com/the-moonwitch/madoromi")
  :tag "Madoromi")

(defcustom madoromi-scale-headings t
  "Whether to scale headings in org, outline, markdown, shr, and info.
Set to nil for uniform heading sizes.  The individual scale factors
are controlled by `madoromi-height-doc-title' and
`madoromi-height-1' through `madoromi-height-3'.  Takes effect on
theme load."
  :type 'boolean
  :group 'madoromi)

(defcustom madoromi-height-doc-title 1.4
  "Height multiplier for document titles (e.g. `org-document-title').
Only takes effect when `madoromi-scale-headings' is non-nil."
  :type 'number
  :group 'madoromi)

(defcustom madoromi-height-1 1.3
  "Height multiplier for level-1 headings.
Only takes effect when `madoromi-scale-headings' is non-nil."
  :type 'number
  :group 'madoromi)

(defcustom madoromi-height-2 1.2
  "Height multiplier for level-2 headings.
Only takes effect when `madoromi-scale-headings' is non-nil."
  :type 'number
  :group 'madoromi)

(defcustom madoromi-height-3 1.1
  "Height multiplier for level-3 headings.
Only takes effect when `madoromi-scale-headings' is non-nil."
  :type 'number
  :group 'madoromi)

(defcustom madoromi-italic-comments t
  "Whether to render comments in italic.
Set to nil if your font renders italics poorly.  Takes effect on
theme load."
  :type 'boolean
  :group 'madoromi)

(defcustom madoromi-flat-mode-line nil
  "Whether to render the mode line without its surrounding box.
When non-nil the mode line is flat (borderless), relying on the
background alone for separation.  Takes effect on theme load."
  :type 'boolean
  :group 'madoromi)

(defcustom madoromi-use-variable-pitch nil
  "Whether to render headings in a variable-pitch (proportional) font.
Applies to headings in org, outline, markdown, adoc, asciidoc, shr,
info and LaTeX.  Takes effect on theme load."
  :type 'boolean
  :group 'madoromi)

(defcustom madoromi-override-colors-alist '()
  "Alist of color overrides applied to all variants.
Each entry should be a cons cell (NAME . VALUE) where NAME is a
color name from any variant's palette and VALUE is the
replacement hex color string."
  :type '(alist :key-type string :value-type string)
  :group 'madoromi)

;;; Color Palettes
(defconst madoromi--palettes
  '(
    (haru-hiru . (("kami" . "#f6eff8")
                  ("hyoshi" . "#ece5ef")
                  ("chitsu" . "#e2dbe5")
                  ("nijimi0" . "#d9ccdd")
                  ("nijimi1" . "#c8bccd")
                  ("nijimi2" . "#b8acbd")
                  ("kasure0" . "#a99cad")
                  ("kasure1" . "#998d9e")
                  ("kasure2" . "#877b8c")
                  ("usuzumi0" . "#77697c")
                  ("usuzumi1" . "#6b5d70")
                  ("sumi" . "#584a5c")
                  ("sakura" . "#aa6e89")
                  ("nadeshiko" . "#d64891")
                  ("botan" . "#b25d9d")
                  ("fuji" . "#6928bd")
                  ("kikyo" . "#4760c0")
                  ("beni" . "#ce2700")
                  ("akane" . "#ee3244")
                  ("kaki" . "#fd5217")
                  ("yamabuki" . "#bda343")
                  ("wakaba" . "#5e8933")
                  ("tokiwa" . "#009162")
                  ("sora" . "#008bae")
                  ("ruri" . "#2678af")
                  ("ai" . "#1955bf")
                  ("selection" . "#d2c8d6")
                  ("cursor-line" . "#e9dfec")
                  ("search" . "#ffbeb3")
                  ("search-other" . "#fcd6d4")
                  ("diff-add-bg" . "#e6e5e5")
                  ("diff-del-bg" . "#f5dde2")
                  ("diff-chg-bg" . "#dbddf3")
                  ("diff-add-text-bg" . "#d9ddd5")
                  ("diff-del-text-bg" . "#f4cfd0")
                  ("diff-chg-text-bg" . "#b7c5eb")
                  ("error-bg" . "#f5dde2")
                  ("warning-bg" . "#f0e7e7")
                  ("info-bg" . "#e2e5f1")
                  ("hint-bg" . "#e2e6e8")))
    (natsu-hiru . (("kami" . "#e9f4f8")
                   ("hyoshi" . "#ddeaf0")
                   ("chitsu" . "#d3e1e6")
                   ("nijimi0" . "#bed6df")
                   ("nijimi1" . "#aec5ce")
                   ("nijimi2" . "#9fb5be")
                   ("kasure0" . "#8fa6ae")
                   ("kasure1" . "#80969f")
                   ("kasure2" . "#6f848d")
                   ("usuzumi0" . "#57717a")
                   ("usuzumi1" . "#4e6872")
                   ("sumi" . "#3b545e")
                   ("sakura" . "#aa6e89")
                   ("nadeshiko" . "#ce37a6")
                   ("botan" . "#b0599b")
                   ("fuji" . "#6526b9")
                   ("kikyo" . "#455cbd")
                   ("beni" . "#b53753")
                   ("akane" . "#d64891")
                   ("kaki" . "#ff5735")
                   ("yamabuki" . "#e3940b")
                   ("wakaba" . "#00915c")
                   ("tokiwa" . "#028e7f")
                   ("sora" . "#008bae")
                   ("ruri" . "#2e79b6")
                   ("ai" . "#526ccb")
                   ("selection" . "#bed0d7")
                   ("cursor-line" . "#d6e6ed")
                   ("search" . "#f9c3b7")
                   ("search-other" . "#f3dbd7")
                   ("diff-add-bg" . "#d6eae8")
                   ("diff-del-bg" . "#e7e2e7")
                   ("diff-chg-bg" . "#d5e4f4")
                   ("diff-add-text-bg" . "#c7e2db")
                   ("diff-del-text-bg" . "#e5d3d9")
                   ("diff-chg-text-bg" . "#bcceee")
                   ("error-bg" . "#e7e2e7")
                   ("warning-bg" . "#e9ebe5")
                   ("info-bg" . "#d6e9f1")
                   ("hint-bg" . "#d6eaec")))
    (aki-hiru . (("kami" . "#f8f0e9")
                 ("hyoshi" . "#f0e6dd")
                 ("chitsu" . "#e6dcd3")
                 ("nijimi0" . "#dfcebf")
                 ("nijimi1" . "#cebeaf")
                 ("nijimi2" . "#beae9f")
                 ("kasure0" . "#ae9e90")
                 ("kasure1" . "#9f8f81")
                 ("kasure2" . "#8d7d6f")
                 ("usuzumi0" . "#7d6b5a")
                 ("usuzumi1" . "#715f4f")
                 ("sumi" . "#5d4c3c")
                 ("sakura" . "#a26480")
                 ("nadeshiko" . "#c63368")
                 ("botan" . "#a1488d")
                 ("fuji" . "#581ca7")
                 ("kikyo" . "#6928bd")
                 ("beni" . "#a43b3b")
                 ("akane" . "#d80638")
                 ("kaki" . "#ff5635")
                 ("yamabuki" . "#e3940b")
                 ("wakaba" . "#7e8418")
                 ("tokiwa" . "#008b57")
                 ("sora" . "#178d9d")
                 ("ruri" . "#2973b0")
                 ("ai" . "#384dad")
                 ("selection" . "#d7c9be")
                 ("cursor-line" . "#ede0d6")
                 ("search" . "#ffc1af")
                 ("search-other" . "#fed7ca")
                 ("diff-add-bg" . "#ebe5d5")
                 ("diff-del-bg" . "#f2ded6")
                 ("diff-chg-bg" . "#dfdde3")
                 ("diff-add-text-bg" . "#e1dcc6")
                 ("diff-del-text-bg" . "#eccfc8")
                 ("diff-chg-text-bg" . "#bec3db")
                 ("error-bg" . "#f2ded6")
                 ("warning-bg" . "#f7e7d7")
                 ("info-bg" . "#e5e6e1")
                 ("hint-bg" . "#e4e6da")))
    (fuyu-hiru . (("kami" . "#f0f1f8")
                  ("hyoshi" . "#e5e7f3")
                  ("chitsu" . "#dbdde9")
                  ("nijimi0" . "#ccd0e4")
                  ("nijimi1" . "#bcc0d3")
                  ("nijimi2" . "#acb0c3")
                  ("kasure0" . "#9ca0b3")
                  ("kasure1" . "#8d91a4")
                  ("kasure2" . "#7b7f91")
                  ("usuzumi0" . "#696d83")
                  ("usuzumi1" . "#5e6277")
                  ("sumi" . "#4a4e63")
                  ("sakura" . "#aa6e89")
                  ("nadeshiko" . "#b560a0")
                  ("botan" . "#a74f93")
                  ("fuji" . "#5e21b0")
                  ("kikyo" . "#3d53b4")
                  ("beni" . "#bb355a")
                  ("akane" . "#e1376f")
                  ("kaki" . "#ff5635")
                  ("yamabuki" . "#e3940b")
                  ("wakaba" . "#618c32")
                  ("tokiwa" . "#028e7f")
                  ("sora" . "#2678af")
                  ("ruri" . "#2266a4")
                  ("ai" . "#4a63c3")
                  ("selection" . "#c8cbda")
                  ("cursor-line" . "#dfe2ef")
                  ("search" . "#fdc1b7")
                  ("search-other" . "#f8d9d7")
                  ("diff-add-bg" . "#e1e7e5")
                  ("diff-del-bg" . "#eddfe7")
                  ("diff-chg-bg" . "#dae0f3")
                  ("diff-add-text-bg" . "#d5dfd5")
                  ("diff-del-text-bg" . "#ebd1da")
                  ("diff-chg-text-bg" . "#bec9ec")
                  ("error-bg" . "#eddfe7")
                  ("warning-bg" . "#efe9e5")
                  ("info-bg" . "#dce5f1")
                  ("hint-bg" . "#dde7ec")))
    (haru-yoru . (("kami" . "#241c26")
                  ("hyoshi" . "#1c151f")
                  ("chitsu" . "#160f18")
                  ("nijimi0" . "#392e3c")
                  ("nijimi1" . "#4e4352")
                  ("nijimi2" . "#615665")
                  ("kasure0" . "#756a7a")
                  ("kasure1" . "#8a7e8f")
                  ("kasure2" . "#9f93a4")
                  ("usuzumi0" . "#b7a8bd")
                  ("usuzumi1" . "#cdbed3")
                  ("sumi" . "#e1d1e7")
                  ("sakura" . "#ffc5da")
                  ("nadeshiko" . "#ffadda")
                  ("botan" . "#fe8dc0")
                  ("fuji" . "#ddb3ff")
                  ("kikyo" . "#99b2f5")
                  ("beni" . "#ff8b79")
                  ("akane" . "#ffa2b5")
                  ("kaki" . "#ffbb74")
                  ("yamabuki" . "#ffc849")
                  ("wakaba" . "#c1dd4a")
                  ("tokiwa" . "#7bd6b6")
                  ("sora" . "#88d9eb")
                  ("ruri" . "#60c9f3")
                  ("ai" . "#6eadff")
                  ("selection" . "#463c49")
                  ("cursor-line" . "#2d2430")
                  ("search" . "#684f43")
                  ("search-other" . "#453535")
                  ("diff-add-bg" . "#312d2d")
                  ("diff-del-bg" . "#36262f")
                  ("diff-chg-bg" . "#2d2b3c")
                  ("diff-add-text-bg" . "#3c3b32")
                  ("diff-del-text-bg" . "#462f35")
                  ("diff-chg-text-bg" . "#3a415c")
                  ("error-bg" . "#36262f")
                  ("warning-bg" . "#362b2d")
                  ("info-bg" . "#2e2c37")
                  ("hint-bg" . "#2d2c33")))
    (natsu-yoru . (("kami" . "#132227")
                   ("hyoshi" . "#0e1a1f")
                   ("chitsu" . "#091317")
                   ("nijimi0" . "#23363d")
                   ("nijimi1" . "#374b53")
                   ("nijimi2" . "#4a5f66")
                   ("kasure0" . "#5d737b")
                   ("kasure1" . "#728790")
                   ("kasure2" . "#869da5")
                   ("usuzumi0" . "#97b3be")
                   ("usuzumi1" . "#adcad4")
                   ("sumi" . "#c0dde8")
                   ("sakura" . "#ffbde2")
                   ("nadeshiko" . "#dd9fbf")
                   ("botan" . "#f894d8")
                   ("fuji" . "#aea8ff")
                   ("kikyo" . "#87a7ff")
                   ("beni" . "#ff8c9f")
                   ("akane" . "#faa7ca")
                   ("kaki" . "#ffb66d")
                   ("yamabuki" . "#eec307")
                   ("wakaba" . "#b9d740")
                   ("tokiwa" . "#6cd2cc")
                   ("sora" . "#5cd7f5")
                   ("ruri" . "#3ec7e8")
                   ("ai" . "#4ab8ff")
                   ("selection" . "#32444a")
                   ("cursor-line" . "#1a2b31")
                   ("search" . "#5f5242")
                   ("search-other" . "#393a35")
                   ("diff-add-bg" . "#21322d")
                   ("diff-del-bg" . "#292c32")
                   ("diff-chg-bg" . "#1a313d")
                   ("diff-add-text-bg" . "#2d3f32")
                   ("diff-del-text-bg" . "#3b343b")
                   ("diff-chg-text-bg" . "#23485d")
                   ("error-bg" . "#292c32")
                   ("warning-bg" . "#26302c")
                   ("info-bg" . "#1b3138")
                   ("hint-bg" . "#1b3135")))
    (aki-yoru . (("kami" . "#271d14")
                 ("hyoshi" . "#20160e")
                 ("chitsu" . "#181008")
                 ("nijimi0" . "#3d3024")
                 ("nijimi1" . "#534538")
                 ("nijimi2" . "#66584b")
                 ("kasure0" . "#7b6c5e")
                 ("kasure1" . "#908072")
                 ("kasure2" . "#a59587")
                 ("usuzumi0" . "#beaa98")
                 ("usuzumi1" . "#d4c0ae")
                 ("sumi" . "#e8d3c1")
                 ("sakura" . "#ffb6cc")
                 ("nadeshiko" . "#dfa3c0")
                 ("botan" . "#f68fd6")
                 ("fuji" . "#d3a1ff")
                 ("kikyo" . "#aea8ff")
                 ("beni" . "#ff8672")
                 ("akane" . "#ff9cb5")
                 ("kaki" . "#ff9b8f")
                 ("yamabuki" . "#ffae1e")
                 ("wakaba" . "#bac105")
                 ("tokiwa" . "#58c59f")
                 ("sora" . "#5ac6f1")
                 ("ruri" . "#5ea3d4")
                 ("ai" . "#7f9bea")
                 ("selection" . "#4a3e32")
                 ("cursor-line" . "#31251b")
                 ("search" . "#6b463b")
                 ("search-other" . "#493127")
                 ("diff-add-bg" . "#342b18")
                 ("diff-del-bg" . "#39271c")
                 ("diff-chg-bg" . "#312b2b")
                 ("diff-add-text-bg" . "#3e371b")
                 ("diff-del-text-bg" . "#492e23")
                 ("diff-chg-text-bg" . "#3e3e4a")
                 ("error-bg" . "#39271c")
                 ("warning-bg" . "#392a19")
                 ("info-bg" . "#2e2c27")
                 ("hint-bg" . "#2e2c20")))
    (fuyu-yoru . (("kami" . "#1c1e2a")
                  ("hyoshi" . "#151722")
                  ("chitsu" . "#0f111b")
                  ("nijimi0" . "#2f3241")
                  ("nijimi1" . "#434757")
                  ("nijimi2" . "#565a6b")
                  ("kasure0" . "#6a6e7f")
                  ("kasure1" . "#7e8294")
                  ("kasure2" . "#9397aa")
                  ("usuzumi0" . "#a8adc4")
                  ("usuzumi1" . "#bec3db")
                  ("sumi" . "#d2d6eb")
                  ("sakura" . "#ffbee1")
                  ("nadeshiko" . "#dfa3c0")
                  ("botan" . "#d18bb7")
                  ("fuji" . "#bbb8ff")
                  ("kikyo" . "#aaa4ff")
                  ("beni" . "#ff8799")
                  ("akane" . "#ffa3d0")
                  ("kaki" . "#ff9b8f")
                  ("yamabuki" . "#ecba09")
                  ("wakaba" . "#aece34")
                  ("tokiwa" . "#5eccc5")
                  ("sora" . "#78d5fc")
                  ("ruri" . "#8ac3ff")
                  ("ai" . "#829eeb")
                  ("selection" . "#3c3f4e")
                  ("cursor-line" . "#242734")
                  ("search" . "#64484c")
                  ("search-other" . "#40333b")
                  ("diff-add-bg" . "#282e2f")
                  ("diff-del-bg" . "#302834")
                  ("diff-chg-bg" . "#272c3e")
                  ("diff-add-text-bg" . "#323b33")
                  ("diff-del-text-bg" . "#41303c")
                  ("diff-chg-text-bg" . "#363f5a")
                  ("error-bg" . "#302834")
                  ("warning-bg" . "#2d2d2f")
                  ("info-bg" . "#252e3c")
                  ("hint-bg" . "#242d37")))
    )
  "Palettes keyed by flavour symbols; values use string slot keys.")

(defconst madoromi--ansi-palettes
  '(
    (haru-hiru . ["#6b5d70" "#ce2700" "#5e8933" "#bda343" "#1955bf" "#b25d9d" "#009162" "#b8acbd" "#77697c" "#ce2700" "#4c7635" "#ad8f3a" "#1b43a5" "#a1488d" "#007d4f" "#c8bccd"])
    (natsu-hiru . ["#4e6872" "#b53753" "#00915c" "#e3940b" "#526ccb" "#b0599b" "#028e7f" "#9fb5be" "#57717a" "#b53753" "#007d4e" "#e3940b" "#4259ba" "#9e458a" "#087971" "#aec5ce"])
    (aki-hiru . ["#715f4f" "#a43b3b" "#7e8418" "#e3940b" "#384dad" "#a1488d" "#008b57" "#beae9f" "#7d6b5a" "#a43b3b" "#6d721d" "#e3940b" "#323b94" "#8f357b" "#00764a" "#cebeaf"])
    (fuyu-hiru . ["#5e6277" "#bb355a" "#618c32" "#e3940b" "#4a63c3" "#a74f93" "#028e7f" "#acb0c3" "#696d83" "#bb355a" "#4f7935" "#e3940b" "#3b50b0" "#953b81" "#087971" "#bcc0d3"])
    (haru-yoru . ["#4e4352" "#ff8b79" "#c1dd4a" "#ffc849" "#6eadff" "#fe8dc0" "#7bd6b6" "#cdbed3" "#615665" "#ffaba3" "#dcee73" "#ffe387" "#8ac3ff" "#f9b3d1" "#9de6cd" "#b7a8bd"])
    (natsu-yoru . ["#374b53" "#ff8c9f" "#b9d740" "#eec307" "#4ab8ff" "#f894d8" "#6cd2cc" "#adcad4" "#4a5f66" "#ffacc0" "#d3e864" "#f6dd00" "#74ccff" "#ffb1e6" "#95e1de" "#97b3be"])
    (aki-yoru . ["#534538" "#ff8672" "#bac105" "#ffae1e" "#7f9bea" "#f68fd6" "#58c59f" "#d4c0ae" "#66584b" "#ffa69c" "#ced500" "#ffcd53" "#95aff3" "#ffabe4" "#7bd6b6" "#beaa98"])
    (fuyu-yoru . ["#434757" "#ff8799" "#aece34" "#ecba09" "#829eeb" "#d18bb7" "#5eccc5" "#bec3db" "#565a6b" "#ffa7bb" "#c6e050" "#f3d401" "#99b2f5" "#dfa3c0" "#87dcd8" "#a8adc4"])
    )
  "Sixteen ANSI colours per flavour, normal then bright.")

(defun madoromi-palette (flavour)
  "Return the palette for FLAVOUR, or signal an error if unknown."
  (or (alist-get flavour madoromi--palettes)
      (error "Unknown Madoromi flavour: %S" flavour)))

(defconst madoromi--variants
  '(madoromi-haru-hiru madoromi-haru-yoru madoromi-natsu-hiru madoromi-natsu-yoru madoromi-aki-hiru madoromi-aki-yoru madoromi-fuyu-hiru madoromi-fuyu-yoru)
  "List of all Madoromi theme variants.")

(defconst madoromi--light-variants '(madoromi-haru-hiru madoromi-natsu-hiru madoromi-aki-hiru madoromi-fuyu-hiru)
  "Madoromi variants that pair with a light macOS title bar.")

;;; Face Application

(defvar madoromi--current nil
  "The currently active Madoromi theme, or nil.")

(defun madoromi--apply-theme (theme-name colors-alist)
  "Apply the Madoromi faces to THEME-NAME using COLORS-ALIST."
  (let* ((flavour (intern (string-remove-prefix "madoromi-" (symbol-name theme-name))))
         (ansi (cdr (assq flavour madoromi--ansi-palettes)))
         (merged (append madoromi-override-colors-alist colors-alist))
         (class '((class color) (min-colors 88))))
    (unless (and colors-alist (vectorp ansi) (= (length ansi) 16))
      (error "Unknown Madoromi palette for %s" theme-name))
    (cl-flet ((c (name)
                (or (cdr (assoc name merged))
                    (error "Missing Madoromi palette slot: %s" name))))
      (let ((h1 (if madoromi-scale-headings madoromi-height-1 1.0))
            (h2 (if madoromi-scale-headings madoromi-height-2 1.0))
            (h3 (if madoromi-scale-headings madoromi-height-3 1.0))
            (h-doc (if madoromi-scale-headings madoromi-height-doc-title 1.0))
            (comment-slant (if madoromi-italic-comments 'italic 'normal))
            (ml-box (unless madoromi-flat-mode-line
                      (list :line-width -1 :color (c "nijimi0"))))
            (ml-box-inactive (unless madoromi-flat-mode-line
                               (list :line-width -1 :color (c "hyoshi"))))
            (madoromi-color-warning-bg (c "warning-bg"))
            (vpitch (if madoromi-use-variable-pitch 'variable-pitch 'default))
            (madoromi-color-ai (c "ai"))
            (madoromi-color-akane (c "akane"))
            (madoromi-color-beni (c "beni"))
            (madoromi-color-botan (c "botan"))
            (madoromi-color-chitsu (c "chitsu"))
            (madoromi-color-cursor-line (c "cursor-line"))
            (madoromi-color-diff-add-bg (c "diff-add-bg"))
            (madoromi-color-diff-add-text-bg (c "diff-add-text-bg"))
            (madoromi-color-diff-chg-bg (c "diff-chg-bg"))
            (madoromi-color-diff-chg-text-bg (c "diff-chg-text-bg"))
            (madoromi-color-diff-del-bg (c "diff-del-bg"))
            (madoromi-color-diff-del-text-bg (c "diff-del-text-bg"))
            (madoromi-color-fuji (c "fuji"))
            (madoromi-color-hyoshi (c "hyoshi"))
            (madoromi-color-kaki (c "kaki"))
            (madoromi-color-kami (c "kami"))
            (madoromi-color-kasure0 (c "kasure0"))
            (madoromi-color-kasure1 (c "kasure1"))
            (madoromi-color-kasure2 (c "kasure2"))
            (madoromi-color-kikyo (c "kikyo"))
            (madoromi-color-nadeshiko (c "nadeshiko"))
            (madoromi-color-nijimi0 (c "nijimi0"))
            (madoromi-color-nijimi1 (c "nijimi1"))
            (madoromi-color-nijimi2 (c "nijimi2"))
            (madoromi-color-ruri (c "ruri"))
            (madoromi-color-sakura (c "sakura"))
            (madoromi-color-search (c "search"))
            (madoromi-color-search-other (c "search-other"))
            (madoromi-color-selection (c "selection"))
            (madoromi-color-sora (c "sora"))
            (madoromi-color-sumi (c "sumi"))
            (madoromi-color-tokiwa (c "tokiwa"))
            (madoromi-color-usuzumi0 (c "usuzumi0"))
            (madoromi-color-usuzumi1 (c "usuzumi1"))
            (madoromi-color-wakaba (c "wakaba"))
            (madoromi-color-yamabuki (c "yamabuki")))
        (custom-theme-set-faces
         theme-name

;;;; Built-in faces
;;;;; basic coloring
         `(default ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-kami))))
         `(cursor ((,class (:background ,madoromi-color-sakura))))
         `(fringe ((,class (:background ,madoromi-color-kami :foreground ,madoromi-color-nijimi2))))
         `(header-line ((,class (:background ,madoromi-color-chitsu :foreground ,madoromi-color-usuzumi1))))
         `(highlight ((,class (:background ,madoromi-color-nijimi1))))
         `(success ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(error ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(link ((,class (:foreground ,madoromi-color-sora :underline t))))
         `(link-visited ((,class (:foreground ,madoromi-color-kikyo :underline t))))
         `(button ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(minibuffer-prompt ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(minibuffer-nonselected ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai))))
         `(escape-glyph ((,class (:foreground ,madoromi-color-botan))))
         `(homoglyph ((,class (:foreground ,madoromi-color-botan))))
         `(tooltip ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0))))
         `(menu ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-hyoshi))))
         `(shadow ((,class (:foreground ,madoromi-color-kasure1))))
         `(region ((,class (:background ,madoromi-color-selection :extend t))))
         `(secondary-selection ((,class (:background ,madoromi-color-nijimi1 :extend t))))
         `(trailing-whitespace ((,class (:background ,madoromi-color-beni))))
         `(vertical-border ((,class (:foreground ,madoromi-color-nijimi1))))
         `(window-divider ((,class (:foreground ,madoromi-color-nijimi1))))
         `(window-divider-first-pixel ((,class (:foreground ,madoromi-color-nijimi1))))
         `(window-divider-last-pixel ((,class (:foreground ,madoromi-color-nijimi1))))
         `(widget-field ((,class (:background ,madoromi-color-nijimi0 :extend t))))

;;;;; fill-column-indicator
         `(fill-column-indicator ((,class (:foreground ,madoromi-color-nijimi0 :weight normal))))

;;;;; mode-line
         `(mode-line ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-chitsu
                                           :box ,ml-box))))
         `(mode-line-inactive ((,class (:foreground ,madoromi-color-kasure1 :background ,madoromi-color-chitsu
                                                    :box ,ml-box-inactive))))
         `(mode-line-buffer-id ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(mode-line-emphasis ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(mode-line-highlight ((,class (:foreground ,madoromi-color-fuji))))

;;;;; ansi-colors
         `(ansi-color-black ((,class (:foreground ,(aref ansi 0) :background ,(aref ansi 0)))))
         `(ansi-color-bright-black ((,class (:foreground ,(aref ansi 8) :background ,(aref ansi 8)))))
         `(ansi-color-red ((,class (:foreground ,(aref ansi 1) :background ,(aref ansi 1)))))
         `(ansi-color-bright-red ((,class (:foreground ,(aref ansi 9) :background ,(aref ansi 9)))))
         `(ansi-color-green ((,class (:foreground ,(aref ansi 2) :background ,(aref ansi 2)))))
         `(ansi-color-bright-green ((,class (:foreground ,(aref ansi 10) :background ,(aref ansi 10)))))
         `(ansi-color-yellow ((,class (:foreground ,(aref ansi 3) :background ,(aref ansi 3)))))
         `(ansi-color-bright-yellow ((,class (:foreground ,(aref ansi 11) :background ,(aref ansi 11)))))
         `(ansi-color-blue ((,class (:foreground ,(aref ansi 4) :background ,(aref ansi 4)))))
         `(ansi-color-bright-blue ((,class (:foreground ,(aref ansi 12) :background ,(aref ansi 12)))))
         `(ansi-color-magenta ((,class (:foreground ,(aref ansi 5) :background ,(aref ansi 5)))))
         `(ansi-color-bright-magenta ((,class (:foreground ,(aref ansi 13) :background ,(aref ansi 13)))))
         `(ansi-color-cyan ((,class (:foreground ,(aref ansi 6) :background ,(aref ansi 6)))))
         `(ansi-color-bright-cyan ((,class (:foreground ,(aref ansi 14) :background ,(aref ansi 14)))))
         `(ansi-color-white ((,class (:foreground ,(aref ansi 7) :background ,(aref ansi 7)))))
         `(ansi-color-bright-white ((,class (:foreground ,(aref ansi 15) :background ,(aref ansi 15)))))

;;;;; font-lock
         `(font-lock-builtin-face ((,class (:foreground ,madoromi-color-beni))))
         `(font-lock-comment-face ((,class (:foreground ,madoromi-color-kasure2 :slant ,comment-slant))))
         `(font-lock-comment-delimiter-face ((,class (:foreground ,madoromi-color-kasure2 :slant ,comment-slant))))
         `(font-lock-constant-face ((,class (:foreground ,madoromi-color-kaki))))
         `(font-lock-doc-face ((,class (:foreground ,madoromi-color-kasure2 :slant ,comment-slant))))
         `(font-lock-doc-markup-face ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(font-lock-function-name-face ((,class (:foreground ,madoromi-color-ai))))
         `(font-lock-function-call-face ((,class (:foreground ,madoromi-color-ai))))
         `(font-lock-keyword-face ((,class (:foreground ,madoromi-color-fuji))))
         `(font-lock-negation-char-face ((,class (:foreground ,madoromi-color-sora))))
         `(font-lock-number-face ((,class (:foreground ,madoromi-color-kaki))))
         `(font-lock-operator-face ((,class (:foreground ,madoromi-color-sora))))
         `(font-lock-preprocessor-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(font-lock-regexp-grouping-construct ((,class (:foreground ,madoromi-color-botan :weight bold))))
         `(font-lock-regexp-grouping-backslash ((,class (:foreground ,madoromi-color-botan :weight bold))))
         `(font-lock-string-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(font-lock-type-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(font-lock-variable-name-face ((,class (:foreground ,madoromi-color-sumi))))
         `(font-lock-variable-use-face ((,class (:foreground ,madoromi-color-sumi))))
         `(font-lock-warning-face ((,class (:inherit warning))))
         `(font-lock-property-name-face ((,class (:foreground ,madoromi-color-ruri))))
         `(font-lock-property-use-face ((,class (:foreground ,madoromi-color-ruri))))
         `(font-lock-bracket-face ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(font-lock-delimiter-face ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(font-lock-escape-face ((,class (:foreground ,madoromi-color-botan))))
         `(font-lock-misc-punctuation-face ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; line numbers
         `(line-number ((,class (:foreground ,madoromi-color-nijimi2 :background ,madoromi-color-kami))))
         `(line-number-current-line ((,class (:foreground ,madoromi-color-fuji :background ,madoromi-color-kami :weight bold))))
         `(line-number-major-tick ((,class (:foreground ,madoromi-color-usuzumi0 :background ,madoromi-color-kami))))
         `(line-number-minor-tick ((,class (:foreground ,madoromi-color-kasure0 :background ,madoromi-color-kami))))

;;;;; isearch / replace
         `(isearch ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search :weight bold))))
         `(isearch-fail ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-nijimi0))))
         `(isearch-group-1 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai))))
         `(isearch-group-2 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-tokiwa))))
         `(lazy-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search-other))))
         `(match ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-tokiwa :weight bold))))
         `(query-replace ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search :weight bold))))

;;;;; show-paren
         `(show-paren-match ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold))))
         `(show-paren-match-expression ((,class (:background ,madoromi-color-nijimi0))))
         `(show-paren-mismatch ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni :weight bold :underline t))))

;;;;; completions
         `(completions-annotations ((,class (:foreground ,madoromi-color-kasure2))))
         `(completions-common-part ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(completions-first-difference ((,class (:foreground ,madoromi-color-kaki))))
         `(completions-highlight ((,class (:background ,madoromi-color-nijimi0))))
         `(completions-group-title ((,class (:foreground ,madoromi-color-fuji :weight bold :slant italic))))
         `(completions-group-separator ((,class (:foreground ,madoromi-color-kasure2 :strike-through t))))

;;;;; compilation
         `(compilation-error ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(compilation-warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(compilation-info ((,class (:foreground ,madoromi-color-tokiwa))))
         `(compilation-mode-line-exit ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(compilation-mode-line-fail ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(compilation-mode-line-run ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(compilation-line-number ((,class (:foreground ,madoromi-color-kasure1))))
         `(compilation-column-number ((,class (:foreground ,madoromi-color-kasure1))))

;;;;; customize
         `(custom-variable-tag ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(custom-group-tag ((,class (:foreground ,madoromi-color-ai :weight bold :height 1.2))))
         `(custom-group-tag-1 ((,class (:foreground ,madoromi-color-fuji :weight bold :height 1.2))))
         `(custom-state ((,class (:foreground ,madoromi-color-wakaba))))
         `(custom-button ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0
                                               :box (:line-width 2 :color ,madoromi-color-nijimi1 :style released-button)))))
         `(custom-button-mouse ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1
                                                     :box (:line-width 2 :color ,madoromi-color-nijimi1 :style released-button)))))
         `(custom-button-pressed ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0
                                                       :box (:line-width 2 :color ,madoromi-color-nijimi1 :style pressed-button)))))

;;;;; diff
         `(diff-added ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg :extend t))))
         `(diff-removed ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg :extend t))))
         `(diff-changed ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-diff-chg-bg :extend t))))
         `(diff-refine-added ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-diff-add-text-bg :weight bold :extend t))))
         `(diff-refine-removed ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-text-bg :weight bold :extend t))))
         `(diff-refine-changed ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-diff-chg-text-bg :weight bold :extend t))))
         `(diff-header ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-hyoshi :extend t))))
         `(diff-file-header ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-hyoshi :weight bold :extend t))))
         `(diff-hunk-header ((,class (:foreground ,madoromi-color-fuji :background ,madoromi-color-hyoshi :extend t))))
         `(diff-indicator-added ((,class (:foreground ,madoromi-color-wakaba))))
         `(diff-indicator-removed ((,class (:foreground ,madoromi-color-beni))))
         `(diff-indicator-changed ((,class (:foreground ,madoromi-color-ai))))
         `(diff-nonexistent ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; dired
         `(dired-directory ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(dired-flagged ((,class (:foreground ,madoromi-color-beni))))
         `(dired-header ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(dired-ignored ((,class (:foreground ,madoromi-color-kasure2))))
         `(dired-mark ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(dired-marked ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(dired-perm-write ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(dired-symlink ((,class (:foreground ,madoromi-color-sora))))
         `(dired-warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(dired-broken-symlink ((,class (:foreground ,madoromi-color-beni :weight bold))))

;;;;; diredfl
         `(diredfl-file-name ((,class (:inherit default))))
         `(diredfl-file-suffix ((,class (:inherit default))))
         `(diredfl-compressed-file-name ((,class (:foreground ,madoromi-color-wakaba))))
         `(diredfl-compressed-file-suffix ((,class (:foreground ,madoromi-color-wakaba))))
         `(diredfl-ignored-file-name ((,class (:inherit dired-ignored))))
         `(diredfl-deletion-file-name ((,class (:inherit dired-flagged))))
         `(diredfl-deletion ((,class (:inherit dired-flagged))))
         `(diredfl-dir-heading ((,class (:inherit dired-header))))
         `(diredfl-dir-name ((,class (:inherit dired-directory))))
         `(diredfl-dir-priv ((,class (:inherit dired-directory))))
         `(diredfl-symlink ((,class (:inherit dired-symlink))))
         `(diredfl-link-priv ((,class (:inherit dired-symlink))))
         `(diredfl-executable-tag ((,class (:foreground ,madoromi-color-beni))))
         `(diredfl-exec-priv ((,class (:foreground ,madoromi-color-beni))))
         `(diredfl-read-priv ((,class (:foreground ,madoromi-color-sora))))
         `(diredfl-write-priv ((,class (:inherit dired-perm-write))))
         `(diredfl-no-priv ((,class (:foreground ,madoromi-color-nijimi2))))
         `(diredfl-other-priv ((,class (:inherit diredfl-exec-priv))))
         `(diredfl-rare-priv ((,class (:inherit diredfl-exec-priv))))
         `(diredfl-date-time ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(diredfl-number ((,class (:foreground ,madoromi-color-yamabuki))))
         `(diredfl-flag-mark ((,class (:inherit dired-mark))))
         `(diredfl-flag-mark-line ((,class (:inherit dired-marked))))
         `(diredfl-autofile-name ((,class (:foreground ,madoromi-color-kikyo))))
         `(diredfl-tagged-autofile-name ((,class (:foreground ,madoromi-color-botan))))

;;;;; ediff
         `(ediff-current-diff-A ((,class (:background ,madoromi-color-diff-del-bg :extend t))))
         `(ediff-current-diff-B ((,class (:background ,madoromi-color-diff-add-bg :extend t))))
         `(ediff-current-diff-C ((,class (:background ,madoromi-color-diff-chg-bg :extend t))))
         `(ediff-fine-diff-A ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg :weight bold :extend t))))
         `(ediff-fine-diff-B ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg :weight bold :extend t))))
         `(ediff-fine-diff-C ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-diff-chg-bg :weight bold :extend t))))
         `(ediff-even-diff-A ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(ediff-even-diff-B ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(ediff-even-diff-C ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(ediff-odd-diff-A ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(ediff-odd-diff-B ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(ediff-odd-diff-C ((,class (:background ,madoromi-color-nijimi0 :extend t))))

;;;;; eshell
         `(eshell-prompt ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(eshell-ls-archive ((,class (:foreground ,madoromi-color-fuji))))
         `(eshell-ls-backup ((,class (:foreground ,madoromi-color-kasure2))))
         `(eshell-ls-clutter ((,class (:foreground ,madoromi-color-kasure2))))
         `(eshell-ls-directory ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(eshell-ls-executable ((,class (:foreground ,madoromi-color-wakaba))))
         `(eshell-ls-missing ((,class (:foreground ,madoromi-color-beni))))
         `(eshell-ls-product ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(eshell-ls-readonly ((,class (:foreground ,madoromi-color-kasure1))))
         `(eshell-ls-special ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(eshell-ls-symlink ((,class (:foreground ,madoromi-color-sora))))
         `(eshell-ls-unreadable ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; erc
         `(erc-action-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         `(erc-bold-face ((,class (:weight bold))))
         `(erc-current-nick-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(erc-default-face ((,class (:foreground ,madoromi-color-sumi))))
         `(erc-direct-msg-face ((,class (:foreground ,madoromi-color-kaki))))
         `(erc-error-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(erc-fool-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(erc-highlight-face ((,class (:background ,madoromi-color-nijimi0))))
         `(erc-input-face ((,class (:foreground ,madoromi-color-sumi))))
         `(erc-keyword-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(erc-my-nick-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(erc-nick-default-face ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(erc-nick-msg-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(erc-notice-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(erc-pal-face ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(erc-prompt-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(erc-timestamp-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(erc-underline-face ((,class (:underline t))))

;;;;; flymake
         `(flymake-error ((,class (:underline (:style wave :color ,madoromi-color-beni)))))
         `(flymake-warning ((,class (:underline (:style wave :color ,madoromi-color-yamabuki)))))
         `(flymake-note ((,class (:underline (:style wave :color ,madoromi-color-tokiwa)))))

;;;;; flyspell
         `(flyspell-duplicate ((,class (:underline (:style wave :color ,madoromi-color-yamabuki)))))
         `(flyspell-incorrect ((,class (:underline (:style wave :color ,madoromi-color-beni)))))

;;;;; gnus
         `(gnus-group-mail-1 ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(gnus-group-mail-1-empty ((,class (:foreground ,madoromi-color-ai))))
         `(gnus-group-mail-2 ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(gnus-group-mail-2-empty ((,class (:foreground ,madoromi-color-tokiwa))))
         `(gnus-group-mail-3 ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(gnus-group-mail-3-empty ((,class (:foreground ,madoromi-color-fuji))))
         `(gnus-group-mail-low ((,class (:foreground ,madoromi-color-kasure2 :weight bold))))
         `(gnus-group-mail-low-empty ((,class (:foreground ,madoromi-color-kasure2))))
         `(gnus-group-news-1 ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(gnus-group-news-1-empty ((,class (:foreground ,madoromi-color-ai))))
         `(gnus-group-news-2 ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(gnus-group-news-2-empty ((,class (:foreground ,madoromi-color-tokiwa))))
         `(gnus-group-news-low ((,class (:foreground ,madoromi-color-kasure2 :weight bold))))
         `(gnus-group-news-low-empty ((,class (:foreground ,madoromi-color-kasure2))))
         `(gnus-header-content ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(gnus-header-from ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(gnus-header-name ((,class (:foreground ,madoromi-color-fuji))))
         `(gnus-header-newsgroups ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(gnus-header-subject ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(gnus-summary-cancelled ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-nijimi0 :extend t))))
         `(gnus-summary-normal-ancient ((,class (:foreground ,madoromi-color-kasure2))))
         `(gnus-summary-normal-read ((,class (:foreground ,madoromi-color-kasure1))))
         `(gnus-summary-normal-ticked ((,class (:foreground ,madoromi-color-usuzumi1 :slant italic))))
         `(gnus-summary-normal-unread ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(gnus-summary-selected ((,class (:foreground ,madoromi-color-ai :weight bold :underline t))))

;;;;; grep
         `(grep-context-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(grep-error-face ((,class (:foreground ,madoromi-color-beni :weight bold :underline t))))
         `(grep-hit-face ((,class (:foreground ,madoromi-color-ai))))
         `(grep-match-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))

;;;;; hi-lock
         `(hi-blue ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai))))
         `(hi-green ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-wakaba))))
         `(hi-pink ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-botan))))
         `(hi-yellow ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-warning-bg))))
         `(hi-blue-b ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(hi-green-b ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(hi-red-b ((,class (:foreground ,madoromi-color-beni :weight bold))))

;;;;; hl-line
         `(hl-line ((,class (:background ,madoromi-color-cursor-line :extend t))))

;;;;; hl-todo
         `(hl-todo ((,class (:foreground ,madoromi-color-akane :weight bold))))

;;;;; icomplete
         `(icomplete-first-match ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(icomplete-selected-match ((,class (:background ,madoromi-color-nijimi0))))

;;;;; ido
         `(ido-first-match ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(ido-only-match ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(ido-subdir ((,class (:foreground ,madoromi-color-ai))))
         `(ido-incomplete-regexp ((,class (:foreground ,madoromi-color-beni))))
         `(ido-indicator ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni))))
         `(ido-virtual ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; info
         `(Info-quoted ((,class (:foreground ,madoromi-color-kaki :inherit fixed-pitch-serif))))
         `(info-header-node ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(info-header-xref ((,class (:foreground ,madoromi-color-tokiwa))))
         `(info-menu-header ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(info-menu-star ((,class (:foreground ,madoromi-color-beni))))
         `(info-node ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(info-title-1 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h1))))
         `(info-title-2 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h2))))
         `(info-title-3 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h3))))
         `(info-title-4 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(info-xref ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(info-xref-visited ((,class (:foreground ,madoromi-color-kikyo :underline t))))

;;;;; message (email composition)
         `(message-cited-text-1 ((,class (:foreground ,madoromi-color-tokiwa))))
         `(message-cited-text-2 ((,class (:foreground ,madoromi-color-wakaba))))
         `(message-cited-text-3 ((,class (:foreground ,madoromi-color-kasure2))))
         `(message-cited-text-4 ((,class (:foreground ,madoromi-color-kasure1))))
         `(message-header-cc ((,class (:foreground ,madoromi-color-ai))))
         `(message-header-name ((,class (:foreground ,madoromi-color-fuji))))
         `(message-header-newsgroups ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(message-header-other ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(message-header-subject ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(message-header-to ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(message-header-xheader ((,class (:foreground ,madoromi-color-kasure1))))
         `(message-mml ((,class (:foreground ,madoromi-color-wakaba))))
         `(message-separator ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; mu4e
         ;; Headers view – message flags
         `(mu4e-unread-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(mu4e-header-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(mu4e-flagged-face ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(mu4e-draft-face ((,class (:foreground ,madoromi-color-kaki :slant italic))))
         `(mu4e-trashed-face ((,class (:foreground ,madoromi-color-kasure2 :strike-through t))))
         `(mu4e-replied-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(mu4e-forwarded-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(mu4e-related-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         ;; Headers view – UI elements
         `(mu4e-header-title-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(mu4e-header-highlight-face ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(mu4e-header-marks-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(mu4e-header-key-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(mu4e-header-field-face ((,class (:foreground ,madoromi-color-fuji))))
         `(mu4e-header-value-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(mu4e-special-header-value-face ((,class (:foreground ,madoromi-color-sora))))
         ;; Message view
         `(mu4e-link-face ((,class (:foreground ,madoromi-color-tokiwa :underline t))))
         `(mu4e-contact-face ((,class (:foreground ,madoromi-color-ai))))
         `(mu4e-highlight-face ((,class (:foreground ,madoromi-color-sora :weight bold))))
         `(mu4e-title-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(mu4e-url-number-face ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(mu4e-footer-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         ;; Compose
         `(mu4e-compose-separator-face ((,class (:foreground ,madoromi-color-kasure2))))
         ;; System / mode-line
         `(mu4e-modeline-face ((,class (:foreground ,madoromi-color-ai))))
         `(mu4e-system-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         `(mu4e-ok-face ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(mu4e-warning-face ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(mu4e-region-code ((,class (:background ,madoromi-color-nijimi0))))
         ;; Threading
         `(mu4e-thread-fold-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))

;;;;; notmuch
         ;; Search view
         `(notmuch-search-date ((,class (:foreground ,madoromi-color-kasure1))))
         `(notmuch-search-count ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-search-subject ((,class (:foreground ,madoromi-color-sumi))))
         `(notmuch-search-matching-authors ((,class (:foreground ,madoromi-color-ai))))
         `(notmuch-search-non-matching-authors ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-search-flagged ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(notmuch-search-unread ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         ;; Tree view
         `(notmuch-tree-match-author-face ((,class (:foreground ,madoromi-color-ai))))
         `(notmuch-tree-match-date-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(notmuch-tree-match-subject-face ((,class (:foreground ,madoromi-color-sumi))))
         `(notmuch-tree-match-tree-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-tree-match-tag-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(notmuch-tree-no-match-author-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-tree-no-match-date-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-tree-no-match-subject-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(notmuch-tree-no-match-tree-face ((,class (:foreground ,madoromi-color-nijimi2))))
         `(notmuch-tree-no-match-tag-face ((,class (:foreground ,madoromi-color-kasure2))))
         ;; Show view
         `(notmuch-message-summary-face ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-hyoshi))))
         ;; Tags
         `(notmuch-tag-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(notmuch-tag-unread ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(notmuch-tag-flagged ((,class (:foreground ,madoromi-color-yamabuki))))
         `(notmuch-tag-deleted ((,class (:foreground ,madoromi-color-beni :strike-through t))))
         `(notmuch-tag-added ((,class (:foreground ,madoromi-color-wakaba :underline t))))
         ;; Wash (inline content toggling / citations)
         `(notmuch-wash-toggle-button ((,class (:foreground ,madoromi-color-kasure1 :background ,madoromi-color-hyoshi))))
         `(notmuch-wash-cited-text ((,class (:foreground ,madoromi-color-kasure2))))
         ;; Crypto
         `(notmuch-crypto-part-header ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(notmuch-crypto-signature-good ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(notmuch-crypto-signature-good-key ((,class (:foreground ,madoromi-color-wakaba))))
         `(notmuch-crypto-signature-bad ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(notmuch-crypto-signature-unknown ((,class (:foreground ,madoromi-color-yamabuki))))
         `(notmuch-crypto-decryption ((,class (:foreground ,madoromi-color-sora))))
         ;; Hello (welcome screen)
         `(notmuch-hello-logo-background ((,class (:background ,madoromi-color-hyoshi))))

;;;;; org-mode
         `(org-archived ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-block ((,class (:background ,madoromi-color-hyoshi :extend t))))
         `(org-block-begin-line ((,class (:foreground ,madoromi-color-kasure2 :background ,madoromi-color-hyoshi :extend t :slant italic))))
         `(org-block-end-line ((,class (:inherit org-block-begin-line))))
         `(org-checkbox ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(org-checkbox-statistics-done ((,class (:foreground ,madoromi-color-wakaba))))
         `(org-checkbox-statistics-todo ((,class (:foreground ,madoromi-color-kaki))))
         `(org-code ((,class (:foreground ,madoromi-color-tokiwa))))
         `(org-date ((,class (:foreground ,madoromi-color-sora :underline t))))
         `(org-document-info ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(org-document-info-keyword ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-document-title ((,class (:inherit ,vpitch :foreground ,madoromi-color-sumi :weight bold :height ,h-doc))))
         `(org-done ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(org-drawer ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-ellipsis ((,class (:foreground ,madoromi-color-kasure2 :underline nil))))
         `(org-footnote ((,class (:foreground ,madoromi-color-tokiwa))))
         `(org-formula ((,class (:foreground ,madoromi-color-kaki))))
         `(org-headline-done ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-hide ((,class (:foreground ,madoromi-color-kami))))
         `(org-level-1 ((,class (:inherit outline-1))))
         `(org-level-2 ((,class (:inherit outline-2))))
         `(org-level-3 ((,class (:inherit outline-3))))
         `(org-level-4 ((,class (:inherit outline-4))))
         `(org-level-5 ((,class (:inherit outline-5))))
         `(org-level-6 ((,class (:inherit outline-6))))
         `(org-level-7 ((,class (:inherit outline-7))))
         `(org-level-8 ((,class (:inherit outline-8))))
         `(org-link ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(org-meta-line ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-priority ((,class (:foreground ,madoromi-color-kaki))))
         `(org-property-value ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(org-quote ((,class (:foreground ,madoromi-color-usuzumi0 :slant italic :extend t))))
         `(org-scheduled ((,class (:foreground ,madoromi-color-wakaba))))
         `(org-scheduled-previously ((,class (:foreground ,madoromi-color-kaki))))
         `(org-scheduled-today ((,class (:foreground ,madoromi-color-wakaba))))
         `(org-special-keyword ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-table ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(org-tag ((,class (:foreground ,madoromi-color-kasure2 :weight normal))))
         `(org-target ((,class (:underline t))))
         `(org-time-grid ((,class (:foreground ,madoromi-color-kasure1))))
         `(org-todo ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(org-upcoming-deadline ((,class (:foreground ,madoromi-color-beni))))
         `(org-verbatim ((,class (:foreground ,madoromi-color-wakaba))))
         `(org-verse ((,class (:inherit org-quote))))
         `(org-warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(org-agenda-date ((,class (:foreground ,madoromi-color-ai))))
         `(org-agenda-date-today ((,class (:foreground ,madoromi-color-ai :weight bold :slant italic))))
         `(org-agenda-date-weekend ((,class (:foreground ,madoromi-color-kasure2))))
         `(org-agenda-date-weekend-today ((,class (:foreground ,madoromi-color-kasure2 :weight bold))))
         `(org-agenda-done ((,class (:foreground ,madoromi-color-wakaba))))
         `(org-agenda-structure ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(org-agenda-current-time ((,class (:foreground ,madoromi-color-sora))))

;;;;; outline
         `(outline-1 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h1))))
         `(outline-2 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h2))))
         `(outline-3 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h3))))
         `(outline-4 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(outline-5 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(outline-6 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(outline-7 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(outline-8 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))

;;;;; re-builder
         `(reb-match-0 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai))))
         `(reb-match-1 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-tokiwa))))
         `(reb-match-2 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-fuji))))
         `(reb-match-3 ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search))))

;;;;; ruler-mode
         `(ruler-mode-default ((,class (:foreground ,madoromi-color-kasure2 :background ,madoromi-color-hyoshi))))
         `(ruler-mode-column-number ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(ruler-mode-current-column ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(ruler-mode-fill-column ((,class (:foreground ,madoromi-color-beni))))

;;;;; sh-mode
         `(sh-heredoc ((,class (:foreground ,madoromi-color-wakaba :slant italic))))
         `(sh-quoted-exec ((,class (:foreground ,madoromi-color-kaki))))

;;;;; shr (eww/elfeed HTML rendering)
         `(shr-h1 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h1))))
         `(shr-h2 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h2))))
         `(shr-h3 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h3))))
         `(shr-h4 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(shr-h5 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(shr-h6 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(shr-link ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(shr-selected-link ((,class (:foreground ,madoromi-color-kaki :underline t))))
         `(shr-code ((,class (:foreground ,madoromi-color-tokiwa :background ,madoromi-color-hyoshi))))
         `(shr-mark ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-warning-bg))))

;;;;; tab-bar / tab-line
         `(tab-bar ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-chitsu))))
         `(tab-bar-tab ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-kami :weight bold))))
         `(tab-bar-tab-inactive ((,class (:foreground ,madoromi-color-kasure1 :background ,madoromi-color-hyoshi))))
         `(tab-bar-tab-ungrouped ((,class (:foreground ,madoromi-color-kasure2 :background ,madoromi-color-hyoshi))))
         `(tab-bar-tab-group-current ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-kami :weight bold))))
         `(tab-bar-tab-group-inactive ((,class (:foreground ,madoromi-color-kasure1 :background ,madoromi-color-hyoshi))))
         `(tab-line ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-chitsu))))
         `(tab-line-tab ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-kami :weight bold))))
         `(tab-line-tab-current ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-kami :weight bold))))
         `(tab-line-tab-inactive ((,class (:foreground ,madoromi-color-kasure1 :background ,madoromi-color-hyoshi))))
         `(tab-line-highlight ((,class (:background ,madoromi-color-nijimi0))))

;;;;; term / ansi-term / vterm
         `(term ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-kami))))
         `(term-color-black ((,class (:foreground ,(aref ansi 0) :background ,(aref ansi 0)))))
         `(term-color-red ((,class (:foreground ,(aref ansi 1) :background ,(aref ansi 1)))))
         `(term-color-green ((,class (:foreground ,(aref ansi 2) :background ,(aref ansi 2)))))
         `(term-color-yellow ((,class (:foreground ,(aref ansi 3) :background ,(aref ansi 3)))))
         `(term-color-blue ((,class (:foreground ,(aref ansi 4) :background ,(aref ansi 4)))))
         `(term-color-magenta ((,class (:foreground ,(aref ansi 5) :background ,(aref ansi 5)))))
         `(term-color-cyan ((,class (:foreground ,(aref ansi 6) :background ,(aref ansi 6)))))
         `(term-color-white ((,class (:foreground ,(aref ansi 7) :background ,(aref ansi 7)))))

;;;;; whitespace-mode
         `(whitespace-empty ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-nijimi0 :extend t))))
         `(whitespace-hspace ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-indentation ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-line ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-nijimi0))))
         `(whitespace-newline ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-space ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-space-after-tab ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-space-before-tab ((,class (:foreground ,madoromi-color-kaki))))
         `(whitespace-tab ((,class (:foreground ,madoromi-color-nijimi1))))
         `(whitespace-trailing ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg))))
         `(whitespace-big-indent ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni))))

;;;;; woman
         `(woman-bold ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(woman-italic ((,class (:foreground ,madoromi-color-fuji :slant italic))))

;;;;; xref
         `(xref-file-header ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(xref-line-number ((,class (:foreground ,madoromi-color-kasure1))))
         `(xref-match ((,class (:foreground ,madoromi-color-kaki :weight bold))))

;;;; Built-in packages
;;;;; bookmark
         `(bookmark-face ((,class (:foreground ,madoromi-color-yamabuki))))

;;;;; calendar
         `(calendar-today ((,class (:foreground ,madoromi-color-ai :weight bold :underline t))))
         `(calendar-weekend-header ((,class (:foreground ,madoromi-color-beni))))
         `(calendar-weekday-header ((,class (:foreground ,madoromi-color-tokiwa))))
         `(calendar-month-header ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(holiday ((,class (:foreground ,madoromi-color-kaki))))
         `(diary ((,class (:foreground ,madoromi-color-yamabuki))))

;;;;; completion-preview
         `(completion-preview ((,class (:foreground ,madoromi-color-kasure1))))
         `(completion-preview-common ((,class (:foreground ,madoromi-color-kasure2))))
         `(completion-preview-exact ((,class (:foreground ,madoromi-color-kasure2 :underline t))))

;;;;; dictionary
         `(dictionary-word-entry-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(dictionary-word-definition-face ((,class (:foreground ,madoromi-color-sumi))))
         `(dictionary-reference-face ((,class (:foreground ,madoromi-color-ruri :underline t))))
         `(dictionary-button-face ((,class (:foreground ,madoromi-color-ai :underline t :weight bold))))

;;;;; eglot
         `(eglot-highlight-symbol-face ((,class (:background ,madoromi-color-nijimi0 :weight bold))))
         `(eglot-diagnostic-tag-unnecessary-face ((,class (:foreground ,madoromi-color-kasure2 :underline (:style wave :color ,madoromi-color-kasure1)))))
         `(eglot-diagnostic-tag-deprecated-face ((,class (:foreground ,madoromi-color-kasure2 :strike-through ,madoromi-color-kasure1))))
         `(eglot-inlay-hint-face ((,class (:foreground ,madoromi-color-kasure1 :height 0.9))))

;;;;; eldoc
         `(eldoc-highlight-function-argument ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))

;;;;; epa (EasyPG)
         `(epa-field-body ((,class (:foreground ,madoromi-color-usuzumi1 :slant italic))))
         `(epa-field-name ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(epa-mark ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(epa-string ((,class (:foreground ,madoromi-color-wakaba))))
         `(epa-validity-disabled ((,class (:foreground ,madoromi-color-beni :slant italic))))
         `(epa-validity-high ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(epa-validity-low ((,class (:foreground ,madoromi-color-kasure2))))
         `(epa-validity-medium ((,class (:foreground ,madoromi-color-yamabuki))))

;;;;; eww
         `(eww-invalid-certificate ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(eww-valid-certificate ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(eww-form-text ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0
                                               :box (:line-width -1 :color ,madoromi-color-nijimi1)))))
         `(eww-form-textarea ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0))))
         `(eww-form-checkbox ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(eww-form-select ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0
                                                 :box (:line-width -1 :color ,madoromi-color-nijimi1)))))
         `(eww-form-submit ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1
                                                 :box (:line-width -1 :color ,madoromi-color-nijimi2)))))

;;;;; man
         `(Man-overstrike ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(Man-underline ((,class (:foreground ,madoromi-color-tokiwa :underline t))))
         `(Man-reverse ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-sumi))))

;;;;; proced
         `(proced-mark ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(proced-marked ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(proced-sort-header ((,class (:foreground ,madoromi-color-ai :weight bold :underline t))))

;;;;; pulse
         `(pulse-highlight-start-face ((,class (:background ,madoromi-color-nijimi1))))

;;;;; speedbar
         `(speedbar-button-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(speedbar-directory-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(speedbar-file-face ((,class (:foreground ,madoromi-color-sumi))))
         `(speedbar-highlight-face ((,class (:background ,madoromi-color-nijimi0))))
         `(speedbar-selected-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(speedbar-separator-face ((,class (:foreground ,madoromi-color-kasure2 :background ,madoromi-color-hyoshi))))
         `(speedbar-tag-face ((,class (:foreground ,madoromi-color-tokiwa))))

;;;;; vc
         `(vc-state-base ((,class (:foreground ,madoromi-color-wakaba))))
         `(vc-conflict-state ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(vc-edited-state ((,class (:foreground ,madoromi-color-yamabuki))))
         `(vc-locally-added-state ((,class (:foreground ,madoromi-color-wakaba))))
         `(vc-locked-state ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(vc-missing-state ((,class (:foreground ,madoromi-color-beni))))
         `(vc-needs-update-state ((,class (:foreground ,madoromi-color-kaki))))
         `(vc-removed-state ((,class (:foreground ,madoromi-color-beni))))
         `(vc-up-to-date-state ((,class (:foreground ,madoromi-color-wakaba))))

;;;;; diff-hl
         `(diff-hl-change ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-diff-chg-bg))))
         `(diff-hl-delete ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg))))
         `(diff-hl-insert ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg))))

;;;;; smerge
         `(smerge-base ((,class (:background ,madoromi-color-diff-chg-bg :extend t))))
         `(smerge-markers ((,class (:foreground ,madoromi-color-kasure2 :background ,madoromi-color-hyoshi :extend t))))
         `(smerge-upper ((,class (:background ,madoromi-color-diff-del-bg :extend t))))
         `(smerge-lower ((,class (:background ,madoromi-color-diff-add-bg :extend t))))
         `(smerge-refined-added ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg :weight bold :extend t))))
         `(smerge-refined-removed ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg :weight bold :extend t))))
         `(smerge-refined-changed ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-diff-chg-bg :weight bold :extend t))))

;;;; Third-party packages
;;;;; evil
         `(evil-ex-commands ((,class (:foreground ,madoromi-color-usuzumi1 :underline t :slant italic))))
         `(evil-ex-info ((,class (:foreground ,madoromi-color-beni :slant italic))))
         `(evil-ex-search ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-nadeshiko :weight bold))))
         `(evil-ex-lazy-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1))))
         `(evil-ex-substitute-matches ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1))))
         `(evil-ex-substitute-replacement ((,class (:foreground ,madoromi-color-kaki :underline t :weight bold))))

;;;;; anzu
         `(anzu-mode-line ((,class (:foreground ,madoromi-color-sora :weight bold))))
         `(anzu-mode-line-no-match ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(anzu-match-1 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai))))
         `(anzu-match-2 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-tokiwa))))
         `(anzu-match-3 ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search))))
         `(anzu-replace-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1))))
         `(anzu-replace-to ((,class (:foreground ,madoromi-color-kaki :underline t :weight bold))))

;;;;; avy
         `(avy-lead-face ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni :weight bold))))
         `(avy-lead-face-0 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-ai :weight bold))))
         `(avy-lead-face-1 ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold))))
         `(avy-lead-face-2 ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-tokiwa :weight bold))))
         `(avy-background-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(avy-goto-char-timer-face ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni))))

;;;;; breadcrumb
         `(breadcrumb-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(breadcrumb-imenu-leaf-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(breadcrumb-imenu-crumbs-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(breadcrumb-imenu-base-face ((,class (:foreground ,madoromi-color-kasure2 :weight bold))))
         `(breadcrumb-project-leaf-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(breadcrumb-project-crumbs-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(breadcrumb-project-base-face ((,class (:foreground ,madoromi-color-kasure2 :weight bold))))

;;;;; clojure-mode
         `(clojure-keyword-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(clojure-character-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(clojure-discard-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))

;;;;; cider
         `(cider-result-overlay-face ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-hyoshi
                                                           :box (:line-width -1 :color ,madoromi-color-nijimi0)))))
         `(cider-debug-code-overlay-face ((,class (:background ,madoromi-color-nijimi0))))
         `(cider-deprecated-face ((,class (:foreground ,madoromi-color-kasure2 :strike-through ,madoromi-color-kasure1))))
         `(cider-enlightened-face ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(cider-enlightened-local-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(cider-error-highlight-face ((,class (:underline (:style wave :color ,madoromi-color-beni)))))
         `(cider-warning-highlight-face ((,class (:underline (:style wave :color ,madoromi-color-yamabuki)))))
         `(cider-fringe-good-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(cider-instrumented-face ((,class (:background ,madoromi-color-diff-chg-bg))))
         `(cider-repl-input-face ((,class (:weight bold))))
         `(cider-repl-prompt-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(cider-repl-stderr-face ((,class (:foreground ,madoromi-color-beni))))
         `(cider-repl-stdout-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(cider-stacktrace-error-class-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(cider-stacktrace-error-message-face ((,class (:foreground ,madoromi-color-beni))))
         `(cider-stacktrace-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(cider-stacktrace-filter-active-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(cider-stacktrace-filter-inactive-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(cider-stacktrace-fn-face ((,class (:foreground ,madoromi-color-ai))))
         `(cider-stacktrace-ns-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(cider-test-error-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(cider-test-failure-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(cider-test-success-face ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(cider-traced-face ((,class (:background ,madoromi-color-diff-chg-bg))))
         `(cider-repl-result-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(cider-fringe-bad-face ((,class (:foreground ,madoromi-color-beni))))
         `(cider-fringe-stale-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(cider-reader-conditional-face ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(cider-debug-prompt-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
;;;;;; nrepl (message log)
         `(nrepl-message-1-face ((,class (:foreground ,madoromi-color-beni))))
         `(nrepl-message-2-face ((,class (:foreground ,madoromi-color-kaki))))
         `(nrepl-message-3-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(nrepl-message-4-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(nrepl-message-5-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(nrepl-message-6-face ((,class (:foreground ,madoromi-color-ruri))))
         `(nrepl-message-7-face ((,class (:foreground ,madoromi-color-ai))))
         `(nrepl-message-8-face ((,class (:foreground ,madoromi-color-kikyo))))

;;;;; company
         `(company-tooltip ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-hyoshi))))
         `(company-tooltip-selection ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0))))
         `(company-tooltip-deprecated ((,class (:foreground ,madoromi-color-kasure2 :strike-through t))))
         `(company-tooltip-search ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(company-tooltip-search-selection ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-nijimi0 :weight bold))))
         `(company-tooltip-mouse ((,class (:background ,madoromi-color-nijimi0))))
         `(company-tooltip-common ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(company-tooltip-common-selection ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(company-tooltip-annotation ((,class (:foreground ,madoromi-color-kasure2))))
         `(company-tooltip-annotation-selection ((,class (:foreground ,madoromi-color-kasure2))))
         `(company-scrollbar-bg ((,class (:background ,madoromi-color-nijimi0))))
         `(company-scrollbar-fg ((,class (:background ,madoromi-color-nijimi2))))
         `(company-preview ((,class (:foreground ,madoromi-color-kasure1))))
         `(company-preview-common ((,class (:foreground ,madoromi-color-ai :weight bold))))

;;;;; consult
         `(consult-file ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(consult-bookmark ((,class (:foreground ,madoromi-color-yamabuki))))
         `(consult-buffer ((,class (:foreground ,madoromi-color-sumi))))
         `(consult-line-number ((,class (:foreground ,madoromi-color-kasure1))))
         `(consult-line-number-prefix ((,class (:foreground ,madoromi-color-kasure2))))
         `(consult-separator ((,class (:foreground ,madoromi-color-kasure0))))
         `(consult-highlight-match ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(consult-preview-match ((,class (:background ,madoromi-color-nijimi0))))
         `(consult-async-split ((,class (:foreground ,madoromi-color-fuji))))
         `(consult-key ((,class (:foreground ,madoromi-color-fuji))))
         `(consult-imenu-prefix ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; corfu
         `(corfu-default ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-hyoshi))))
         `(corfu-current ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0))))
         `(corfu-bar ((,class (:background ,madoromi-color-nijimi2))))
         `(corfu-border ((,class (:background ,madoromi-color-nijimi0))))
         `(corfu-annotations ((,class (:foreground ,madoromi-color-kasure2))))
         `(corfu-deprecated ((,class (:foreground ,madoromi-color-kasure2 :strike-through t))))
         `(corfu-popupinfo ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-hyoshi))))

;;;;; copilot
         `(copilot-overlay-face ((,class (:foreground ,madoromi-color-kasure1 :slant italic))))

;;;;; doom-modeline
         `(doom-modeline-bar ((,class (:background ,madoromi-color-ai))))
         `(doom-modeline-bar-inactive ((,class (:background ,madoromi-color-nijimi0))))
         `(doom-modeline-buffer-file ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(doom-modeline-buffer-major-mode ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(doom-modeline-buffer-minor-mode ((,class (:foreground ,madoromi-color-kasure1))))
         `(doom-modeline-buffer-modified ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(doom-modeline-buffer-path ((,class (:foreground ,madoromi-color-ai))))
         `(doom-modeline-evil-emacs-state ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(doom-modeline-evil-insert-state ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(doom-modeline-evil-motion-state ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(doom-modeline-evil-normal-state ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(doom-modeline-evil-operator-state ((,class (:foreground ,madoromi-color-sora :weight bold))))
         `(doom-modeline-evil-replace-state ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(doom-modeline-evil-visual-state ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(doom-modeline-info ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(doom-modeline-lsp-error ((,class (:foreground ,madoromi-color-beni))))
         `(doom-modeline-lsp-running ((,class (:foreground ,madoromi-color-kaki))))
         `(doom-modeline-lsp-success ((,class (:foreground ,madoromi-color-wakaba))))
         `(doom-modeline-lsp-warning ((,class (:foreground ,madoromi-color-yamabuki))))
         `(doom-modeline-project-dir ((,class (:foreground ,madoromi-color-ai))))
         `(doom-modeline-warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))

;;;;; elfeed
         `(elfeed-log-date-face ((,class (:foreground ,madoromi-color-sora))))
         `(elfeed-log-debug-level-face ((,class (:foreground ,madoromi-color-fuji))))
         `(elfeed-log-error-level-face ((,class (:foreground ,madoromi-color-beni))))
         `(elfeed-log-info-level-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(elfeed-log-warn-level-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(elfeed-search-date-face ((,class (:foreground ,madoromi-color-sora))))
         `(elfeed-search-feed-face ((,class (:foreground ,madoromi-color-ai))))
         `(elfeed-search-filter-face ((,class (:foreground ,madoromi-color-fuji))))
         `(elfeed-search-tag-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(elfeed-search-title-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(elfeed-search-unread-count-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(elfeed-search-unread-title-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))

;;;;; embark
         `(embark-keybinding ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(embark-collect-marked ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-fuji))))
         `(embark-collect-zebra-highlight ((,class (:background ,madoromi-color-nijimi0))))

;;;;; easy-kill
         `(easy-kill-selection ((,class (:background ,madoromi-color-selection :extend t))))
         `(easy-kill-origin ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni))))

;;;;; flycheck
         `(flycheck-error ((,class (:underline (:style wave :color ,madoromi-color-beni)))))
         `(flycheck-warning ((,class (:underline (:style wave :color ,madoromi-color-yamabuki)))))
         `(flycheck-info ((,class (:underline (:style wave :color ,madoromi-color-tokiwa)))))
         `(flycheck-error-list-error ((,class (:foreground ,madoromi-color-beni))))
         `(flycheck-error-list-warning ((,class (:foreground ,madoromi-color-yamabuki))))
         `(flycheck-error-list-info ((,class (:foreground ,madoromi-color-tokiwa))))
         `(flycheck-fringe-error ((,class (:foreground ,madoromi-color-beni))))
         `(flycheck-fringe-warning ((,class (:foreground ,madoromi-color-yamabuki))))
         `(flycheck-fringe-info ((,class (:foreground ,madoromi-color-tokiwa))))

;;;;; erlang
         `(erlang-font-lock-exported-function-name-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(erlang-edoc-heading ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(erlang-edoc-tag ((,class (:foreground ,madoromi-color-usuzumi0))))
         `(erlang-edoc-macro ((,class (:foreground ,madoromi-color-botan))))
         `(erlang-edoc-verbatim ((,class (:foreground ,madoromi-color-tokiwa))))
         `(erlang-edoc-todo ((,class (:foreground ,madoromi-color-akane :weight bold))))

;;;;; forge
         `(forge-topic-open ((,class (:foreground ,madoromi-color-wakaba))))
         `(forge-topic-closed ((,class (:foreground ,madoromi-color-kasure2))))
         `(forge-topic-merged ((,class (:foreground ,madoromi-color-fuji))))
         `(forge-topic-unmerged ((,class (:foreground ,madoromi-color-yamabuki))))
         `(forge-issue-open ((,class (:foreground ,madoromi-color-wakaba))))
         `(forge-issue-completed ((,class (:foreground ,madoromi-color-kasure2))))
         `(forge-pullreq-open ((,class (:foreground ,madoromi-color-wakaba))))
         `(forge-pullreq-merged ((,class (:foreground ,madoromi-color-fuji))))
         `(forge-pullreq-rejected ((,class (:foreground ,madoromi-color-beni))))
         `(forge-pullreq-draft ((,class (:foreground ,madoromi-color-kasure1 :slant italic))))
         `(forge-topic-label ((,class (:box (:line-width -1 :color ,madoromi-color-nijimi1)))))
         `(forge-post-author ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(forge-post-date ((,class (:foreground ,madoromi-color-sora))))
         `(forge-suffix-active ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(forge-suffix-active-and-implied ((,class (:foreground ,madoromi-color-wakaba))))
         `(forge-suffix-implied ((,class (:foreground ,madoromi-color-kasure1))))

;;;;; git-timemachine
         `(git-timemachine-commit ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(git-timemachine-minibuffer-author-face ((,class (:foreground ,madoromi-color-ai))))
         `(git-timemachine-minibuffer-detail-face ((,class (:foreground ,madoromi-color-sora))))

;;;;; gptel
         `(gptel-context-highlight-face ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(gptel-context-deletion-face ((,class (:background ,madoromi-color-diff-del-bg :extend t))))
         `(gptel-rewrite-highlight-face ((,class (:background ,madoromi-color-diff-chg-bg :extend t))))
         `(gptel-response-highlight ((,class (:background ,madoromi-color-hyoshi :extend t))))
         `(gptel-response-fringe-highlight ((,class (:foreground ,madoromi-color-ai))))

;;;;; haskell-mode
         `(haskell-keyword-face ((,class (:foreground ,madoromi-color-fuji))))
         `(haskell-type-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(haskell-constructor-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(haskell-definition-face ((,class (:foreground ,madoromi-color-ai))))
         `(haskell-operator-face ((,class (:foreground ,madoromi-color-sora))))
         `(haskell-pragma-face ((,class (:foreground ,madoromi-color-botan))))
         `(haskell-quasi-quote-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(haskell-literate-comment-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         `(haskell-hole-face ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(haskell-error-face ((,class (:underline (:style wave :color ,madoromi-color-beni)))))
         `(haskell-warning-face ((,class (:underline (:style wave :color ,madoromi-color-yamabuki)))))
         `(haskell-interactive-face-prompt ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(haskell-interactive-face-prompt-cont ((,class (:foreground ,madoromi-color-ruri))))
         `(haskell-interactive-face-compile-error ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(haskell-interactive-face-compile-warning ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(haskell-interactive-face-result ((,class (:foreground ,madoromi-color-wakaba))))
         `(haskell-interactive-face-garbage ((,class (:foreground ,madoromi-color-kasure1))))

;;;;; hydra
         `(hydra-face-red ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(hydra-face-blue ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(hydra-face-amaranth ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(hydra-face-pink ((,class (:foreground ,madoromi-color-botan :weight bold))))
         `(hydra-face-teal ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))

;;;;; inf-ruby
         `(inf-ruby-result-overlay-face ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-hyoshi
                                                              :box (:line-width -1 :color ,madoromi-color-nijimi0)))))

;;;;; ivy
         `(ivy-current-match ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold))))
         `(ivy-minibuffer-match-face-1 ((,class (:foreground ,madoromi-color-kasure2))))
         `(ivy-minibuffer-match-face-2 ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(ivy-minibuffer-match-face-3 ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(ivy-minibuffer-match-face-4 ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(ivy-confirm-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(ivy-match-required-face ((,class (:foreground ,madoromi-color-beni))))
         `(ivy-remote ((,class (:foreground ,madoromi-color-fuji))))
         `(ivy-virtual ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; jinx
         `(jinx-misspelled ((,class (:underline (:style wave :color ,madoromi-color-beni)))))
         `(jinx-highlight ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-beni :weight bold))))
         `(jinx-save ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(jinx-key ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(jinx-annotation ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; keycast
         `(keycast-key ((,class (:foreground ,madoromi-color-kami :background ,madoromi-color-fuji :weight bold))))
         `(keycast-command ((,class (:weight bold))))

;;;;; lsp-mode
         `(lsp-face-highlight-textual ((,class (:background ,madoromi-color-nijimi0))))
         `(lsp-face-highlight-read ((,class (:background ,madoromi-color-nijimi0))))
         `(lsp-face-highlight-write ((,class (:background ,madoromi-color-nijimi0 :weight bold))))

;;;;; lsp-ui
         `(lsp-ui-doc-background ((,class (:background ,madoromi-color-hyoshi))))
         `(lsp-ui-doc-header ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold))))
         `(lsp-ui-doc-highlight-hover ((,class (:background ,madoromi-color-nijimi0))))
         `(lsp-ui-doc-url ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(lsp-ui-peek-peek ((,class (:background ,madoromi-color-hyoshi))))
         `(lsp-ui-peek-list ((,class (:background ,madoromi-color-hyoshi))))
         `(lsp-ui-peek-filename ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(lsp-ui-peek-line-number ((,class (:foreground ,madoromi-color-kasure1))))
         `(lsp-ui-peek-highlight ((,class (:foreground ,madoromi-color-beni :weight bold :box (:line-width -1 :color ,madoromi-color-beni)))))
         `(lsp-ui-peek-header ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold))))
         `(lsp-ui-peek-footer ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1))))
         `(lsp-ui-peek-selection ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0 :weight bold))))
         `(lsp-ui-sideline-symbol ((,class (:foreground ,madoromi-color-kasure1 :box (:line-width -1 :color ,madoromi-color-kasure1)))))
         `(lsp-ui-sideline-current-symbol ((,class (:foreground ,madoromi-color-sumi :weight bold :box (:line-width -1 :color ,madoromi-color-sumi)))))
         `(lsp-ui-sideline-code-action ((,class (:foreground ,madoromi-color-yamabuki))))
         `(lsp-ui-sideline-symbol-info ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         `(lsp-ui-sideline-global ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; magit
;;;;;; magit-bisect
         `(magit-bisect-bad ((,class (:foreground ,madoromi-color-beni))))
         `(magit-bisect-good ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-bisect-skip ((,class (:foreground ,madoromi-color-yamabuki))))
;;;;;; magit-blame
         `(magit-blame-heading ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-hyoshi :extend t))))
         `(magit-blame-hash ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-blame-name ((,class (:foreground ,madoromi-color-ai))))
         `(magit-blame-date ((,class (:foreground ,madoromi-color-sora))))
         `(magit-blame-summary ((,class (:foreground ,madoromi-color-sumi))))
         `(magit-blame-dimmed ((,class (:foreground ,madoromi-color-kasure2))))
         `(magit-blame-margin ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-hyoshi))))
;;;;;; magit-branch
         `(magit-branch-local ((,class (:foreground ,madoromi-color-ai))))
         `(magit-branch-remote ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-branch-remote-head ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(magit-branch-current ((,class (:foreground ,madoromi-color-ai :weight bold :box (:line-width -1 :color ,madoromi-color-ai)))))
         `(magit-branch-upstream ((,class (:foreground ,madoromi-color-tokiwa))))
         `(magit-branch-warning ((,class (:foreground ,madoromi-color-yamabuki))))
;;;;;; magit-cherry
         `(magit-cherry-equivalent ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-cherry-unmatched ((,class (:foreground ,madoromi-color-sora))))
;;;;;; magit-diff
         `(magit-diff-added ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg :extend t))))
         `(magit-diff-added-highlight ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg :weight bold :extend t))))
         `(magit-diff-removed ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg :extend t))))
         `(magit-diff-removed-highlight ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg :weight bold :extend t))))
         `(magit-diff-base ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-diff-chg-bg :extend t))))
         `(magit-diff-base-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-diff-chg-bg :weight bold :extend t))))
         `(magit-diff-context ((,class (:foreground ,madoromi-color-kasure2 :extend t))))
         `(magit-diff-context-highlight ((,class (:foreground ,madoromi-color-usuzumi0 :background ,madoromi-color-hyoshi :extend t))))
         `(magit-diff-file-heading ((,class (:foreground ,madoromi-color-sumi :weight bold :extend t))))
         `(magit-diff-file-heading-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0 :weight bold :extend t))))
         `(magit-diff-file-heading-selection ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi2 :extend t))))
         `(magit-diff-hunk-heading ((,class (:foreground ,madoromi-color-usuzumi1 :background ,madoromi-color-nijimi0 :extend t))))
         `(magit-diff-hunk-heading-highlight ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi1 :weight bold :extend t))))
         `(magit-diff-hunk-heading-selection ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi2 :extend t))))
         `(magit-diff-lines-heading ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-search :extend t))))
         `(magit-diff-revision-summary ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(magit-diff-revision-summary-highlight ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(magit-diff-whitespace-warning ((,class (:background ,madoromi-color-beni))))
         `(magit-diffstat-added ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-diffstat-removed ((,class (:foreground ,madoromi-color-beni))))
;;;;;; magit-log
         `(magit-log-author ((,class (:foreground ,madoromi-color-ai))))
         `(magit-log-date ((,class (:foreground ,madoromi-color-sora))))
         `(magit-log-graph ((,class (:foreground ,madoromi-color-kasure2))))
;;;;;; magit-process
         `(magit-process-ng ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(magit-process-ok ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
;;;;;; magit-reflog
         `(magit-reflog-amend ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-reflog-checkout ((,class (:foreground ,madoromi-color-ai))))
         `(magit-reflog-cherry-pick ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-reflog-commit ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-reflog-merge ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-reflog-other ((,class (:foreground ,madoromi-color-sora))))
         `(magit-reflog-rebase ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-reflog-remote ((,class (:foreground ,madoromi-color-tokiwa))))
         `(magit-reflog-reset ((,class (:foreground ,madoromi-color-beni))))
;;;;;; magit-section
         `(magit-section-heading ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(magit-section-heading-selection ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(magit-section-highlight ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(magit-section-secondary-heading ((,class (:foreground ,madoromi-color-fuji :weight bold))))
;;;;;; magit-sequence
         `(magit-sequence-done ((,class (:foreground ,madoromi-color-kasure2))))
         `(magit-sequence-drop ((,class (:foreground ,madoromi-color-beni))))
         `(magit-sequence-head ((,class (:foreground ,madoromi-color-ai))))
         `(magit-sequence-onto ((,class (:foreground ,madoromi-color-kasure2))))
         `(magit-sequence-part ((,class (:foreground ,madoromi-color-yamabuki))))
         `(magit-sequence-pick ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-sequence-stop ((,class (:foreground ,madoromi-color-tokiwa))))
;;;;;; magit-signature
         `(magit-signature-bad ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(magit-signature-error ((,class (:foreground ,madoromi-color-beni))))
         `(magit-signature-expired ((,class (:foreground ,madoromi-color-kaki))))
         `(magit-signature-expired-key ((,class (:foreground ,madoromi-color-kaki))))
         `(magit-signature-good ((,class (:foreground ,madoromi-color-wakaba))))
         `(magit-signature-revoked ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-signature-untrusted ((,class (:foreground ,madoromi-color-yamabuki))))
;;;;;; magit-tag
         `(magit-tag ((,class (:foreground ,madoromi-color-yamabuki))))
;;;;;; magit-misc
         `(magit-dimmed ((,class (:foreground ,madoromi-color-kasure2))))
         `(magit-filename ((,class (:foreground ,madoromi-color-sumi))))
         `(magit-hash ((,class (:foreground ,madoromi-color-kasure2))))
         `(magit-header-line ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(magit-keyword ((,class (:foreground ,madoromi-color-fuji))))
         `(magit-mode-line-process ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(magit-mode-line-process-error ((,class (:foreground ,madoromi-color-beni :weight bold))))

;;;;; marginalia
         `(marginalia-archive ((,class (:foreground ,madoromi-color-fuji))))
         `(marginalia-char ((,class (:foreground ,madoromi-color-kaki))))
         `(marginalia-date ((,class (:foreground ,madoromi-color-sora))))
         `(marginalia-documentation ((,class (:foreground ,madoromi-color-kasure2))))
         `(marginalia-file-name ((,class (:foreground ,madoromi-color-sumi))))
         `(marginalia-file-owner ((,class (:foreground ,madoromi-color-kasure1))))
         `(marginalia-file-priv-dir ((,class (:foreground ,madoromi-color-ai))))
         `(marginalia-file-priv-exec ((,class (:foreground ,madoromi-color-wakaba))))
         `(marginalia-file-priv-link ((,class (:foreground ,madoromi-color-sora))))
         `(marginalia-file-priv-no ((,class (:foreground ,madoromi-color-kasure2))))
         `(marginalia-file-priv-other ((,class (:foreground ,madoromi-color-kasure1))))
         `(marginalia-file-priv-rare ((,class (:foreground ,madoromi-color-kaki))))
         `(marginalia-file-priv-read ((,class (:foreground ,madoromi-color-yamabuki))))
         `(marginalia-file-priv-write ((,class (:foreground ,madoromi-color-beni))))
         `(marginalia-function ((,class (:foreground ,madoromi-color-ai))))
         `(marginalia-installed ((,class (:foreground ,madoromi-color-wakaba))))
         `(marginalia-key ((,class (:foreground ,madoromi-color-fuji))))
         `(marginalia-lighter ((,class (:foreground ,madoromi-color-kasure1))))
         `(marginalia-list ((,class (:foreground ,madoromi-color-tokiwa))))
         `(marginalia-mode ((,class (:foreground ,madoromi-color-fuji))))
         `(marginalia-modified ((,class (:foreground ,madoromi-color-yamabuki))))
         `(marginalia-null ((,class (:foreground ,madoromi-color-kasure2))))
         `(marginalia-number ((,class (:foreground ,madoromi-color-kaki))))
         `(marginalia-size ((,class (:foreground ,madoromi-color-tokiwa))))
         `(marginalia-string ((,class (:foreground ,madoromi-color-wakaba))))
         `(marginalia-symbol ((,class (:foreground ,madoromi-color-ai))))
         `(marginalia-true ((,class (:foreground ,madoromi-color-wakaba))))
         `(marginalia-type ((,class (:foreground ,madoromi-color-yamabuki))))
         `(marginalia-value ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(marginalia-version ((,class (:foreground ,madoromi-color-tokiwa))))

;;;;; asciidoc-mode
         `(asciidoc-document-title-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-sumi :weight bold :height ,h-doc))))
         `(asciidoc-title-1-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h1))))
         `(asciidoc-title-2-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h2))))
         `(asciidoc-title-3-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h3))))
         `(asciidoc-title-4-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(asciidoc-title-5-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(asciidoc-markup-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(asciidoc-code-face ((,class (:foreground ,madoromi-color-tokiwa :background ,madoromi-color-hyoshi :extend t))))
         `(asciidoc-link-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(asciidoc-link-mouse-face ((,class (:foreground ,madoromi-color-ai :background ,madoromi-color-nijimi0 :underline t))))
         `(asciidoc-url-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(asciidoc-cross-reference-face ((,class (:foreground ,madoromi-color-kikyo :underline t))))
         `(asciidoc-anchor-face ((,class (:foreground ,madoromi-color-kikyo))))
         `(asciidoc-superscript-face ((,class (:foreground ,madoromi-color-sumi :height 0.8))))
         `(asciidoc-subscript-face ((,class (:foreground ,madoromi-color-sumi :height 0.8))))
         `(asciidoc-metadata-key-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(asciidoc-metadata-value-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(asciidoc-footnote-marker-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(asciidoc-footnote-text-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(asciidoc-highlight-face ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-warning-bg))))
         `(asciidoc-strike-through-face ((,class (:foreground ,madoromi-color-kasure1 :strike-through t))))
         `(asciidoc-underline-face ((,class (:underline t))))
         `(asciidoc-overline-face ((,class (:overline t))))
         `(asciidoc-admonition-note-label-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(asciidoc-admonition-note-face ((,class (:background ,madoromi-color-diff-chg-bg :extend t))))
         `(asciidoc-admonition-tip-label-face ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(asciidoc-admonition-tip-face ((,class (:background ,madoromi-color-diff-add-bg :extend t))))
         `(asciidoc-admonition-important-label-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(asciidoc-admonition-important-face ((,class (:background ,madoromi-color-hyoshi :extend t))))
         `(asciidoc-admonition-caution-label-face ((,class (:foreground ,madoromi-color-yamabuki :weight bold))))
         `(asciidoc-admonition-caution-face ((,class (:background ,madoromi-color-hyoshi :extend t))))
         `(asciidoc-admonition-warning-label-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(asciidoc-admonition-warning-face ((,class (:background ,madoromi-color-diff-del-bg :extend t))))

;;;;; markdown-mode
         `(markdown-header-face-1 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h1))))
         `(markdown-header-face-2 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h2))))
         `(markdown-header-face-3 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold :height ,h3))))
         `(markdown-header-face-4 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(markdown-header-face-5 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(markdown-header-face-6 ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(markdown-bold-face ((,class (:weight bold))))
         `(markdown-italic-face ((,class (:slant italic))))
         `(markdown-code-face ((,class (:foreground ,madoromi-color-tokiwa :background ,madoromi-color-hyoshi))))
         `(markdown-inline-code-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(markdown-pre-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(markdown-link-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(markdown-url-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(markdown-plain-url-face ((,class (:foreground ,madoromi-color-ai :underline t))))
         `(markdown-reference-face ((,class (:foreground ,madoromi-color-kikyo))))
         `(markdown-blockquote-face ((,class (:foreground ,madoromi-color-usuzumi0 :slant italic))))
         `(markdown-footnote-marker-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(markdown-list-face ((,class (:foreground ,madoromi-color-ai))))
         `(markdown-markup-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(markdown-metadata-key-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(markdown-metadata-value-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(markdown-missing-link-face ((,class (:foreground ,madoromi-color-beni))))
         `(markdown-hr-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(markdown-html-attr-name-face ((,class (:foreground ,madoromi-color-fuji))))
         `(markdown-html-attr-value-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(markdown-html-tag-name-face ((,class (:foreground ,madoromi-color-ai))))
         `(markdown-table-face ((,class (:foreground ,madoromi-color-usuzumi0))))

;;;;; mistty
         `(mistty-fringe-face ((,class (:foreground ,madoromi-color-kasure0))))

;;;;; orderless
         `(orderless-match-face-0 ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(orderless-match-face-1 ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(orderless-match-face-2 ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))
         `(orderless-match-face-3 ((,class (:foreground ,madoromi-color-kaki :weight bold))))

;;;;; rainbow-delimiters
         `(rainbow-delimiters-depth-1-face ((,class (:foreground ,madoromi-color-fuji))))
         `(rainbow-delimiters-depth-2-face ((,class (:foreground ,madoromi-color-ai))))
         `(rainbow-delimiters-depth-3-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(rainbow-delimiters-depth-4-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(rainbow-delimiters-depth-5-face ((,class (:foreground ,madoromi-color-botan))))
         `(rainbow-delimiters-depth-6-face ((,class (:foreground ,madoromi-color-sora))))
         `(rainbow-delimiters-depth-7-face ((,class (:foreground ,madoromi-color-fuji))))
         `(rainbow-delimiters-depth-8-face ((,class (:foreground ,madoromi-color-ai))))
         `(rainbow-delimiters-depth-9-face ((,class (:foreground ,madoromi-color-yamabuki))))
         ;; Error faces use a red box instead of a foreground color so they
         ;; stay visible regardless of which depth color the paren already has.
         `(rainbow-delimiters-unmatched-face ((,class (:box (:line-width (-1 . -1) :color ,madoromi-color-beni) :weight bold))))
         `(rainbow-delimiters-mismatched-face ((,class (:box (:line-width (-1 . -1) :color ,madoromi-color-beni) :weight bold))))
         `(rainbow-delimiters-base-error-face ((,class (:box (:line-width (-1 . -1) :color ,madoromi-color-beni) :weight bold))))

;;;;; smartparens
         `(sp-show-pair-match-face ((,class (:inherit show-paren-match))))
         `(sp-show-pair-mismatch-face ((,class (:inherit show-paren-mismatch))))
         `(sp-pair-overlay-face ((,class (:background ,madoromi-color-nijimi0))))
         `(sp-show-pair-match-content-face ((,class (:background ,madoromi-color-nijimi0))))

;;;;; transient
         `(transient-heading ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(transient-key ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(transient-argument ((,class (:foreground ,madoromi-color-wakaba))))
         `(transient-value ((,class (:foreground ,madoromi-color-wakaba))))
         `(transient-inactive-argument ((,class (:foreground ,madoromi-color-kasure2))))
         `(transient-inactive-value ((,class (:foreground ,madoromi-color-kasure2))))
         `(transient-unreachable ((,class (:foreground ,madoromi-color-kasure1))))
         `(transient-unreachable-key ((,class (:foreground ,madoromi-color-kasure1))))
         `(transient-enabled-suffix ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg))))
         `(transient-disabled-suffix ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg))))
         `(transient-separator ((,class (:background ,madoromi-color-hyoshi :extend t))))
         `(transient-amaranth ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(transient-blue ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(transient-pink ((,class (:foreground ,madoromi-color-botan :weight bold))))
         `(transient-purple ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(transient-red ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(transient-teal ((,class (:foreground ,madoromi-color-tokiwa :weight bold))))

;;;;; treemacs
         `(treemacs-directory-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(treemacs-directory-collapsed-face ((,class (:foreground ,madoromi-color-ai))))
         `(treemacs-window-background-face ((,class (:background ,madoromi-color-hyoshi))))
         `(treemacs-hl-line-face ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(treemacs-file-face ((,class (:foreground ,madoromi-color-sumi))))
         `(treemacs-root-face ((,class (:foreground ,madoromi-color-ai :weight bold :height 1.1))))
         `(treemacs-root-unreadable-face ((,class (:foreground ,madoromi-color-beni :weight bold :height 1.1))))
         `(treemacs-root-remote-face ((,class (:foreground ,madoromi-color-fuji :weight bold :height 1.1))))
         `(treemacs-root-remote-unreadable-face ((,class (:foreground ,madoromi-color-beni :slant italic :height 1.1))))
         `(treemacs-root-remote-disconnected-face ((,class (:foreground ,madoromi-color-kasure2 :weight bold :height 1.1))))
         `(treemacs-term-node-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(treemacs-git-unmodified-face ((,class (:foreground ,madoromi-color-sumi))))
         `(treemacs-git-modified-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(treemacs-git-renamed-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(treemacs-git-ignored-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(treemacs-git-untracked-face ((,class (:foreground ,madoromi-color-kaki))))
         `(treemacs-git-added-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(treemacs-git-conflict-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(treemacs-tags-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(treemacs-help-title-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(treemacs-help-column-face ((,class (:foreground ,madoromi-color-ai))))
         `(treemacs-on-failure-pulse-face ((,class (:background ,madoromi-color-diff-del-bg))))
         `(treemacs-on-success-pulse-face ((,class (:background ,madoromi-color-diff-add-bg))))
         `(treemacs-fringe-indicator-face ((,class (:foreground ,madoromi-color-ai))))
         `(treemacs-header-button-face ((,class (:foreground ,madoromi-color-sumi :background ,madoromi-color-nijimi0 :box (:line-width -1 :color ,madoromi-color-nijimi1)))))
         `(treemacs-marked-file-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(treemacs-git-commit-diff-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(treemacs-async-loading-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))

;;;;; vertico
         `(vertico-current ((,class (:background ,madoromi-color-nijimi0 :extend t))))
         `(vertico-group-title ((,class (:foreground ,madoromi-color-fuji :weight bold :slant italic))))
         `(vertico-group-separator ((,class (:foreground ,madoromi-color-kasure2 :strike-through t))))
         `(vertico-multiline ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; web-mode
         `(web-mode-error-face ((,class (:foreground ,madoromi-color-beni :underline t))))
         `(web-mode-warning-face ((,class (:foreground ,madoromi-color-yamabuki :underline t))))
         `(web-mode-preprocessor-face ((,class (:foreground ,madoromi-color-botan))))
         `(web-mode-block-delimiter-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(web-mode-block-control-face ((,class (:foreground ,madoromi-color-fuji))))
         `(web-mode-builtin-face ((,class (:foreground ,madoromi-color-beni))))
         `(web-mode-symbol-face ((,class (:foreground ,madoromi-color-kaki))))
         `(web-mode-doctype-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(web-mode-html-tag-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-html-tag-custom-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-html-tag-unclosed-face ((,class (:foreground ,madoromi-color-beni :underline t))))
         `(web-mode-html-tag-namespaced-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-html-tag-bracket-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(web-mode-html-attr-name-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(web-mode-html-attr-custom-face ((,class (:foreground ,madoromi-color-yamabuki :slant italic))))
         `(web-mode-html-attr-engine-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(web-mode-html-attr-equal-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(web-mode-html-attr-value-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(web-mode-block-attr-name-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(web-mode-block-attr-value-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(web-mode-variable-name-face ((,class (:foreground ,madoromi-color-nadeshiko))))
         `(web-mode-css-selector-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(web-mode-css-selector-class-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(web-mode-css-selector-tag-face ((,class (:foreground ,madoromi-color-sora))))
         `(web-mode-css-pseudo-class-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(web-mode-css-at-rule-face ((,class (:foreground ,madoromi-color-fuji))))
         `(web-mode-css-property-name-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-css-color-face ((,class (:foreground ,madoromi-color-kaki))))
         `(web-mode-css-priority-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(web-mode-css-function-face ((,class (:foreground ,madoromi-color-sora))))
         `(web-mode-css-variable-face ((,class (:foreground ,madoromi-color-nadeshiko))))
         `(web-mode-function-name-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-filter-face ((,class (:foreground ,madoromi-color-sora))))
         `(web-mode-function-call-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-string-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(web-mode-block-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-part-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-javascript-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-css-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-json-key-face ((,class (:foreground ,madoromi-color-ai))))
         `(web-mode-json-context-face ((,class (:foreground ,madoromi-color-fuji))))
         `(web-mode-json-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-comment-face ((,class (:foreground ,madoromi-color-kasure2 :slant italic))))
         `(web-mode-block-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-part-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-json-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-javascript-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-css-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-annotation-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(web-mode-annotation-tag-face ((,class (:foreground ,madoromi-color-kasure1))))
         `(web-mode-annotation-type-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(web-mode-annotation-value-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(web-mode-annotation-html-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(web-mode-constant-face ((,class (:foreground ,madoromi-color-kaki))))
         `(web-mode-type-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(web-mode-keyword-face ((,class (:foreground ,madoromi-color-fuji))))
         `(web-mode-param-name-face ((,class (:foreground ,madoromi-color-akane))))
         `(web-mode-whitespace-face ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg))))
         `(web-mode-inlay-face ((,class (:background ,madoromi-color-hyoshi))))
         `(web-mode-block-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-part-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-script-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-style-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-folded-face ((,class (:foreground ,madoromi-color-kasure2 :underline t))))
         `(web-mode-current-element-highlight-face ((,class (:background ,madoromi-color-nijimi0))))
         `(web-mode-current-column-highlight-face ((,class (:background ,madoromi-color-cursor-line))))
         `(web-mode-comment-keyword-face ((,class (:foreground ,madoromi-color-nadeshiko :weight bold))))
         `(web-mode-sql-keyword-face ((,class (:foreground ,madoromi-color-fuji))))
         `(web-mode-html-entity-face ((,class (:foreground ,madoromi-color-kaki))))

;;;;; which-func
         `(which-func ((,class (:foreground ,madoromi-color-ai))))

;;;;; which-key
         `(which-key-key-face ((,class (:foreground ,madoromi-color-fuji :weight bold))))
         `(which-key-separator-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(which-key-note-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(which-key-command-description-face ((,class (:foreground ,madoromi-color-sumi))))
         `(which-key-group-description-face ((,class (:foreground ,madoromi-color-ai))))
         `(which-key-local-map-description-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(which-key-special-key-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))

;;;;; auctex
         `(font-latex-bold-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(font-latex-italic-face ((,class (:foreground ,madoromi-color-sumi :slant italic))))
         `(font-latex-math-face ((,class (:foreground ,madoromi-color-tokiwa))))
         `(font-latex-script-char-face ((,class (:foreground ,madoromi-color-kaki))))
         `(font-latex-sectioning-0-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :height ,h1 :weight bold))))
         `(font-latex-sectioning-1-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :height ,h2 :weight bold))))
         `(font-latex-sectioning-2-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :height ,h3 :weight bold))))
         `(font-latex-sectioning-3-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(font-latex-sectioning-4-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(font-latex-sectioning-5-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-fuji :weight bold))))
         `(font-latex-sedate-face ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(font-latex-slide-title-face ((,class (:inherit ,vpitch :foreground ,madoromi-color-ai :weight bold :height ,h1))))
         `(font-latex-string-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(font-latex-subscript-face ((,class (:height 0.9))))
         `(font-latex-superscript-face ((,class (:height 0.9))))
         `(font-latex-verbatim-face ((,class (:foreground ,madoromi-color-tokiwa :inherit fixed-pitch))))
         `(font-latex-warning-face ((,class (:foreground ,madoromi-color-kaki :weight bold))))
         `(font-latex-doctex-documentation-face ((,class (:background ,madoromi-color-hyoshi))))
         `(font-latex-doctex-preprocessor-face ((,class (:foreground ,madoromi-color-fuji))))

;;;;; centaur-tabs
         `(centaur-tabs-default ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-kasure2))))
         `(centaur-tabs-selected ((,class (:background ,madoromi-color-kami :foreground ,madoromi-color-sumi :weight bold))))
         `(centaur-tabs-unselected ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-kasure2))))
         `(centaur-tabs-selected-modified ((,class (:background ,madoromi-color-kami :foreground ,madoromi-color-fuji :weight bold))))
         `(centaur-tabs-unselected-modified ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-fuji))))
         `(centaur-tabs-active-bar-face ((,class (:background ,madoromi-color-ai))))
         `(centaur-tabs-modified-marker-selected ((,class (:foreground ,madoromi-color-kaki))))
         `(centaur-tabs-modified-marker-unselected ((,class (:foreground ,madoromi-color-kaki))))

;;;;; git-gutter
         `(git-gutter:added ((,class (:foreground ,madoromi-color-wakaba))))
         `(git-gutter:deleted ((,class (:foreground ,madoromi-color-beni))))
         `(git-gutter:modified ((,class (:foreground ,madoromi-color-ai))))
         `(git-gutter:unchanged ((,class (:background ,madoromi-color-nijimi0))))

;;;;; git-gutter-fr
         `(git-gutter-fr:added ((,class (:foreground ,madoromi-color-wakaba))))
         `(git-gutter-fr:deleted ((,class (:foreground ,madoromi-color-beni))))
         `(git-gutter-fr:modified ((,class (:foreground ,madoromi-color-ai))))

;;;;; highlight-numbers
         `(highlight-numbers-number ((,class (:foreground ,madoromi-color-kaki))))

;;;;; multiple-cursors
         `(mc/cursor-face ((,class (:inverse-video nil :background ,madoromi-color-nijimi0 :foreground ,madoromi-color-sumi))))
         `(mc/cursor-bar-face ((,class (:background ,madoromi-color-sumi :height 1))))
         `(mc/region-face ((,class (:inherit region))))

;;;;; neotree
         `(neo-banner-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(neo-header-face ((,class (:foreground ,madoromi-color-sumi))))
         `(neo-root-dir-face ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(neo-dir-link-face ((,class (:foreground ,madoromi-color-ai))))
         `(neo-file-link-face ((,class (:foreground ,madoromi-color-sumi))))
         `(neo-expand-btn-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(neo-vc-default-face ((,class (:foreground ,madoromi-color-sumi))))
         `(neo-vc-up-to-date-face ((,class (:foreground ,madoromi-color-sumi))))
         `(neo-vc-edited-face ((,class (:foreground ,madoromi-color-ai))))
         `(neo-vc-needs-merge-face ((,class (:foreground ,madoromi-color-kaki))))
         `(neo-vc-added-face ((,class (:foreground ,madoromi-color-wakaba))))
         `(neo-vc-conflict-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(neo-vc-missing-face ((,class (:foreground ,madoromi-color-beni))))
         `(neo-vc-ignored-face ((,class (:foreground ,madoromi-color-kasure0))))

;;;;; nerd-icons
         `(nerd-icons-red ((,class (:foreground ,madoromi-color-beni))))
         `(nerd-icons-lred ((,class (:foreground ,madoromi-color-beni))))
         `(nerd-icons-dred ((,class (:foreground ,madoromi-color-akane))))
         `(nerd-icons-green ((,class (:foreground ,madoromi-color-wakaba))))
         `(nerd-icons-lgreen ((,class (:foreground ,madoromi-color-wakaba))))
         `(nerd-icons-dgreen ((,class (:foreground ,madoromi-color-tokiwa))))
         `(nerd-icons-yellow ((,class (:foreground ,madoromi-color-yamabuki))))
         `(nerd-icons-lyellow ((,class (:foreground ,madoromi-color-yamabuki))))
         `(nerd-icons-dyellow ((,class (:foreground ,madoromi-color-kaki))))
         `(nerd-icons-blue ((,class (:foreground ,madoromi-color-ai))))
         `(nerd-icons-lblue ((,class (:foreground ,madoromi-color-sora))))
         `(nerd-icons-dblue ((,class (:foreground ,madoromi-color-ruri))))
         `(nerd-icons-maroon ((,class (:foreground ,madoromi-color-akane))))
         `(nerd-icons-lmaroon ((,class (:foreground ,madoromi-color-beni))))
         `(nerd-icons-dmaroon ((,class (:foreground ,madoromi-color-akane))))
         `(nerd-icons-purple ((,class (:foreground ,madoromi-color-fuji))))
         `(nerd-icons-lpurple ((,class (:foreground ,madoromi-color-fuji))))
         `(nerd-icons-dpurple ((,class (:foreground ,madoromi-color-fuji))))
         `(nerd-icons-orange ((,class (:foreground ,madoromi-color-kaki))))
         `(nerd-icons-lorange ((,class (:foreground ,madoromi-color-kaki))))
         `(nerd-icons-dorange ((,class (:foreground ,madoromi-color-kaki))))
         `(nerd-icons-cyan ((,class (:foreground ,madoromi-color-sora))))
         `(nerd-icons-lcyan ((,class (:foreground ,madoromi-color-sora))))
         `(nerd-icons-dcyan ((,class (:foreground ,madoromi-color-tokiwa))))
         `(nerd-icons-pink ((,class (:foreground ,madoromi-color-botan))))
         `(nerd-icons-lpink ((,class (:foreground ,madoromi-color-botan))))
         `(nerd-icons-dpink ((,class (:foreground ,madoromi-color-nadeshiko))))
         `(nerd-icons-silver ((,class (:foreground ,madoromi-color-usuzumi1))))
         `(nerd-icons-lsilver ((,class (:foreground ,madoromi-color-sumi))))
         `(nerd-icons-dsilver ((,class (:foreground ,madoromi-color-kasure2))))

;;;;; perspective
         `(persp-selected-face ((,class (:foreground ,madoromi-color-ai :weight bold))))

;;;;; solaire
         `(solaire-default-face ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-sumi))))
         `(solaire-minibuffer-face ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-sumi))))
         `(solaire-hl-line-face ((,class (:background ,madoromi-color-nijimi0))))
         `(solaire-line-number-face ((,class (:background ,madoromi-color-hyoshi :foreground ,madoromi-color-nijimi1))))
         `(solaire-mode-line-face ((,class (:background ,madoromi-color-hyoshi))))
         `(solaire-mode-line-inactive-face ((,class (:background ,madoromi-color-chitsu))))
         `(solaire-org-hide-face ((,class (:foreground ,madoromi-color-hyoshi))))

;;;;; undo-tree
         `(undo-tree-visualizer-active-branch-face ((,class (:foreground ,madoromi-color-sumi :weight bold))))
         `(undo-tree-visualizer-current-face ((,class (:foreground ,madoromi-color-beni))))
         `(undo-tree-visualizer-default-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(undo-tree-visualizer-register-face ((,class (:foreground ,madoromi-color-yamabuki))))
         `(undo-tree-visualizer-unmodified-face ((,class (:foreground ,madoromi-color-tokiwa))))

;;;;; volatile-highlights
         `(vhl/default-face ((,class (:background ,madoromi-color-nijimi1))))

;;;;; vundo
         `(vundo-node ((,class (:foreground ,madoromi-color-kasure1))))
         `(vundo-stem ((,class (:foreground ,madoromi-color-nijimi2))))
         `(vundo-branch-stem ((,class (:foreground ,madoromi-color-kasure0))))
         `(vundo-highlight ((,class (:foreground ,madoromi-color-ai :weight bold))))
         `(vundo-saved ((,class (:foreground ,madoromi-color-wakaba))))
         `(vundo-last-saved ((,class (:foreground ,madoromi-color-wakaba :weight bold))))
         `(vundo-diff-highlight ((,class (:foreground ,madoromi-color-kaki :weight bold))))

;;;;; wgrep
         `(wgrep-face ((,class (:foreground ,madoromi-color-wakaba :background ,madoromi-color-diff-add-bg))))
         `(wgrep-delete-face ((,class (:foreground ,madoromi-color-beni :background ,madoromi-color-diff-del-bg))))
         `(wgrep-done-face ((,class (:foreground ,madoromi-color-ai))))
         `(wgrep-file-face ((,class (:foreground ,madoromi-color-kasure2))))
         `(wgrep-reject-face ((,class (:foreground ,madoromi-color-beni :weight bold))))
         `(term-color-bright-black ((,class (:foreground ,(aref ansi 8) :background ,(aref ansi 8)))))
         `(term-color-bright-red ((,class (:foreground ,(aref ansi 9) :background ,(aref ansi 9)))))
         `(term-color-bright-green ((,class (:foreground ,(aref ansi 10) :background ,(aref ansi 10)))))
         `(term-color-bright-yellow ((,class (:foreground ,(aref ansi 11) :background ,(aref ansi 11)))))
         `(term-color-bright-blue ((,class (:foreground ,(aref ansi 12) :background ,(aref ansi 12)))))
         `(term-color-bright-magenta ((,class (:foreground ,(aref ansi 13) :background ,(aref ansi 13)))))
         `(term-color-bright-cyan ((,class (:foreground ,(aref ansi 14) :background ,(aref ansi 14)))))
         `(term-color-bright-white ((,class (:foreground ,(aref ansi 15) :background ,(aref ansi 15))))))
        (custom-theme-set-variables
         theme-name
         ;; This legacy variable represents the eight normal ANSI colors.
         ;; Modern ANSI and term faces above cover all sixteen separately.
         `(ansi-color-names-vector ,(cl-subseq ansi 0 8))
         `(pdf-view-midnight-colors '(,madoromi-color-sumi . ,madoromi-color-kami)))))
    ;; Emacs 27/28 lack enable-theme-functions; record only after success.
    (setq madoromi--current theme-name)))

;;; Hooks

(defcustom madoromi-after-load-hook nil
  "Hook run after a Madoromi theme is loaded.
Each function is called with the theme name (a symbol) as its
sole argument.  Useful for applying additional customizations
that depend on theme colors being set."
  :type 'hook
  :group 'madoromi)

;;; Palette API

(defun madoromi--palette-for (theme)
  "Return the colors alist for THEME, or nil if unknown."
  (when (memq theme madoromi--variants)
    (madoromi-palette (intern (string-remove-prefix "madoromi-" (symbol-name theme))))))

(defun madoromi-get-color (name &optional theme)
  "Return the hex color value for NAME in the current Madoromi theme.
NAME is a string like \"ai\".  If THEME is given, look up
colors in that variant's palette instead.  User overrides from
`madoromi-override-colors-alist' are respected."
  (let* ((variant (or theme madoromi--current))
         (palette (or (madoromi--palette-for variant)
                      (error "No Madoromi theme is active")))
         (merged (append madoromi-override-colors-alist palette)))
    (cdr (assoc name merged))))

;;;###autoload
(defmacro madoromi-with-colors (&rest body)
  "Bind all palette colors for the current Madoromi theme and evaluate BODY.
Inside BODY, each palette color is available as a local variable,
e.g. `ai', `chitsu', etc.

Example:
  (madoromi-with-colors
    (set-face-attribute \\='some-face nil :foreground ai))"
  (declare (indent 0))
  `(let* ((madoromi--colors
           (append madoromi-override-colors-alist
                   (or (madoromi--palette-for madoromi--current)
                       (error "No Madoromi theme is active"))))
          ,@(mapcar (lambda (entry)
                      `(,(intern (car entry))
                        (cdr (assoc ,(car entry) madoromi--colors))))
                    (cdr (assq 'haru-hiru madoromi--palettes))))
     ,@body))

;;; Interactive Palette Viewer

(defun madoromi-list-colors (&optional theme)
  "Display all palette colors for the current Madoromi theme.
With prefix argument, prompt for THEME variant."
  (interactive
   (list (when current-prefix-arg
           (intern (completing-read "Variant: "
                                    (mapcar #'symbol-name madoromi--variants)
                                    nil t)))))
  (let* ((variant (or theme madoromi--current
                      (error "No Madoromi theme is active")))
         (palette (or (madoromi--palette-for variant)
                      (error "Unknown theme: %s" variant)))
         (merged (append madoromi-override-colors-alist palette))
         (buf (get-buffer-create (format "*Madoromi Palette: %s*" variant))))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (format "Palette for %s\n\n" variant))
        (dolist (entry merged)
          (let ((name (car entry))
                (color (cdr entry)))
            (insert (format "  %-25s  %s  " name color))
            (insert (propertize "  sample  "
                                'face `(:foreground ,color)))
            (insert (propertize "  sample  "
                                'face `(:background ,color
                                                    :foreground ,(if (< (madoromi--relative-luminance color) 0.5)
                                                                     "#ffffff" "#000000"))))
            (insert "\n")))
        (goto-char (point-min)))
      (special-mode))
    (pop-to-buffer buf)))

(defun madoromi--relative-luminance (hex)
  "Return the relative luminance of HEX color string.
Uses the WCAG 2.0 formula."
  (let* ((rgb (color-name-to-rgb hex))
         (r (nth 0 rgb))
         (g (nth 1 rgb))
         (b (nth 2 rgb))
         (adjust (lambda (c)
                   (if (<= c 0.03928)
                       (/ c 12.92)
                     (expt (/ (+ c 0.055) 1.055) 2.4)))))
    (+ (* 0.2126 (funcall adjust r))
       (* 0.7152 (funcall adjust g))
       (* 0.0722 (funcall adjust b)))))

;;; User Commands

;;;###autoload
(defun madoromi-reload ()
  "Reload the current Madoromi theme.
Useful after changing `madoromi-override-colors-alist' or
`madoromi-scale-headings' without having to call `load-theme'
manually."
  (interactive)
  (if madoromi--current
      (progn
        (load-theme madoromi--current t)
        (run-hook-with-args 'madoromi-after-load-hook madoromi--current))
    (user-error "No Madoromi theme is currently active")))

;;;###autoload
(defun madoromi-select ()
  "Select and load a Madoromi theme variant interactively."
  (interactive)
  (let* ((names (mapcar #'symbol-name madoromi--variants))
         (choice (intern (completing-read "Madoromi theme: " names nil t))))
    (mapc #'disable-theme madoromi--variants)
    (load-theme choice t)
    (setq madoromi--current choice)
    (run-hook-with-args 'madoromi-after-load-hook choice)))

(defun madoromi--apply-ns-appearance (theme)
  "Match the macOS title bar to THEME's brightness via `ns-appearance'.
On macOS the GUI derives the title bar text color from the frame's
`ns-appearance' parameter.  Without this, a light hiru flavour
renders near-white title bar text on a light background, which is
unreadable (see issue #5).  Applied to existing frames and to
`default-frame-alist' so new frames inherit it."
  (when (or (featurep 'ns) (featurep 'mac))
    (let ((appearance (if (memq theme madoromi--light-variants) 'light 'dark)))
      (setf (alist-get 'ns-appearance default-frame-alist) appearance)
      (dolist (frame (frame-list))
        (set-frame-parameter frame 'ns-appearance appearance)))))

(defun madoromi--set-current (theme)
  "Record THEME as the active Madoromi theme.
Called from `enable-theme-functions'."
  (when (memq theme madoromi--variants)
    (setq madoromi--current theme)
    (madoromi--apply-ns-appearance theme)))

(defun madoromi--clear-current (theme)
  "Clear the active Madoromi theme if THEME is being disabled.
Called from `disable-theme-functions'."
  (when (eq theme madoromi--current)
    (setq madoromi--current nil)))

(when (boundp 'enable-theme-functions)
  (add-hook 'enable-theme-functions #'madoromi--set-current)
  (add-hook 'disable-theme-functions #'madoromi--clear-current))

(provide 'madoromi)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; madoromi.el ends here
