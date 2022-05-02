;; Prevent any special-filename parsing of files loaded from the init file
(setq file-name-handler-alist nil)
;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)
;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
	    (setq gc-cons-threshold (expt 2 23))))

;; Disable the toolbar
(tool-bar-mode -1)
;; Alias for yes(y) and no(n)
(defalias 'yes-or-no-p 'y-or-n-p)
;; Line numbers
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))
;; Time 24hr format
(display-time-mode 1)
(setq display-time-24hr-format t)
;; Highlight the current line
(global-hl-line-mode 1)
;; Replace the standard text representation of various identifiers/symbols
(global-prettify-symbols-mode 1)
;; Default UTF8
(prefer-coding-system 'utf-8-unix)
;; Disable bell sound
(setq ring-bell-function 'ignore)
;; Matching pairs of parentheses
(show-paren-mode 1)
;; Whether confirmation is requested before visiting a new file or buffer
(setq confirm-nonexistent-file-or-buffer nil)
;; Make window title the buffer name
(setq-default frame-title-format '("%b"))
;; Line-style cursor similar to other text editors
(setq-default cursor-type 'bar)
;; Line and column display
(setq column-number-mode t)
(setq line-number-mode t)
;; Structure Templates org mode
(require 'org-tempo)

;; Delete old version backup
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
;; Set directory for backup and autosave
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)

(defun my/js-indent ()
;; 2 space for javascript mode
(setq js-indent-level 2)
;; js not set tab
(setq tab-stop-list nil)
(setq indent-tabs-mode nil))

;; Kill all buffers
(defun my/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))
;; Tangle my init org file
(defun my/tangle-dotfiles ()
  (interactive)
  (org-babel-tangle)
  (message "Dotfile tangled"))
;; Formatting C style
(defun my/gnu-astyle ()
  (interactive)
  (shell-command-to-string
    (concat
    "astyle -s2 --style=gnu --pad-header --align-pointer=name --indent-col1-comments --pad-first-paren-out " (buffer-file-name)))
  (revert-buffer :ignore-auto :noconfirm))

;; Ctrl-x, v, p
(cua-mode t)
;; Don't tabify after rectangle commands
(setq cua-auto-tabify-rectangles nil)
;; No region when it is not highlighted
(transient-mark-mode 1)
;; Standard Windows behaviour
(setq cua-keep-region-after-copy t)

;; No default startup buffer
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)
;; Default org-mode startup
(setq-default initial-major-mode 'org-mode
              major-mode 'org-mode
              initial-scratch-message ""
              read-file-name-completion-ignore-case t
              read-buffer-completion-ignore-case t
              mouse-yank-at-point t
              inhibit-startup-screen t
              package-check-signature nil)

;;NodeJS
(setenv "PATH" (concat (getenv "PATH") ":/opt/node-v16.15.0-linux-x64/bin"))
(setq exec-path (append exec-path '("/opt/node-v16.15.0-linux-x64/bin")))

;; Personal Elisp script
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("gnu" . "https://elpa.gnu.org/packages/")
                        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Automatically update Emacs packages
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; This package implements hiding or abbreviation of the mode line displays (lighters) of minor-modes  
(use-package diminish
  :ensure t)

;; which-key is a minor mode for Emacs that displays the key bindings following your currently entered incomplete command (a prefix) in a popup
(use-package which-key
  :ensure t
  :init
  (which-key-mode 1)
  :diminish which-key-mode)

;; Collection of Ivy-enhanced versions of common Emacs commands.
(use-package counsel
  :ensure t
  :after ivy
  :bind
  ("M-x"     . counsel-M-x)
  ("C-x f"   . counsel-describe-function)
  ("C-x v"   . counsel-describe-variable)
  ("C-x C-f" . counsel-find-file))

;; Generic completion mechanism for Emacs
(use-package ivy
  :ensure t
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (bind-key "C-c C-r" 'ivy-resume)
  (ivy-mode 1)
  (setq ivy-re-builders-alist
    '(( swiper . ivy--regex-plus)
    (t . ivy--regex-fuzzy)))
    :diminish ivy-mode)

;; Ivy-enhanced alternative to Isearch
(use-package swiper
  :ensure t
  :bind
  ("C-s" . 'swiper))

;; Editing yaml file
(use-package yaml-mode
  :ensure t)

;; Company is a text completion framework for Emacs
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)
  (company-tng-configure-default)
  (global-company-mode 1)
  :diminish company-mode)

;; Syntax checking 
(use-package flycheck
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'flycheck-mode)
  :config
  (progn
    (setq-default flycheck-disable-checkers 'c/c++-clang)))

;; Magit is a complete text-based user interface to Git
(use-package magit
  :ensure t
  :init
  (global-set-key (kbd "C-x g") 'magit-status))
;; Work with Git forges from the comfort of Magit 
(use-package forge
  :ensure t
  :after magit)

;; Zenburn theme
(use-package zenburn-theme
  :ensure t)
;; Solarized theme
(use-package solarized-theme
  :ensure t
  :init
  (load-theme solarized-dark t))
;; Powerline
(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

;; Indent Javascript hook
(add-hook 'js-mode-hook #'my/js-indent)

(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
  '(blink-cursor-blinks -1))

(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
  '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal)))))
