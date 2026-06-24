;;; -*- lexical-binding: t; -*-

;; ── Package ──────────────────────────────────────────────
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ── Boon ─────────────────────────────────────────────────
(use-package boon
  :ensure t
  :config
  (require 'boon-keys)
  (require 'boon-paths)
  (require 'boon-toggles)
  (require 'boon-search)
  (require 'boon-compile)
  (boon-mode 1)
  :bind
  (("<f7>" . boon-toggle)
   ("C-c b m" . boon-mode)))

;; ── Vterm ────────────────────────────────────────────────
(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-module-compile-extra-flags
        '("-I" "/nix/store" "-I" "/usr/include"))
  :bind
  ("C-c v" . vterm)
  ("C-c V" . vterm-other-window))

;; ── Base UI ──────────────────────────────────────────────
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode '(1 . 1))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(show-paren-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; ── Theme ────────────────────────────────────────────────
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; ── Completion ───────────────────────────────────────────
(use-package vertico
  :ensure t
  :init (vertico-mode 1))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

(use-package marginalia
  :ensure t
  :init (marginalia-mode 1))

(use-package which-key
  :ensure t
  :init (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0.5))

;; ── Git ──────────────────────────────────────────────────
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; ── LSP (optional, disabled by default) ─────────────────
;; (use-package eglot
;;   :hook ((prog-mode . eglot-ensure)))

;;; init.el ends here
