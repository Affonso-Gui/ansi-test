;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Mar 28 07:36:30 1998
;;;; Contains: Testing of CL Features related to "CONS", part 9

(in-package :cl-test)
(use-package :rt)
(declaim (optimize (safety 3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; butlast, nbutlast

(deftest butlast-1
    (let ((x (list 'a 'b 'c 'd 'e)))
      (let ((xcopy (make-scaffold-copy x)))
	(let ((result (butlast x 2)))
	  (and
	   (check-scaffold-copy x xcopy)
	   result))))
  (a b c))

(deftest butlast-2
    (let ((x (list 'a 'b 'c 'd 'e)))
      (let ((xcopy (make-scaffold-copy x)))
	(let ((result (butlast x 0)))
	  (and
	   (check-scaffold-copy x xcopy)
	   result))))
  (a b c d e))

(deftest butlast-3
    (let ((x (list 'a 'b 'c 'd 'e)))
      (let ((xcopy (make-scaffold-copy x)))
	(let ((result (butlast x 5)))
	  (and
	   (check-scaffold-copy x xcopy)
	   result))))
  nil)

(deftest butlast-4
    (let ((x (list 'a 'b 'c 'd 'e)))
      (let ((xcopy (make-scaffold-copy x)))
	(let ((result (butlast x 6)))
	  (and
	   (check-scaffold-copy x xcopy)
	   result))))
  nil)

(deftest butlast-5
  (butlast (copy-tree '(a b c . d)) 1)
  (a b))

(deftest butlast.error.1
  (classify-error (butlast (copy-tree '(a b c d)) 'a))
  type-error)

(deftest butlast.error.2
  (classify-error (butlast 'a 0))
  type-error)

(deftest butlast.error.3
  (classify-error (butlast))
  program-error)

(deftest butlast.error.4
  (classify-error (butlast '(a b c) 3 3))
  program-error)

(deftest butlast.error.5
  (classify-error (locally (butlast 'a 0) t))
  type-error)


;;; Tests of NBUTLAST

(deftest nbutlast-1
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((y (cdr x))
	  (z (cddr x)))
      (let ((result (nbutlast x 2)))
	(and (eqt x result)
	     (eqt (cdr x) y)
	     (eqt (cddr x) z)
	     result))))
  (a b c))

(deftest nbutlast-2
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((result (nbutlast x 5)))
      (list x result)))
  ((a b c d e) nil))

(deftest nbutlast-3
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((result (nbutlast x 500)))
      (list x result)))
  ((a b c d e) nil))

(deftest nbutlast-4
  (let ((x (list* 'a 'b 'c 'd)))
    (let ((result (nbutlast x 1)))
      (and (eqt result x)
	   result)))
  (a b))

(deftest nbutlast-5
  (classify-error (let ((x (list* 'a 'b 'c 'd))) (nbutlast x 'a)))
  type-error)

(deftest nbutlast-6
  (classify-error (nbutlast 'a 10))
  type-error)

(deftest nbutlast-7
  (classify-error (nbutlast 2 10))
  type-error)

(deftest nbutlast-8
  (classify-error (nbutlast #\w 10))
  type-error)

(deftest nbutlast-9
  (classify-error (nbutlast (list 'a 'b 'c 'd) -3))
  type-error)

(deftest nbutlast-10
  (nbutlast nil)
  nil)

(deftest nbutlast-11
  (nbutlast (list 'a))
  nil)

(deftest nbutlast-12
  (classify-error (nbutlast (list 'a) 20.0))
  type-error)

(deftest nbutlast-13
  (classify-error (nbutlast (list 'a) -100.0))
  type-error)

(deftest nbutlast-14
  (classify-error (nbutlast))
  program-error)

(deftest nbutlast-15
  (classify-error (nbutlast (list 'a 'b 'c) 3 3))
  program-error)

(deftest nbutlast-16
  (classify-error (locally (nbutlast 'a 10) t))
  type-error)
