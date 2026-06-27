;;; -*- lexical-binding: t; -*-
;; ==========================================
;; 1. 基础性能优化
;; ==========================================
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))
            (message "Emacs 启动耗时: %s" (emacs-init-time))))
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq ring-bell-function 'ignore)
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
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(show-paren-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq warning-suppress-types '((comp) (native-compiler)))

;; ==========================================
;; 2. Elpaca 异步包管理器
;; ==========================================
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                       :ref nil :depth 1 :inherit ignore
                       :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                       :build (:not elpaca-activate)))

(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))

(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; ==========================================
;; 3. Use-Package
;; ==========================================
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq use-package-always-ensure t))
(elpaca-wait)

;; ==========================================
;; 4. Boon 核心模态
;; ==========================================
(use-package boon
  :config
  (require 'boon-qwerty)
  (boon-mode 1)
  (define-key boon-moves-map (kbd "<escape>") 'boon-command-mode))

;; 无模态编辑时的后备：默认进入 view-mode 防止误编辑
;; (setq initial-major-mode 'view-mode)

;; ==========================================
;; 5. 辅助效率插件
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
;; 6. Minibuffer 补全四件套
;; ==========================================
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

;; ==========================================
;; 7. Git & Org
;; ==========================================
(use-package transient
  :ensure t
  :demand t)

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package org
  :config
  (setq org-startup-indented t)
  (setq org-ellipsis " ▾")
  (setq org-hide-leading-stars t)
  (setq org-log-done 'time)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)"))))

;; ==========================================
;; 8. Vterm
;; ==========================================
(use-package vterm
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-module-compile-extra-flags
        '("-I" "/nix/store" "-I" "/usr/include"))
  :bind
  ("C-c v" . vterm)
  ("C-c V" . vterm-other-window))

;; ==========================================
;; 9. Theme
;; ==========================================
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-light-medium t))

;; ==========================================
;; 10. lsp-bridge (从 GitHub 安装，MELPA 没有)
;;     依赖 NixOS Python 包：epc orjson sexpdata six
;;     paramiko rapidfuzz watchdog packaging
;; ==========================================
(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))
(elpaca-wait)

(elpaca (lsp-bridge :host github :repo "manateelazycat/lsp-bridge"
                     :files (:defaults "acm" "core" "langserver"
                                       "resources" "lsp-bridge.py")))
(use-package lsp-bridge
  :ensure nil
  :hook ((prog-mode . lsp-bridge-mode))
  :config
  (setq lsp-bridge-enable-diagnostics t)
  (setq lsp-bridge-enable-hover-diagnostic t)
  (setq acm-enable-doc t)
  (setq acm-enable-copilot nil)
  (setq acm-doc-frame-max-lines 20)
  ;; 远程开发：通过 SSH 在服务端启动 lsp-bridge Python 后端
  (setq lsp-bridge-enable-remote t)
  (setq lsp-bridge-remote-start-path "~/lsp-bridge/lsp-bridge.py")
  (setq lsp-bridge-remote-sync-file-save-delay 0.5))

;; ==========================================
;; 11. gptel (LLM 对话)
;; ==========================================
(use-package gptel
  :config
  (gptel-make-openai "Hermes"
    :host "localhost:8000"
    :key "your-hermes-token-if-any"
    :stream t
    :models '("hermes-agent")))

;;; init.el ends here
