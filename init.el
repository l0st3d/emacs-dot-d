;;; init.el --- Ed's setup

;;; Commentary:

;;; Code:

(setq load-path (append (list "~/.emacs.d/local-lisp/") load-path))
(require 'package)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(dolist (lib '("general-setup"
	       "general-keybindings"
	       "java-setup"
	       "clojure-setup"))
  (load lib 'noerror))

;; Temp adding this here, while I get it working
(load-file "/home/ed/dev/l0st3d/emacs-jvm-build-minor-mode/l0st3d-jvm-build.el")
(l0st3d-jvm-build/initialise-mode)

(put 'set-goal-column 'disabled nil)

;; (provide 'init)
;;; init.el ends here
