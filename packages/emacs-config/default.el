;;; default.el --- Minimal developer Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; System-level Emacs configuration for the Minimal build system.
;; Provides a terminal-friendly developer environment with LSP support.

;;; Code:

;; ── General settings ──────────────────────────────────────────────────
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      use-short-answers t
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Terminal-friendly UI
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(column-number-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(savehist-mode 1)
(recentf-mode 1)

;; Theme
(load-theme 'modus-vivendi t)

;; Scrolling
(setq scroll-margin 3
      scroll-conservatively 101)

;; Indentation
(setq-default indent-tabs-mode nil
              tab-width 4)

;; ── Package load paths ────────────────────────────────────────────────
(let ((site-lisp-dir (expand-file-name "../share/emacs/site-lisp" data-directory)))
  (when (file-directory-p site-lisp-dir)
    (dolist (dir (directory-files site-lisp-dir t "\\`[^.]"))
      (when (file-directory-p dir)
        (add-to-list 'load-path dir)
        ;; Also add lisp/ subdirectory if present (e.g., magit/lisp/)
        (let ((lisp-subdir (expand-file-name "lisp" dir)))
          (when (file-directory-p lisp-subdir)
            (add-to-list 'load-path lisp-subdir)))))))

;; ── Completion framework (vertico + orderless + marginalia + consult) ─
(when (require 'vertico nil t)
  (vertico-mode 1))

(when (require 'orderless nil t)
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles partial-completion)))))

(when (require 'marginalia nil t)
  (marginalia-mode 1))

(when (require 'consult nil t)
  (global-set-key (kbd "C-x b") 'consult-buffer)
  (global-set-key (kbd "M-g g") 'consult-goto-line)
  (global-set-key (kbd "M-s l") 'consult-line)
  (global-set-key (kbd "M-s r") 'consult-ripgrep))

;; ── In-buffer completion (corfu) ──────────────────────────────────────
(when (require 'corfu nil t)
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2)
  (global-corfu-mode 1))

;; ── Which-key ─────────────────────────────────────────────────────────
(when (require 'which-key nil t)
  (which-key-mode 1))

;; ── Magit ─────────────────────────────────────────────────────────────
(when (require 'transient nil t)
  (when (require 'magit nil t)
    (global-set-key (kbd "C-x g") 'magit-status)))

;; ── Extra modes ───────────────────────────────────────────────────────
(require 'markdown-mode nil t)
(require 'yaml-mode nil t)
(require 'dockerfile-mode nil t)
(require 'nickel-mode nil t)

;; ── Tree-sitter ───────────────────────────────────────────────────────
(setq treesit-font-lock-level 4)

;; ── EditorConfig ──────────────────────────────────────────────────────
(when (fboundp 'editorconfig-mode)
  (editorconfig-mode 1))

;; ── Eglot (LSP) ──────────────────────────────────────────────────────
(with-eval-after-load 'eglot
  (dolist (entry '((nickel-mode . ("nls"))
                   (go-mode . ("gopls"))
                   (go-ts-mode . ("gopls"))
                   (rust-mode . ("rust-analyzer"))
                   (rust-ts-mode . ("rust-analyzer"))
                   ((js-mode js-ts-mode tsx-ts-mode typescript-ts-mode typescript-mode)
                    . ("typescript-language-server" "--stdio"))
                   (python-mode . ("pyright-langserver" "--stdio"))
                   (python-ts-mode . ("pyright-langserver" "--stdio"))
                   ((bash-ts-mode sh-mode) . ("bash-language-server" "start"))
                   ((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd"))))
    (add-to-list 'eglot-server-programs entry)))

;; Auto-start eglot for programming modes where an LSP server is likely available
(defun minimal--maybe-eglot ()
  "Start eglot if a server program is configured for the current mode."
  (when (and (fboundp 'eglot-ensure)
             (not (derived-mode-p 'emacs-lisp-mode))
             (assoc major-mode eglot-server-programs
                    (lambda (key mode)
                      (if (listp key)
                          (memq mode key)
                        (eq key mode)))))
    (eglot-ensure)))

(add-hook 'prog-mode-hook #'minimal--maybe-eglot)

;;; default.el ends here
