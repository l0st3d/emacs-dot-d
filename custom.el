(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-repl-display-help-banner nil)
 '(cljr-magic-require-namespaces
   (quote
    (("io" . "clojure.java.io")
     ("set" . "clojure.set")
     ("str" . "clojure.string")
     ("walk" . "clojure.walk")
     ("zip" . "clojure.zip")
     ("json" . "clojure.data.json"))))
 '(cursor-type (quote bar))
 '(custom-enabled-themes (quote (tango-dark)))
 '(delete-active-region nil)
 '(exec-path
   (quote
    ("/usr/local/bin" "/usr/local/sbin" "/usr/bin" "/usr/sbin" "/usr/libexec/emacs/25.1/x86_64-redhat-linux-gnu" "/home/ed/bin" "/home/ed/.sdkman/candidates/kotlin/current/bin/")))
 '(flycheck-checkers
   (quote
    (ed-java/check-with-javac ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck groovy haml handlebars haskell-ghc haskell-hlint html-tidy jade javascript-jshint javascript-eslint javascript-gjslint javascript-jscs javascript-standard json-jsonlint less luacheck lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr racket rpm-rpmlint rst rst-sphinx ruby-rubocop ruby-rubylint ruby ruby-jruby rust sass scala scala-scalastyle scss-lint scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim sql-sqlint tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(global-company-mode t)
 '(indent-tabs-mode nil)
 '(kotlin-tab-width 4)
 '(mouse-yank-at-point t)
 '(org-agenda-files (quote ("~/Documents/agenda.org")))
 '(package-selected-packages
   (quote
    (yasnippet-snippets kotlin-mode markdown-mode go-mode cargo flycheck-rust racer toml-mode helm helm-cider helm-company helm-flx helm-fuzzier helm-git helm-git-grep helm-projectile projectile company magit-find-file haskell-mode scion yafolding smex magit java-snippets groovy-mode gradle-mode flymake-ruby flycheck-protobuf flycheck-haskell flycheck-clojure eruby-mode ensime enh-ruby-mode company-web company-inf-ruby clojure-snippets clj-refactor aggressive-indent)))
 '(safe-local-variable-values
   (quote
    ((bug-reference-bug-regexp . "#\\(?2:[[:digit:]]+\\)")
     (checkdoc-package-keywords-flag))))
 '(sentence-end-double-space nil)
 '(sql-server ""))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(yafolding-ellipsis-face ((t (:background "Yellow"))) t))
