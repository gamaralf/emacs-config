(defun gg-add-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols."
  (interactive)
  ;;~ http://ergoemacs.org/emacs/emacs_pretty_lambda.html
  (setq prettify-symbols-alist '(("lambda" . 955) ; λ
                                 ("->" . 8594)    ; →
                                 ("=>" . 8658)    ; ⇒
                                 ("map" . 8614))))   ; ↦

(defun gg-def-atalho (atalhos)
  "Define ATALHOS que estão na lista associativa."
  (dolist (item atalhos)
    (define-key evil-emacs-state-map (kbd (car item)) (cdr item))))

(defun gg-get-primary ()
  ;;~ https://stackoverflow.com/questions/28403647/
  ;;~ S-Insert cola do PRIMARY (tipo o botão do meio do mouse)
  (interactive)
  (insert
   (gui-get-primary-selection)))

(defun gg-atalhos-comuns ()
  "Teclas comuns usadas em outros editores."

  (load "~/g/.emacs.d/config/funcoes-ergoemacs")

  (gg-def-atalho '(("M-i" . previous-line)
                   ("M-k" . next-line)
                   ("M-l" . right-char)
                   ("M-j" . left-char)
                   ("M-o" . right-word)
                   ("M-u" . left-word)
                   ("C-M-i" . cua-scroll-down)
                   ("C-M-k" . cua-scroll-up)

                   ;; ver qual é melhor
                   ("C-<f1>" . lazy-helm/helm-mini)
                   ("<f3>" . lazy-helm/helm-mini)
                   ("C-/" . gg-comentar-linha)
                   ("M-;" . gg-comentar-linha)

                   ("C-<prior>" . next-buffer)  ;; pgUp
                   ("C-<next>" . previous-buffer)  ;; pgDn

                   ("S-<insert>" . gg-get-primary)
                   ("C-f" . isearch-forward)
                   ("C-S-f" . spacemacs/helm-project-do-rg)
                   ("C-o" . helm-find-files)
                   ("C-p" . projectile-find-file) ;;  helm-projectile-find-file
                   ("C-w" . kill-buffer)
                   ("C-S-n" . make-frame-command)
                   ("C-s" . save-buffer)
                   ("<f2>" . save-buffer)
                   ("C-S-s" . write-file)
                   ("C-z" . undo)
                   ("C-S-z" . undo-tree-visualize)
                   ("C-<tab>" . other-window)
                   ("C-S-d" . mc/mark-next-like-this)
                   ;; ("C-S-d" . mc/edit-lines)
                   ("M-w" . gg-shrink-whitespaces)
                   ;; ("M-/" . gg-toggle-letter-case)
                   ("M-q" . gg-compact-uncompact-block)))

  (bind-keys :map global-map
             ("C-+" . text-scale-increase)
             ("C--" . text-scale-decrease))

  (bind-keys :map isearch-mode-map
             ("C-f" . isearch-repeat-forward)
             ("C-r" . isearch-repeat-backward)
             ("C-v" . isearch-yank-x-selection)))

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

(defun gg-ligaduras ()
  "Ativa ligadura de fonte para o prog-mode"
  (interactive "P")

  ;; https://www.rockyourcode.com/fira-code-font-ligatures-in-emacs/spacemacs-on-arch-linux/
  (defun my-correct-symbol-bounds (pretty-alist)
    "Prepend a TAB character to each symbol in this alist,
  this way compose-region called by prettify-symbols-mode
  will use the correct width of the symbols
  instead of the width measured by char-width."
    (mapcar (lambda (el)
              (setcdr el (string ?\t (cdr el)))
              el)
            pretty-alist))

  (defun my-ligature-list (ligatures codepoint-start)
    "Create an alist of strings to replace with
  codepoints starting from codepoint-start."
    (let ((codepoints (-iterate '1+ codepoint-start (length ligatures))))
      (-zip-pair ligatures codepoints)))

  (setq my-fira-code-ligatures
        (let*
            ((ligs '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
                     "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
                     "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
                     "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
                     ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
                     "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
                     "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
                     "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
                     ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
                     "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
                     "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
                     "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
                     "x" ":" "+" "+" "*")))
          (my-correct-symbol-bounds (my-ligature-list ligs #Xe100))))

  (defun my-set-fira-code-ligatures ()
    "Add fira code ligatures for use with prettify-symbols-mode."
    (setq prettify-symbols-alist
          (append my-fira-code-ligatures prettify-symbols-alist))
    (prettify-symbols-mode))

  (add-hook 'prog-mode-hook 'my-set-fira-code-ligatures)
  )

(defun gg-prog-config ()
  "Configs e atalhos para modos de linguagens programação."

  (bind-keys* :map prog-mode-map
              ("<f8>"  . flycheck-next-error)
              ("S-<f8>" . flycheck-previous-error)
              ( "M-;" . gg-comentar-linha)
              ( "C-;" . gg-comentar-linha))
  ;; (bind-keys* :map undo-tree-map
  ;;             ( "C-/" . gg-comentar-linha))

  (yafolding-mode nil)
  (bind-keys :map yafolding-mode-map
             ("C-<return>" . yafolding-toggle-element)
             ("C-S-<return>" . yafolding-toggle-all)
             ("C-M-<return>" . yafolding-toggle-all))

  ;; (defun gg-ruby-atalhos ()
  ;;   (local-set-key (kbd "C-S-i") 'rubocopfmt))
  ;; (add-hook 'ruby-mode-hook #'gg-ruby-atalhos)

  (use-package ruby-mode
               :bind (:map ruby-mode-map
                           ("C-S-i" . rubocopfmt)))

  (use-package python-mode
               :bind (:map python-mode-map
                           ("<f9>" . spacemacs/python-execute-file)))

  ;; NOTE: Não funciona
  ;; (unicode-fonts :variables unicode-fonts-enable-ligatures t)
  ;; (gg-add-pretty-symbols)

  (gg-ligaduras)
  )

(defun gg-org-capture-config ()
  (bind-key "C-c c" 'org-capture)
  (setq org-capture-templates
        '(("a" "Afazer" entry (file+headline "~/org/AFAZER.org" "Tarefas")
           "* AFAZER %?\n Adicionado: %U\n")
          ("z" "Afazer um dia" entry (file+headline "~/org/sine_die.org" "Tarefas")
           "* %?\n Adicionado: %U\n")
          ("r" "Registro no diário" entry (file+headline "~/org/Diario_de_bordo.org" "")
           "* %u %?")
          ("c" "Comprar" entry (file+headline "~/org/compras.org" "")
           "* AFAZER %?\n Adicionado: %U\n")
          ("p" "Comprar um dia" entry (file+headline "~/org/sine_die.org" "Comprar")
           "* %?\n Adicionado: %U\n")
          ("t" "Afazer do trabalho" entry (file+headline "~/org/trabalho_camara.org"
                                                         "Tarefas")
           "* AFAZER %?\n Adicionado: %U\n")
          ("n" "Anotações" entry (file+headline "~/org/anotacoes.org" "Anotações")
           "* %^{Anotações}\n Adicionado: %u\n %?")
          ("f" "Filme" entry (file+headline "~/org/sine_die_filmes.org" "Lista geral")
           "* AFAZER %^{Filme pra ver}\n Adicionado: %u\n %?")
          ("l" "Livro" entry (file+headline "~/org/sine_die.org" "Livros para ler")
           "* %^{Livro pra ler}\n Adicionado: %u\n %?"))))

(defun gg-org-config ()
  "Config básicas do org e seus atalhos."

  ;; (setq word-wrap t)

  ;; se eu for usar o visual-fill-column-mode
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)

  (gg-org-capture-config)

  (font-lock-add-keywords
   'org-mode
   '(("^ +\\([-*]\\) "
      (0 (prog1 () (compose-region
                    (match-beginning 1) (match-end 1) "•"))))))

  (use-package org
               :bind (("C-t" . 'org-todo)
                      ("C-c l" . 'org-store-link)
                      ("C-<down>" . 'outline-next-visible-heading)
                      ("C-<up>" . 'outline-previous-visible-heading))

               :config
               (electric-indent-mode 0)
               (undo-tree-mode 1)
               (setq org-log-done t)
               (setq org-directory "~/org")
               (setq org-hide-emphasis-markers t)
               (setq org-pretty-entities t)
               (setq org-support-shift-select 'always)
               (setq org-todo-keyword-faces
                     '(("INICIADO" :foreground "Blue1" :weight bold)
                       ("CANCELADO"  :foreground "red1" :weight bold)
                       ("ESPERA"  :foreground "orange" :weight bold)))

               :hook ((org-mode . (lambda () (org-content 1))) ;; mostrar só os cabeçalhos nivel 1
                      (org-mode . visual-line-mode))
               ) )

(defun gg-config-geral ()
  "Config gerais: ativar modos, opções, variáveis"
  ;; (message "** Config gerais: INICIO")
  (smartparens-global-mode)
  (global-linum-mode) ;; parece melhor que o padrão do spacemacs
  (scroll-bar-mode)
  (undo-tree-mode)

  (when (not (display-graphic-p))
    (message "** NÃO vai redimensionar a janela (display-graphic-p)"))

  (when (not (window-system))
    (message "** NÃO vai redimensionar a janela (window-system)"))

  ;; https://stackoverflow.com/a/5795518/7432
  ;; https://stackoverflow.com/a/93019
  (when (display-graphic-p) ;; voltei window-system e tirei display-graphic-p
    (message "** Redimensionando a janela (display-graphic-p)")
    (let ((larg 117) (alt 48))
      (set-frame-size (selected-frame) larg alt)
      ;;frame TODO porque a expansão de variável não funciona?
      ;; (setq dimensoes '((width . larg) (height . alt)))
      (setq default-frame-alist '((width . 117) (height . 48)))))

  (setq select-active-regions 'only
        mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        load-prefer-newer t)
  ;; (message "** Config gerais: FIM")
)
