(global-unset-key "\C-x\C-c")

(global-set-key (kbd "C-z") 'smex)
(global-set-key (kbd "C-x M-b") 'bury-buffer)

(global-set-key (kbd "M-?") 'etags-select-find-tag-at-point)
(global-set-key (kbd "M-.") 'etags-select-find-tag)

(global-set-key (kbd "C-x C-b" ) 'ido-switch-buffer)
(global-set-key (kbd "C-x b" ) 'ido-switch-buffer)

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
