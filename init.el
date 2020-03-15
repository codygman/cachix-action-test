;; straight.el configuration and install
(setq straight-profiles '((nil . "~/.emacs.d/straight-versions.el")))
(setq straight-repository-branch "develop")
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default t)
(straight-use-package 'org-plus-contrib)
(straight-use-package '(org :local-repo nil))
(straight-use-package 'use-package)

;; tangle and load emacs-config.org
(defun my-emacs-everywhere-directory ()
  (if (eq nil (getenv "TRAVIS_OS_NAME"))
      "~/.emacs.d/"
    "~/build/codygman/my-emacs-everywhere/"))
(org-babel-load-file (format "%s/emacs-config.org" (my-emacs-everywhere-directory)))
