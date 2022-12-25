;;; init.el --- my Emacs init file

;;; Commentary:

;; My Emacs init file.
;; I'd like to leave it very minimal.

;;; Code:

;; Prevent any special-filename parsing of files loaded from the init file
(setq file-name-handler-alist nil)

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      read-process-output-max (* 1024 1024))

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (expt 2 23))))

;; Scrolling by pixel lines
(pixel-scroll-mode 1)

;; Disable the menubar
(menu-bar-mode -1)

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
(require 'time)
(display-time-mode 1)
(setq display-time-24hr-format 1
      display-time-format "%H:%M")

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

;; Token
(require 'auth-source)
(setq auth-sources '("~/.authinfo"))

;; Save Cursor Position
(save-place-mode 1)

;; Save minibuffer history
(savehist-mode 1)

;; Keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

;; Icomplete
(require 'icomplete)
(icomplete-mode 1)
(setq icomplete-separator "\n")
(setq icomplete-hide-common-prefix nil)
(setq icomplete-in-buffer t)
(define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-backward-completions)
(fido-vertical-mode 1)

;; ANSI Coloring in Compilation Mode
;; (require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

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

;; undo
(setq undo-no-redo t)

;; Eldoc only emacs-lisp-mode
(global-eldoc-mode -1)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

;; Kill all buffers
(defun nullzeiger-kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; Tangle my init org file
(defun nullzeiger-tangle-dotfiles ()
  "Tangle my org file for generate init.el."
  (interactive)
  (org-babel-tangle)
  (message "Dotfile tangled"))

;; Formatting C style using indent
(defun nullzeiger-indent-format ()
  "Formatting c file using indent."
  (interactive)
  (shell-command-to-string
    (concat
    "indent --no-tabs " (buffer-file-name)))
  (revert-buffer :ignore-auto :noconfirm))

;; Create TAGS file for c
(defun nullzeiger-create-tags (dir-name)
  "Create tags file in DIR-NAME."
  (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))

;; Call passwordclimanager for print all password
(defun nullzeiger-password ()
  "Print all my personal password."
  (interactive)
  (shell-command "passwordclimanager -a"))

;; No default startup buffer
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
;; Native elisp file compile
(setq package-native-compile t)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			("gnu" . "https://elpa.gnu.org/packages/")
			("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; dabbrev mode key
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)

;; Flymake
(require 'flymake)
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
;; Activate flymake in c-mode
(add-hook 'c-mode-hook 'flymake-mode)
;; Activate flymake in c++-mode
(add-hook 'c++-mode-hook 'flymake-mode)
;; Activate flymake in emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'flymake-mode)
;; Activate flymake in python-mode
(add-hook 'python-mode-hook 'flymake-mode)

;; Java Path
(setenv "PATH" (concat (getenv "PATH") ":/home/ivan/.sdkman/candidates/java/current/bin/"))
(setq exec-path (append exec-path '("/home/ivan/.sdkman/candidates/java/current/bin/")))
;; passwordclimanager Path
(setenv "PATH" (concat (getenv "PATH") ":/home/ivan/dev/c/password-cli-manager/src/"))
(setq exec-path (append exec-path '("/home/ivan/dev/c/password-cli-manager/src/")))

;; Electric-pair
(add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)

;; Set calendar
(require 'solar)
(setq calendar-latitude 49.5137)
(setq calendar-longitude 8.4176)
(setq calendar-location-name "Ludwigshafen")

;; My birthday
(setq holiday-other-holidays '((holiday-fixed 5 22 "Compleanno")))

;; Auto reload TAGS
(require 'etags)
(setq tags-revert-without-query 1)

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
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 130 :width normal)))))

;;; init.el ends here
