(Given "^I have an easy-after-load directory$"
       (lambda ()
         ; nothing to do
         ))

(Given "^I have a second easy-after-load directory \"\\(.+\\)\"$"
       (lambda (dir)
         (setq easy-after-load-test-extra-dir (expand-file-name (concat "tmp/" dir) easy-after-load-root-path))
         (mkdir easy-after-load-test-extra-dir 'parents)))

(Given "^I have an? \"\\(.+\\)\" after-load file$"
       (lambda (filename)
         (let ((path (expand-file-name filename easy-after-load-test-directory)))
           (condition-case nil (delete-file path) (error))
           (with-temp-buffer
             (insert (concat "(message \"Loaded %s!\" \"" filename "\")\n"))
             (write-region (point-min) (point-max) path)))))

(Given "^I have an? \"\\(.+\\)\" after-load file in \"\\(.+\\)\"$"
       (lambda (filename dir)
         ; Ignoring dir, it's really just easy-after-load-test-extra-dir
         (let ((easy-after-load-test-directory easy-after-load-test-extra-dir))
           (Given (format "I have an \"%s\" after-load file" filename)))))

(Given "^my easy-after-load-function returns the filename sans extension$"
       (lambda ()
         (setq easy-after-load-function 'file-name-sans-extension)))

(When "^I run easy-after-load$"
      (lambda () (easy-after-load)))

(When "^I run easy-after-load on \"\\(.+\\)\"$"
       (lambda (dir)
         ; Ignoring dir, it's really just easy-after-load-test-extra-dir
         (easy-after-load easy-after-load-test-extra-dir)))

(Then "^an after-load-alist entry should be present for '\\(.+\\)$"
      (lambda (feature)
        (should (not (null (-first (lambda (e) (eq e (intern feature)))
                                   (mapcar 'car after-load-alist)))))))




;; todo
(And "^I am recording every file found by easy-after-load$"
       (lambda ()
         (error "unimpl")))

(Then "^I should not see a message about \"\\([^\"]+\\)\"$"
       (lambda (arg)
         (error "unimpl")
         ))

(Then "^I have no idea what will happen, actually$"
       (lambda ()
         (error "unimpl")
         ))

(When "^I add a custom eval-after-load line for \"\\([^\"]+\\)\"$"
       (lambda (arg)
         (error "unimpl")))

(Then "^only one after-load-alist entry should be present for '\\(.+\\)$"
       (lambda (arg)
         (error "unimpl")
         ))
