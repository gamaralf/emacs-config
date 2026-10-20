;;~ (require 'zenburn-theme)  ;;(zenburn-theme)
;;~ (load-theme 'zenburn)
(load-theme 'gruvbox-dark-hard)

(smartparens-global-mode 1)
(setq show-paren-style 'expression)
(size-indication-mode t)
(tab-bar-mode t)  ;;~ era (tabbar-mode t)
(recentf-mode t)
(tool-bar-mode -1)
;;(global-linum-mode t)
;;~ (prettify-symbols-mode t)
;;~ (idob-mode t)
(column-number-mode)
(desktop-save-mode)
(setq highlight-thing-what-thing 'region)

; comportamento do botão do meio do mause, acho que o ergoemacs mudou ele
(global-set-key (kbd "<mouse-2>") 'mouse-yank-primary)
(modify-coding-system-alist 'file "" 'utf-8-unix)

;;~ (projectile-mode +1)
;;~ (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;;~ (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;~ https://github.com/technomancy/better-defaults
(save-place-mode)
(require 'uniquify)
(setq-default indent-tabs-mode nil)
(setq uniquify-buffer-name-style 'forward)
(show-paren-mode)
(setq save-interprogram-paste-before-kill t
	  select-active-regions 'only
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain)
      ;;~ custom-file (expand-file-name "~/.emacs.d/custom.el")
