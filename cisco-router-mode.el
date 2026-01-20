;;; cisco-router-mode.el --- Major mode for Cisco router configs -*- lexical-binding: t; -*-

;; Original author: Noufal Ibrahim <nkv at hcoop period net>
;; Updated by: Fred Renner 2022, and others
;; This file is NOT part of GNU Emacs.

;;; Code:

(defgroup cisco-router nil
  "Major mode for Cisco router configuration files."
  :group 'languages)

(defvar cisco-router-mode-hook nil
  "Hook called by `cisco-router-mode'.")

(defvar cisco-router-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-j") #'newline-and-indent)
    map)
  "Keymap for `cisco-router-mode'.")

;;;; Faces

(defface cisco-router-ipadd-face
  '((((type tty) (class color))     (:foreground "yellow"))
    (((type graphic) (class color)) (:foreground "LightGoldenrod"))
    (t                              (:foreground "LightGoldenrod")))
  "Face for IP addresses.")

(defface cisco-router-command-face 
  '((((type tty) (class color))     (:foreground "cyan"))
    (((type graphic) (class color)) (:foreground "cyan"))
    (t                              (:foreground "cyan")))
  "Face for basic router commands.")

(defface cisco-router-toplevel-face
  '((((type tty) (class color))     (:foreground "blue"))
    (((type graphic) (class color)) (:foreground "lightsteelblue"))
    (t                              (:foreground "blue")))
  "Face for top level commands.")

(defface cisco-router-no-face
  '((((type graphic) (class color)) (:foreground "red"))
    (t                              (:underline t)))
  "Face for \"no\" and related negations.")

(defface cisco-router-up-face
  '((((type graphic) (class color)) (:foreground "green"))
    (t                              (:underline t)))
  "Face for \"up\" and related positive.")

(defface cisco-router-interface-face
  '((((type tty) (class color))     (:foreground "orange"))
    (((type graphic) (class color)) (:foreground "orange"))
    (t                              (:foreground "orange")))
  "Face for interface names.")

(defvar cisco-router-ipadd-face 'cisco-router-ipadd-face)
(defvar cisco-router-command-face 'cisco-router-command-face)
(defvar cisco-router-toplevel-face 'cisco-router-toplevel-face)
(defvar cisco-router-no-face 'cisco-router-no-face)
(defvar cisco-router-up-face 'cisco-router-up-face)
(defvar cisco-router-interface-face 'cisco-router-interface-face)

;;;; Font-lock

(defconst cisco-router-font-lock-keywords
  (list
   ;; Top-level sections
   '("\\<\\(access-list\\|c\\(?:lass-map\\|ontroller\\)\\|i\\(?:nterface\\|p vrf\\)\\|line\\|policy-map\\|r\\(?:edundancy\\|oute\\(?:-map\\|r\\)\\)\\)\\>"
     . cisco-router-toplevel-face)
   ;; Global commands
   '("\\<\\(alias\\|boot\\|card\\|diagnostic\\|^enable\\|hostname\\|logging\\|radius-server\\|s\\(?:ervice\\|nmp-server\\)\\|v\\(?:ersion\\|tp\\|timestamps\\|ip domain-name\\|name\\|description\\|)\\)\\>"
     . cisco-router-command-face)
   ;; “no” and “shutdown”
   '("\\<\\(no\\|shutdown\\|down\\|trunk\\|not\\)\\>" . cisco-router-no-face)
   ;; “up” and “connected”
   '("\\<\\(up\\|connected\\|#\\)\\>" . cisco-router-up-face)
   ;; IPv4 addresses
   '("\\<\\([0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\)\\>"
     . cisco-router-ipadd-face)
   ;; Interface names (Ethernet, Vlan, ae, Loopback, etc.)
   '("\\<\\([a-zA-Z]*Ethernet[0-9]+/[0-9]+/[0-9]+\\|[a-zA-Z]*Ethernet\\([0-9]+\\S+[0-9]+\\)+\\|[a-zA-Z]*Ethernet[0-9]+\\|Vlan[0-9]+\\|vlan [0-9]+\\|ae[0-9]\\S+[0-9]+\\|ae[0-9]+\\|Loopback[0-9]+\\|Tunnel[0-9]+\\|Port-Channel[0-9]+\\|ethernet\\([0-9]+\\S+\\)+\\)\\|Vxlan[0-9]+\\|ethernet[0-9]+\\S+[0-9]+\\>"
     . cisco-router-interface-face))
  "Font-lock rules for `cisco-router-mode'.")

;;;; Imenu

(defvar cisco-router-imenu-expression
  '(("Interfaces"        "^[\t ]*interface *\\(.*\\)" 1)
    ("VRFs"              "^ip vrf *\\(.*\\)" 1)
    ("Controllers"       "^[\t ]*controller *\\(.*\\)" 1)
    ("Routing protocols" "^router *\\(.*\\)" 1)
    ("Class maps"        "^class-map *\\(.*\\)" 1)
    ("Policy maps"       "^policy-map *\\(.*\\)" 1))
  "Imenu expressions for `cisco-router-mode'.")

;;;; Indentation

(defun cisco-router-indent-line ()
  "Indent current line as a Cisco router config line."
  (let ((indent0 "^interface\\|redundancy\\|^line\\|^ip vrf \\|^controller\\|^class-map\\|^policy-map\\|router\\|access-list\\|route-map")
        (indent1 " *main-cpu\\| *class\\W"))
    (beginning-of-line)
    (let ((not-indented t)
          (cur-indent 0))
      (cond
       ((or (bobp) (looking-at indent0) (looking-at "!"))
        (setq not-indented nil
              cur-indent 0))
       ((looking-at indent1)
        (setq not-indented nil
              cur-indent 1)))
      (save-excursion
        (while not-indented
          (forward-line -1)
          (cond
           ((looking-at indent1)
            (setq cur-indent 2
                  not-indented nil))
           ((looking-at indent0)
            (setq cur-indent 1
                  not-indented nil))
           ((looking-at "!")
            (setq cur-indent 0
                  not-indented nil))
           ((bobp)
            (setq cur-indent 0
                  not-indented nil)))))
      (indent-line-to cur-indent))))

;;;; Syntax table

(defvar cisco-router-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?- "w" st)
    (modify-syntax-entry ?! "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?\r ">" st)
    st)
  "Syntax table for `cisco-router-mode'.")

;;;; Major mode

;;;###autoload
(define-derived-mode cisco-router-mode text-mode "CiscoRouter"
  "Major mode for editing Cisco router configuration files."
  :syntax-table cisco-router-mode-syntax-table
  (setq-local font-lock-defaults '(cisco-router-font-lock-keywords))
  (setq-local indent-line-function #'cisco-router-indent-line)
  (setq-local comment-start "!")
  (setq-local comment-start-skip "\\(\\(^\\|[^\\\\\n]\\)\\(\\\\\\\\\\)*\\)!+ *")
  (setq-local imenu-case-fold-search nil)
  (setq-local imenu-generic-expression cisco-router-imenu-expression)
  (imenu-add-to-menubar "Imenu"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cfg\\'" . cisco-router-mode))

(provide 'cisco-router-mode)

;;; cisco-router-mode.el ends here
