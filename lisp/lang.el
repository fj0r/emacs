;;; lang.el --- LSP + AI -*- lexical-binding: t; -*-

;; ==========================================
;; lsp-bridge (从 GitHub 安装，MELPA 没有)
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
;; gptel (LLM 对话)
;; ==========================================
(use-package gptel
  :config
  (gptel-make-openai "Hermes"
    :host "localhost:8000"
    :key "your-hermes-token-if-any"
    :stream t
    :models '("hermes-agent")))

(provide 'lang)
;;; lang.el ends here
