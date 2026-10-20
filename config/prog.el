(defun my-add-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols."
  (interactive)
  ;;~ http://ergoemacs.org/emacs/emacs_pretty_lambda.html
  (setq prettify-symbols-alist '(
				 ("lambda" . 955) ; λ
				 ("->" . 8594)    ; →
				 ("=>" . 8658)    ; ⇒
				 ("map" . 8614))))   ; ↦

(defun my-hide-show-config ()
  "Ligar o hide-show e criar atalhos."
  (interactive)
  (hs-minor-mode t)
  (local-set-key (kbd "C-S-<return>") 'hs-toggle-hiding)
  (local-set-key (kbd "C-}") 'hs-show-all)
  (local-set-key (kbd "C-{") 'hs-hide-all))

(require 'yasnippet)
(yas-reload-all)

;;~ (add-hook 'prog-mode-hook #'flyspell-prog-mode)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;;=== Lisp -------------------------------------------------------------
(defun my-lisp-config ()
  "Configuração para elisp."
  (interactive)
  (set (make-local-variable 'comment-start) ";;~ "))

(defun my-lisp-flyspell-config ()
  "Configuração flyspel pra não conferir strings, apenas comentários."
  (interactive "P")
  (flyspell-prog-mode)
  (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
  )

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook #'my-lisp-flyspell-config)
;;~ (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
(add-hook 'emacs-lisp-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'emacs-lisp-mode-hook #'my-add-pretty-symbols)
(add-hook 'emacs-lisp-mode-hook #'company-mode)
(add-hook 'emacs-lisp-mode-hook #'my-hide-show-config)
(add-hook 'emacs-lisp-mode-hook #'my-lisp-config)

;;=== Ruby -------------------------------------------------------------
(defun my-rvm-config ()
  "Configuração de RVM."
  (interactive)
  (require 'rvm)
  (rvm-use-default))

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

(add-hook 'enh-ruby-mode-hook #'my-rvm-config -1)
(add-hook 'enh-ruby-mode-hook #'my-add-pretty-symbols)
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

;;=== Coffeescript --------------------------------------------------------
(defun my-coffeescript-config ()
  "Configuração de Coffeescript."
  (interactive)
  (set 'outline-regexp "^\s*#=[=]+")
  (set (make-local-variable 'coffee-tab-width) 2)
  (fic-mode 1)  ; destaca "FIXME" "TODO" "BUG", etc
  (turn-on-fic-mode)
  (whitespace-mode -1)
  ; http://ergoemacs.org/emacs/emacs_pretty_lambda.html
  (setq prettify-symbols-alist
        (append prettify-symbols-alist
				'(("is" . 8801)  ; ≡  2261
   				  ("isnt" . 8800 )))))  ; ≠ 2260

(add-hook 'coffee-mode-hook #'my-add-pretty-symbols)
(add-hook 'coffee-mode-hook #'my-coffeescript-config 99) ; exec last

;;=== Python --------------------------------------------------------
(defun my-python-config ()
  "Configuração de Python."
  (interactive)
  (fic-mode 1)  ; destaca "FIXME" "TODO" "BUG", etc
  (local-set-key (kbd "f9") 'spacemacs/python-execute-file)
  (setq prettify-symbols-alist
        (append prettify-symbols-alist
				'( ("self." . 64) )))) ; self. -> @ (a la Ruby)

(add-hook 'python-mode-hook	#'my-python-config 98)
(add-hook 'python-mode-hook	#'prettify-symbols-mode 99) ; exec last
