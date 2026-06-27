;;; org.el --- Org mode -*- lexical-binding: t; -*-

;; 确保 elpaca 的 org 优先于系统内置
(add-to-list 'load-path (expand-file-name "elpaca/builds/org" user-emacs-directory))

(use-package org
  :ensure nil
  :config
  (setq org-startup-indented t)
  (setq org-ellipsis " ▾")
  (setq org-hide-leading-stars t)
  (setq org-log-done 'time)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)"))))

(provide 'org)
;;; org.el ends here
