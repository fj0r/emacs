;;; my-session.el --- 按项目保存/恢复编辑状态 -*- lexical-binding: t; -*-

(defvar my/session-dir (expand-file-name "sessions/" user-emacs-directory)
  "项目 session 存储目录。")

(defun my/project-root ()
  "获取当前项目根目录，非项目则返回 nil。"
  (and (bound-and-true-p projectile-mode)
       (projectile-project-root)))

(defun my/session-key ()
  "用项目根路径生成 session key（目录名）。"
  (when-let ((root (my/project-root)))
    (replace-regexp-in-string "[^a-zA-Z0-9_-]" "_"
                              (file-name-nondirectory (directory-file-name root)))))

(defun my/session-directory ()
  "当前项目的 session 目录。"
  (when-let ((key (my/session-key)))
    (expand-file-name key my/session-dir)))

;; --- desktop-save 按项目隔离 ---
(setq desktop-save nil)
(setq desktop-restore-eager t)
(setq desktop-files-not-to-save "\\(?:\\.\\.?/\\|/\\.git/\\|COMMIT\\|TAGS\\)")
(setq desktop-globals-to-save '(kill-ring register-alist))
(setq enable-local-variables :safe)
(setq desktop-load-locked-desktop t)

(defun my/save-session (&optional interactive)
  "保存当前项目 session：buffer 列表 + 窗口布局。"
  (interactive "p")
  (when (my/project-root)
    (let ((session-dir (my/session-directory)))
      (unless (file-directory-p session-dir)
        (make-directory session-dir t))
      (desktop-save session-dir)
      (when interactive
        (message "Session saved: %s" (my/session-key))))))

(defun my/restore-session (&optional interactive)
  "恢复当前项目 session：buffer 列表 + 窗口布局。"
  (interactive "p")
  (let ((session-dir (my/session-directory)))
    (when (and session-dir
               (file-exists-p (expand-file-name ".emacs.desktop" session-dir)))
      (desktop-read session-dir)
      (when interactive
        (message "Session restored: %s" (my/session-key))))))

;; --- 自动保存/恢复 ---
(add-hook 'kill-emacs-hook #'my/save-session)

(defun my/auto-restore-session ()
  "启动时自动恢复 session。"
  (when (and (my/project-root) (my/session-directory))
    (let ((desktop-file (expand-file-name ".emacs.desktop" (my/session-directory))))
      (when (file-exists-p desktop-file)
        (my/restore-session)))))
(add-hook 'emacs-startup-hook #'my/auto-restore-session)

;; --- 快捷键 ---
(global-set-key (kbd "C-c ss") #'my/save-session)
(global-set-key (kbd "C-c sr") #'my/restore-session)

(provide 'my-session)
;;; my-session.el ends here
