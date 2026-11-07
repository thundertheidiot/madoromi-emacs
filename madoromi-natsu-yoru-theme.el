;;; madoromi-natsu-yoru-theme.el --- Madoromi natsu-yoru theme -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Bozhidar Batsov

;; Author: Bozhidar Batsov <bozhidar@batsov.dev>

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

;; The natsu night / dark Madoromi palette.
;; Derived from Batppuccin; colour design by samhain / the-moonwitch.
;; See `madoromi.el' for the shared infrastructure.

;;; Code:

(require 'madoromi)

(deftheme madoromi-natsu-yoru "Madoromi natsu, night / dark.")

(put 'madoromi-natsu-yoru 'theme-properties
     '(:kind color-scheme :background-mode dark :family madoromi))

(madoromi--apply-theme 'madoromi-natsu-yoru (madoromi-palette 'natsu-yoru))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'madoromi-natsu-yoru)

(provide 'madoromi-natsu-yoru-theme)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; madoromi-natsu-yoru-theme.el ends here
