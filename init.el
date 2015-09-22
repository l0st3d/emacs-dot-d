;;; init.el --- Ed's setup

;;; Commentary:

;;; Code:

(setq load-path (append (list "~/.emacs.d/local-lisp/") load-path))
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(dolist (lib '("general-setup"
	       "general-keybindings"
	       "java-setup"
	       "clojure-setup"))
  (load lib 'noerror))

(put 'set-goal-column 'disabled nil)

;; (provide 'init)
;;; init.el ends here
