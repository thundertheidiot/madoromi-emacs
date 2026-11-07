;;; madoromi-haru-hiru-theme.el --- Madoromi haru-hiru theme -*- lexical-binding: t; -*-

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

;; The haru day / light Madoromi palette.
;; Derived from Batppuccin; colour design by samhain / the-moonwitch.
;; See `madoromi.el' for the shared infrastructure.

;;; Code:

(require 'madoromi)

(deftheme madoromi-haru-hiru "Madoromi haru, day / light.")

(put 'madoromi-haru-hiru 'theme-properties
     '(:kind color-scheme :background-mode light :family madoromi))

(madoromi--apply-theme 'madoromi-haru-hiru (madoromi-palette 'haru-hiru))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'madoromi-haru-hiru)

(provide 'madoromi-haru-hiru-theme)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; madoromi-haru-hiru-theme.el ends here
