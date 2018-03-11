;;; side-notes.el --- Easy access to a directory notes file  -*- lexical-binding: t; -*-

;; Copyright (c) 2018 Paul W. Rankin

;; Author: Paul W. Rankin <hello@paulwrankin.com>
;; Keywords: convenience

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

;; 

;;; Code:

(defgroup side-notes ()
  "Display a notes file."
  :group 'convenience)

(defcustom side-notes-hook
  nil
  "Hook run after showing notes buffer."
  :type 'hook
  :group 'side-notes)

(defcustom side-notes-file
  "notes.txt"
  "Name of the notes file to find.

This is always relative to `default-directory'. The idea is that
your project has its own directory and notes file, but if you
would like to use a file-specific notes file, specify a string
with `add-file-local-variable'."
  :type 'string
  :group 'side-notes)
(make-variable-buffer-local 'side-notes-file)

(defcustom side-notes-select-window
  t
  "If non-nil, switch to notes window upon displaying it."
  :type 'boolean
  :group 'notes)

(defcustom side-notes-display-alist
  '((side . right)
    (window-width . 35)
    (slot . 0))
  "Alist used to display notes buffer.

See `display-buffer-in-side-window' for example options."
  :type 'alist
  :group 'notes)

(defvar-local side-notes-buffer-identify
  nil
  "Buffer local variable to identify a notes buffer.")

(defun side-notes-toggle-notes (&optional arg)
  "Pop up a window containing notes of current directory.
If prefixed with ARG, create the `side-notes-file' if it does not exist."
  (interactive)
  (if side-notes-buffer-identify
      (quit-window)
    (let ((display-buffer-mark-dedicated t)
          (buffer (find-file-noselect
                   (expand-file-name side-notes-file default-directory))))
      (if (get-buffer-window buffer (selected-frame))
          (delete-windows-on buffer (selected-frame))
        (display-buffer-in-side-window buffer side-notes-display-alist)
        (with-current-buffer buffer
          (setq side-notes-buffer-identify t)
          (run-hooks 'side-notes-hook))
        (if side-notes-select-window
            (select-window (get-buffer-window buffer (selected-frame))))
        (message "Showing `%s'; %s to hide" buffer
                 (key-description (where-is-internal this-command
                                                     overriding-local-map t)))))))

(provide 'side-notes)
;;; side-notes.el ends here