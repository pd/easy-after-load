;;; easy-after-load.el -- eval-after-load for all files in a directory

;; Author: Kyle Hargraves
;; URL: https://github.com/pd/easy-after-load
;; Version: 0.1

; This doesn't seem to fit in to any particular customize group.
; Maybe 'tools is a better option. Meh.
(defgroup easy-after-load nil
  "Easily manage eval-after-load statements."
  :group 'files)

(defcustom easy-after-load-directory
  (file-name-as-directory (expand-file-name "after-loads" user-emacs-directory))
  "The directory in which you keep your after-load files."
  :type 'directory
  :group 'easy-after-load)

(defcustom easy-after-load-pattern "^after-\\(.+\\)\\.el$"
  "The pattern used to extract the name of the feature to add the
`eval-after-load' statement for.  The first subexpression should
return the name of the feature. For the default value, the file
\"after-foo.el\" will be loaded after loading the feature \"foo\".

If you change `easy-after-load-function', this pattern will not
be used."
  :type 'regexp
  :group 'easy-after-load)

(defcustom easy-after-load-function 'easy-after-load-apply-pattern
  "The function used to extract the name of the feature to add the
`eval-after-load' statement for.  The function is given a single
argument, the `file-name-nondirectory' part of the filename of each
file in `easy-after-load-directory'. It should return the name of the
feature to add the `eval-after-load' statement for."
  :type 'function
  :group 'easy-after-load)

(defun easy-after-load-apply-pattern (filename)
  "Apply `easy-after-load-pattern' to FILENAME and return the
contents of the first matching subexpression."
  (if (string-match easy-after-load-pattern filename)
      (match-string 1 filename)
    (progn
      (message "easy-after-load-pattern failed to match against %s" filename)
      nil)))

(defun easy-after-load--files (dir)
  (condition-case err
      (directory-files dir t "\\.el$")
    (file-error (message "easy-after-load encountered an error reading from directory: %s" dir))))

(defun easy-after-load--get-feature (path)
  (let ((filename (file-name-nondirectory path)))
    (condition-case err
        (let ((feature (funcall easy-after-load-function filename)))
          (and feature (cons path (intern feature))))
      (error (message "easy-after-load-function failed on %s" filename)
             nil))))

(easy-after-load--get-feature (expand-file-name "~/.emacs.d/after-loads/init-ruby-mode.el"))

(defun easy-after-load--eval-after-load (after-load)
  (when after-load
    (eval-after-load (cdr after-load)
      `(load ,(car after-load)))))

(defun easy-after-load (&optional directory)
  "Add `eval-after-load' statements for all features with corresponding
files in DIRECTORY (or `easy-after-load-directory' if nil).

See also `easy-after-load-pattern', `easy-after-load-function'."
  (let* ((directory   (file-name-as-directory (or directory easy-after-load-directory)))
         (paths       (easy-after-load--files directory)))
    (mapc 'easy-after-load--eval-after-load
          (mapcar 'easy-after-load--get-feature paths))))

(provide 'easy-after-load)

;;; easy-after-load.el ends here
