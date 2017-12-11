(require 'package)

;; Package Manager Settings
;;
;; add MELPA to the package archive
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; update the package metadata when missing
(unless package-archive-contents
  (package-refresh-contents))

;; install use-package - https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

;; General Settings
;;
;; user settings
(setq user-full-name "Miguel Guinada" user-mail-address "mguinada@gmail.com")

;; enable line numbers
(global-linum-mode t)
(setq linum-format "%3d\u2502 ")
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; no hard tabs
(setq tab-width 2 indent-tabs-mode nil)

;; no backup files
(setq make-backup-files nil)

;; os x key bindings
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))

;; scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; require newline at end of file
(setq require-final-newline t)

;; enable y and n for emacs queries
(defalias 'yes-or-no-p 'y-or-n-p)

;; buffers reflect external file changes
(global-auto-revert-mode t)

;; remove the toolbar, menu bar and scroll bars
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; disable splash screen
(setq inhibit-splash-screen t)

;; start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; init on org-mode
(setq initial-major-mode 'org-mode)

;; trim whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; boot integration
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
(add-to-list 'magic-mode-alist '(".* boot" . clojure-mode))

;; Packages
;;
;; exec-path-from-shell to read $PATH from shell - https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

;; SMEX for smart M-x - https://github.com/nonsequitur/smex
(use-package smex
  :ensure t
  :bind ("M-x" . smex))

;; ido - https://www.emacswiki.org/emacs/InteractivelyDoThings
(use-package ido
  :ensure t
  :config
  (setq ido-enable-prefix nil
	ido-enable-flex-matching t
	ido-create-new-buffer 'always
	ido-use-filename-at-point 'guess
	ido-max-prospects 10
	ido-default-file-method 'selected-window
	ido-auto-merge-work-directories-length nil)
  (ido-mode t))

;; ido-completing-read+ - https://github.com/DarwinAwardWinner/ido-completing-read-plus
(use-package ido-completing-read+
  :ensure t
  :config
  (ido-everywhere 1)
  (ido-ubiquitous-mode 1))

;; flx-ido - https://github.com/lewang/flx
(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode +1)
  ;; disable ido faces to see flx highlights
  (setq ido-use-faces nil))

;; which-key for help with key bindings - https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode +1))

;; expand region for region selection by semantic units - https://github.com/magnars/expand-region.el
(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "M-SPC") 'er/expand-region)
  (which-key-mode +1))

;; paredit for s-expression editing - https://www.emacswiki.org/emacs/ParEdit
(use-package paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  ;; enable in the *scratch* buffer
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  ;; easier for in-REPL code typing
  (define-key paredit-mode-map (kbd "M-RET") 'paredit-newline))

;; rainbow delimiters - https://github.com/jlr/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t)

;; Bracket matcher
(use-package paren
  :config
  (show-paren-mode t))

;; magit - a git interface - https://github.com/magit/magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; twilight-theme - https://emacsthemes.com/themes/twilight-theme.html
(use-package twilight-theme
  :ensure t
  :config
  (load-theme 'twilight t))

;; smart-mode-line - https://github.com/Malabarba/smart-mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'dark)
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

;; move between windows - https://www.emacswiki.org/emacs/WindMove
(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

;; unbound to find available key bindings - https://www.emacswiki.org/emacs/unbound.el
(use-package unbound
  :ensure t)

;; auto-complete - https://github.com/auto-complete/auto-complete
(use-package auto-complete
  :ensure t
  :init
  (require 'auto-complete-config)
  :config
  (ac-config-default)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict"))

;; auto-complete for the repl - https://github.com/clojure-emacs/ac-cider
(use-package ac-cider
  :ensure t
  :config
  (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
  (add-hook 'cider-mode-hook 'ac-cider-setup)
  (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
  (eval-after-load "auto-complete"
    '(progn
       (add-to-list 'ac-modes 'cider-mode)
       (add-to-list 'ac-modes 'cider-repl-mode))))

;; multiple cursors - https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-x c") 'mc/edit-lines)
  (global-set-key (kbd "C-x x") 'mc/mark-all-like-this)
  (global-set-key (kbd "M-p") 'mc/mark-previous-like-this)
  (global-set-key (kbd "M-n") 'mc/mark-next-like-this))

;; markdown mode - http://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  :ensure t)

;; YAML mode https://github.com/yoshiki/yaml-mode
(use-package yaml-mode
  :ensure t)

;; gist mode - https://github.com/defunkt/gist.el
(use-package gist
  :ensure t)

;; coffee script mode - https://github.com/defunkt/coffee-mode
(use-package coffee-mode
  :ensure t)

;; javascript mode - https://github.com/mooz/js2-mode
(use-package js2-mode
  :ensure t)

;; inf-ruby REPL buffer connected to a Ruby - https://github.com/nonsequitur/inf-ruby
(use-package inf-ruby
  :ensure t
  :config
  (add-hook 'ruby-mode-hook #'inf-ruby-minor-mode))

;; ruby mode - https://github.com/jwiegley/ruby-mode
(use-package ruby-mode
  :ensure t)

;; clojure mode - https://github.com/clojure-emacs/clojure-mode
(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

;; CIDER - https://github.com/clojure-emacs/cider
(use-package cider
  :ensure t
  :config
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

;; projectile for project management - https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))
