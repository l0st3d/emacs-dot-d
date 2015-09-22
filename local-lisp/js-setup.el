;;; java-setup.el --- Ed's setup

;;; Commentary:

;;; Code:

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'flycheck)

(add-to-list 'flycheck-disabled-checkers 'javascript-jshint)

(provide 'js-setup)
;;; js-setup.el ends here
