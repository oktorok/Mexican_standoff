; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    .emacs                                             :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: tnicolas <marvin@42.fr>                    +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2017/11/25 16:34:31 by tnicolas          #+#    #+#              ;
;    Updated: 2017/12/05 11:09:09 by jagarcia         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

; Load general features files
(setq config_files "/usr/share/emacs/site-lisp/")
(setq load-path (append (list nil config_files) load-path))

(load "list.el")
(load "string.el")
(load "comments.el")
(load "header.el")

(autoload 'php-mode "php-mode" "Major mode for editing PHP code" t)
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

; Set default emacs configuration
;(set-language-environment "UTF-8")
;(setq-default font-lock-global-modes nil)
;(setq-default line-number-mode nil)
;(setq-default tab-width 4)
;(setq-default indent-tabs-mode t)
(global-set-key (kbd "DEL") 'backward-delete-char)
(global-set-key (kbd "C-c h") 'check-header)
;(setq-default c-backspace-function 'backward-delete-char)
;(setq-default c-basic-offset 4)
;(setq-default c-default-style "linux")
(setq-default tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                                 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

; Load user configuration
(if (file-exists-p "~/.myemacs") (load-file "~/.myemacs"))

(set-language-environment "UTF-8")

;;indent 4 spaces
(setq c-basic-offset 4)
(column-number-mode t)
(setq-default tab-always-indent 'complete)

;;show parenteze
(show-paren-mode t)
(setq c-default-style "bsd")

;;auto indent (all with <F12>)
(define-key global-map (kbd "RET") 'newline-and-indent)
(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f12] 'indent-buffer)

;;highlight useless spaces
(require 'whitespace)
(setq whitespace-style '(face lines-tail trailing))
(global-whitespace-mode t)


;;auto close ( { [ ' "
	(add-hook 'c-mode-hook
	 (lambda ()
	  (define-key c-mode-map "\"" 'electric-pair)
	  (define-key c-mode-map "\'" 'electric-pair)
	  (define-key c-mode-map "(" 'electric-pair)
	  (define-key c-mode-map "[" 'electric-pair)
	  (define-key c-mode-map "{" 'electric-pair)))

(defun electric-pair ()
 "If at end of line, insert character pair without surrounding spaces.
 Otherwise, just insert the typed character."
 (interactive)
 (if (eolp) (let (parens-require-spaces) (insert-pair))
  (self-insert-command 1)))

;;Highlight trailing whitespace.
(setq-default show-trailing-whitespace t)
	(set-face-background 'trailing-whitespace "red")

(defvar bad-whitespace
 '(("\t" . 'extra-whitespace-face)))

(add-hook 'change-major-mode-hook '(lambda () (highlight-regexp "  " 'hi-red)))

;;set backup file in .emacs.d
(setq backup-directory-alist `(("." . "~/.emacs.d")))
(setq backup-by-copying t)
(setq delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)
(setq make-backup-files nil)

;HEADER;
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern nil)
(defun timestamp ()
 (interactive)
 (insert (format-time-string "%Y/%m/%d %H:%M:%S")))
(defun timestamp2 ()
 (interactive)
 (insert (format-time-string "%Y/%m/%d %T"
  (nth 5 (file-attributes (buffer-name))))))
(defun header-file-line()
  (setq i 0)
  (insert "/*")
  (while (< i 3)
	(insert " ")
	(setq i (1+ i)))
  (if (> (length (buffer-name)) 41)
	    (insert (substring (buffer-name) 1 39) "...")
	(insert (buffer-name)))
  (setq i (current-column))
  (while (< i 56)
    (insert " ")
    (setq i (1+ i)))
  (insert ":+:      :+:    :+:")
  (setq i (current-column))
  (while (< i 77)
	(insert " ")
	(setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header-line($char)
  (insert "/* ")
  (setq i 0)
  (while (< i 74)
	(insert $char)
	(setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header42-line1()
  (insert "/* ")
  (setq i 0)
  (while (< i 55)
    (insert " ")
    (setq i (1+ i)))
  (insert ":::      ::::::::")
  (setq i (current-column))
  (while (< i 77)
    (insert " ")
    (setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header42-line2()
  (insert "/* ")
  (setq i 0)
  (while (< i 51)
    (insert " ")
    (setq i (1+ i)))
  (insert "+:+ +:+         +:+")
  (setq i (current-column))
  (while (< i 77)
    (insert " ")
    (setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header42-line3()
  (insert "/* ")
  (setq i 0)
  (while (< i 47)
    (insert " ")
    (setq i (1+ i)))
  (insert "+#+#+#+#+#+   +#+")
  (setq i (current-column))
  (while (< i 77)
    (insert " ")
    (setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header-name-line()
  (setq i 0)
  (insert "/*")
  (while (< i 3)
	(insert " ")
	(setq i (1+ i)))
  (insert "By: ")
  (insert (getenv "USER"))
  (insert " <")
  (if (> (length (getenv "MAIL")) 23)
	    (insert (substring (getenv "MAIL") 1 24) "...")
	(insert (getenv "MAIL")))
  (insert ">")
  (setq i (current-column))
  (while (< i 52)
    (insert " ")
    (setq i (1+ i)))
  (insert "+#+  +:+       +#+")
  (setq i (current-column))
  (while (< i 77)
	(insert " ")
	(setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header-creation-line()
  (setq i 0)
  (insert "/*")
  (while (< i 3)
    (insert " ")
    (setq i (1+ i)))
  (insert "Created: ")
  (timestamp)
  (insert " by ")
  (insert (getenv "USER"))
  (setq i (current-column))
  (while (< i 55)
    (insert " ")
    (setq i (1+ i)))
  (insert "#+#    #+#")
  (setq i (current-column))
  (while (< i 77)
    (insert " ")
    (setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun header-update-line()
  (setq i 0)
  (insert "/*")
  (while (< i 3)
    (insert " ")
    (setq i (1+ i)))
  (insert "Updated: ")
  (insert (format-time-string "%Y/%m/%d %H:%M:%S"(set-visited-file-modtime)))
  (insert " by ")
  (insert (getenv "USER"))
  (setq i (current-column))
  (while (< i 54)
    (insert " ")
    (setq i (1+ i)))
  (insert "###   ########.fr")
  (setq i (current-column))
  (while (< i 77)
    (insert " ")
    (setq i (1+ i)))
  (insert " */")
  (insert "\n"))
(defun add-header()
  (interactive)
  (goto-char 0)
  (header-line "*")
  (header-line " ")
  (header42-line1)
  (header-file-line)
  (header42-line2)
  (header-name-line)
  (header42-line3)
  (header-creation-line)
  (header-update-line)
  (header-line " ")
  (header-line "*"))
(defun check-header()
 (interactive)
 (if(>=(point-max) 890)
     (if(equal (buffer-substring-no-properties 1 249) "/* ************************************************************************** */\n/*                                         \
                                   */\n/*                                                        :::      ::::::::   */\n/*   ")
           (if(equal(buffer-substring-no-properties 290 415) "          :+:      :+:    :+:   */\n/*                                                    +:+ +:+         +:+     */\n\
/*   By: ")
               (if(equal(buffer-substring-no-properties 448 582) "          +#+  +:+       +#+        */\n/*                                                +#+#+#+#+#+   +#+       \
    */\n/*   Created: ")
                   (if(equal(buffer-substring-no-properties 613 663) "          #+#    #+#             */\n/*   Updated: ")
                       (if(equal(buffer-substring-no-properties 694 891) "         ###   ########.fr       */\n/*                                                                   \
         */\n/* ************************************************************************** */")
                           ()
                               (add-header))
                           (add-header))
				         (add-header))
                   (add-header))
	             (add-header))
    (add-header)))
;*******************************************************************************;