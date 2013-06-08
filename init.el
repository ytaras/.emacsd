(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(starter-kit starter-kit-lisp starter-kit-bindings starter-kit-eshell starter-kit-ruby
                rinari markdown-mode+ projectile yasnippet
                scala-mode2 haskell-mode haml-mode coffee-mode
                flymake-ruby flymake-haskell-multi flymake-haml flymake-coffee
                solarized-theme)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'solarized-dark)

;;; TODO Separate to other file
(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (funcall indent-line-function))

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key [f12] (quote menu-bar-mode))
(global-set-key "" 'ibuffer)
(global-set-key (kbd "C-x m") 'eshell)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [S-return] (quote smart-open-line))
(global-set-key [C-S-return] (quote smart-open-line-above))

(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

(projectile-global-mode)
(yas-global-mode)
