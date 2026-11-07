;;; coverage-test.el --- Full upstream face parity gate -*- lexical-binding: t; -*-

;; Coverage baseline extracted from batppuccin.el at
;; 233399d074499eea3268779b4bcc99cb2176a079 (GPL-3.0-or-later).
;; Copyright (C) 2026 Bozhidar Batsov
;; Distributed under GPL-3.0-or-later; see COPYING.

(require 'buttercup)
(require 'madoromi)
(let ((root (expand-file-name ".." (file-name-directory load-file-name))))
  (add-to-list 'custom-theme-load-path root))

(defconst madoromi-coverage--upstream-faces
  '(
    Info-quoted Man-overstrike Man-reverse Man-underline ansi-color-black ansi-color-blue
    ansi-color-bright-black ansi-color-bright-blue ansi-color-bright-cyan ansi-color-bright-green ansi-color-bright-magenta ansi-color-bright-red
    ansi-color-bright-white ansi-color-bright-yellow ansi-color-cyan ansi-color-green ansi-color-magenta ansi-color-red
    ansi-color-white ansi-color-yellow anzu-match-1 anzu-match-2 anzu-match-3 anzu-mode-line
    anzu-mode-line-no-match anzu-replace-highlight anzu-replace-to asciidoc-admonition-caution-face asciidoc-admonition-caution-label-face asciidoc-admonition-important-face
    asciidoc-admonition-important-label-face asciidoc-admonition-note-face asciidoc-admonition-note-label-face asciidoc-admonition-tip-face asciidoc-admonition-tip-label-face asciidoc-admonition-warning-face
    asciidoc-admonition-warning-label-face asciidoc-anchor-face asciidoc-code-face asciidoc-cross-reference-face asciidoc-document-title-face asciidoc-footnote-marker-face
    asciidoc-footnote-text-face asciidoc-highlight-face asciidoc-link-face asciidoc-link-mouse-face asciidoc-markup-face asciidoc-metadata-key-face
    asciidoc-metadata-value-face asciidoc-overline-face asciidoc-strike-through-face asciidoc-subscript-face asciidoc-superscript-face asciidoc-title-1-face
    asciidoc-title-2-face asciidoc-title-3-face asciidoc-title-4-face asciidoc-title-5-face asciidoc-underline-face asciidoc-url-face
    avy-background-face avy-goto-char-timer-face avy-lead-face avy-lead-face-0 avy-lead-face-1 avy-lead-face-2
    bookmark-face breadcrumb-face breadcrumb-imenu-base-face breadcrumb-imenu-crumbs-face breadcrumb-imenu-leaf-face breadcrumb-project-base-face
    breadcrumb-project-crumbs-face breadcrumb-project-leaf-face button calendar-month-header calendar-today calendar-weekday-header
    calendar-weekend-header centaur-tabs-active-bar-face centaur-tabs-default centaur-tabs-modified-marker-selected centaur-tabs-modified-marker-unselected centaur-tabs-selected
    centaur-tabs-selected-modified centaur-tabs-unselected centaur-tabs-unselected-modified cider-debug-code-overlay-face cider-debug-prompt-face cider-deprecated-face
    cider-enlightened-face cider-enlightened-local-face cider-error-highlight-face cider-fringe-bad-face cider-fringe-good-face cider-fringe-stale-face
    cider-instrumented-face cider-reader-conditional-face cider-repl-input-face cider-repl-prompt-face cider-repl-result-face cider-repl-stderr-face
    cider-repl-stdout-face cider-result-overlay-face cider-stacktrace-error-class-face cider-stacktrace-error-message-face cider-stacktrace-face cider-stacktrace-filter-active-face
    cider-stacktrace-filter-inactive-face cider-stacktrace-fn-face cider-stacktrace-ns-face cider-test-error-face cider-test-failure-face cider-test-success-face
    cider-traced-face cider-warning-highlight-face clojure-character-face clojure-discard-face clojure-keyword-face company-preview
    company-preview-common company-scrollbar-bg company-scrollbar-fg company-tooltip company-tooltip-annotation company-tooltip-annotation-selection
    company-tooltip-common company-tooltip-common-selection company-tooltip-deprecated company-tooltip-mouse company-tooltip-search company-tooltip-search-selection
    company-tooltip-selection compilation-column-number compilation-error compilation-info compilation-line-number compilation-mode-line-exit
    compilation-mode-line-fail compilation-mode-line-run compilation-warning completion-preview completion-preview-common completion-preview-exact
    completions-annotations completions-common-part completions-first-difference completions-group-separator completions-group-title completions-highlight
    consult-async-split consult-bookmark consult-buffer consult-file consult-highlight-match consult-imenu-prefix
    consult-key consult-line-number consult-line-number-prefix consult-preview-match consult-separator copilot-overlay-face
    corfu-annotations corfu-bar corfu-border corfu-current corfu-default corfu-deprecated
    corfu-popupinfo cursor custom-button custom-button-mouse custom-button-pressed custom-group-tag
    custom-group-tag-1 custom-state custom-variable-tag default diary dictionary-button-face
    dictionary-reference-face dictionary-word-definition-face dictionary-word-entry-face diff-added diff-changed diff-file-header
    diff-header diff-hl-change diff-hl-delete diff-hl-insert diff-hunk-header diff-indicator-added
    diff-indicator-changed diff-indicator-removed diff-nonexistent diff-refine-added diff-refine-changed diff-refine-removed
    diff-removed dired-broken-symlink dired-directory dired-flagged dired-header dired-ignored
    dired-mark dired-marked dired-perm-write dired-symlink dired-warning diredfl-autofile-name
    diredfl-compressed-file-name diredfl-compressed-file-suffix diredfl-date-time diredfl-deletion diredfl-deletion-file-name diredfl-dir-heading
    diredfl-dir-name diredfl-dir-priv diredfl-exec-priv diredfl-executable-tag diredfl-file-name diredfl-file-suffix
    diredfl-flag-mark diredfl-flag-mark-line diredfl-ignored-file-name diredfl-link-priv diredfl-no-priv diredfl-number
    diredfl-other-priv diredfl-rare-priv diredfl-read-priv diredfl-symlink diredfl-tagged-autofile-name diredfl-write-priv
    doom-modeline-bar doom-modeline-bar-inactive doom-modeline-buffer-file doom-modeline-buffer-major-mode doom-modeline-buffer-minor-mode doom-modeline-buffer-modified
    doom-modeline-buffer-path doom-modeline-evil-emacs-state doom-modeline-evil-insert-state doom-modeline-evil-motion-state doom-modeline-evil-normal-state doom-modeline-evil-operator-state
    doom-modeline-evil-replace-state doom-modeline-evil-visual-state doom-modeline-info doom-modeline-lsp-error doom-modeline-lsp-running doom-modeline-lsp-success
    doom-modeline-lsp-warning doom-modeline-project-dir doom-modeline-warning easy-kill-origin easy-kill-selection ediff-current-diff-A
    ediff-current-diff-B ediff-current-diff-C ediff-even-diff-A ediff-even-diff-B ediff-even-diff-C ediff-fine-diff-A
    ediff-fine-diff-B ediff-fine-diff-C ediff-odd-diff-A ediff-odd-diff-B ediff-odd-diff-C eglot-diagnostic-tag-deprecated-face
    eglot-diagnostic-tag-unnecessary-face eglot-highlight-symbol-face eglot-inlay-hint-face eldoc-highlight-function-argument elfeed-log-date-face elfeed-log-debug-level-face
    elfeed-log-error-level-face elfeed-log-info-level-face elfeed-log-warn-level-face elfeed-search-date-face elfeed-search-feed-face elfeed-search-filter-face
    elfeed-search-tag-face elfeed-search-title-face elfeed-search-unread-count-face elfeed-search-unread-title-face embark-collect-marked embark-collect-zebra-highlight
    embark-keybinding epa-field-body epa-field-name epa-mark epa-string epa-validity-disabled
    epa-validity-high epa-validity-low epa-validity-medium erc-action-face erc-bold-face erc-current-nick-face
    erc-default-face erc-direct-msg-face erc-error-face erc-fool-face erc-highlight-face erc-input-face
    erc-keyword-face erc-my-nick-face erc-nick-default-face erc-nick-msg-face erc-notice-face erc-pal-face
    erc-prompt-face erc-timestamp-face erc-underline-face erlang-edoc-heading erlang-edoc-macro erlang-edoc-tag
    erlang-edoc-todo erlang-edoc-verbatim erlang-font-lock-exported-function-name-face error escape-glyph eshell-ls-archive
    eshell-ls-backup eshell-ls-clutter eshell-ls-directory eshell-ls-executable eshell-ls-missing eshell-ls-product
    eshell-ls-readonly eshell-ls-special eshell-ls-symlink eshell-ls-unreadable eshell-prompt evil-ex-commands
    evil-ex-info evil-ex-lazy-highlight evil-ex-search evil-ex-substitute-matches evil-ex-substitute-replacement eww-form-checkbox
    eww-form-select eww-form-submit eww-form-text eww-form-textarea eww-invalid-certificate eww-valid-certificate
    fill-column-indicator flycheck-error flycheck-error-list-error flycheck-error-list-info flycheck-error-list-warning flycheck-fringe-error
    flycheck-fringe-info flycheck-fringe-warning flycheck-info flycheck-warning flymake-error flymake-note
    flymake-warning flyspell-duplicate flyspell-incorrect font-latex-bold-face font-latex-doctex-documentation-face font-latex-doctex-preprocessor-face
    font-latex-italic-face font-latex-math-face font-latex-script-char-face font-latex-sectioning-0-face font-latex-sectioning-1-face font-latex-sectioning-2-face
    font-latex-sectioning-3-face font-latex-sectioning-4-face font-latex-sectioning-5-face font-latex-sedate-face font-latex-slide-title-face font-latex-string-face
    font-latex-subscript-face font-latex-superscript-face font-latex-verbatim-face font-latex-warning-face font-lock-bracket-face font-lock-builtin-face
    font-lock-comment-delimiter-face font-lock-comment-face font-lock-constant-face font-lock-delimiter-face font-lock-doc-face font-lock-doc-markup-face
    font-lock-escape-face font-lock-function-call-face font-lock-function-name-face font-lock-keyword-face font-lock-misc-punctuation-face font-lock-negation-char-face
    font-lock-number-face font-lock-operator-face font-lock-preprocessor-face font-lock-property-name-face font-lock-property-use-face font-lock-regexp-grouping-backslash
    font-lock-regexp-grouping-construct font-lock-string-face font-lock-type-face font-lock-variable-name-face font-lock-variable-use-face font-lock-warning-face
    forge-issue-completed forge-issue-open forge-post-author forge-post-date forge-pullreq-draft forge-pullreq-merged
    forge-pullreq-open forge-pullreq-rejected forge-suffix-active forge-suffix-active-and-implied forge-suffix-implied forge-topic-closed
    forge-topic-label forge-topic-merged forge-topic-open forge-topic-unmerged fringe git-gutter-fr:added
    git-gutter-fr:deleted git-gutter-fr:modified git-gutter:added git-gutter:deleted git-gutter:modified git-gutter:unchanged
    git-timemachine-commit git-timemachine-minibuffer-author-face git-timemachine-minibuffer-detail-face gnus-group-mail-1 gnus-group-mail-1-empty gnus-group-mail-2
    gnus-group-mail-2-empty gnus-group-mail-3 gnus-group-mail-3-empty gnus-group-mail-low gnus-group-mail-low-empty gnus-group-news-1
    gnus-group-news-1-empty gnus-group-news-2 gnus-group-news-2-empty gnus-group-news-low gnus-group-news-low-empty gnus-header-content
    gnus-header-from gnus-header-name gnus-header-newsgroups gnus-header-subject gnus-summary-cancelled gnus-summary-normal-ancient
    gnus-summary-normal-read gnus-summary-normal-ticked gnus-summary-normal-unread gnus-summary-selected gptel-context-deletion-face gptel-context-highlight-face
    gptel-response-fringe-highlight gptel-response-highlight gptel-rewrite-highlight-face grep-context-face grep-error-face grep-hit-face
    grep-match-face haskell-constructor-face haskell-definition-face haskell-error-face haskell-hole-face haskell-interactive-face-compile-error
    haskell-interactive-face-compile-warning haskell-interactive-face-garbage haskell-interactive-face-prompt haskell-interactive-face-prompt-cont haskell-interactive-face-result haskell-keyword-face
    haskell-literate-comment-face haskell-operator-face haskell-pragma-face haskell-quasi-quote-face haskell-type-face haskell-warning-face
    header-line hi-blue hi-blue-b hi-green hi-green-b hi-pink
    hi-red-b hi-yellow highlight highlight-numbers-number hl-line hl-todo
    holiday homoglyph hydra-face-amaranth hydra-face-blue hydra-face-pink hydra-face-red
    hydra-face-teal icomplete-first-match icomplete-selected-match ido-first-match ido-incomplete-regexp ido-indicator
    ido-only-match ido-subdir ido-virtual inf-ruby-result-overlay-face info-header-node info-header-xref
    info-menu-header info-menu-star info-node info-title-1 info-title-2 info-title-3
    info-title-4 info-xref info-xref-visited isearch isearch-fail isearch-group-1
    isearch-group-2 ivy-confirm-face ivy-current-match ivy-match-required-face ivy-minibuffer-match-face-1 ivy-minibuffer-match-face-2
    ivy-minibuffer-match-face-3 ivy-minibuffer-match-face-4 ivy-remote ivy-virtual jinx-annotation jinx-highlight
    jinx-key jinx-misspelled jinx-save keycast-command keycast-key lazy-highlight
    line-number line-number-current-line line-number-major-tick line-number-minor-tick link link-visited
    lsp-face-highlight-read lsp-face-highlight-textual lsp-face-highlight-write lsp-ui-doc-background lsp-ui-doc-header lsp-ui-doc-highlight-hover
    lsp-ui-doc-url lsp-ui-peek-filename lsp-ui-peek-footer lsp-ui-peek-header lsp-ui-peek-highlight lsp-ui-peek-line-number
    lsp-ui-peek-list lsp-ui-peek-peek lsp-ui-peek-selection lsp-ui-sideline-code-action lsp-ui-sideline-current-symbol lsp-ui-sideline-global
    lsp-ui-sideline-symbol lsp-ui-sideline-symbol-info magit-bisect-bad magit-bisect-good magit-bisect-skip magit-blame-date
    magit-blame-dimmed magit-blame-hash magit-blame-heading magit-blame-margin magit-blame-name magit-blame-summary
    magit-branch-current magit-branch-local magit-branch-remote magit-branch-remote-head magit-branch-upstream magit-branch-warning
    magit-cherry-equivalent magit-cherry-unmatched magit-diff-added magit-diff-added-highlight magit-diff-base magit-diff-base-highlight
    magit-diff-context magit-diff-context-highlight magit-diff-file-heading magit-diff-file-heading-highlight magit-diff-file-heading-selection magit-diff-hunk-heading
    magit-diff-hunk-heading-highlight magit-diff-hunk-heading-selection magit-diff-lines-heading magit-diff-removed magit-diff-removed-highlight magit-diff-revision-summary
    magit-diff-revision-summary-highlight magit-diff-whitespace-warning magit-diffstat-added magit-diffstat-removed magit-dimmed magit-filename
    magit-hash magit-header-line magit-keyword magit-log-author magit-log-date magit-log-graph
    magit-mode-line-process magit-mode-line-process-error magit-process-ng magit-process-ok magit-reflog-amend magit-reflog-checkout
    magit-reflog-cherry-pick magit-reflog-commit magit-reflog-merge magit-reflog-other magit-reflog-rebase magit-reflog-remote
    magit-reflog-reset magit-section-heading magit-section-heading-selection magit-section-highlight magit-section-secondary-heading magit-sequence-done
    magit-sequence-drop magit-sequence-head magit-sequence-onto magit-sequence-part magit-sequence-pick magit-sequence-stop
    magit-signature-bad magit-signature-error magit-signature-expired magit-signature-expired-key magit-signature-good magit-signature-revoked
    magit-signature-untrusted magit-tag marginalia-archive marginalia-char marginalia-date marginalia-documentation
    marginalia-file-name marginalia-file-owner marginalia-file-priv-dir marginalia-file-priv-exec marginalia-file-priv-link marginalia-file-priv-no
    marginalia-file-priv-other marginalia-file-priv-rare marginalia-file-priv-read marginalia-file-priv-write marginalia-function marginalia-installed
    marginalia-key marginalia-lighter marginalia-list marginalia-mode marginalia-modified marginalia-null
    marginalia-number marginalia-size marginalia-string marginalia-symbol marginalia-true marginalia-type
    marginalia-value marginalia-version markdown-blockquote-face markdown-bold-face markdown-code-face markdown-footnote-marker-face
    markdown-header-face-1 markdown-header-face-2 markdown-header-face-3 markdown-header-face-4 markdown-header-face-5 markdown-header-face-6
    markdown-hr-face markdown-html-attr-name-face markdown-html-attr-value-face markdown-html-tag-name-face markdown-inline-code-face markdown-italic-face
    markdown-link-face markdown-list-face markdown-markup-face markdown-metadata-key-face markdown-metadata-value-face markdown-missing-link-face
    markdown-plain-url-face markdown-pre-face markdown-reference-face markdown-table-face markdown-url-face match
    mc/cursor-bar-face mc/cursor-face mc/region-face menu message-cited-text-1 message-cited-text-2
    message-cited-text-3 message-cited-text-4 message-header-cc message-header-name message-header-newsgroups message-header-other
    message-header-subject message-header-to message-header-xheader message-mml message-separator minibuffer-nonselected
    minibuffer-prompt mistty-fringe-face mode-line mode-line-buffer-id mode-line-emphasis mode-line-highlight
    mode-line-inactive mu4e-compose-separator-face mu4e-contact-face mu4e-draft-face mu4e-flagged-face mu4e-footer-face
    mu4e-forwarded-face mu4e-header-face mu4e-header-field-face mu4e-header-highlight-face mu4e-header-key-face mu4e-header-marks-face
    mu4e-header-title-face mu4e-header-value-face mu4e-highlight-face mu4e-link-face mu4e-modeline-face mu4e-ok-face
    mu4e-region-code mu4e-related-face mu4e-replied-face mu4e-special-header-value-face mu4e-system-face mu4e-thread-fold-face
    mu4e-title-face mu4e-trashed-face mu4e-unread-face mu4e-url-number-face mu4e-warning-face neo-banner-face
    neo-dir-link-face neo-expand-btn-face neo-file-link-face neo-header-face neo-root-dir-face neo-vc-added-face
    neo-vc-conflict-face neo-vc-default-face neo-vc-edited-face neo-vc-ignored-face neo-vc-missing-face neo-vc-needs-merge-face
    neo-vc-up-to-date-face nerd-icons-blue nerd-icons-cyan nerd-icons-dblue nerd-icons-dcyan nerd-icons-dgreen
    nerd-icons-dmaroon nerd-icons-dorange nerd-icons-dpink nerd-icons-dpurple nerd-icons-dred nerd-icons-dsilver
    nerd-icons-dyellow nerd-icons-green nerd-icons-lblue nerd-icons-lcyan nerd-icons-lgreen nerd-icons-lmaroon
    nerd-icons-lorange nerd-icons-lpink nerd-icons-lpurple nerd-icons-lred nerd-icons-lsilver nerd-icons-lyellow
    nerd-icons-maroon nerd-icons-orange nerd-icons-pink nerd-icons-purple nerd-icons-red nerd-icons-silver
    nerd-icons-yellow notmuch-crypto-decryption notmuch-crypto-part-header notmuch-crypto-signature-bad notmuch-crypto-signature-good notmuch-crypto-signature-good-key
    notmuch-crypto-signature-unknown notmuch-hello-logo-background notmuch-message-summary-face notmuch-search-count notmuch-search-date notmuch-search-flagged
    notmuch-search-matching-authors notmuch-search-non-matching-authors notmuch-search-subject notmuch-search-unread notmuch-tag-added notmuch-tag-deleted
    notmuch-tag-face notmuch-tag-flagged notmuch-tag-unread notmuch-tree-match-author-face notmuch-tree-match-date-face notmuch-tree-match-subject-face
    notmuch-tree-match-tag-face notmuch-tree-match-tree-face notmuch-tree-no-match-author-face notmuch-tree-no-match-date-face notmuch-tree-no-match-subject-face notmuch-tree-no-match-tag-face
    notmuch-tree-no-match-tree-face notmuch-wash-cited-text notmuch-wash-toggle-button nrepl-message-1-face nrepl-message-2-face nrepl-message-3-face
    nrepl-message-4-face nrepl-message-5-face nrepl-message-6-face nrepl-message-7-face nrepl-message-8-face orderless-match-face-0
    orderless-match-face-1 orderless-match-face-2 orderless-match-face-3 org-agenda-current-time org-agenda-date org-agenda-date-today
    org-agenda-date-weekend org-agenda-date-weekend-today org-agenda-done org-agenda-structure org-archived org-block
    org-block-begin-line org-block-end-line org-checkbox org-checkbox-statistics-done org-checkbox-statistics-todo org-code
    org-date org-document-info org-document-info-keyword org-document-title org-done org-drawer
    org-ellipsis org-footnote org-formula org-headline-done org-hide org-level-1
    org-level-2 org-level-3 org-level-4 org-level-5 org-level-6 org-level-7
    org-level-8 org-link org-meta-line org-priority org-property-value org-quote
    org-scheduled org-scheduled-previously org-scheduled-today org-special-keyword org-table org-tag
    org-target org-time-grid org-todo org-upcoming-deadline org-verbatim org-verse
    org-warning outline-1 outline-2 outline-3 outline-4 outline-5
    outline-6 outline-7 outline-8 persp-selected-face proced-mark proced-marked
    proced-sort-header pulse-highlight-start-face query-replace rainbow-delimiters-base-error-face rainbow-delimiters-depth-1-face rainbow-delimiters-depth-2-face
    rainbow-delimiters-depth-3-face rainbow-delimiters-depth-4-face rainbow-delimiters-depth-5-face rainbow-delimiters-depth-6-face rainbow-delimiters-depth-7-face rainbow-delimiters-depth-8-face
    rainbow-delimiters-depth-9-face rainbow-delimiters-mismatched-face rainbow-delimiters-unmatched-face reb-match-0 reb-match-1 reb-match-2
    reb-match-3 region ruler-mode-column-number ruler-mode-current-column ruler-mode-default ruler-mode-fill-column
    secondary-selection sh-heredoc sh-quoted-exec shadow show-paren-match show-paren-match-expression
    show-paren-mismatch shr-code shr-h1 shr-h2 shr-h3 shr-h4
    shr-h5 shr-h6 shr-link shr-mark shr-selected-link smerge-base
    smerge-lower smerge-markers smerge-refined-added smerge-refined-changed smerge-refined-removed smerge-upper
    solaire-default-face solaire-hl-line-face solaire-line-number-face solaire-minibuffer-face solaire-mode-line-face solaire-mode-line-inactive-face
    solaire-org-hide-face sp-pair-overlay-face sp-show-pair-match-content-face sp-show-pair-match-face sp-show-pair-mismatch-face speedbar-button-face
    speedbar-directory-face speedbar-file-face speedbar-highlight-face speedbar-selected-face speedbar-separator-face speedbar-tag-face
    success tab-bar tab-bar-tab tab-bar-tab-group-current tab-bar-tab-group-inactive tab-bar-tab-inactive
    tab-bar-tab-ungrouped tab-line tab-line-highlight tab-line-tab tab-line-tab-current tab-line-tab-inactive
    term term-color-black term-color-blue term-color-cyan term-color-green term-color-magenta
    term-color-red term-color-white term-color-yellow tooltip trailing-whitespace transient-amaranth
    transient-argument transient-blue transient-disabled-suffix transient-enabled-suffix transient-heading transient-inactive-argument
    transient-inactive-value transient-key transient-pink transient-purple transient-red transient-separator
    transient-teal transient-unreachable transient-unreachable-key transient-value treemacs-async-loading-face treemacs-directory-collapsed-face
    treemacs-directory-face treemacs-file-face treemacs-fringe-indicator-face treemacs-git-added-face treemacs-git-commit-diff-face treemacs-git-conflict-face
    treemacs-git-ignored-face treemacs-git-modified-face treemacs-git-renamed-face treemacs-git-unmodified-face treemacs-git-untracked-face treemacs-header-button-face
    treemacs-help-column-face treemacs-help-title-face treemacs-hl-line-face treemacs-marked-file-face treemacs-on-failure-pulse-face treemacs-on-success-pulse-face
    treemacs-root-face treemacs-root-remote-disconnected-face treemacs-root-remote-face treemacs-root-remote-unreadable-face treemacs-root-unreadable-face treemacs-tags-face
    treemacs-term-node-face treemacs-window-background-face undo-tree-visualizer-active-branch-face undo-tree-visualizer-current-face undo-tree-visualizer-default-face undo-tree-visualizer-register-face
    undo-tree-visualizer-unmodified-face vc-conflict-state vc-edited-state vc-locally-added-state vc-locked-state vc-missing-state
    vc-needs-update-state vc-removed-state vc-state-base vc-up-to-date-state vertical-border vertico-current
    vertico-group-separator vertico-group-title vertico-multiline vhl/default-face vundo-branch-stem vundo-diff-highlight
    vundo-highlight vundo-last-saved vundo-node vundo-saved vundo-stem warning
    web-mode-annotation-face web-mode-annotation-html-face web-mode-annotation-tag-face web-mode-annotation-type-face web-mode-annotation-value-face web-mode-block-attr-name-face
    web-mode-block-attr-value-face web-mode-block-comment-face web-mode-block-control-face web-mode-block-delimiter-face web-mode-block-face web-mode-block-string-face
    web-mode-builtin-face web-mode-comment-face web-mode-comment-keyword-face web-mode-constant-face web-mode-css-at-rule-face web-mode-css-color-face
    web-mode-css-comment-face web-mode-css-function-face web-mode-css-priority-face web-mode-css-property-name-face web-mode-css-pseudo-class-face web-mode-css-selector-class-face
    web-mode-css-selector-face web-mode-css-selector-tag-face web-mode-css-string-face web-mode-css-variable-face web-mode-current-column-highlight-face web-mode-current-element-highlight-face
    web-mode-doctype-face web-mode-error-face web-mode-filter-face web-mode-folded-face web-mode-function-call-face web-mode-function-name-face
    web-mode-html-attr-custom-face web-mode-html-attr-engine-face web-mode-html-attr-equal-face web-mode-html-attr-name-face web-mode-html-attr-value-face web-mode-html-entity-face
    web-mode-html-tag-bracket-face web-mode-html-tag-custom-face web-mode-html-tag-face web-mode-html-tag-namespaced-face web-mode-html-tag-unclosed-face web-mode-inlay-face
    web-mode-javascript-comment-face web-mode-javascript-string-face web-mode-json-comment-face web-mode-json-context-face web-mode-json-key-face web-mode-json-string-face
    web-mode-keyword-face web-mode-param-name-face web-mode-part-comment-face web-mode-part-face web-mode-part-string-face web-mode-preprocessor-face
    web-mode-script-face web-mode-sql-keyword-face web-mode-string-face web-mode-style-face web-mode-symbol-face web-mode-type-face
    web-mode-variable-name-face web-mode-warning-face web-mode-whitespace-face wgrep-delete-face wgrep-done-face wgrep-face
    wgrep-file-face wgrep-reject-face which-func which-key-command-description-face which-key-group-description-face which-key-key-face
    which-key-local-map-description-face which-key-note-face which-key-separator-face which-key-special-key-face whitespace-big-indent whitespace-empty
    whitespace-hspace whitespace-indentation whitespace-line whitespace-newline whitespace-space whitespace-space-after-tab
    whitespace-space-before-tab whitespace-tab whitespace-trailing widget-field window-divider window-divider-first-pixel
    window-divider-last-pixel woman-bold woman-italic xref-file-header xref-line-number xref-match
    )
  "All 1176 static faces from the pinned Batppuccin shared engine.")

(describe "full upstream face parity"
  (dolist (variant madoromi--variants)
    (let ((theme variant))
      (it (format "retains all upstream face specs in %s" theme)
        (unwind-protect
            (progn
              (load-theme theme t)
              (dolist (face madoromi-coverage--upstream-faces)
                (expect (assq theme (get face 'theme-face)) :to-be-truthy)))
          (disable-theme theme)))
      (it (format "never emits nil foreground/background colours in %s" theme)
        (unwind-protect
            (progn
              (load-theme theme t)
              (dolist (entry (get theme 'theme-settings))
                (when (eq (car entry) 'theme-face)
                  (dolist (spec (nth 3 entry))
                    (let ((props (cadr spec)))
                      (dolist (attr '(:foreground :background))
                        (when (plist-member props attr)
                          (expect (plist-get props attr) :to-be-truthy))))))))
          (disable-theme theme))))))


(defun madoromi-coverage--attr (face theme attr)
  "Read ATTR from FACE's stored THEME spec without frame recomputation."
  (plist-get (cadar (cadr (assq theme (get face 'theme-face)))) attr))

(describe "Madoromi semantic fidelity"
  (dolist (variant madoromi--variants)
    (let ((theme variant))
      (it (format "uses the guide's exact semantic slots in %s" theme)
        (unwind-protect
            (progn
              (load-theme theme t)
              (let ((palette (madoromi-palette
                              (intern (substring (symbol-name theme) 9)))))
                (dolist (entry '((default :foreground "sumi")
                                 (default :background "kami")
                                 (cursor :background "sakura")
                                 (font-lock-keyword-face :foreground "fuji")
                                 (font-lock-function-name-face :foreground "ai")
                                 (font-lock-string-face :foreground "wakaba")
                                 (font-lock-type-face :foreground "yamabuki")
                                 (font-lock-builtin-face :foreground "beni")
                                 (font-lock-comment-face :foreground "kasure2")
                                 (font-lock-variable-name-face :foreground "sumi")
                                 (font-lock-constant-face :foreground "kaki")
                                 (font-lock-preprocessor-face :foreground "tokiwa")
                                 (font-lock-property-name-face :foreground "ruri")
                                 (font-lock-property-use-face :foreground "ruri")
                                 (font-lock-number-face :foreground "kaki")
                                 (font-lock-operator-face :foreground "sora")
                                 (font-lock-escape-face :foreground "botan")
                                 (font-lock-bracket-face :foreground "usuzumi0")
                                 (font-lock-delimiter-face :foreground "usuzumi0")
                                 (font-lock-regexp-grouping-backslash :foreground "botan")
                                 (font-lock-regexp-grouping-construct :foreground "botan")
                                 (mode-line :background "chitsu")
                                 (mode-line-inactive :background "chitsu")
                                 (header-line :background "chitsu")
                                 (line-number :foreground "nijimi2")
                                 (outline-1 :foreground "fuji")
                                 (rainbow-delimiters-depth-1-face :foreground "fuji")
                                 (rainbow-delimiters-depth-2-face :foreground "ai")
                                 (rainbow-delimiters-depth-3-face :foreground "yamabuki")
                                 (rainbow-delimiters-depth-4-face :foreground "wakaba")
                                 (rainbow-delimiters-depth-5-face :foreground "botan")
                                 (rainbow-delimiters-depth-6-face :foreground "sora")
                                 (link :foreground "sora")
                                 (error :foreground "beni")
                                 (warning :foreground "yamabuki")
                                 (success :foreground "wakaba")
                                 (line-number-current-line :foreground "fuji")
                                 (region :background "selection")
                                 (hl-line :background "cursor-line")
                                 (isearch :background "search")
                                 (lazy-highlight :background "search-other")
                                 (diff-added :background "diff-add-bg")
                                 (diff-removed :background "diff-del-bg")
                                 (diff-changed :background "diff-chg-bg")
                                 (diff-refine-added :background "diff-add-text-bg")
                                 (diff-refine-removed :background "diff-del-text-bg")
                                 (diff-refine-changed :background "diff-chg-text-bg")))
                  (expect (madoromi-coverage--attr (nth 0 entry) theme (nth 1 entry))
                          :to-equal (cdr (assoc (nth 2 entry) palette))))))
          (disable-theme theme))))))


(describe "ANSI and appearance metadata"
  (dolist (variant madoromi--variants)
    (let ((theme variant))
      (it (format "uses all sixteen exact ANSI colours in %s" theme)
        (unwind-protect
            (progn
              (load-theme theme t)
              (let* ((flavour (intern (substring (symbol-name theme) 9)))
                     (ansi (cdr (assq flavour madoromi--ansi-palettes)))
                     (names '(black red green yellow blue magenta cyan white)))
                (dolist (prefix '(ansi-color term-color))
                  (dotimes (index 16)
                    (let ((face (intern (format "%s-%s%s" prefix
                                               (if (>= index 8) "bright-" "")
                                               (nth (% index 8) names)))))
                      (expect (madoromi-coverage--attr face theme :foreground)
                              :to-equal (aref ansi index))
                      (expect (madoromi-coverage--attr face theme :background)
                              :to-equal (aref ansi index)))))
                (expect (cadr (assq theme (get 'ansi-color-names-vector 'theme-value)))
                        :to-equal (cl-subseq ansi 0 8))))
          (disable-theme theme)))
      (it (format "declares the correct light/dark appearance for %s" theme)
        (unwind-protect
            (progn
              (load-theme theme t)
              (let ((expected (if (string-suffix-p "-hiru" (symbol-name theme))
                                  'light 'dark)))
                (expect (plist-get (get theme 'theme-properties) :background-mode)
                        :to-be expected)
                (expect (not (null (memq theme madoromi--light-variants)))
                        :to-equal (eq expected 'light))))
          (disable-theme theme))))))

(describe "invalid palette and theme requests"
  (it "rejects an unknown flavour without changing active-theme tracking"
    (let ((madoromi--current 'madoromi-haru-hiru))
      (expect (madoromi-palette 'unknown) :to-throw 'error)
      (expect (madoromi--apply-theme 'madoromi-unknown nil) :to-throw 'error)
      (expect madoromi--current :to-be 'madoromi-haru-hiru)))
  (it "rejects explicit unknown themes and lookup with no active theme"
    (let ((madoromi--current nil))
      (expect (madoromi-get-color "kami") :to-throw 'error)
      (expect (madoromi-get-color "kami" 'madoromi-unknown) :to-throw 'error))))

;;; coverage-test.el ends here
