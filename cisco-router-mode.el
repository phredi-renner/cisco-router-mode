;;; cisco-config-mode.el --- Major mode for Cisco router configs -*- lexical-binding: t; -*-

(defgroup cisco-config nil
  "Major mode for editing Cisco router configuration files."
  :group 'languages)

;; Basic keyword classes
(defconst cisco-config-font-lock-keywords
  (let* (
         ;; Top-level / mode keywords
         (keywords '("version" "hostname" "enable secret" "enable password"
                     "service password-encryption"
                     "ip domain-name" "ip name-server"
                     "logging" "clock timezone"
                     "access-list" "ip access-list" "route-map"
                     "router" "network" "redistribute" "neighbor"
                     "line" "interface" "vlan" "ip route"
                     "banner" "username" "aaa" "crypto" "snmp-server"))

         ;; Common subcommands
         (subcmds '("description" "ip address" "no shutdown" "shutdown"
                    "duplex" "speed" "switchport" "encapsulation"
                    "service-policy" "ip nat" "ip ospf" "ip pim" "standby"))

         ;; Interface name patterns
         (ifaces '("GigabitEthernet" "FastEthernet" "TenGigabitEthernet"
                   "Ethernet" "Serial" "Loopback" "Vlan" "Port-channel"))

         ;; Build regexps
         (keywords-regexp (regexp-opt keywords 'words))
         (subcmds-regexp  (regexp-opt subcmds 'words))
         (ifaces-regexp   (concat "\\<"
                                  (regexp-opt ifaces)
                                  "[0-9./]*\\>")))
    `(
      ;; Top-level / mode keywords
      (,keywords-regexp . font-lock-keyword-face)
      ;; Subcommands
      (,subcmds-regexp  . font-lock-builtin-face)
      ;; Interface names like GigabitEthernet0/1, Loopback0, Vlan10
      (,ifaces-regexp   . font-lock-variable-name-face)
      ;; IPv4 addresses
      ("\\<[0-9]+\\(?:\\.[0-9]+\\)\\{3\\}\\>" . font-lock-constant-face)
      ;; Access-list numbers
      ("\\<\\([0-9]\\{1,5\\}\\)\\>" 1 font-lock-constant-face))))

;;;###autoload
(define-derived-mode cisco-config-mode fundamental-mode "CiscoCfg"
  "Major mode for editing Cisco router configuration files."
  :group 'cisco-config
  (setq font-lock-defaults '(cisco-config-font-lock-keywords))
  (setq-local comment-start "!")
  (setq-local comment-start-skip "!+\\s-*"))

;;;###autoload
(add-to-list 'auto-mode-alist '("cisco-.*\\.txt\\'" . cisco-config-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ios\\'"        . cisco-config-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cisco\\'"      . cisco-config-mode))

(provide 'cisco-config-mode)
;;; cisco-config-mode.el ends here
