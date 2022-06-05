;; Prevent any special-filename parsing of files loaded from the init file
(setq file-name-handler-alist nil)
;; Minimize garbage collection during startup
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))
;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (expt 2 23))))

;; Disable the toolbar
(tool-bar-mode -1)
;; Disable scrollbar
(scroll-bar-mode -1)
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
(setq-default cursor-type 'box)
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
;; Formatting C style using clang-format
(defun my/clang-format ()
  (interactive)
  (shell-command-to-string
    (concat
    "clang-format -i " (buffer-file-name)))
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
(setenv "PATH" (concat (getenv "PATH") ":/home/ivan/.local/node-v16.15.0.app/bin"))
(setq exec-path (append exec-path '("/home/ivan/.local/node-v16.15.0.app/bin")))

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

;; Icons
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

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
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d ")
	:diminish ivy-mode)

;; Ivy-enhanced alternative to Isearch
(use-package swiper
  :ensure t
  :bind
  ("C-s" . 'swiper))

;; Prescient
(use-package prescient
  :ensure t
  :config
  (setq prescient-sort-length-enable nil))
(use-package ivy-prescient
  :ensure t
  :after (prescient counsel)
  :config
  (setq ivy-prescient-retain-classic-highlighting t)
  (ivy-prescient-mode 1))
(use-package company-prescient
  :ensure t
  :after (prescient company)
  :config
  (company-prescient-mode 1))
(use-package selectrum-prescient
  :ensure t)

;; Tree file and directory 
(use-package neotree
  :ensure t
  :config
  (setq neo-window-fixed-size nil)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :bind
  ([f8] . 'neotree-toggle))

;; Editing yaml file
(use-package yaml-mode
  :ensure t)

;; Editor config
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1)
  :diminish editorconfig-mode)

;; ggtags
(use-package ggtags
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
  (lambda ()
    (when (derived-mode-p 'c-mode)
      (ggtags-mode t))))
  :diminish ggtags-mode)

;; Path bin exec
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Typescript mode
(use-package typescript-mode
  :ensure t)

;; Vterm for Emacs
(use-package vterm
  :ensure t)

;; Company is a text completion framework for Emacs
(use-package company
  :config
  (setq-local eldoc-documentation-function #'ggtags-eldoc-function)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (setq company-backends (delete 'company-semantic company-backends))
  (setq company-backends '((company-clang)))
  (setq company-format-margin-function 'company-text-icons-margin)
  (company-tng-mode)
  (global-company-mode 1)
  :diminish company-mode)

;; Company C Headers
(use-package company-c-headers
  :ensure t
  :config
  (add-to-list 'company-backends 'company-c-headers))

;; Tree-sitter provides a buffer-local syntax tree
(use-package tree-sitter
  :ensure t
  :config
 (add-hook 'c-mode-hook #'tree-sitter-mode)
 (add-hook 'c-mode-hook #'tree-sitter-hl-mode))
 (use-package tree-sitter-langs
  :ensure t)
 (use-package tree-sitter-indent
   :ensure t)

;; Projectile a project interaction library for Emacs.
(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'ivy)
  (projectile-mode +1)
  :bind (:map projectile-mode-map
  ("s-p" . projectile-command-map)
  ("C-c p" . projectile-command-map))
  :diminish projectile-mode)

;; Syntax checking 
(use-package flycheck
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'flycheck-mode)
  :config
  (setq flycheck-disable-checkers 'c/c++-clang))

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
  :ensure t
  :init
  (load-theme 'zenburn t))

;; Solarized theme
 (use-package solarized-theme
  :ensure t
  :init)

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
  '(default ((t (:family "DejaVuSansMono Nerd Font" :foundry "PfEd" :slant normal :weight normal :height 130 :width normal)))))
