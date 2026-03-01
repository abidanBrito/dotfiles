;;; init.el --- Abi's GNU Emacs configuration -*- lexical-binding: t -*-

;; Copyright (C) 2025 Abidán Brito

;; Author: Abidán Brito <abidan.brito@gmail.com>
;; Maintainer: Abidán Brito <abidan.brito@gmail.com>
;; Created: 2025
;; Homepage: https://github.com/abidanBrito/dotfiles

;;; License:

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
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

;; This is my personal configuration layer for GNU Emacs.
;; I'm still getting acquainted with Emacs and the defaults I have set up
;; are those which work best for me.  If you're looking for best practices
;; or an unopinionated configuration, I'd recommend to look elsewhere.

;;; Code:

(when (< emacs-major-version 29)
  (user-error "This configuration requires GNU Emacs 29 or newer.  You're running %s" emacs-version))

(require 'org)
(require 'ob-tangle)

(setq vc-follow-symlinks nil)

(let* ((config-name "config")
       (org-file (expand-file-name (concat config-name ".org") user-emacs-directory))
       (el-file (expand-file-name (concat config-name ".el")  user-emacs-directory))
       (org-confirm-babel-evaluate nil))
  (when (or (not (file-exists-p el-file))
            (file-newer-than-file-p org-file el-file))
    (condition-case err
	(progn
	  (org-babel-tangle-file org-file)
	  (message "Bootstrapped: tangled %s.org → %s.el" config-name config-name))
      (error
       (error "Failed to tangle %s: %s" org-file (error-message-string err)))))
  (if (file-exists-p el-file)
      (load el-file nil 'nomessage)
    (error "Tangle produced no config.el - Check :tangle headers in %s" org-file)))

(provide 'init)
;;; init.el ends here
