;; -*- lexical-binding: t; -*-
;;; Commentary:

; Atalhos gerais

;;; Code:
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
  (global-set-key (kbd "M-g a") 'avy-goto-line)

  (define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
  (define-key isearch-mode-map "\C-r" 'isearch-repeat-backward)

  (global-set-key (kbd "C-o") 'find-file)
  (global-set-key (kbd "C-w") 'kill-buffer)
  (global-set-key (kbd "C-S-n") 'make-frame-command)

  (global-set-key  (kbd "C-S-z") 'undo-tree-visualize)
  
  ;;~ (global-set-key '[f3] 'recentf)

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

  ;; (global-set-key (kbd "C-.") 'company-complete)
  (global-set-key (kbd "M-m") 'dabbrev-expand)

  (global-set-key (kbd "M-w") 'gg-shrink-whitespaces)
  (global-set-key (kbd "M-/") 'gg-toggle-letter-case)
  (global-set-key (kbd "M-q") 'gg-compact-uncompact-block)

  ;; Font size
  (define-key global-map (kbd "C-+") 'text-scale-increase)
  (define-key global-map (kbd "C--") 'text-scale-decrease)
  )
