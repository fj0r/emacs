;;; term.el --- Vterm 终端 -*- lexical-binding: t; -*-

(use-package vterm
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-module-compile-extra-flags
        '("-I" "/nix/store" "-I" "/usr/include"))
  :bind
  ("C-c v" . vterm)
  ("C-c V" . vterm-other-window))

(provide 'term)
;;; term.el ends here
