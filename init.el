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
                rinari markdown-mode+ projectile yasnippet pomodoro
                scala-mode2 haskell-mode haml-mode coffee-mode tuareg
                flymake-ruby flymake-haskell-multi flymake-haml flymake-coffee
                solarized-theme nzenburn-theme)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(haskell-program-name "~/.cabal/bin/cabal-dev ghci")
 '(haskell-tags-on-save t)
 '(tuareg-support-metaocaml t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'nzenburn)

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

;;; TODO This should be done in one func with an argument
(defun split-window-func-vert ()
  "Loaded from Wikipedia"
    (interactive)
    (split-window-vertically)
    (set-window-buffer (next-window) (other-buffer)))
(defun split-window-func-horiz ()
  "Loaded from Wikipedia"
    (interactive)
    (split-window-horizontally)
    (set-window-buffer (next-window) (other-buffer)))

(global-set-key "\C-x2" 'split-window-func-vert )
(global-set-key "\C-x3" 'split-window-func-horiz )

(global-set-key [f12] (quote menu-bar-mode))
(global-set-key "" 'ibuffer)
(global-set-key (kbd "C-x m") 'eshell)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [S-return] (quote smart-open-line))
(global-set-key [C-S-return] (quote smart-open-line-above))

(defun dont-kill-emacs ()
      (interactive)
      (error (substitute-command-keys "To exit emacs: \\[kill-emacs]")))
(global-set-key "\C-x\C-c" 'dont-kill-emacs)

(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

(projectile-global-mode)
(yas-global-mode)
(global-linum-mode)
(global-whitespace-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(if (file-exists-p "~/.cabal/bin/agda-mode")
    (load-file (let ((coding-system-for-read 'utf-8))
             (shell-command-to-string "~/.cabal/bin/agda-mode locate"))))

(if (file-exists-p "~/quicklisp/slime-helper.el")
    (load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
  (setq inferior-lisp-program "sbcl"))

(setq tab-width 2)
(setq coffee-tab-width 2)
;; (pomodoro-add-to-mode-line)

;;;
;;; Org Mode
;;;

(if (eq system-type 'windows-nt)
    (progn
      (setq dropbox-path "C:/Users/ytaras/Dropbox"))
    (progn
      (setq dropbox-path "~/Dropbox")))

(defun dropbox-file-path (path)
  (concat 'string dropbox-path path))

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;;
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

;; I use C-M-r to start capture mode
(global-set-key (kbd "C-M-r") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/git/org/flagged.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/git/org/flagged.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/git/org/flagged.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("p" "Phone call" entry (file "~/git/org/flagged.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/git/org/flagged.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)



(setq org-mobile-inbox-for-pull "~/Dropbox/git/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-agenda-files (quote ("~/Dropbox/git/org")))
(setq org-default-notes-file "~/Dropbox/git/org/flagged.org")
(setq org-directory "~/Dropbox/git/org")

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)
