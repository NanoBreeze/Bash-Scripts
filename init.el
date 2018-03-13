;;(global-hl-line-mode)
;;(require 'hl-line)
;;(defadvice hl-line-mode (after
;;dino-advise-hl-line-mode
;;activate compile)
;;(set-face-background hl-line "white"))
;;(set-face-background 'hl-line "gray20")
;;(set-face-foreground 'hl-line "white")
;;(global-hl-line-mode)

;;(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#3e4446")
;;(set-face-foreground 'highlight nil)







;;(global-hl-line-mode 1)
     
;; To customize the background color
;;(set-face-background 'hl-line "grey33")  ;; Emacs 22 Only
;(set-face-background 'highlight "#330")  ;; Emacs 21 Only
;;(set-face-foreground 'hl-line nil)



















(add-hook 'prog-mode-hook 'linum-mode)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
