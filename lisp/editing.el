;;; editing.el --- Boon 模态 + 效率插件 -*- lexical-binding: t; -*-

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(show-paren-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(recentf-mode 1)

;; ==========================================
;; Boon 核心模态 (已禁用)
;; ==========================================
;; (use-package boon
;;   :config
;;   (require 'boon-qwerty)
;;   (boon-mode 1)
;;   (define-key boon-moves-map (kbd "<escape>") 'boon-command-mode))

;; ==========================================
;; 辅助效率插件
;; ==========================================
(use-package avy
  :bind ("C-;" . avy-goto-char))

(use-package projectile
  :init (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/world/")
        projectile-sort-order 'recentf
        projectile-indexing-method 'alien
        projectile-enable-caching t))

;; ==========================================
;; Treemacs 目录树
;; ==========================================
(use-package treemacs
  :bind ("C-x t t" . treemacs)
  :config
  (setq treemacs-width 30)
  (setq treemacs-indentation 2)
  (setq treemacs-show-hidden-files t)
  (setq treemacs-no-png-images t))

(use-package treemacs-projectile
  :after (treemacs projectile))

(provide 'editing)
;;; editing.el ends here
