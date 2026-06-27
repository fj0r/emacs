;;; init.el --- Emacs 配置入口 -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'base)      ;; 性能 + Elpaca + Use-Package
(require 'ui)        ;; 界面 + 主题
(require 'editing)   ;; Boon + avy + projectile
(require 'completion) ;; vertico + consult + which-key
(require 'vcs)       ;; Magit
(require 'org)       ;; Org mode
(require 'term)      ;; Vterm
(require 'lang)      ;; lsp-bridge + gptel
(require 'my-session)   ;; 按项目保存/恢复

;;; init.el ends here
