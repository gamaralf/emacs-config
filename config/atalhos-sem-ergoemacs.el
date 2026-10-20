;;== Meu Ergo Emacs
;;=== atalhos
;;~ (ido-mode)

;;~ (global-set-key (kbd "<return>") 'newline)

(global-set-key "\M-m" 'dabbrev-expand)
(global-set-key (kbd "M-x") 'helm-M-x)

;; geraldo: remepeando a busca para C-f
;; Referência: http://ergoemacs.org/emacs/reclaim_keybindings.html
(global-set-key "\C-f" 'isearch-forward)
(global-set-key (kbd "C-S-f") 'helm-projectile-grep)

(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\C-r" 'isearch-repeat-backward)

;;~ (global-set-key "\C-o" 'ido-find-file)
(global-set-key (kbd "C-o") 'helm-find-files)

(global-set-key (kbd "C-S-n") 'make-frame-command)
;;~ (global-set-key "\C-s" 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file)

(global-set-key "\M-w" 'gg-shrink-whitespaces)
(global-set-key "\M-/" 'gg-toggle-letter-case)
(global-set-key "\M-q" 'gg-compact-uncompact-block)

(global-set-key "\M-v" 'yank)
(global-set-key "\M-c" 'kill-ring-save)
;;~ (global-set-key "\M-x" 'kill-region)
(global-set-key "\M-a" 'execute-extended-command)
(global-set-key "\M-z" 'undo)
(global-set-key "\C-z" 'undo)
(global-set-key  (kbd "C-S-z") 'redo)

(global-set-key "\C-w" 'kill-buffer)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)
(global-set-key "\M-a" 'execute-extended-command)

;;~ Agora uso nos novos tabs (Emacs 27.1)
;;~ (global-set-key (kbd "<C-next>") 'next-buffer)
;;~ (global-set-key (kbd "<C-prior>") 'previous-buffer)

;;~ (ido-mode)
