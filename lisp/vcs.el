;;; vcs.el --- Git (Magit) -*- lexical-binding: t; -*-

(use-package transient
  :ensure t
  :demand t)

(use-package magit
  :bind ("C-x g" . magit-status))

(provide 'vcs)
;;; vcs.el ends here
