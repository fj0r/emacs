;;; ui.el --- 界面 + 主题 -*- lexical-binding: t; -*-

(menu-bar-mode -1)
(tool-bar-mode -1)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)
(push '(left-fringe . 1) default-frame-alist)
(push '(right-fringe . 1) default-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)
(push '(undecorated . t) default-frame-alist)

;; 中文字体 fallback
(set-frame-font "Lilex-11" nil t)
(set-fontset-font "fontset-default" (quote (#x4E00 . #x9FFF)) "Noto Sans Mono CJK SC-11")
(set-fontset-font "fontset-default" (quote (#x3000 . #x303F)) "Noto Sans Mono CJK SC-11")
(set-fontset-font "fontset-default" (quote (#xFF00 . #xFFEF)) "Noto Sans Mono CJK SC-11")

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; ==========================================
;; Theme
;; ==========================================
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-light-medium t))

(provide 'ui)
;;; ui.el ends here
