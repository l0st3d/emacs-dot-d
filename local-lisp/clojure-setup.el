;;; clojure-setup.el --- Ed's setup

;;; Commentary:

;;; Code:

(require 'cider)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-mode-hook #'yafolding-mode)

;; (setq cider-prompt-save-file-on-load 'always-save)u

(add-hook 'after-save-hook (lambda ()
			     (when (and (eq major-mode 'clojure-mode)
					(not (string-match ".*/project\\.clj$" (buffer-file-name)))
					(cider-connected-p))
			       (cider-load-buffer))))
(require 'paredit)

(defun ed/clojure-bind-keys ()
  (local-set-key (kbd "C-c <C-BACKSPACE>") 'paredit-raise-sexp))

(add-hook 'cider-mode-hook 'ed/clojure-bind-keys)

;; (provide 'clojure-setup)
;;; clojure-setup.el ends here
