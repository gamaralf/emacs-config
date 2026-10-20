;; -*- lexical-binding: t; -*-
;;; Commentary:

; Atalhos gerais

;;; Code:
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

