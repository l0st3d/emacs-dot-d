(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
(display-time)
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(global-font-lock-mode t)
(ido-mode t)
(menu-bar-mode -1)
;; (mouse-avoidance-mode 'cat-and-mouse)
(mouse-wheel-mode 1)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'upcase-region 'disabled nil)
(savehist-mode 1)
(scroll-bar-mode -1)
(server-start)
(setq compilation-scroll-output t)
(setq completion-ignore-case t)
(setq-default ispell-program-name "/usr/local/bin/aspell")
(setq ido-enable-flex-matching t)
(setq ispell-personal-dictionary "~/.personalDictionary")
(setq make-backup-files nil)
(setq selective-display-ellipses t)
(setq visible-bell t)
(tool-bar-mode -1)
(winner-mode 1)
(setq inhibit-splash-screen t) 
(setq focus-follows-mouse t)
(setq mouse-autoselect-window t)
(setq cursor-type 'bar)
;; (bar-cursor-mode t)
(desktop-save-mode 1)
(setq inhibit-splash-screen t)

(setq sql-informix-options nil)

(subword-mode 1)
(smex-initialize)