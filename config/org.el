;;=== Org --------------------------------------------------------------
;;==== Aparência
;;~ https://zzamboni.org/post/beautifying-org-mode-in-emacs/

(setq org-hide-emphasis-markers t)
(setq org-pretty-entities t)

(font-lock-add-keywords
 'org-mode
 '(("^ +\\([-*]\\) "
    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;;~ (when window-system
;;~   (let* ((variable-tuple
;;~           (cond
;;~            ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;~            ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;~            ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;~            ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;~ 		   ;;~ ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
;;~            (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;~ 		 (base-font-color     (face-foreground 'default nil 'default))
;;~ 		 (headline           `(:inherit default :weight bold)))
;;~ 	;;~ (headline           `(:inherit default :weight bold :foreground ,base-font-color)))
	
;;~ 	(custom-theme-set-faces
;;~ 	 'user
;;~ 	 `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;~ 	 `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;~ 	 `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;~ 	 `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;~ 	 `(org-level-4 ((t (,@headline ,@variable-tuple :height 0.9))))
;;~ 	 `(org-level-3 ((t (,@headline ,@variable-tuple :height 0.9)))) ;; 1.25
;;~ 	 `(org-level-2 ((t (,@headline ,@variable-tuple :height 0.9))))  ;; 1.5
;;~ 	 `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.0)))) ;; 1.75
;;~ 	 `(org-document-title ((t (,@headline ,@variable-tuple :height 1.3 :underline nil))))))) ;; 2.0

;;==== geral
(defun negritar ()
  "Negritar região."
  (interactive)
  (org-emphasize (string-to-char "*"))  ; era "b" em vez de "*"
)

(defun estilo-codigo ()
  "Colocar região com fonte fixa."
  (interactive)
  (org-emphasize (string-to-char "="))  ; era "b" em vez de "*"
)

(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/anotacoes.org"))
(setq org-deadline-warning-days 7)

(setq org-log-done t)

(global-set-key "\C-cc" 'org-capture) ; "\C-cc"
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cl" 'org-store-link)

(setq org-agenda-files
      (list "~/org/AFAZER.org" "~/org/trabalho_camara.org"))

(setq org-todo-keyword-faces
      '(("INICIADO" :foreground "Blue1" :weight bold)
        ("CANCELADO"  :foreground "red1" :weight bold)
        ("ESPERA"  :foreground "orange" :weight bold)))

(setq org-level-1 '((t (:foreground "#dfaf8f" :height 1.2))))
(setq org-level-2 '((t (:foreground "#f0dfaf" :weight bold))))
(setq org-level-4 '((t (:foreground "spring green"))))

(setq org-src-fontify-natively t)

;;~ (setq org-support-shift-select (quote always))

;;~ Export UTF-8 checkboxes: turns - [X] into ☑ and - [ ] into ☐.
;;~ https://www.emacswiki.org/emacs/OrgMode#toc19
;;~ (defun sacha/org-html-checkbox (checkbox)
;;~   "Format CHECKBOX into HTML."
;;~   (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
;;~ 	(off "<span class=\"checkbox\">&#x2610;</span>")
;;~ 	(trans "<code>[-]</code>")
;;~ 	(t "")))
;;~ (defadvice org-html-checkbox (around sacha activate)
;;~   (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))

;;==== Hooks
(defun atalhos-org ()
  "Atalhos do Org."
  (interactive)
  (local-set-key (kbd "C-t") 'org-todo)
  (local-set-key (kbd "C-<tab>") 'other-window)
  (local-set-key (kbd "C-b") 'negritar)
  (local-set-key (kbd "C-=") 'estilo-codigo)
  (local-set-key (kbd "C-S-b") 'org-emphasize)

  (local-set-key '[(mouse-3 )] 'mouse-popup-menubar-stuff)
  (local-set-key "\M-a" 'execute-extended-command)
  (local-set-key [C-down] 'outline-next-visible-heading)
  (local-set-key [C-up] 'outline-previous-visible-heading)
  (local-set-key [C-M-up] 'outline-up-heading))

(add-hook 'org-mode-hook #'atalhos-org)
(add-hook 'org-mode-hook #'flyspell-mode)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook #'company-mode)

;;==== Templates
;;  "[[https://www.dealextreme.com/accounts/summaries.dx/OrderNumber.$INVOICE~page.invoice][DX: Status da compra]\n" 
;; OBS: use backquote ("`") pra fazer funcionar a concat abaixo.
(setq links-dx (concat
"Substituir: $RASTREIO\n"
"Substituir: $INVOICE\n"
"[[https://my.dx.com/MyOrders/OrderDetail/$INVOICE][DX: Status da compra]\n"
"[[http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=$RASTREIO][Rastreamento no Hong Kong Post]\n" 
"[[http://websro.correios.com.br/sro_bin/txect01$.ResultList?P_ITEMCODE=$RASTREIO&P_LINGUA=001][Rastreamento nos Correios] ($RASTREIO)"))

(setq compra-bookdep (concat
"* AFAZER BookDep: %?\n" 
" Adicionado: %u \n\n" 
"\nExecutar\n"
"date +'[%F]' --date  '%U 39 days'\n\n"
"Prazo para reclamar:\n"
"- na BookDep (40 dias): [XXX]\n"
"- nos Correios (15 dias): n/a\n\n"
"Do valor	R$XXX\n"
"Para o valor	$XXX\n"
"Taxa de câmbio: 1 BRL = 0,XXX\n\n"
"Order No. XXX\n"))


(setq org-capture-templates 
      `(("a" "Afazer" entry (file+headline "~/org/AFAZER.org" "Tarefas") "* AFAZER %?
 Adicionado: %U
") 
        ("z" "Afazer um dia" entry (file+headline "~/org/sine_die.org" "Tarefas") "* %?
 Adicionado: %U
") 
        ("r" "Registro no diário" entry (file+headline "~/org/Diario_de_bordo.org" "") "* %u Registros
- %?") 
        ("c" "Comprar" entry (file+headline "~/org/compras.org" "") "* AFAZER %?
 Adicionado: %U
") 
        ("p" "Comprar um dia" entry (file+headline "~/org/sine_die.org" "Comprar") "* %?
 Adicionado: %U
") 
        ("t" "Afazer do trabalho" entry (file+headline "~/org/trabalho_camara.org" "Tarefas") "* AFAZER %?
 Adicionado: %U
") 
        ("n" "Anotações" entry (file+headline "~/org/anotacoes.org" "Anotações") "* %^{Anotações}
 Adicionado: %u 
 %? 
") 
        ("f" "Filme" entry (file+headline "~/org/sine_die_filmes.org" "Lista geral") "* AFAZER %^{Filme pra ver}
 Adicionado: %u 
 %?
") 
        ("l" "Livro" entry (file+headline "~/org/sine_die.org" "Livros para ler") "* %^{Livro pra ler}
 Adicionado: %u 
 %?
") 
        ("d" "Comprar DX" entry (file+headline "~/org/compras.org" "Comprar") "* AFAZER DX: %^{O que comprar}
 Adicionado: %u 
 %?
Substituir: $RASTREIO
Substituir: $INVOICE
[[https://my.dx.com/MyOrders/OrderDetail/$INVOICE][DX: Status da compra]
[[http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=$RASTREIO][Rastreamento no Hong Kong Post]
[[http://websro.correios.com.br/sro_bin/txect01$.ResultList?P_ITEMCODE=$RASTREIO&P_LINGUA=001][Rastreamento nos Correios] ($RASTREIO)
** Itens
| SKU | Item | U$ |
** Order confirmation
") 
        ("b" "Comprar BookDep" entry (file+headline "~/org/compras.org" "Comprar") "* AFAZER BookDep: %?
 Adicionado: %u 


Executar
date +'[%F]' --date  '%U 39 days'

Prazo para reclamar:
- na BookDep (40 dias): [XXX]
- nos Correios (15 dias): n/a

Do valor	R$XXX
Para o valor	$XXX
Taxa de câmbio: 1 BRL = 0,XXX

Order No. XXX
")))
