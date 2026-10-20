;;; Commentary:

; Atalhos gerais

;;; Code:
(defun get-primary ()
  "S-Insert cola do PRIMARY (tipo o botão do meio do mouse)
https://stackoverflow.com/questions/28403647/."
  (interactive)
  (insert
   (gui-get-primary-selection)))

(global-set-key (kbd "S-<insert>") 'get-primary)

(global-set-key '[(mouse-3 )] 'mouse-popup-menubar-stuff)

(global-unset-key (kbd "C-t"))  ;; tecla inútil

(global-set-key "\C-l" 'recenter-top-bottom)
(global-set-key (kbd "C-S-l") 'goto-line)

(global-set-key (kbd "C-<f10>") 'menu-bar-mode)
(global-set-key (kbd "C-<tab>") 'other-window) ;; coloquei no hook do Org tb
(global-set-key "\M-m" 'dabbrev-expand)
(global-set-key (kbd "<C-next>") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "<C-prior>") 'tab-bar-switch-to-prev-tab)

(global-set-key (kbd "C-x 1") 'delete-other-windows)
(global-set-key (kbd "C-x 2") 'split-window-vertically)
(global-set-key (kbd "C-x 3") 'split-window-horizontally)
(global-set-key (kbd "C-x o") 'other-window)
(global-set-key (kbd "C-x 0") 'delete-window)
(global-set-key (kbd "M-0") 'delete-window)

(global-set-key "\C-s" 'save-buffer)
(global-set-key '[f2] 'save-buffer)
;;(global-set-key '[f3] 'ido-find-file) ;; icicle-find-file
(global-set-key '[f3] 'start-or-end-kbd-macro)
(global-set-key '[f4] 'call-last-kbd-macro)
;;(global-set-key '[f5] 'start-or-end-kbd-macro)

(global-set-key (kbd "C-M-;") 'comentar-linha)
(global-set-key (kbd "M-;") 'comentar-linha)
(global-set-key (kbd "C-;") 'comentar-linha)
(global-set-key (kbd "C-/") 'comentar-linha)

;;~ (global-set-key (kbd "C-S-p") 'my-helm-multi-all)
(global-set-key (kbd "C-S-M-p") 'helm-resume)
;(global-set-key (kbd "C-p") 'helm-buffers-list)
(global-set-key (kbd "C-S-p") 'helm-buffers-list)
(global-set-key (kbd "C-p") 'helm-projectile)

(global-set-key (kbd "C-d") 'mc/mark-next-like-this)
(global-set-key (kbd "C-S-d") 'mc/edit-lines)

;; http://www.emacswiki.org/emacs/NavigatingParentheses
(global-set-key (kbd "C-m") 'forward-or-backward-sexp)
(global-set-key (kbd "C-m") nil)
(global-set-key (kbd "<RET>") 'newline)

(global-set-key (kbd "C-.") 'company-complete)

;;~ yafolding
(require 'yafolding)
(define-key yafolding-mode-map (kbd "<C-return>") 'yafolding-toggle-element)
(define-key yafolding-mode-map '[f2] 'yafolding-toggle-element)
(define-key yafolding-mode-map (kbd "<C-S-return>") 'yafolding-toggle-all)
;;~ (define-key yafolding-mode-map (kbd "C-c <C-S-return>") 'yafolding-hide-parent-element)

;;~ (global-set-key "\M-a" 'execute-extended-command)
;;~ select-active-regions
