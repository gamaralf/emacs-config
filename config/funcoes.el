;;=== Funções ----------------------------------------------------------
(defun fixx ()
  (interactive)
  (fic-mode t)
  (font-lock-fontify-buffer))

(defun open-encrypted-file (fname)
  "Abrir um arquivo (FNAME) encriptado com bcrypt."
  
  (interactive "FFind file: \n")
  (let ((buf (create-file-buffer fname)))
    (shell-command
     (concat "echo " (read-passwd "Senha: ") " | bcrypt -o " fname)
     buf)
    (set-buffer buf)
    (kill-line)(kill-line)
    ;; (toggle-read-only)
    (read-only-mode)
    (not-modified)))

(defun meu-ergo ()
  (interactive)
  (ergoemacs-mode t)
  (atalhos))

(defun atalhos ()
  (interactive)
  (load "~/.emacs.d/config/atalhos"))

(defun comentar-linha ()
  "comentar toda uma linha. AFAZER: se houver regiao ativa, usar o comport padrao"
  (interactive)
  (beginning-of-line)
  (if (region-active-p)
      (comment-dwim nil)
    (progn
      (beginning-of-line)
      (let ((beg (point)))
        (end-of-line)
        (comment-or-uncomment-region beg (point))))))

(defun my-helm-multi-all ()
  "'multi-occur' in all buffers backed by files."
  (interactive)
  (helm-multi-occur
   (delq nil
         (mapcar (lambda (b)
                   (when (buffer-file-name b) (buffer-name b)))
                 (buffer-list)))))

(defun dobraduras ()
  "Atalhos pra dobrar código"
  (global-set-key (kbd "C-<return>") 'folding-toggle-show-hide)
  (global-set-key (kbd "S-<return>") 'folding-toggle-enter-exit)
  (global-set-key '[f7] 'folding-fold-region))

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


;;~ (add-hook 'outline-minor-mode-hook (lambda ()
;;~                        (local-set-key [M-left] 'hide-body)
;;~                        (local-set-key [M-right] 'show-all)
;;~                        (local-set-key [M-up] 'outline-previous-heading)
;;~                        (local-set-key [M-down] 'outline-next-heading)
;;~                        (local-set-key [C-return] 'outline-toggle-children)
;;~                        (local-set-key [S-return] 'outline-toggle-children)))

