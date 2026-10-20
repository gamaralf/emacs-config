;; -*- lexical-binding: t; -*-
(require 'package)

;;; Code:

;; Peguei muita coisa de:
;; https://github.com/mgmarlow/start-emacs/blob/main/init.el

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
  
(push "~/.emacs.d/lib/" load-path)

(setq custom-file "~/tmp/emacs-config/custom.el")
(load custom-file)

;;=== Emacs server----------------------------------------------------
;; Fonte: http://www.littleredbat.net/mk/blog/story/73/
(require 'server)
(defun start-named-server (name)
  "Start a server named 'NAME' - ensure only 1 server of that name is running."
  (interactive "sServer Name: ")
  (setq server-name name)
  (setq mk-server-socket-file (concat server-socket-dir "/" name))
  (unless (file-exists-p mk-server-socket-file)
    (server-start)))
(start-named-server "server") ; default server-name

;;=== Pacotes gerais -------------------------------------------------
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Executar esta função uma vez em novas instalações do Emacs para
;; instalar todos os pacotes que eu uso vide:
;; https://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
(defun instalar-pacotes ()
  "Instalar pacotes que eu uso partir de uma lista."
  (interactive)

  ;;~ lista de pacotes desejados
  ;;~ Pegar lista de pacotes instalados de package-activated-list
  ;; TODO tirar algus daqui e usar use-package pra configurar atalhos e etc
  ;; OBSOLETOS?: coffee-mode enh-ruby-mode helm-projectile helm helm-core
  (setq lista-de-pacotes '(use-package highlight-thing
                            fic-mode autothemer hl-todo impatient-showdown
                            impatient-mode htmlize lua-mode magit git-commit 
                            markdown-mode projectile robe inf-ruby
                            rspec-mode rubocop ruby-electric ruby-extra-highlight
                            ruby-interpolation simple-httpd tldr
                            with-editor yafolding yasnippet-snippets
                            yasnippet yaml-mode zenburn-theme web-mode))

  ;;~ atualizar lista de pacotes
  (unless package-archive-contents (package-refresh-contents))

  ;;~ instalar os pacotes faltantes
  (dolist (pacote lista-de-pacotes)
    (unless (package-installed-p pacote)
      (package-install pacote))))

;;~ '(initial-buffer-choice "~/org/Diario_de_bordo.org")

;; (instalar-pacotes)
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))
                                        ;
(use-package undo-tree :config (global-undo-tree-mode))
(use-package flycheck)
(use-package gruvbox-theme)
(use-package unicode-fonts :config (unicode-fonts-setup))
(use-package which-key :config (which-key-mode))
(use-package smartparens :config (smartparens-mode))
;; (use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
(use-package yasnippet :config (yas-global-mode 1))
(use-package multiple-cursors)
(use-package all-the-icons-dired
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))
(use-package eglot
  ;; Uncomment these dotted pairs to automatically activate Eglot when
  ;; that major mode is active.
  ;;
  ;; :hook ((rust-ts-mode . eglot-ensure)
  ;;        (go-ts-mode . eglot-ensure))
  :bind (("C-c ." . eglot-code-action-quickfix))
  )

;;~ https://www.masteringemacs.org/article/unicode-ligatures-color-emoji
;;~ https://github.com/mickeynp/ligature.el
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures
   'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers.  You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package web-mode
  :hook emmet-mode
  :config
  (setq web-mode-enable-current-column-highlight t
        web-mode-enable-current-element-highlight t))

;; (use-package company-web
;;   :config
;;   (set (make-local-variable 'company-backends)
;;        '(company-css company-web-html company-yasnippet company-files)))

(use-package emmet-mode
  :bind
  ("C-j" . emmet-expand-line)
  :hook
  (emmet-preview-mode))

;;=== Completar: company ou corfu? -------------------------------------------------
;; (use-package company :hook ((prog-mode text-mode) . company-mode)) ;; Code completion at point

;;== vertico e cia (ou heml) -----------------------------------------------
;; Better minibuffer completion
(use-package vertico
  :init
  (vertico-mode)
  
  ;; (setq vertico-scroll-margin 0) ;; Different scroll margin
  ;; (setq vertico-count 20) ;; Show more candidates
  ;; (setq vertico-resize t) ;; Grow and shrink the Vertico minibuffer

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  
  :bind
  ("<f3>" . recentf))

;; Persist minibuffer history over Emacs restarts. Vertico uses this
;; to sort based on history.
(use-package savehist
  :init
  (savehist-mode))

;; para melhorar o vertico
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Show lots of useful stuff in the minibuffer
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; Replace the default Emacs isearch with Consult, which offers a rich
;; minibuffer results window and integration with Orderless.
(use-package consult
  :ensure t
  ;; :bind (("C-s" . consult-line)
  ;;        :map minibuffer-local-map
  ;;        ("C-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region))

;; https://elpa.gnu.org/packages/corfu.html
(use-package corfu
  :init
  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  ;; (corfu-history-mode)
  ;; (corfu-mouse-mode)
  ;; (corfu-popupinfo-mode)

  :custom
  (corfu-auto t)
  ;; You might want to configure these variables to suit your
  ;; preferences.  It's recommended to have some amount of delay if
  ;; you use Corfu with Eglot, otherwise editing performance could
  ;; suffer.
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2) )

;;=== funçõe úteis-----------------------------------------------------

(defun start-or-end-kbd-macro ()
  "Start defining a keyboard macro, or stop if we're already defining."
  ;; IMPORTANT: Any function bound to a key MUST have an interactive spec,
  ;; usually just the following line:
  (interactive)
  (if defining-kbd-macro
      (end-kbd-macro)
    (start-kbd-macro nil)))

(defun forward-or-backward-sexp (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg))
        ((looking-back "\\s)" 1) (backward-sexp arg))
        ;; Now, try to succeed from inside of a bracket
        ((looking-at "\\s)") (forward-char) (backward-sexp arg))
        ((looking-back "\\s(" 1) (backward-char) (forward-sexp arg))))

(load-file "./config/funcoes-ergoemacs.el")

;;== Arquivos de config ----------------------------------------------
;; (load "~/.emacs.d/config/geral")

(defun gg-config-geral ()
  "Configurações gerais do Emacs."
  (interactive)

  (when (display-graphic-p) ;; voltei window-system e tirei display-graphic-p
    (message "** Redimensionando a janela (display-graphic-p)")
    (let ((larg 117) (alt 47))
      (set-frame-size (selected-frame) larg alt)
      ;;frame TODO porque a expansão de variável não funciona?
      ;; (setq dimensoes '((width . larg) (height . alt)))
      (setq default-frame-alist '((width . 117) (height . 47)))))

  (load-theme 'gruvbox-dark-hard)
  (smartparens-global-mode)
  (size-indication-mode)
  (require 'recentf)
  (recentf-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (column-number-mode)
  (cua-mode)
  (global-display-line-numbers-mode)

  ;; Respect color escape sequences.  Particularly useful for "M-x
  ;; compile" with modern programming languages that use colors to
  ;; convey information.
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

  ;; comportamento do botão do meio do mause, acho que o ergoemacs mudou ele
  (global-set-key (kbd "<mouse-2>") 'mouse-yank-primary)
  (modify-coding-system-alist 'file "" 'utf-8-unix)

  ;;~ https://github.com/technomancy/better-defaults
  (save-place-mode)
  (require 'uniquify)
  (setq-default indent-tabs-mode nil)
  ;;~ (setq uniquify-buffer-name-style 'forward)
  (show-paren-mode)
  (setq save-interprogram-paste-before-kill t
        select-active-regions 'only
        apropos-do-all t
        mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        load-prefer-newer t
        ediff-window-setup-function 'ediff-setup-windows-plain
        tramp-default-method "sshx"
        show-paren-style 'expression
        ispell-alternate-dictionary "/usr/share/dict/brazilian"
        ispell-program-name "/usr/bin/hunspell"
        ;;~ (prettify-symbols-mode t)
        ;;~ (desktop-save-mode)
        highlight-thing-what-thing 'region
        uniquify-buffer-name-style 'forward ) )

(load-file "./config/atalhos.el")

;;== yafolding -----------------------------------------------
(use-package yafolding
  :bind (("M-<return>" . yafolding-toggle-element)
    ("M-S-<return>" . yafolding-toggle-all)))

;;== Arquivos de config --------------------------------------------
(use-package org
  :bind (("C-t" . 'org-todo)
         ("C-c l" . 'org-store-link)
         ("C-c C-t" . 'org-time-stamp-inactive)
         ("C-<down>" . 'outline-next-visible-heading)
         ("C-b" . 'org-emphasize)
         ("M-<return>" . 'org-insert-item)
         ("C-<up>" . 'outline-previous-visible-heading))

  :config
  (electric-indent-mode 0)
  ;; se eu for usar o visual-fill-column-mode
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)

  (setq org-log-done t
        org-directory "~/org"
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-support-shift-select 'always
        org-hide-leading-stars nil
        org-todo-keyword-faces
        '(("INICIADO" :foreground "Blue1" :weight bold)
          [("CANCELADO"  :foreground "red1" :weight bold)]
          ("ESPERA"  :foreground "orange" :weight bold)))

  :hook ((org-mode . (lambda () (org-content 1))) ;; mostrar só os cabeçalhos nivel 1
         ;; (org-mode . company-mode)
         (org-mode . visual-line-mode))) 

;;=== Programação -------------------------------------------------------------
;;~ (defun my-add-pretty-symbols ()
;;~   "Make some word or string show as pretty Unicode symbols."
;;~   (interactive)
;;~   ;;~ http://ergoemacs.org/emacs/emacs_pretty_lambda.html
;;~   (setq prettify-symbols-alist '(
;;~ 				 ("lambda" . 955) ; λ
;;~ 				 ("->" . 8594)    ; →
;;~ 				 ("=>" . 8658)    ; ⇒
;;~ 				 ("map" . 8614))))   ; ↦

;;=== Lisp -------------------------------------------------------------
(defun my-lisp-config ()
  "Configuração para elisp."
  (interactive)
  (flycheck-mode 1)
  (set (make-local-variable 'comment-start) ";;~ "))

;;~ (defun my-lisp-flyspell-config ()
;;~   "Configuração flyspel pra não conferir strings, apenas comentários."
;;~   (interactive "P")
;;~   (flyspell-mode 1)
;;~   (setq flyspell-prog-text-faces
;;~         '(font-lock-comment-face font-lock-doc-face)))
;;~ (add-hook 'emacs-lisp-mode-hook #'my-lisp-flyspell-config)

;;~ (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)

;;~ (add-hook 'emacs-lisp-mode-hook #'my-add-pretty-symbols)
(add-hook 'emacs-lisp-mode-hook #'my-lisp-config)

;;=== Python --------------------------------------------------------
(defun my-python-config ()
  "Configuração de Python."
  (interactive)
  (fic-mode 1)  ; destaca "FIXME" "TODO" "BUG", etc
  ;; (local-set-key (kbd "f9") 'spacemacs/python-execute-file)
  (setq prettify-symbols-alist
        (append prettify-symbols-alist
		'( ("self." . 64) )))) ; self. -> @ (a la Ruby)

(add-hook 'python-mode-hook #'my-python-config 98)
(add-hook 'python-mode-hook #'prettify-symbols-mode 99) ; exec last

;;=== treemacs -------------------------------------------------------------
(load-file "./config/treemacs.el")

(gg-config-geral)
(gg-atalhos-gerais)

;;~ (provide 'init)
;;; init.el ends here
