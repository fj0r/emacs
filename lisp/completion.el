;;; completion.el --- Minibuffer 补全 -*- lexical-binding: t; -*-

(use-package vertico
  :init (vertico-mode 1))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)
         ("M-s f" . consult-find)))

(use-package which-key
  :init (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0.5))

(provide 'completion)
;;; completion.el ends here
