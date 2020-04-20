(setq cquery-executable-path "/home/mgrabarczyk/tools/cquery/build/release/bin/cquery")

(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "~/.emacs.d/custom")

(setq inhibit-startup-screen t) ; dont show startup screen
(setq package-enable-at-startup nil) ; to avoid initializing twice
(setq package-check-signature nil) ;; don't verify package signatures
(package-initialize) ;;  to be able to use packages

;; add package repositories
(when (>= emacs-major-version 24)
    (require 'package)
      (add-to-list
          'package-archives
             '("melpa" . "http://melpa.org/packages/")
                t))


;; PACKAGES
(unless (package-installed-p 'use-package) ;; install use-package package first
  (package-refresh-contents)
  (package-install 'use-package))

; always install packages if not present
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package use-package-hydra)

(use-package hydra
  :after use-package-hydra)

(use-package cc-mode)

;; better grep
(use-package ag)

;; parentheses management
(use-package smartparens
  :init
  (smartparens-global-mode t)
  :config
  (sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET"))) ; add empty line on RET within {}
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
  :bind ;(:map c++-mode-map
              ("C-M-k" . sp-kill-sexp)
              ("C-M-a" . sp-beginning-of-sexp)
              ("C-M-e" . sp-end-of-sexp)
              ("C-M-f" . sp-forward-sexp)
              ("C-M-b" . sp-backward-sexp)
              ("C-M-n" . sp-next-sexp)
              ("C-M-p" . sp-previous-sexp)
              ("<C-right>" . sp-forward-slurp-sexp)
              ("<C-left>" . sp-backward-slurp-sexp)
              ("<M-right>" . sp-forward-barf-sexp)
              ("<M-left>" . sp-backward-barf-sexp)
         ;     )
  )


;; better C-w
(use-package easy-kill
  :init
  (progn
  (global-set-key [remap kill-ring-save] 'easy-kill)
  ))

 ;; revert closed buffers
(use-package zygospore
  :bind (("C-x 1" . zygospore-toggle-delete-other-windows))
  )

 ;; better undo
(use-package undo-tree
  :bind (("C-z" . undo-tree-undo))
  )

;; highlight pasted text
(use-package volatile-highlights
  :config
  (volatile-highlights-mode t))

;; highlight and edit muliple words at point
(use-package iedit
  :bind (("C-]" . iedit-mode)))

; silently deletes trailing whitespaces
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode)
  )

;; adds modern cpp syntax, like Args... etc
(use-package modern-cpp-font-lock
  :config
  (modern-c++-font-lock-global-mode t)
  )

;; comment lines in a better way
(use-package comment-dwim-2
  :bind (("M-;" . comment-dwim-2))
  )

;; clean indentation white-space area
(use-package clean-aindent-mode
  :config
  (add-hook 'prog-mode-hook 'clean-aindent-mode)
  )

;; project management
(use-package projectile
  :init
  (setq projectile-keymap-prefix (kbd "C-c p"))
  (setq projectile-enable-caching t)
  (projectile-mode t)
  :config
  (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")
  (add-to-list 'projectile-project-root-files "compile_commands.json")
  (add-to-list 'projectile-project-root-files-top-down-recurring "compile_commands.json")
  (add-to-list 'projectile-project-root-files-bottom-up "compile_commands.json")
  :bind (("<f5>" . projectile-compile-project)
         )
  )

;; list buffers sorted by projectile project
(use-package ibuffer-projectile
  :after (projectile)
  :init
  (add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))
  (defalias 'list-buffers 'ibuffer)
  )

;; completion mechanism
(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode 1)
  :bind
  ("C-c C-r" . ivy-resume)
  ("<f6>" . ivy-resume)
  )

;; Ivy-enchaced versions of common emacs commands
(use-package counsel
  :bind
  ("M-x" . counsel-M-x)
  ("M-y" . counsel-yank-pop)
  ("C-x C-f" . counsel-find-file)
  ("<f1> f" . counsel-describe-function)
  ("<f1> v" . counsel-describe-variable)
  ("<f1> l" . counsel-load-library)
  ("<f2> i" . counsel-info-lookup-symbol)
  ("<f2> u" . counsel-unicode-char)
  ("C-c g" . counsel-git)
  ("C-c j" . counsel-git-grep)
  ("C-c k" . counsel-ag)
  ("C-x l" . counsel-locate)
  )

;; alternative to isearch
(use-package swiper
  :bind
  ("C-s" . swiper)
)

;; format C++ code
(use-package clang-format
  :bind (:map c++-mode-map
         ("C-c b" . clang-format-buffer)
         ("C-c r" . clang-format-region)
         )
  )

;; snippets
(use-package yasnippet
  :config
  (yas-global-mode 1)
  )

;; more snippets
(use-package yasnippet-snippets)

;; writable grep
(use-package wgrep)

;; git management
(use-package magit
  :bind ("C-x g" . magit-status)
  )

;; syntax checking on the fly
(use-package flycheck
  :init (global-flycheck-mode))

;; language server protocol, integration with xref
(use-package lsp-mode)

;; extensions to lsp-mode (flycheck etc)
(use-package lsp-ui
  :after (lsp-mode)
  :init
  ;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  )

;; company lsp backend
(use-package company-lsp
  :init
  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil))

;; company-completion
(use-package company
  :config
  (global-company-mode)
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-lsp))
  (set-face-attribute 'company-tooltip-annotation nil :foreground "hot pink")
  (set-face-attribute 'company-preview nil :foreground "lightgrey" :underline t  :inherit nil)
  (set-face-attribute 'company-preview-common nil :inherit 'company-preview)
  (set-face-attribute 'company-tooltip nil :background "gray25" :foreground "deep sky blue")
  (set-face-attribute 'company-tooltip-selection nil :background "steelblue" :foreground "white")
  (set-face-attribute 'company-tooltip-common nil :inherit 'company-tooltip :weight 'bold :foreground nil) ; foreground 'unspecified ?
  (set-face-attribute 'company-tooltip-common-selection nil :inherit 'company-tooltip-selection :weight 'bold)
  :bind ("<C-tab>" . company-complete)
  )

;; tags for c++
(use-package cquery
  :commands lsp-cquery-enable
  :init
  (defun cquery//enable ()
    (condition-case nil
        (lsp-cquery-enable)
      (user-error nil)))
  (add-hook 'c-mode-common-hook #'cquery//enable)
  (setq cquery-executable cquery-executable-path)
  (setq cquery-sem-highlight-method 'font-lock)
  (setq cquery-extra-init-params '(:completion (:detailedLabel t)))
  :bind (:map c++-mode-map
              ("M-/" . xref-find-definitions)
              )
  )

;; format lisp code
(use-package elisp-format)

;; naive code navigation without any additional TAGS file
(use-package dumb-jump
  :bind (:map dumb-jump-mode-map
              (("M-." . dumb-jump-go)
               ("M-," . dumb-jump-back)
               ("M-]" . dumb-jump-go-prompt)))
  :config
  (setq dumb-jump-selector 'ivy)
  (add-hook 'prog-mode-hook dumb-jump-mode)
  (add-hook 'c++-mode-hook (lambda () (dumb-jump-mode -1)))
  :ensure)

;; show keybindings for prefixes
(use-package which-key
  :config
  (which-key-mode))

;; colorify parentheses
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; better bottom buffer line
(use-package powerline
  :config
  (powerline-default-theme))

;; major mode for yaml files
(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

;; workspace management
(use-package eyebrowse
  :init
  (eyebrowse-mode t)
  :config
  (setq eyebrowse-new-workspace t)
  :bind (:map eyebrowse-mode-map
              ("M-1" . eyebrowse-switch-to-window-config-1)
              ("M-2" . eyebrowse-switch-to-window-config-2)
              ("M-3" . eyebrowse-switch-to-window-config-3)
              ("M-4" . eyebrowse-switch-to-window-config-4)
              )
  )

(use-package workgroups2
  :defer t
  :init
  (workgroups-mode 1)
  :custom
  (wg-prefix-key (kbd "C-c s"))
  )

;; resizing windows accordingly to golden ratio
(use-package golden-ratio
  :diminish golden-ratio-mode
  :init
  ;; (golden-ratio-mode 1)
  )

;; better window switching
(use-package ace-window
  :after hydra
  :bind (:map yas-minor-mode-map ("M-p" . hydra-window/body))
  :hydra (hydra-window (:color red :hint nil)
                       ("a" ace-window "ace")
                       ("s" ace-swap-window "swap")
                       ("h" (lambda() (interactive)
                              (split-window-right)
                              (windmove-right))
                        "split-h")
                       ("v" (lambda() (interactive)
                              (split-window-below)
                              (windmove-down))
                        "split-v")
                       ("<up>" enlarge-window "enlarge")
                       ("<down>" shrink-window "shrink")
                       ("<right>" enlarge-window-horizontally "enlarge-v")
                       ("<left>" shrink-window-horizontally "shrink-h")
  )
  )

; Show func definition on top of frame
(use-package stickyfunc-enhance)

; Switch frames with Shift + arrows
(use-package windmove
  :config
  ;; use command key on Mac
  (windmove-default-keybindings)
  ;; wrap around at edges
  (setq windmove-wrap-around t))

;; wandbox online compiler client
(use-package wandbox
  :ensure t
  :bind (:map yas-minor-mode-map ("C-c w" . hydra-wandbox/body))
  :hydra (hydra-wandbox (:color red :hint nil)
                        ("b" wandbox-compile-buffer "wandbox compile-buffer")
                        ("c" (wandbox-insert-template "gcc") "wandbox-c++ template"))
)


;; Hydra bindings

(defun hydra-buffer-movement/pre ()
  (set-cursor-color "#e52b50"))

(defun hydra-buffer-movement/post ()
  (set-cursor-color "#ffffff"))

(global-set-key
   (kbd "C-o")
   (defhydra hydra-buffer-movement (:pre hydra-buffer-movement/pre
                                         :post hydra-buffer-movement/post
                                         :color red)
     "vi"
     ("a" beginning-of-line)
     ("e" end-of-line)
     ("f" forward-char)
     ("b" backward-char)
     ("n" next-line)
     ("p" previous-line)
     ("k" backward-word "prev-subword")
     ("l" forward-word "next-subword")
     ("v" scroll-up-command "screen-down")
     ("c" scroll-down-command "screen-up")
     ("[" beginning-of-defun "begin-fun")
     ("m" end-of-defun "end-fun")
     ("q" nil "quit")))
  (hydra-set-property 'hydra-buffer-movement :verbosity 1)

;; CUSTOM FUNCTIONS

(defun fancy-tab (arg)
  "Tab for indentation or hippie abbrev."
    (interactive "P")
      (setq this-command last-command)
        (if (or (eq this-command 'hippie-expand) (looking-at "\\_>"))
                  (progn
                    (setq this-command 'hippie-expand)
                    (hippie-expand arg))
          (setq this-command 'indent-for-tab-command)
          (indent-for-tab-command arg)))

(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point)
  )

(defun kill-whole-subword (&optional arg)
  "Kill whole subword at point and place into 'kill-ring'.
    e.g. word 'CamelCase nextWord' , when cursor is in letter 'm' it will kill subword Camel"
(interactive "P")
  (forward-char 1)
  (let ((beg (get-point 'subword-backward))
        (end (get-point 'subword-forward)))
    (message "killed subword: \"%s\"" (buffer-substring beg end))
    (kill-region beg end)
    )
  )

(defun delete-current-buffer-file ()
  "Remove file connected to current buffer and kill buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; MISC

; Clean UI
(setq inhibit-startup-screen t) ; don't show startup screen
(menu-bar-mode -1) ; don't show menu bar
(tool-bar-mode -1) ; don't show toolbar
(scroll-bar-mode -1) ; don't show scroll bars

(load-theme 'tango-dark) ;; color theme
(global-auto-revert-mode 1) ;; auto revert files
(global-subword-mode 0)
(desktop-save-mode 1) ;; save emacs session buffers
(add-hook 'c-mode-common-hook 'hs-minor-mode) ;; hs-minor-mode for folding source code
(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET
(show-paren-mode 1) ; show parentheses match
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)) ; treat .h files as a c++ files
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode)) ; treat cuda files as a C++ files
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode)) ; treat cuda header files as a C++ files
(global-linum-mode 1) ; show line numbers
(setq Buffer-menu-name-width 60)
(setq tab-width 4) ; set default width of tab to 4 spaces
(setq shell-file-name "bash") ;; read ~/.bashrc before M-x shell or M-x compile
(setq shell-command-switch "-c")
(setq split-width-threshold nil)
(setq tramp-default-method "ssh")
(setq dired-dwim-target t)
(setq-default indent-tabs-mode nil) ;; use spaces instead of tabs
(add-to-list 'xref-prompt-for-identifier 'xref-find-references t) ; dont prompt when looking for references
(put 'dired-find-alternate-file 'disabled nil) ;; [dired] visit file or dir instead of open in new buffer

(setq hippie-expand-try-functions-list
      '(yas-hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-line
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(defalias 'yes-or-no-p 'y-or-n-p) ;; y/n instead of yes or no

;; show unncessary whitespaces that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; background transparency - for some terms, for cygwin it's unnecessary
(defun on-after-init ()
    (unless (display-graphic-p (selected-frame))
          (set-face-background 'default "unspecified-bg" (selected-frame))))
(add-hook 'window-setup-hook 'on-after-init)

;; grepignore
(eval-after-load "grep"
  '(progn
     (add-to-list 'grep-find-ignored-files "GPATH")
     (add-to-list 'grep-find-ignored-files "GRTAGS")
     (add-to-list 'grep-find-ignored-files "GTAGS")
     (add-to-list 'grep-find-ignored-files "*.obj")
     (add-to-list 'grep-find-ignored-files "*.vcxproj")
     (add-to-list 'grep-find-ignored-files "#*")
     (add-to-list 'grep-find-ignored-directories ".git")))

;; coding style
(defconst my-cpp-style
  '("stroustrup"
    (c-basic-offset . 4)
    (c-offsets-alist . ((innamespace . [0]))))) ;; no indent in namespaces

(c-add-style "my-cpp-style" my-cpp-style)
(setq c-default-style "my-cpp-style")

;; KEYBINDINGS

(global-set-key [(control shift right)] 'forward-word)
(global-set-key [(control shift left)] 'backward-word)

(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

(global-set-key (kbd "C-q") (quote kill-whole-subword))
(global-set-key (kbd "C-l") (quote kill-whole-line))

(global-set-key (kbd "C-x o")   'next-multiframe-window)
(global-set-key (kbd "C-x C-o") 'next-multiframe-window)

(global-set-key (kbd "C-x .") 'next-buffer)
(global-set-key (kbd "C-x ,") 'previous-buffer)

(global-set-key (kbd "C-x C-.") 'next-buffer)
(global-set-key (kbd "C-x C-,") 'previous-buffer)

(global-unset-key (kbd "C-x C-z"))
(global-set-key "\e\t" 'hippie-expand)

(define-key c++-mode-map (kbd "<tab>")  'fancy-tab)
(define-key c++-mode-map (kbd "TAB")  'fancy-tab)
(define-key c-mode-map (kbd "<tab>")  'fancy-tab)
(define-key c-mode-map (kbd "TAB")  'fancy-tab)
