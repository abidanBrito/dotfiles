;;; Tempel templates  -*- mode: lisp-data; -*-
;;
;; Format: a `mode' symbol, then its templates.
;; Syntax cheatsheet:
;;   p    -> field / point         r    -> the active region
;;   n    -> newline               n>   -> newline + indent
;;   r>   -> region, reindented    "…"  -> literal string

fundamental-mode

(user    (user-login-name))
(host    (system-name))
(name    (user-full-name))
(email   (progn user-mail-address))
(sig     (user-full-name) " <" (progn user-mail-address) ">")
(today   (format-time-string "%Y-%m-%d"))
(day     (format-time-string "%A"))
(month   (format-time-string "%B"))
(week    (format-time-string "W%V"))
(now     (format-time-string "%Y-%m-%d %H:%M"))
(time    (format-time-string "%H:%M"))
(time12  (format-time-string "%I:%M %p"))
(iso     (format-time-string "%Y-%m-%dT%H:%M:%S%z"))      ; ISO-8061
(utc     (format-time-string "%Y-%m-%dT%H:%M:%SZ" nil t)) ; ISO-8601 (normalized to UTC)
(utcnow  (format-time-string "%Y-%m-%d %H:%M UTC" nil t)) ; Human-friendly UTC
(rfc     (format-time-string "%a, %d %b %Y %H:%M:%S %z")) ; RFC 2822/5322 date format (email date headers, RSS feeds)
(epoch   (format-time-string "%s"))                       ; Unix/POSIX time
(stamp   (format-time-string "%Y%m%d-%H%M%S"))            ; Filename-safe timestamp
(file    (file-name-nondirectory (or (buffer-file-name) (buffer-name))))
(rule    (make-string 60 ?-))

prog-mode

(todo       (abi/comment-prefix) "TODO(abi): " r)
(fixme      (abi/comment-prefix) "FIXME(abi): " r)
(bug        (abi/comment-prefix) "BUG(abi): " r)
(hack       (abi/comment-prefix) "HACK(abi): " r)
(temp       (abi/comment-prefix) "TEMP(abi): " r)
(important  (abi/comment-prefix) "IMPORTANT(abi): " r)
(question   (abi/comment-prefix) "QUESTION(abi): " r)
(note       (abi/comment-prefix) "NOTE(abi): " r)
(perf       (abi/comment-prefix) "PERF(abi): " r)

emacs-lisp-mode

(lambda  "(lambda (" p ")" n> r> ")")
(defun   "(defun " p " (" p ")" n> r> ")")
(use     "(use-package " p n> r> ")")

org-mode

(src    "#+begin_src " p n r n "#+end_src")
(quote  "#+begin_quote" n r n "#+end_quote")
