;;; sample.el --- A taste of Madoromi -*- lexical-binding: t; -*-

;; This file exists only to show the theme off in screenshots.  It packs
;; a bit of everything the syntax highlighting touches: comments,
;; docstrings, strings, keywords, symbols, numbers, and a few defuns.

(require 'cl-lib)

(defgroup madoromi-demo nil
  "A tiny group so the screenshot has a `defcustom' to color."
  :group 'faces)

(defcustom madoromi-demo-greeting "Hello, Madoromi!"
  "Text shown by `madoromi-demo-say-hello'."
  :type 'string)

(defconst madoromi-demo-flavors
  '(
     (haru-hiru . "#f6eff8")
     (natsu-hiru . "#e9f4f8")
     (aki-hiru . "#f8f0e9")
     (fuyu-hiru . "#f0f1f8")
     (haru-yoru . "#241c26")
     (natsu-yoru . "#132227")
     (aki-yoru . "#271d14")
     (fuyu-yoru . "#1c1e2a"))
  "Base background color for each flavor.")

(defun madoromi-demo-luminance (hex)
  "Return the relative luminance of HEX, a \"#rrggbb\" string."
  (cl-loop for i from 1 below 7 by 2
           for channel = (/ (string-to-number (substring hex i (+ i 2)) 16) 255.0)
           for weight in '(0.2126 0.7152 0.0722)
           sum (* weight (if (<= channel 0.03928)
                             (/ channel 12.92)
                           (expt (/ (+ channel 0.055) 1.055) 2.4)))))

(defun madoromi-demo-say-hello (&optional name)
  "Greet NAME, defaulting to `user-login-name'."
  (interactive)
  (let ((who (or name user-login-name)))
    (message "%s (%s)" madoromi-demo-greeting who)))

(provide 'sample)
;;; sample.el ends here
