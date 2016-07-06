;;; mutt-setup.el --- Mutt setup

;;; Commentary:

;;; Code:

(defun ed/init-mail ()
  "Init mail files."
  (auto-fill-mode)
  (flyspell-mode))

(setq auto-mode-alist (cons '(".*/tmp/mutt.*" . mail-mode) auto-mode-alist))

(add-hook 'mail-mode-hook 'ed/init-mail)

;; (provide 'ed/mutt-setup)
;;; mutt-setup.el ends here
