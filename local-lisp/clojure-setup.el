;;; clojure-setup.el --- Ed's clojure setup

;;; Commentary:

;;; Code:

(require 'cider)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-mode-hook #'yafolding-mode)

;; (setq cider-prompt-save-file-on-load 'always-save)

(defun ed-clojure/compile-after-save ()
  "Compile after save."
  (when (and (eq major-mode 'clojure-mode)
	     (or (not (string-match ".*/project\\.clj$" (buffer-file-name)))
		 (not (string-match ".*/profiles\\.clj$" (buffer-file-name))))
	     (cider-connected-p))
    (cider-load-buffer)))

(add-hook 'after-save-hook 'ed-clojure/compile-after-save)
(require 'paredit)

(defun ed-clojure/bind-keys ()
  "Bind keys."
  (define-key clojure-mode-map (kbd "C-c <C-backspace>") 'paredit-raise-sexp)
  (define-key clojure-mode-map (kbd "C-c DEL") 'paredit-splice-sexp-killing-backward)
  (define-key clojure-mode-map (kbd "C-c C-9") 'paredit-backward-slurp-sexp)
  (define-key clojure-mode-map (kbd "C-c C-0") 'paredit-forward-slurp-sexp)
  (define-key clojure-mode-map (kbd "C-c C-(") 'paredit-backward-barf-sexp)
  (define-key clojure-mode-map (kbd "C-c C-)") 'paredit-forward-barf-sexp)
  (define-key clojure-mode-map (kbd "C-c \"") 'clojure-toggle-keyword-string))

(add-hook 'clojure-mode-hook 'ed-clojure/bind-keys)

;; (provide 'clojure-setup)
;;; clojure-setup.el ends here
