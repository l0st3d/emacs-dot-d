;;; clojure-setup.el --- Ed's clojure setup

;;; Commentary:

;;; Code:

(require 'cider)
(require 'cider-client)
(require 'clj-refactor)
(require 'yasnippet)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-mode-hook #'yafolding-mode)

;; (setq cider-prompt-save-file-on-load 'always-save)

(cider-add-to-alist 'cider-jack-in-dependencies "alembic" "0.3.2")

(defun ed-clojure/compile-after-save ()
  "Compile after save."
  (when (and (eq major-mode 'clojure-mode)
	     (and (not (string-match ".*/profiles\\.clj$" (buffer-file-name)))
                  (not (string-match ".*/dot.lein.profiles\\.clj$" (buffer-file-name))))
	     (cider-connected-p))
    (if (string-match ".*/project\\.clj$" (buffer-file-name))
        (progn
          (cider-nrepl-request:eval "(try (require 'alembic.still) (catch Exception e))"
                                    (nrepl-make-response-handler (current-buffer)
                                                                 (lambda (_buffer result)
                                                                   (let ((msg (read result)))
                                                                     (message msg)))
                                                                 '() '() '()))
          (cider-nrepl-request:eval "(try (alembic.still/load-project) (catch Exception e))"
                                    (nrepl-make-response-handler (current-buffer)
                                                                 (lambda (_buffer result)
                                                                   (let ((msg (read result)))
                                                                     (message msg)))
                                                                 '() '() '())))
      (cider-load-buffer))))

(defun ed-clojure/json->edn (start end)
  "Convert JSON to EDN.  Takes region START and END."
  (interactive "r")
  (when (cider-connected-p)
    (cider-nrepl-request:eval
     (concat
      "(let [d " (prin1-to-string (buffer-substring-no-properties start end))"]
(or
 (try
  (require 'cheshire.core)
  (require 'camel-snake-kebab.core)
  (pr-str (cheshire.core/decode d camel-snake-kebab.core/->kebab-case-keyword))
  (catch Throwable e)))
"
      ")")
     (nrepl-make-response-handler (current-buffer)
                                  (lambda (_buffer result)
                                    (let ((msg (read result)))
                                      (kill-new msg)))
                                  '() '() '()))))

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
  (define-key clojure-mode-map (kbd "C-c \"") 'clojure-toggle-keyword-string)
  (define-key cider-repl-mode-map (kbd "C-c <C-backspace>") 'paredit-raise-sexp)
  (clj-refactor-mode 1)
  (yas-minor-mode 1)
  (aggressive-indent-mode)
  (cljr-add-keybindings-with-prefix "C-c r"))

(add-hook 'clojure-mode-hook 'ed-clojure/bind-keys)

(defun backward-up-sexp (arg)
  "ARG."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(global-set-key [remap backward-up-list] 'backward-up-sexp)

;; (provide 'clojure-setup)
;;; clojure-setup.el ends here
