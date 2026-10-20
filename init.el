(require 'package)

;;; Code:

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(when (< emacs-major-version 27) (package-initialize))

(push "~/.emacs.d/lib/" load-path)

(setq custom-file "~/.emacs.d/custom.el")
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
  (setq lista-de-pacotes '(use-package highlight-thing
        coffee-mode enh-ruby-mode fic-mode flycheck
        gruvbox-theme autothemer
        helm-projectile helm helm-core hl-todo impatient-showdown
        impatient-mode htmlize lua-mode magit git-commit 
        markdown-mode multiple-cursors projectile robe inf-ruby
        rspec-mode rubocop ruby-electric ruby-extra-highlight
        ruby-interpolation simple-httpd tldr
        with-editor yafolding yasnippet-snippets
        yasnippet yaml-mode zenburn-theme web-mode
        marginalia))

  ;; web-beautify tabbar jade-mode async ergoemacs-mode ack epl
  ;; request popup pkg-info dash transient graphviz-dot-mode slim-mode

  ;;~ atualizar lista de pacotes
  (unless package-archive-contents (package-refresh-contents))

  ;;~ instalar os pacotes faltantes
  (dolist (pacote lista-de-pacotes)
    (unless (package-installed-p pacote)
      (package-install pacote))))

 ;;~ '(initial-buffer-choice "~/org/Diario_de_bordo.org")

;; (instalar-pacotes)

(use-package company :hook ((prog-mode text-mode) . company-mode))
(use-package undo-tree :config (global-undo-tree-mode))
(use-package unicode-fonts :config (unicode-fonts-setup))
(use-package which-key :config (which-key-mode))
(use-package smartparens :config (smartparens-mode))
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
(use-package yasnippet :config (yas-global-mode 1))

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

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (ruby-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package all-the-icons-dired
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;;~ (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;;----- para desenvolvimento web
;;~ https://fransiska.github.io/emacs/2017/08/21/web-development-in-emacs
;;~ https://unkertmedia.com/how-to-setup-emacs-for-web-development/

(use-package web-mode
  :hook emmet-mode
  :config
  (setq web-mode-enable-current-column-highlight t
        web-mode-enable-current-element-highlight t))

(use-package company-web
  :config
  (set (make-local-variable 'company-backends)
       '(company-css company-web-html company-yasnippet company-files)))

(use-package emmet-mode
  :bind
  ("C-j" . emmet-expand-line)
  :hook
  (emmet-preview-mode))

;;== helm (ou vertico) -----------------------------------------------
;;TODO usar use-package (colocar "ensure t" e tirar da lista acima)
;;~ (use-package helm
;;~   :bind (("C-S-f" . helm-projectile-grep)
;;~     ("C-o" . helm-find-files)
;;~     ("C-x b" . helm-buffers-list)
;;~     ("M-x" . helm-M-x)
;;~     ("<f3>" . helm-recentf)))

;;== vertico (ou heml) -----------------------------------------------
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  
  :bind
  ("<f3>" . recentf))

;; para melhorar o vertico
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

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

(defun gg-shrink-whitespaces ()
  "Remove white spaces around cursor to just one or none.
If current line does have visible chars, then shrink whitespace
surrounding cursor to just one space.
If current line does not have visible chars, then shrink al neighboring
blank lines to just one.
If current line is a single space, remove that space.
Calling this command 3 times will always result in no whitespaces around cursor."
  (interactive)
  (let (cursor-point
        line-has-meat-p  ; current line contains non-white space chars
        spaceTabNeighbor-p
        whitespace-begin whitespace-end
        space-or-tab-begin space-or-tab-end
        line-begin-pos line-end-pos)
    (save-excursion
      ;; todo: might consider whitespace as defined by syntax table, and also consider whitespace chars in unicode if syntax table doesn't already considered it.
      (setq cursor-point (point))
      
      (setq spaceTabNeighbor-p (if (or (looking-at " \\|\t") (looking-back " \\|\t")) t nil) )
      (move-beginning-of-line 1) (setq line-begin-pos (point) )
      (move-end-of-line 1) (setq line-end-pos (point) )
      ;;       (re-search-backward "\n$") (setq line-begin-pos (point) )
      ;;       (re-search-forward "\n$") (setq line-end-pos (point) )
      (setq line-has-meat-p (if (< 0 (count-matches "[[:graph:]]" line-begin-pos line-end-pos)) t nil) )
      (goto-char cursor-point)
      
      (skip-chars-backward "\t ")
      (setq space-or-tab-begin (point))
      
      (skip-chars-backward "\t \n")
      (setq whitespace-begin (point))
      
      (goto-char cursor-point)
      (skip-chars-forward "\t ")
      (setq space-or-tab-end (point))
      (skip-chars-forward "\t \n")
      (setq whitespace-end (point)))
    
    (if line-has-meat-p
        (let (deleted-text)
          (when spaceTabNeighbor-p
            ;; remove all whitespaces in the range
            (setq deleted-text (delete-and-extract-region space-or-tab-begin space-or-tab-end))
            ;; insert a whitespace only if we have removed something
            ;; different that a simple whitespace
            (if (not (string= deleted-text " "))
                (insert " "))))      
      (progn
        ;; (delete-region whitespace-begin whitespace-end)
        ;; (insert "\n")
        (delete-blank-lines))
      ;; todo: possibly code my own delete-blank-lines here for better efficiency, because delete-blank-lines seems complex.
      )))

(defun gg-toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
  (interactive)
  (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )
    
    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps"))
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps"))
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps"))
         (t (put this-command 'state "all lower") ) ) ) )
    
    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )) )

(defun gg-compact-uncompact-block ()
  "Remove or add line ending chars on current paragraph.
This command is similar to a toggle of `fill-paragraph'.
When there is a text selection, act on the region."
  (interactive)
  
  ;; This command symbol has a property “'stateIsCompact-p”.
  (let (currentStateIsCompact (bigFillColumnVal 4333999) (deactivate-mark nil))
    
    (save-excursion
      ;; Determine whether the text is currently compact.
      (setq currentStateIsCompact
            (if (eq last-command this-command)
                (get this-command 'stateIsCompact-p)
              (if (> (- (line-end-position) (line-beginning-position)) fill-column) t nil) ) )
      
      (if (region-active-p)
          (if currentStateIsCompact
              (fill-region (region-beginning) (region-end))
            (let ((fill-column bigFillColumnVal))
              (fill-region (region-beginning) (region-end))) )
        (if currentStateIsCompact
            (fill-paragraph nil)
          (let ((fill-column bigFillColumnVal))
            (fill-paragraph nil)) ) )
      
      (put this-command 'stateIsCompact-p (if currentStateIsCompact nil t)))))

(defun gg-get-primary ()
  "S-Insert cola do PRIMARY (tipo o botão do meio do mouse)."
  ;;~ https://stackoverflow.com/questions/28403647/
  (interactive)
  (insert
   (gui-get-primary-selection)))

(defun gg-comentar-linha ()
  "Comentar toda uma linha."
  ;; TODO: se houver regiao ativa, usar o comport padrao
  (interactive)
  (beginning-of-line)
  (if (region-active-p)
      (comment-dwim nil)
    (progn
      (beginning-of-line)
      (let ((beg (point)))
        (end-of-line)
        (comment-or-uncomment-region beg (point))))))

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
  (recentf-mode)
  (tool-bar-mode -1)
  (column-number-mode)
  (cua-mode)
  (menu-bar-mode)
  (global-display-line-numbers-mode)

  ;;~ (setq tramp-default-method "ssh")
  ;;~ (setq show-paren-style 'expression)
  ;;~ (setq ispell-alternate-dictionary "/usr/share/dict/brazilian")
  ;;~ (setq ispell-program-name "/usr/bin/hunspell")
  ;;~ ;;~ (prettify-symbols-mode t)
  ;;~ ;;~ (desktop-save-mode)
  ;;~ (setq highlight-thing-what-thing 'region)

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
        tramp-default-method "ssh"
        show-paren-style 'expression
        ispell-alternate-dictionary "/usr/share/dict/brazilian"
        ispell-program-name "/usr/bin/hunspell"
        ;;~ (prettify-symbols-mode t)
        ;;~ (desktop-save-mode)
        highlight-thing-what-thing 'region
        uniquify-buffer-name-style 'forward
        )

  ;;         (custom-file (expand-file-name "~/.emacs.d/custom.el")  )
  )

;;== Atalhos gerais -----------------------------------------------
;;(load "~/.emacs.d/config/atalhos")
; Atalhos gerais

(defun get-primary ()
  "S-Insert cola do PRIMARY (tipo o botão do meio do mouse)
https://stackoverflow.com/questions/28403647/."
  (interactive)
  (insert
   (gui-get-primary-selection)))

(defun gg-atalhos-gerais ()
  "S-Insert cola do PRIMARY (tipo o botão do meio do mouse)."
  ;;~ https://stackoverflow.com/questions/28403647/
  (interactive)

  (global-set-key (kbd "C-s") 'save-buffer)
  (global-set-key '[f2] 'save-buffer)
  (global-set-key (kbd "C-S-s") 'write-file)

  ;; geraldo: remepeando a busca para C-f
  ;; Referência: http://ergoemacs.org/emacs/reclaim_keybindings.html
  (global-set-key (kbd "C-f") 'isearch-forward)

  (define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
  (define-key isearch-mode-map "\C-r" 'isearch-repeat-backward)

  (global-set-key (kbd "C-o") 'find-file)
  (global-set-key (kbd "C-w") 'kill-buffer)
  (global-set-key (kbd "C-S-n") 'make-frame-command)

  (global-set-key  (kbd "C-S-z") 'undo-tree-visualize)

  (global-set-key '[f3] 'recentf)
  
  (global-set-key '[f4] 'call-last-kbd-macro)
  ;;(global-set-key '[f5] 'start-or-end-kbd-macro)

  (global-set-key (kbd "S-<insert>") 'get-primary)

  (global-set-key '[(mouse-3 )] 'mouse-popup-menubar-stuff)

  (global-unset-key (kbd "C-t"))  ;; tecla inútil

  (global-set-key (kbd "C-l") 'recenter-top-bottom)
  (global-set-key (kbd "C-S-l") 'goto-line)

  ;;~ (global-set-key (kbd "C-<f10>") 'menu-bar-mode)
  (global-set-key (kbd "C-<tab>") 'other-window) ;; coloquei no hook do Org tb
  ;;~ (global-set-key "\M-m" 'dabbrev-expand)

  (global-set-key (kbd "C-M-;") 'gg-comentar-linha)
  (global-set-key (kbd "M-;") 'gg-comentar-linha)
  (global-set-key (kbd "C-;") 'gg-comentar-linha)
  (global-set-key (kbd "C-/") 'gg-comentar-linha)


  (global-set-key (kbd "C-S-d") 'mc/mark-next-like-this)
  ;;~ (global-set-key (kbd "C-S-d") 'mc/edit-lines)

  ;; http://www.emacswiki.org/emacs/NavigatingParentheses
  (global-set-key (kbd "C-m") 'forward-or-backward-sexp)
  (global-set-key (kbd "<RET>") 'newline)

  (global-set-key (kbd "C-.") 'company-complete)
  (global-set-key (kbd "M-m") 'dabbrev-expand)

  (global-set-key (kbd "M-w") 'gg-shrink-whitespaces)
  (global-set-key (kbd "M-/") 'gg-toggle-letter-case)
  (global-set-key (kbd "M-q") 'gg-compact-uncompact-block)

  ;; Font size
  (define-key global-map (kbd "C-+") 'text-scale-increase)
  (define-key global-map (kbd "C--") 'text-scale-decrease)
  )

;;== yafolding -----------------------------------------------
(use-package yafolding
  :bind (("M-<return>" . yafolding-toggle-element)
    ("M-S-<return>" . yafolding-toggle-all)))


;;== Arquivos de config --------------------------------------------
;; (load "~/.emacs.d/config/org")
;;~ (setq org-hide-emphasis-markers t)
;;~ (setq org-pretty-entities t)
;;~ (setq org-directory "~/org")
;;~ (global-set-key (kbd "C-c c") 'org-capture) ; "\C-cc"
;;~ (global-set-key (kbd "C-c l") 'org-store-link) ; "\C-cl"
;;~ (setq org-todo-keyword-faces
;;~       '(("INICIADO" :foreground "Blue1" :weight bold)
;;~         ("CANCELADO"  :foreground "red1" :weight bold)
;;~         ("ESPERA"  :foreground "orange" :weight bold)))
;;~ (setq org-support-shift-select (quote always))
;;~ (defun atalhos-org ()
;;~   "Atalhos do Org."
;;~   (interactive)
;;~   (local-set-key (kbd "C-t") 'org-todo)
;;~   (local-set-key (kbd "C-<tab>") 'other-window)
;;~   (local-set-key (kbd "C-b") 'org-emphasize)
;;~   (local-set-key (kbd "C-=") 'estilo-codigo)
;;~   (local-set-key (kbd "C-S-b") 'org-emphasize)

;;~   (local-set-key '[(mouse-3 )] 'mouse-popup-menubar-stuff)
;;~   (local-set-key (kbd "M-a") 'execute-extended-command)
;;~   (local-set-key [C-down] 'outline-next-visible-heading)
;;~   (local-set-key [C-up] 'outline-previous-visible-heading)
;;~   (local-set-key [C-M-up] 'outline-up-heading))

;;~ (add-hook 'org-mode-hook #'atalhos-org)
;;~ (add-hook 'org-mode-hook #'flyspell-mode)
;;~ (add-hook 'org-mode-hook #'visual-line-mode)
;;~ (add-hook 'org-mode-hook #'company-mode)

;;~ (load "~/.emacs.d/config/funcoes-ergoemacs")
;;~ (load "~/.emacs.d/config/atalhos-sem-ergoemacs")
;;~ Voltar? ☹️
;;~ (load "~/.emacs.d/config/prog")

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
         (org-mode . company-mode)
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
  (set (make-local-variable 'comment-start) ";;~ "))

(defun my-lisp-flyspell-config ()
  "Configuração flyspel pra não conferir strings, apenas comentários."
  (interactive "P")
  (flyspell-prog-mode)
  (setq flyspell-prog-text-faces
        '(font-lock-comment-face font-lock-doc-face)))

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook #'my-lisp-flyspell-config)
;;~ (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
(add-hook 'emacs-lisp-mode-hook #'display-fill-column-indicator-mode)
;;~ (add-hook 'emacs-lisp-mode-hook #'my-add-pretty-symbols)
(add-hook 'emacs-lisp-mode-hook #'company-mode)
(add-hook 'emacs-lisp-mode-hook #'my-lisp-config)

;;=== Python --------------------------------------------------------
(defun my-python-config ()
  "Configuração de Python."
  (interactive)
  (fic-mode 1)  ; destaca "FIXME" "TODO" "BUG", etc
  (local-set-key (kbd "f9") 'spacemacs/python-execute-file)
  (setq prettify-symbols-alist
        (append prettify-symbols-alist
		'( ("self." . 64) )))) ; self. -> @ (a la Ruby)

(add-hook 'python-mode-hook #'my-python-config 98)
(add-hook 'python-mode-hook #'prettify-symbols-mode 99) ; exec last

;;=== Ruby -------------------------------------------------------------
; (defun my-rvm-config ()
;   "Configuração de RVM."
;   (interactive)
;   (require 'rvm)
;   (rvm-use-default))

(defun my-ruby-config ()
  "Configuração de Ruby."
  (interactive)
  ;;~ (message "Ruby config!")
  (rubocop-mode)
  ; gambiarra, vide https://github.com/rubocop-hq/rubocop-emacs/issues/26
  (defun rubocop-ensure-installed ())
  (flycheck-mode) ;; pro Rubocop funcionar
  ;;~ (push 'company-yasnippet company-backends)
  (local-set-key (kbd "C->") 'company-yasnippet))

;;~ enh-ruby-mode
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;;~ robe mode (dá pau)
;;~ (add-hook 'ruby-mode-hook #'robe-mode)
;;~ (eval-after-load 'company
;;~   '(push 'company-robe company-backends))
;;~ (advice-add 'inf-ruby-console-auto :before #'rvm-activate-corresponding-ruby)

;(add-hook 'enh-ruby-mode-hook #'my-rvm-config -1)
;;~ (add-hook 'enh-ruby-mode-hook #'my-add-pretty-symbols)
(add-hook 'enh-ruby-mode-hook #'prettify-symbols-mode)
(add-hook 'enh-ruby-mode-hook #'yafolding-mode)
(add-hook 'enh-ruby-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'enh-ruby-mode-hook #'company-mode)
(add-hook 'enh-ruby-mode-hook #'my-ruby-config 99)

;;~ AVALIAR
(add-hook 'enh-ruby-mode-hook #'ruby-extra-highlight-mode)
(eval-after-load "enh-ruby-mode"
  '(add-hook 'enh-ruby-mode-hook 'ruby-electric-mode))
(eval-after-load 'rspec-mode
  '(rspec-install-snippets))

;;=== treemacs -------------------------------------------------------------
;; inpirado em https://github.com/Alexander-Miller/treemacs#installation
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-all-the-icons :ensure t
  :after (treemacs))

(gg-config-geral)
(gg-atalhos-gerais)

;;~ (provide 'init)
;;; init.el ends here
