;;; madoromi-test.el --- Tests for madoromi -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Buttercup test suite for the madoromi theme family.
;;
;; Face assertions read directly from the `theme-face' property rather
;; than going through `face-attribute' - in batch mode, faces aren't
;; recomputed to reflect theme specs, so `face-attribute' would miss
;; what the theme actually sets.  `theme-face' is the source of truth.
;;

;;; Code:

(require 'buttercup)
(require 'madoromi)

;; Make theme files loadable.
(let ((dir (file-name-directory
            (or load-file-name buffer-file-name default-directory))))
  (add-to-list 'custom-theme-load-path
               (expand-file-name ".." dir)))

(defvar madoromi-test--variants
  madoromi--variants
  "All theme variants exercised by the suite.")

(defconst madoromi-test--source-file
  (expand-file-name
   "../madoromi.el"
   (file-name-directory (or load-file-name buffer-file-name default-directory)))
  "Path to the theme source, for the checks that read it as text.")

(defun madoromi-test--palette (variant)
  "Return the colors-alist for VARIANT."
  (madoromi--palette-for variant))

(defun madoromi-test--luminance (hex)
  "Return the WCAG relative luminance of the color HEX."
  (let ((channels (mapcar
                   (lambda (offset)
                     (let ((v (/ (string-to-number
                                  (substring hex offset (+ offset 2)) 16)
                                 255.0)))
                       (if (<= v 0.04045) (/ v 12.92)
                         (expt (/ (+ v 0.055) 1.055) 2.4))))
                   '(1 3 5))))
    (+ (* 0.2126 (nth 0 channels))
       (* 0.7152 (nth 1 channels))
       (* 0.0722 (nth 2 channels)))))

(defun madoromi-test--contrast (a b)
  "Return the WCAG contrast ratio between the colors A and B."
  (let* ((la (madoromi-test--luminance a))
         (lb (madoromi-test--luminance b))
         (lighter (max la lb)) (darker (min la lb)))
    (/ (+ lighter 0.05) (+ darker 0.05))))

(defun madoromi-test--reload (variant)
  "Disable any active Madoromi theme and (re-)load VARIANT.
Reloading re-evaluates the theme file, which picks up any let-bound
`madoromi-scale-headings' the caller wants to exercise."
  (dolist (v madoromi-test--variants)
    (when (custom-theme-enabled-p v)
      (disable-theme v))
    ;; Force the theme file to be re-read on the next `load-theme'.
    (put v 'theme-settings nil)
    (setq custom-known-themes (delq v custom-known-themes)))
  (load-theme variant t))

(defun madoromi-test--face-attr (face variant attr)
  "Return ATTR from FACE's theme-face spec for VARIANT, or nil.
Reads directly from the theme-face property so we don't depend on
frame-side face recomputation (which is unreliable in batch)."
  (let* ((theme-face (get face 'theme-face))
         (entry     (assoc variant theme-face))
         (specs     (cadr entry))
         (first     (car specs))
         (props     (cadr first)))
    (plist-get props attr)))

;;; Heading scaling

(describe "madoromi-scale-headings"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (describe "when enabled (default)"
    (before-each
      (let ((madoromi-scale-headings t))
        (madoromi-test--reload 'madoromi-haru-yoru)))

    (it "scales outline-1..3"
      (expect (madoromi-test--face-attr 'outline-1 'madoromi-haru-yoru :height) :to-equal 1.3)
      (expect (madoromi-test--face-attr 'outline-2 'madoromi-haru-yoru :height) :to-equal 1.2)
      (expect (madoromi-test--face-attr 'outline-3 'madoromi-haru-yoru :height) :to-equal 1.1))

    (it "leaves outline-4..8 without a :height"
      (dolist (face '(outline-4 outline-5 outline-6 outline-7 outline-8))
        (expect (madoromi-test--face-attr face 'madoromi-haru-yoru :height) :to-be nil)))

    (it "scales org-document-title via h-doc"
      (expect (madoromi-test--face-attr 'org-document-title 'madoromi-haru-yoru :height) :to-equal 1.4))

    (it "scales info-title-1..3"
      (expect (madoromi-test--face-attr 'info-title-1 'madoromi-haru-yoru :height) :to-equal 1.3)
      (expect (madoromi-test--face-attr 'info-title-2 'madoromi-haru-yoru :height) :to-equal 1.2)
      (expect (madoromi-test--face-attr 'info-title-3 'madoromi-haru-yoru :height) :to-equal 1.1))

    (it "scales shr-h1..3"
      (expect (madoromi-test--face-attr 'shr-h1 'madoromi-haru-yoru :height) :to-equal 1.3)
      (expect (madoromi-test--face-attr 'shr-h2 'madoromi-haru-yoru :height) :to-equal 1.2)
      (expect (madoromi-test--face-attr 'shr-h3 'madoromi-haru-yoru :height) :to-equal 1.1))

    (it "scales asciidoc titles"
      (expect (madoromi-test--face-attr 'asciidoc-document-title-face 'madoromi-haru-yoru :height) :to-equal 1.4)
      (expect (madoromi-test--face-attr 'asciidoc-title-1-face 'madoromi-haru-yoru :height) :to-equal 1.3)
      (expect (madoromi-test--face-attr 'asciidoc-title-2-face 'madoromi-haru-yoru :height) :to-equal 1.2)
      (expect (madoromi-test--face-attr 'asciidoc-title-3-face 'madoromi-haru-yoru :height) :to-equal 1.1))

    (it "does not set :height on org-level-N (org inherits via outline)"
      ;; We leave org-level-N as a plain :inherit so that outline scaling
      ;; flows through. Setting :height directly would override the
      ;; inheritance chain.
      (dolist (face '(org-level-1 org-level-2 org-level-3))
        (expect (madoromi-test--face-attr face 'madoromi-haru-yoru :height) :to-be nil))))

  (describe "when disabled"
    (before-each
      (let ((madoromi-scale-headings nil))
        (madoromi-test--reload 'madoromi-haru-yoru)))

    (it "leaves outline-1..3 at 1.0"
      (expect (madoromi-test--face-attr 'outline-1 'madoromi-haru-yoru :height) :to-equal 1.0)
      (expect (madoromi-test--face-attr 'outline-2 'madoromi-haru-yoru :height) :to-equal 1.0)
      (expect (madoromi-test--face-attr 'outline-3 'madoromi-haru-yoru :height) :to-equal 1.0))

    (it "leaves org-document-title at 1.0"
      (expect (madoromi-test--face-attr 'org-document-title 'madoromi-haru-yoru :height) :to-equal 1.0))

    (it "leaves info / shr top levels at 1.0"
      (dolist (face '(info-title-1 info-title-2 info-title-3
                      shr-h1 shr-h2 shr-h3))
        (expect (madoromi-test--face-attr face 'madoromi-haru-yoru :height) :to-equal 1.0))))

  (describe "with custom scale factors"
    (before-each
      (let ((madoromi-scale-headings t)
            (madoromi-height-1 2.0)
            (madoromi-height-doc-title 2.5))
        (madoromi-test--reload 'madoromi-haru-yoru)))

    (it "honors the per-level height factors"
      (expect (madoromi-test--face-attr 'outline-1 'madoromi-haru-yoru :height) :to-equal 2.0)
      (expect (madoromi-test--face-attr 'markdown-header-face-1 'madoromi-haru-yoru :height) :to-equal 2.0)
      (expect (madoromi-test--face-attr 'org-document-title 'madoromi-haru-yoru :height) :to-equal 2.5))))

;;; Appearance options

(describe "italic comments"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "renders comments italic by default"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-test--face-attr 'font-lock-comment-face 'madoromi-haru-yoru :slant) :to-equal 'italic)
    (expect (madoromi-test--face-attr 'font-lock-doc-face 'madoromi-haru-yoru :slant) :to-equal 'italic))

  (it "drops the italic when disabled"
    (let ((madoromi-italic-comments nil))
      (madoromi-test--reload 'madoromi-haru-yoru))
    (expect (madoromi-test--face-attr 'font-lock-comment-face 'madoromi-haru-yoru :slant) :to-equal 'normal)
    (expect (madoromi-test--face-attr 'font-lock-doc-face 'madoromi-haru-yoru :slant) :to-equal 'normal)))

(describe "flat mode line"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "boxes the mode line by default"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-test--face-attr 'mode-line 'madoromi-haru-yoru :box) :not :to-be nil))

  (it "drops the box when flat"
    (let ((madoromi-flat-mode-line t))
      (madoromi-test--reload 'madoromi-haru-yoru))
    (expect (madoromi-test--face-attr 'mode-line 'madoromi-haru-yoru :box) :to-be nil)
    (expect (madoromi-test--face-attr 'mode-line-inactive 'madoromi-haru-yoru :box) :to-be nil)))

(describe "variable-pitch headings"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "leaves headings fixed-pitch by default"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-test--face-attr 'outline-1 'madoromi-haru-yoru :inherit) :to-equal 'default))

  (it "switches headings to variable-pitch when enabled"
    (let ((madoromi-use-variable-pitch t))
      (madoromi-test--reload 'madoromi-haru-yoru))
    (dolist (face '(outline-1 org-document-title markdown-header-face-1
                    asciidoc-title-1-face shr-h1 info-title-1))
      (expect (madoromi-test--face-attr face 'madoromi-haru-yoru :inherit) :to-equal 'variable-pitch))))

;;; Palette integrity

(describe "color palettes"
  (it "define the same set of color keys across all variants"
    (let ((expected (sort (mapcar #'car (madoromi-test--palette 'madoromi-haru-yoru)) #'string<)))
      (dolist (variant madoromi-test--variants)
        (expect (sort (mapcar #'car (madoromi-test--palette variant)) #'string<)
                :to-equal expected))))

  (it "contain all 26 native Madoromi slots"
    (dolist (alist (mapcar #'madoromi-test--palette madoromi-test--variants))
      (dolist (name '("sakura" "nadeshiko" "botan" "fuji"
                      "beni" "akane" "kaki" "yamabuki"
                      "wakaba" "tokiwa" "sora" "ruri"
                      "ai" "kikyo"
                      "sumi" "usuzumi1" "usuzumi0"
                      "kasure2" "kasure1" "kasure0"
                      "nijimi2" "nijimi1" "nijimi0"
                      "kami" "hyoshi" "chitsu"))
        (expect (assoc name alist) :not :to-be nil))))

  (it "have hex-formatted color values"
    (dolist (alist (mapcar #'madoromi-test--palette madoromi-test--variants))
      (dolist (entry alist)
        (expect (cdr entry) :to-match "\\`#[0-9a-fA-F]\\{6\\}\\'")))))

;;; Text has to be readable on its own background

(defconst madoromi-test--dim-colors
  '("kasure0" "kasure1" "kasure2"
    "nijimi0" "nijimi1" "nijimi2")
  "Palette entries reserved for intentionally de-emphasized text.
A face reaching for one of these is asking to recede, so it opts out of
the contrast floor rather than needing an entry in an exception list.")

(defconst madoromi-test--legibility-floor 3.0
  "Contrast a face's own text must reach against its own background.")

(defun madoromi-test--dim-p (variant color)
  "Return non-nil if COLOR is one of VARIANT's de-emphasized entries."
  (let ((palette (madoromi-test--palette variant)))
    (seq-some (lambda (name) (equal color (cdr (assoc name palette))))
              madoromi-test--dim-colors)))

(describe "text on its own background"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (dolist (variant madoromi-test--variants)
    (it (format "stays readable in %s" variant)
      (madoromi-test--reload variant)
      (let ((floor madoromi-test--legibility-floor)
            (illegible '()))
        (mapatoms
         (lambda (sym)
           (let ((fg (madoromi-test--face-attr sym variant :foreground))
                 (bg (madoromi-test--face-attr sym variant :background)))
             (when (and (stringp fg) (stringp bg)
                        ;; ansi and term color faces set foreground and
                        ;; background alike on purpose
                        (not (string-match-p "\\`\\(ansi\\|term\\)-color-" (symbol-name sym)))
                        (not (madoromi-test--dim-p variant fg))
                        (< (madoromi-test--contrast fg bg) floor))
               (push (list sym (madoromi-test--contrast fg bg)) illegible)))))
        (expect illegible :to-equal '())))))

;;; Backgrounds that match the buffer background

(defconst madoromi-test--flat-background-faces
  '(default fringe term
    line-number line-number-current-line
    line-number-major-tick line-number-minor-tick
    centaur-tabs-selected centaur-tabs-selected-modified
    tab-bar-tab tab-bar-tab-group-current tab-line-tab tab-line-tab-current)
  "Faces allowed to set `:background' to the variant's own `kami'.
Setting it elsewhere lifts nothing and punches through whatever is
underneath, such as `hl-line' or `region'.")

(describe "faces sitting on the buffer background"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (dolist (variant madoromi-test--variants)
    (it (format "only lets the allowed faces match kami in %s" variant)
      (madoromi-test--reload variant)
      (let ((bg (cdr (assoc "kami" (madoromi-test--palette variant))))
            (offenders '()))
        (mapatoms
         (lambda (sym)
           (when (and (assoc variant (get sym 'theme-face))
                      (equal (madoromi-test--face-attr sym variant :background) bg)
                      (not (memq sym madoromi-test--flat-background-faces)))
             (push sym offenders))))
        (expect offenders :to-equal '())))))

;;; Code-block backgrounds

(describe "markdown-code-face background"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  ;; Regression for #10: without an explicit :background, code blocks in
  ;; Latte could end up dark via inheritance / user customization. We
  ;; anchor the background to hyoshi in every variant.
  (dolist (variant madoromi-test--variants)
    (it (format "sets an explicit :background in %s" variant)
      (madoromi-test--reload variant)
      (let ((bg (madoromi-test--face-attr 'markdown-code-face variant :background))
            (mantle (cdr (assoc "hyoshi"
                                (madoromi-test--palette variant)))))
        (expect bg :to-equal mantle)))))

;;; Package coverage smoke tests

(describe "diredfl face coverage"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (dolist (variant madoromi-test--variants)
    (it (format "defines every diredfl-* face in %s" variant)
      (madoromi-test--reload variant)
      (dolist (face '(diredfl-file-name diredfl-file-suffix
                      diredfl-compressed-file-name diredfl-compressed-file-suffix
                      diredfl-ignored-file-name diredfl-deletion-file-name
                      diredfl-deletion diredfl-dir-heading diredfl-dir-name
                      diredfl-dir-priv diredfl-symlink diredfl-link-priv
                      diredfl-executable-tag diredfl-exec-priv diredfl-read-priv
                      diredfl-write-priv diredfl-no-priv diredfl-other-priv
                      diredfl-rare-priv diredfl-date-time diredfl-number
                      diredfl-flag-mark diredfl-flag-mark-line
                      diredfl-autofile-name diredfl-tagged-autofile-name))
        (expect (assoc variant (get face 'theme-face)) :not :to-be nil)))))

(defconst madoromi-test--package-faces
  '((anzu anzu-mode-line anzu-match-1 anzu-match-2 anzu-match-3
          anzu-replace-highlight anzu-replace-to)
    (jinx jinx-misspelled jinx-highlight jinx-save jinx-key jinx-annotation)
    (keycast keycast-key keycast-command)
    (completion-preview completion-preview completion-preview-common
                        completion-preview-exact)
    (dictionary dictionary-word-entry-face dictionary-word-definition-face
                dictionary-reference-face dictionary-button-face)
    (asciidoc-mode asciidoc-document-title-face asciidoc-title-1-face
                   asciidoc-title-5-face asciidoc-markup-face
                   asciidoc-code-face asciidoc-link-face asciidoc-url-face
                   asciidoc-metadata-key-face asciidoc-highlight-face
                   asciidoc-admonition-note-label-face
                   asciidoc-admonition-note-face
                   asciidoc-admonition-tip-label-face
                   asciidoc-admonition-important-label-face
                   asciidoc-admonition-caution-label-face
                   asciidoc-admonition-warning-label-face
                   asciidoc-admonition-warning-face)
    (cider cider-repl-result-face cider-fringe-bad-face
           cider-fringe-stale-face cider-reader-conditional-face
           cider-debug-prompt-face nrepl-message-1-face nrepl-message-8-face)
    (corfu corfu-popupinfo)
    (inf-ruby inf-ruby-result-overlay-face)
    (volatile-highlights vhl/default-face)
    (vundo vundo-node vundo-stem vundo-branch-stem vundo-highlight
           vundo-saved vundo-last-saved vundo-diff-highlight)
    (easy-kill easy-kill-selection easy-kill-origin)
    (copilot copilot-overlay-face)
    (mistty mistty-fringe-face)
    (clojure-mode clojure-keyword-face clojure-character-face
                  clojure-discard-face)
    (git-timemachine git-timemachine-commit
                     git-timemachine-minibuffer-author-face
                     git-timemachine-minibuffer-detail-face)
    (haskell-mode haskell-keyword-face haskell-type-face
                  haskell-constructor-face haskell-definition-face
                  haskell-operator-face haskell-pragma-face
                  haskell-hole-face haskell-error-face haskell-warning-face
                  haskell-interactive-face-prompt
                  haskell-interactive-face-compile-error
                  haskell-interactive-face-result)
    (erlang erlang-font-lock-exported-function-name-face
            erlang-edoc-heading erlang-edoc-tag erlang-edoc-macro
            erlang-edoc-verbatim erlang-edoc-todo)
    (breadcrumb breadcrumb-face breadcrumb-imenu-leaf-face
                breadcrumb-imenu-crumbs-face breadcrumb-imenu-base-face
                breadcrumb-project-leaf-face breadcrumb-project-crumbs-face
                breadcrumb-project-base-face)
    (gptel gptel-context-highlight-face gptel-context-deletion-face
           gptel-rewrite-highlight-face gptel-response-highlight
           gptel-response-fringe-highlight))
  "Alist of (PACKAGE . FACES) the theme is expected to cover.")

(describe "package face coverage"
  (before-all
    (madoromi-test--reload 'madoromi-haru-yoru))
  (after-all
    (disable-theme 'madoromi-haru-yoru))

  (dolist (entry madoromi-test--package-faces)
    (let ((package (car entry))
          (faces (cdr entry)))
      (it (format "themes %s" package)
        (dolist (face faces)
          (expect (assq 'madoromi-haru-yoru (get face 'theme-face))
                  :to-be-truthy)))))

  (it "gives jinx-misspelled the same underline as flyspell-incorrect"
    (expect (madoromi-test--face-attr 'jinx-misspelled 'madoromi-haru-yoru :underline)
            :to-equal
            (madoromi-test--face-attr 'flyspell-incorrect 'madoromi-haru-yoru :underline)))

  (it "styles inf-ruby's result overlay like cider's"
    (dolist (attr '(:foreground :background :box))
      (expect (madoromi-test--face-attr 'inf-ruby-result-overlay-face 'madoromi-haru-yoru attr)
              :to-equal
              (madoromi-test--face-attr 'cider-result-overlay-face 'madoromi-haru-yoru attr)))))
;;; The shape of the source itself

(defun madoromi-test--face-body ()
  "Return the part of the source holding the face definitions."
  (with-temp-buffer
    (insert-file-contents madoromi-test--source-file)
    (goto-char (point-min))
    (search-forward "madoromi--apply-theme")
    (buffer-substring-no-properties (point) (point-max))))

(defun madoromi-test--matches (regexp string &optional group)
  "Return every GROUP match of REGEXP in STRING."
  (let ((start 0) (found '()))
    (while (string-match regexp string start)
      (push (match-string (or group 1) string) found)
      (setq start (match-end 0)))
    (nreverse found)))

(describe "the source"
  (it "defines each face exactly once"
    (let* ((faces (madoromi-test--matches
                   "`(\\([^ ()]+\\) ((,class" (madoromi-test--face-body)))
           (seen (make-hash-table :test 'equal)) (dupes '()))
      (dolist (face faces)
        (when (gethash face seen) (push face dupes))
        (puthash face t seen))
      (expect (delete-dups dupes) :to-equal '())))

  (it "takes every color from the palette rather than hardcoding it"
    (expect (madoromi-test--matches
             ":\\(?:fore\\|back\\)ground \\(\"#[0-9a-fA-F]\\{6\\}\"\\)"
             (madoromi-test--face-body))
            :to-equal '()))

  (it "only refers to colors the palette defines"
    (let* ((defined (mapcar #'car (madoromi-test--palette 'madoromi-haru-yoru)))
           (used (delete-dups (madoromi-test--matches
                               ",madoromi-color-\\([a-z0-9-]+\\)" (madoromi-test--face-body)))))
      (expect (seq-remove (lambda (name) (member name defined)) used)
              :to-equal '()))))

;;; Package headers

(defconst madoromi-test--source-files
  (let ((dir (file-name-directory madoromi-test--source-file)))
    (mapcar (lambda (name) (expand-file-name name dir))
            (cons "madoromi.el" (mapcar (lambda (variant) (concat (symbol-name variant) "-theme.el")) madoromi-test--variants))))
  "Every hand-written file that ships in the package.")

(defun madoromi-test--file-text (file)
  (with-temp-buffer (insert-file-contents file) (buffer-string)))

(describe "package headers"
  (dolist (file madoromi-test--source-files)
    (let ((name (file-name-nondirectory file)))
      (it (format "%s opens with a summary and a lexical-binding cookie" name)
        (expect (car (split-string (madoromi-test--file-text file) "\n"))
                :to-match (rx-to-string '(seq ";;; " (1+ nonl) " --- " (1+ nonl)
                                              "-*- lexical-binding: t; -*-"))))
      (it (format "%s closes with the conventional footer" name)
        (expect (string-trim-right (madoromi-test--file-text file))
                :to-match (rx-to-string `(seq ";;; " ,name " ends here" eos))))))

  (it "declares the headers a package needs"
    (let ((text (madoromi-test--file-text madoromi-test--source-file)))
      (dolist (header '("Author" "URL" "Version" "Package-Requires" "Keywords"))
        (expect (string-match-p (concat "^;; " header ": ") text) :not :to-be nil))))

  (it "declares a Package-Requires that reads back as an alist"
    (let* ((text (madoromi-test--file-text madoromi-test--source-file))
           (_ (string-match "^;; Package-Requires: \\(.*\\)$" text))
           (deps (car (read-from-string (match-string 1 text)))))
      (expect (assq 'emacs deps) :not :to-be nil))))

;;; Emphasis restraint

(describe "emphasis"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (it "never stacks three emphasis attributes on one face"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (let ((overwrought '()))
      (mapatoms
       (lambda (sym)
         (when (assoc 'madoromi-haru-yoru (get sym 'theme-face))
           (when (> (seq-count (lambda (attr)
                                 (madoromi-test--face-attr sym 'madoromi-haru-yoru attr))
                               '(:weight :slant :underline :box :overline :strike-through))
                    2)
             (push sym overwrought)))))
      (expect overwrought :to-equal '()))))

;;; Public API

(describe "the public API"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v)))
    (setq madoromi-override-colors-alist '()))

  (it "reads a color from the active variant"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-get-color "kami") :to-equal "#241c26"))

  (it "reads a color from a variant that isn't active"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-get-color "kami" 'madoromi-haru-hiru) :to-equal "#f6eff8"))

  ;; `enable-theme-functions' only exists from Emacs 29.  Without this, every
  ;; command reading the active variant fails on 27 and 28, which the package
  ;; claims to support.
  (it "knows the active variant without enable-theme-functions"
    (let ((enable-theme-functions nil) (disable-theme-functions nil))
      (setq madoromi--current nil)
      (madoromi-test--reload 'madoromi-aki-yoru)
      (expect madoromi--current :to-be 'madoromi-aki-yoru)
      (expect (madoromi-get-color "kami") :to-equal "#271d14")))

  (it "binds palette colors inside madoromi-with-colors"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (expect (madoromi-with-colors kami) :to-equal "#241c26"))

  (it "lets madoromi-override-colors-alist win"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (setq madoromi-override-colors-alist '(("kami" . "#000000")))
    (expect (madoromi-get-color "kami") :to-equal "#000000"))

  (it "reapplies an override on reload"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (setq madoromi-override-colors-alist '(("kami" . "#010203")))
    (madoromi-reload)
    (expect (madoromi-test--face-attr 'default 'madoromi-haru-yoru :background)
            :to-equal "#010203"))

  (it "renders the palette buffer without error"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (madoromi-list-colors)
    (expect (get-buffer "*Madoromi Palette: madoromi-haru-yoru*") :not :to-be nil)))

;;; Switching between variants

(describe "madoromi-select"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (it "leaves exactly one variant enabled"
    (madoromi-test--reload 'madoromi-haru-yoru)
    (spy-on 'completing-read :and-return-value "madoromi-haru-hiru")
    (madoromi-select)
    (expect (seq-filter #'custom-theme-enabled-p madoromi-test--variants)
            :to-equal '(madoromi-haru-hiru)))

  (it "runs madoromi-after-load-hook with the chosen variant"
    (let* ((seen '())
           (madoromi-after-load-hook (list (lambda (theme) (push theme seen)))))
      (spy-on 'completing-read :and-return-value "madoromi-aki-yoru")
      (madoromi-select)
      (expect seen :to-equal '(madoromi-aki-yoru)))))

;;; Variant loading smoke tests

(describe "theme loading"
  (after-each
    (dolist (v madoromi-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (dolist (variant madoromi-test--variants)
    (it (format "loads %s without error" variant)
      (expect (load-theme variant t) :to-be-truthy)
      (expect (custom-theme-enabled-p variant) :to-be-truthy))))

;;; madoromi-test.el ends here