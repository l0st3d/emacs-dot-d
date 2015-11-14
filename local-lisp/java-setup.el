;;; java-setup.el --- Ed's setup

;;; Commentary:
;;
;; Manual shell scripts look something like:
;;
;; #!/bin/bash
;; 
;; ## $1 is the data being asked for, and $2 is the buffer file name
;; case $1 in
;;     classpath)
;;         echo -n '/Users/ebo03/dev/java-scratchpad/target/classes/'
;;         ;;
;;     target-dir)
;;         echo -n '/Users/ebo03/dev/java-scratchpad/target/classes/'
;;         ;;
;;     project-dir)
;;         pwd -P
;;         ;;
;;     source-path)
;;         echo -n ''
;;         ;;
;;     source-version)
;;         echo -n '1.8'
;;         ;;
;;     target-version)
;;         echo -n '1.8'
;;         ;;
;;     post-compile-hook)
;;         ;;
;; esac

;;; Code:

(require 'flycheck)
(require 'cider)
(require 'ensime-macros)

;; constants
(defconst ed-java/mvn "/Users/ebo03/Apps/maven/bin/mvn")
(defconst ed-java/lein "/Users/ebo03/bin/lein")
(defconst ed-java/etags "/Applications/Emacs.app/Contents/MacOS/bin/etags")
(defconst ed-java/javac "javac")

;; global state
(defvar ed-java/project-classpaths (make-hash-table :test 'equal))
(defvar ed-java/project-repls (make-hash-table :test 'equal))

;; local state
(defvar-local ed-java/project-dir nil)
(defvar-local ed-java/project-type nil)
(defvar-local ed-java/target-compile-dir nil)
(defvar-local ed-java/compile-sourcepath nil)
(defvar-local ed-java/tags-file-location nil)

;; funcs
(defun ed-java/remove-whitespace (str)
  "Remove whitespace from a STR."
  (replace-regexp-in-string "[ \r\t\n]*" "" str))

(defun ed-java/find-above-buffer (file-name)
  "Docs with FILE-NAME."
  (when-let (file-name (locate-dominating-file (buffer-file-name) file-name))
	    (expand-file-name file-name)))

(defun ed-java/get-mvn-classpath (project-dir)
  "Docs with PROJECT-DIR."
  (shell-command-to-string (concat "cd " project-dir " ; " ed-java/mvn " -o  dependency:build-classpath | grep '^/'")))

(defun ed-java/get-lein-classpath (project-dir)
  "Docs with PROJECT-DIR."
  (concat "target:" (shell-command-to-string (concat "cd " project-dir " ; " ed-java/lein " classpath"))))

(defun ed-java/update-tags (tags-dir)
  "Docs with TAGS-DIR."
  (when ed-java/tags-file-location
    (shell-command-to-string (concat "cd " tags-dir " ; find . -iname '*.java' | xargs " ed-java/etags))))

(defun ed-java/run-tests ()
  "Docs."
  (interactive)
  (when ed-java/project-dir
    (compile (concat "cd " ed-java/project-dir " ; " ed-java/mvn " -o test"))))

(defun ed-java/compile ()
  "Docs."
  (interactive)
  (when ed-java/project-dir
    (compile (concat "cd " ed-java/project-dir " ; " ed-java/mvn " -o compile"))))

;; (defun ed-java/open-file-in-intelij ()
;;   "Docs."
;;   (interactive)
;;   (shell-command-to-string (concat "/Applications/IntelliJ IDEA 14 CE.app/Contents/MacOS/idea " (ed-java/find-above-buffer ".git") " --line" (int-to-string (line-number-at-pos))  " " (buffer-file-name))))

(defun ed-java/bind-java-keys ()
  "Docs."
  (local-set-key (kbd "C-c C-t") 'ed-java/run-tests)
  (local-set-key (kbd "C-c i") 'ed-java/open-file-in-intelij)
  (local-set-key (kbd "C-c C-c") 'ed-java/compile))

(defun ed-java/select-target-compile-dir (project-type project-dir manual-shell-script)
  "Return the compile dir given the PROJECT-TYPE, PROJECT-DIR, and MANUAL-SHELL-SCRIPT."
  (if (eq 'manual-shell-script project-type)
      (ed-java/remove-whitespace (shell-command-to-string (concat manual-shell-script " target-dir " (buffer-file-name))))
    (concat ed-java/project-dir "target" (when (eq 'lein project-type) "/classes"))))

(defun ed-java/select-project-dir (pom project-dot-clj manual-shell-script)
  "Select a project dir based on POM, PROJECT-DOT-CLJ and MANUAL-SHELL-SCRIPT."
  (or project-dot-clj pom (ed-java/remove-whitespace (shell-command-to-string (concat manual-shell-script " project-dir " (buffer-file-name))))))

(defun ed-java/select-project-type (pom project-dot-clj manual-shell-script)
  "Select a project dir based on POM, PROJECT-DOT-CLJ and MANUAL-SHELL-SCRIPT."
  (cond (manual-shell-script 'manual-shell-script)
	(project-dot-clj 'lein)
	(pom 'maven)))

(defun ed-java/select-project-classpath (project-type project-dir manual-shell-script)
  "Select a project classpath based on PROJECT-TYPE and PROJECT-DIR and MANUAL-SHELL-SCRIPT."
  (cond ((eq 'maven project-type) (ed-java/get-mvn-classpath project-dir))
	((eq 'lein project-type) (ed-java/get-lein-classpath project-dir))
	((eq 'manual-shell-script project-type) (ed-java/remove-whitespace (shell-command-to-string (concat manual-shell-script " classpath " (buffer-file-name)))))
	(t (message "Cannot find project classpath"))))

(defun ed-java/select-sourcepath (project-type project-dir manual-shell-script)
  "Select a project sourcepath based on PROJECT-TYPE, PROJECT-DIR and MANUAL-SHELL-SCRIPT."
  (cond ((eq 'maven project-type) (concat project-dir "src/main/java:" project-dir "src/test/java:"))
	((eq 'lein project-type) (concat project-dir "src"))
	((eq 'manual-shell-script project-type) (ed-java/remove-whitespace (shell-command-to-string (concat manual-shell-script " sourcepath " (buffer-file-name)))))))

(defun ed-java/init-java-buffer ()
  "Init java buffer."
  (let* ((pom (ed-java/find-above-buffer "pom.xml"))
	 (project-dot-clj (ed-java/find-above-buffer "project.clj"))
	 (manual-shell-script (concat (ed-java/find-above-buffer "compile-info.sh") "compile-info.sh"))
	 (project-dir (ed-java/select-project-dir pom project-dot-clj manual-shell-script)))
    (when project-dir
      (setq ed-java/project-type (ed-java/select-project-type pom project-dot-clj manual-shell-script))
      (setq ed-java/project-dir project-dir)
      (setq ed-java/compile-sourcepath (ed-java/select-sourcepath ed-java/project-type project-dir manual-shell-script))
      (setq ed-java/target-compile-dir (ed-java/select-target-compile-dir ed-java/project-type project-dir manual-shell-script))
      (when (not (gethash project-dir ed-java/project-classpaths))
	(puthash project-dir (ed-java/select-project-classpath ed-java/project-type project-dir manual-shell-script)
		 ed-java/project-classpaths)))
    (when-let (tags-dir (ed-java/find-above-buffer "TAGS"))
      (setq ed-java/tags-file-location tags-dir)))
  (ed-java/bind-java-keys))

(defun ed-java/after-save-action ()
  "Docs."
  (when ed-java/tags-file-location
    (ed-java/update-tags ed-java/tags-file-location)))

(defun ed-java/open-repl-for-project ()
  "Docs."
  (interactive)
  (let ((b (gethash ed-java/project-dir ed-java/project-repls)))
    (if (bufferp b)
    	(switch-to-buffer b)
      (progn
	(let ((cmd (concat "cd " ed-java/project-dir ":target/ ; groovysh -cp" (gethash ed-java/project-dir ed-java/project-classpaths))))
	  ;; ansi-term
	  ;; (shell cmd)
	  (puthash ed-java/project-dir (current-buffer) ed-java/project-repls))))))

(defun ed-java/reload-java-class-files-in-nrepl-projects ()
  "Docs."
  (when (and (eq 'lein ed-java/project-type) (cider-connected-p) (not flycheck-current-errors))
    (;; nrepl-request:eval
     message "(vinyasa.reimport/reimport-reload \"target/classes\")")))

;; flycheck
(flycheck-define-checker ed-java/check-with-javac
  "Check a java file with javac, given a classpath from mvn."
  :command ("javac" "-Xlint:all" "-classpath" (eval (gethash ed-java/project-dir ed-java/project-classpaths))
	    "-d" (eval (progn ed-java/target-compile-dir))
	    "-sourcepath" (eval (progn ed-java/compile-sourcepath))
	    ;; instead of source-original and flycheck-buffer-saved-p in predicates store in temp dir
	    ;; (eval
	    ;;  (let ((temp-file (concat (flycheck-temp-dir-system)
	    ;; 			      (replace-regexp-in-string
	    ;; 			       (if (eq 'maven ed-java/project-type)
	    ;; 				   ".*src/[mt][ae][is][nt]/java/"
	    ;; 				 ".*src/")
	    ;; 			       "/"
	    ;; 			       (buffer-file-name)))))
	    ;;    (make-directory (replace-regexp-in-string "[^/*]\\.java$" "" temp-file) 't)
	    ;;    (append-to-file nil nil temp-file)
	    ;;    temp-file))
	    source-original)
  :error-patterns ((error line-start (file-name) ":" line ": error: " (message) line-end))
  :modes java-mode
  :predicate (lambda () (and (flycheck-buffer-saved-p) ed-java/project-dir (gethash ed-java/project-dir ed-java/project-classpaths) (file-accessible-directory-p ed-java/target-compile-dir))))

;; (flycheck-define-checker ed-java/check-with-mvn
;;   "Check a java file with mvn."
;;   :command ("/Users/ebo03/Apps/maven/bin/mvn" "-f" (eval (concat ed-java/project-dir "pom.xml")) "compile")
;;   :error-patterns ((error line-start (file-name) ":[" line "]," column "] " (message) line-end))
;;   :modes java-mode
;;   :predicate (lambda () ed-java/project-dir))

(add-to-list 'flycheck-checkers 'ed-java/check-with-javac)
(add-hook 'java-mode-hook 'ed-java/init-java-buffer)
(add-hook 'after-save-hook 'ed-java/after-save-action)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; (add-hook 'flycheck-after-syntax-check-hook #'ed-java/reload-java-class-files-in-nrepl-projects)


;; (provide 'java-setup)
;;; java-setup.el ends here



