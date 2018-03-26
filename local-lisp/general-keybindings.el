;;; package --- Summary
;;; Commentary:

;;; Code:
(global-unset-key "\C-x\C-c")

(global-set-key (kbd "C-z") 'helm-M-x)
(global-set-key (kbd "C-x M-b") 'bury-buffer)

(global-set-key (kbd "M-?") 'etags-select-find-tag-at-point)
(global-set-key (kbd "M-.") 'etags-select-find-tag)

(global-set-key (kbd "C-x C-b" ) 'helm-buffers-list)
(global-set-key (kbd "C-x b" ) 'helm-buffers-list)

(global-set-key (kbd "C-c C-g") 'rgrep)
;; (global-set-key (kbd "C-x M-o") 'moccur)

(global-set-key (kbd "C-M-y") 'browse-kill-ring)

(global-set-key (kbd "M-(") 'insert-pair)
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "C-M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)
(global-set-key (kbd "C-M-<") 'insert-pair)

(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-x o") 'other-frame)

;; (global-set-key (kbd "C-n") 'next-logical-line)
;; (global-set-key (kbd "C-p") 'previous-logical-line)

(global-set-key (kbd "C-M-=") 'ispell-region)
(global-set-key (kbd "C-c =") 'magit-status)
(global-set-key (kbd "C-c C-=") 'smerge-ediff)

(global-set-key (kbd "C-c <up>") 'enlarge-window)
(global-set-key (kbd "C-c <down>") 'shrink-window)

(global-set-key (kbd "C-c C-f") 'find-dired)

(global-set-key (kbd "C-c M-o") 'ed/rotate-windows)

(global-set-key (kbd "C-o") 'Control-X-prefix)

(fset 'ed/delete-indentation-insert-comma [?\M-^ ?,])
(global-set-key (kbd "C-M-^") 'ed/delete-indentation-insert-comma)

(global-set-key (kbd "C-^") 'delete-blank-lines)

(global-set-key (kbd "C-n") 'next-logical-line)
(global-set-key (kbd "C-p") 'previous-logical-line)

(global-set-key (kbd "s-SPC") 'org-agenda)

(require 'multiple-cursors)
(define-prefix-command 'ed/C-x-C-c-prefix)
(global-set-key (kbd "C-x C-c") 'ed/C-x-C-c-prefix)
(define-key ed/C-x-C-c-prefix (kbd "C-SPC") 'mc/mark-all-like-this)
(define-key ed/C-x-C-c-prefix (kbd "C-c") 'mc/mark-all-words-like-this)
(define-key ed/C-x-C-c-prefix (kbd "C-m") 'mc/mark-more-like-this-extended)
(define-key ed/C-x-C-c-prefix (kbd "C-r") 'mc/mark-all-in-region-regexp)
(define-key ed/C-x-C-c-prefix (kbd "C-/") 'company-complete)
(define-key ed/C-x-C-c-prefix (kbd "C-d") 'find-dired)
(define-key ed/C-x-C-c-prefix (kbd "C-z") 'smex)
(define-key ed/C-x-C-c-prefix (kbd "b") 'ido-switch-buffer)
(define-key ed/C-x-C-c-prefix (kbd "C-b") 'helm-bookmarks)
(define-key ed/C-x-C-c-prefix (kbd "C-y") 'helm-show-kill-ring)
(define-key ed/C-x-C-c-prefix (kbd "C-f") 'helm-projectile)
(define-key ed/C-x-C-c-prefix (kbd "C-g") 'helm-projectile-grep)
(define-key ed/C-x-C-c-prefix (kbd "C-h") 'helm-cider-apropos)

;; (defhydra hydra-ed-C-x-C-C (:colour blue)
;;   "
;; ^Multicursor^                      ^Company^
;; ^^^^^^^^-----------------------------------------------------------------
;; _SPC_: Mark all like region        _/_: Company complete
;;   _c_: Mark all symbols like this
;;   _m_: Mark here

;;   _q_: quit
;; "
;;   ("SPC" mc/mark-all-like-this)
;;   ("c" mc/mark-all-symbols-like-this)
;;   ("m" mc/create-fake-cursor-at-point)
;;   ("/" company-complete)
;;   ("q" nil "quit"))

;; (global-set-key (kbd "C-x C-c") 'hydra-ed-C-x-C-C/body)

(provide 'general-keybindings)
;;; general-keybindings.el ends here
