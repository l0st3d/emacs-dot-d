;;; java-setup.el --- Ed's setup

;;; Commentary:

;;; Code:

(require 'flycheck)

;; constants
(defconst ed/mvn "/Users/ebo03/Apps/maven/bin/mvn")
(defconst ed/lein "/Users/ebo03/bin/lein")
(defconst ed/etags "/Applications/Emacs.app/Contents/MacOS/bin/etags")
(defconst ed/javac "javac")

;; global state
(defvar ed/project-classpaths (make-hash-table :test 'equal))
(defvar ed/project-repls (make-hash-table :test 'equal))

;; local state
(defvar-local ed/project-dir nil)
(defvar-local ed/project-type nil)
(defvar-local ed/tags-file-location nil)

;; funcs
(defun ed/find-above-buffer (file-name)
  (when-let (file-name (locate-dominating-file (buffer-file-name) file-name))
	    (expand-file-name file-name)))

(defun ed/get-mvn-classpath (project-dir)
  (shell-command-to-string (concat "cd " project-dir " ; " ed/mvn " -o  dependency:build-classpath | grep '^/'")))

(defun ed/get-lein-classpath (project-dir)
  (concat "target:" (shell-command-to-string (concat "cd " project-dir " ; " ed/lein " classpath"))))

(defun ed/update-tags (tags-dir)
  (when ed/tags-file-location
    (shell-command-to-string (concat "cd " tags-dir " ; find . -iname '*.java' | xargs " ed/etags))))

(defun ed/run-tests ()
  (interactive)
  (when ed/project-dir
    (compile (concat "cd " ed/project-dir " ; " ed/mvn " -o test"))))

(defun ed/compile ()
  (interactive)
  (when ed/project-dir
    (compile (concat "cd " ed/project-dir " ; " ed/mvn " -o compile"))))

(defun ed/open-file-in-intelij ()
  (interactive)
  (shell-command-to-string (concat "/Applications/IntelliJ IDEA 14 CE.app/Contents/MacOS/idea " (ed/find-above-buffer ".git") " --line" (int-to-string (line-number-at-pos))  " " (buffer-file-name))))

(defun ed/bind-java-keys ()
  (local-set-key (kbd "C-c C-t") 'ed/run-tests)
  (local-set-key (kbd "C-c i") 'ed/open-file-in-intelij)
  (local-set-key (kbd "C-c C-c") 'ed/compile))

(defun ed/init-java-buffer ()
  (let* ((pom (ed/find-above-buffer "pom.xml"))
	 (project-dot-clj (ed/find-above-buffer "project.clj"))
	 (project-dir (or project-dot-clj pom))
	 (tags-dir (ed/find-above-buffer "TAGS")))
    (when project-dir
      (setq ed/project-type (cond (pom 'maven)
				  (project-dot-clj 'lein)))
      (setq ed/project-dir project-dir)
      (when (not (gethash project-dir ed/project-classpaths))
	(puthash project-dir
		 (cond (pom (ed/get-mvn-classpath project-dir))
		       (project-dot-clj (ed/get-lein-classpath project-dir))
		       't (error "Cannot find project classpath"))
		 ed/project-classpaths)))
    (when tags-dir
      (setq ed/tags-file-location tags-dir)))
  (ed/bind-java-keys))

(defun ed/after-save-action ()
  (when ed/tags-file-location
    (ed/update-tags ed/tags-file-location)))

(defun ed/open-repl-for-project ()
  (interactive)
  (let ((b (gethash ed/project-dir ed/project-repls)))
    (if (bufferp b)
    	(switch-to-buffer b)
      (progn
	(let ((cmd (concat "cd " ed/project-dir ":target/ ; groovysh -cp" (gethash ed/project-dir ed/project-classpaths))))
	  ;; ansi-term
	  ;; (shell cmd)
	  (puthash ed/project-dir (current-buffer) ed/project-repls))))))

(defun ed/reload-java-class-files-in-nrepl-projects ()
  "Docs."
  (when (and (eq 'lein ed/project-type) (cider-connected-p) (not flycheck-current-errors))
    (;; nrepl-request:eval
     message "(vinyasa.reimport/reimport-reload \"target\")")))

;; flycheck
(flycheck-define-checker ed/check-with-javac
  "Check a java file with javac, given a classpath from mvn."
  :command ("javac" "-classpath" (eval (gethash ed/project-dir ed/project-classpaths))
	    "-d" (eval (concat ed/project-dir "target"))
	    "-sourcepath" (eval (concat ed/project-dir "src/main/java:" ed/project-dir "src/test/java"))
	    source-original)
  :error-patterns ((error line-start (file-name) ":" line ": error: " (message) line-end))
  :modes java-mode
  :predicate (lambda ()
	       (and ed/project-dir (gethash ed/project-dir ed/project-classpaths))))

(flycheck-define-checker ed/check-with-mvn
  "Check a java file with mvn."
  :command ("/Users/ebo03/Apps/maven/bin/mvn" "-f" (eval (concat ed/project-dir "pom.xml")) "compile")
  :error-patterns ((error line-start (file-name) ":[" line "]," column "] " (message) line-end))
  :modes java-mode
  :predicate (lambda () ed/project-dir))

(add-to-list 'flycheck-checkers 'ed/check-with-javac)
(add-hook 'java-mode-hook 'ed/init-java-buffer)
(add-hook 'after-save-hook 'ed/after-save-action)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; (add-hook 'flycheck-after-syntax-check-hook #'ed/reload-java-class-files-in-nrepl-projects)


;; (provide 'java-setup)
;;; java-setup.el ends here
