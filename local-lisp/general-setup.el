;;; general-setup.el --- Ed's general setup

;;; Commentary:

;;; Code:

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
(setq-default ispell-program-name "/usr/bin/aspell")
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

(setq frame-title-format (list (getenv "USER") " - %b"))

(setq sql-informix-options nil)

(subword-mode 1)
(smex-initialize)

(defun ed/untabify-line ()
  (interactive)
  (save-excursion
    (back-to-indentation)
    (let ((m (point)))
      (end-of-line)
      (untabify m (point)))))

(defun ed/un-camelcase-string (s &optional sep start)
  "Convert CamelCase string S to lower case with word separator SEP.
Default for SEP is a hyphen \"-\".

If third argument START is non-nil, convert words after that
index in STRING."
  (let ((case-fold-search nil))
    (while (string-match "[A-Z]" s (or start 1))
      (setq s (replace-match (concat (or sep "-")
				     (downcase (match-string 0 s)))
			     t nil s)))
    (downcase s)))

(defun ed/un-camelcase-region ()
  "Uncamelcase region."
  (interactive)
  (let* ((start (region-beginning))
	 (end (region-end))
	 (replacement (ed/un-camelcase-string (buffer-substring-no-properties start end))))
    (when (stringp replacement)
      (save-excursion
	(delete-region start end)
	(goto-char start)
	(insert replacement)))))

(defun ed/mark-more-like-this-thing-at-point ()
  "Mark more things like the thing at point.  Requires multiple-cursors."
  (interactive)
  (let ((this-cmd  this-command)
        (last-cmd  last-command)
        (regionp   mark-active))
    (cond ((set-mark (save-excursion (goto-char (mark))
                                     (forward-thing thgcmd-last-thing-type arg)
                                     (point))))
          (t
           (setq thgcmd-last-thing-type
                 (or thing
                     (prog1 (let ((icicle-sort-function  nil))
                              (intern (completing-read
                                       "Thing (type): " (thgcmd-things-alist) nil nil nil nil
                                       (symbol-name thgcmd-last-thing-type))))
                       (setq this-command  this-cmd))))
           (push-mark (save-excursion
                        (forward-thing thgcmd-last-thing-type (prefix-numeric-value arg))
                        (point))
                      nil t)))
    (let ((bnds  (thgcmd-bounds-of-thing-at-point thgcmd-last-thing-type)))
      (unless (or regionp  bnds)
        ;; If we are not on a thing, use `thing-region' to capture one.
        ;; Because it always puts point after mark, flip them if necessary.
        (thing-region (symbol-name thgcmd-last-thing-type))
        (when (natnump (prefix-numeric-value arg)) (exchange-point-and-mark)))
      ;; If we are not extending existing region, and we are in a thing (BNDS non-nil), then:
      ;; We have moved forward (or backward if ARG < 0) to the end of the thing.
      ;; Now we extend the region backward (or forward if ARG < 0) up to its beginning
      ;; (or end if ARG < 0), to select the whole thing.
      (unless (or regionp  (not bnds)  (eql (point) (car bnds)))
        (forward-thing thgcmd-last-thing-type (if (< (mark) (point)) 1 -1)))))
  (setq deactivate-mark  nil))

(defun ed/isearch-yank-symbol ()
  "*Put symbol at current point into search string."
  (interactive)
  (let ((sym (symbol-at-point)))
    (if sym
        (progn
          (setq isearch-regexp t
                isearch-string (concat "\\_<" (regexp-quote (symbol-name sym)) "\\_>")
                isearch-message (mapconcat 'isearch-text-char-description isearch-string "")
                isearch-yank-flag t))
      (ding)))
  (isearch-search-and-update))

;; (mc/mark-more-like-this-extended)

;; (global-aggressive-indent-mode)

;; (provide 'general-setup)
;;; general-setup.el ends here
