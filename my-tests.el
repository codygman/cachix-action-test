(require 'ert)
(require 'ert-x)
(ert-deftest version-check ()
  (should (string-equal "27.0.50" emacs-version)))
(ert-deftest evil-installed ()
  (should (fboundp 'evil-version)))
(ert-deftest evil-collection-installed ()
  (should (fboundp 'evil-collection-init)))

(defun tests-run ()
  "Run Evil tests."
  (interactive '(nil t))
  ;; We would like to use `ert-run-tests-batch-and-exit'
  ;; Unfortunately it doesn't work outside of batch mode, and we
  ;; can't use batch mode because we have tests that need windows.
  ;; Instead, run the tests interactively, copy the results to a
  ;; text file, and then exit with an appropriate code.
  (setq attempt-stack-overflow-recovery nil
	attempt-orderly-shutdown-on-fatal-signal nil)
  (unwind-protect
      (progn
	(ert-run-tests-interactively t)
	(with-current-buffer "*ert*"
	  (append-to-file (point-min) (point-max) "test-results.txt")
	  (when (not (getenv "DEBUG_TESTS")) (kill-emacs (if (zerop (ert-stats-completed-unexpected ert--results-stats)) 0 1))))
    (unwind-protect
	(progn
	  (append-to-file "Error running tests\n" nil "test-results.txt")
	  (append-to-file (backtrace-to-string (backtrace-get-frames 'backtrace)) nil "test-results.txt"))
      (when (not (getenv "DEBUG_TESTS")) (kill-emacs 2))))))
