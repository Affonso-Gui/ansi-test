;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Mon Mar 30 22:10:34 1998
;;;; Contains: Testing of CL Features related to "CONS", part 22

(in-package :cl-test)
(use-package :rt)
(declaim (optimize (safety 3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; set-difference

(deftest set-difference.1
  (set-difference nil nil)
  nil)

(deftest set-difference.2
  (let ((result
	 (set-difference-with-check '(a b c) nil)))
    (check-set-difference '(a b c) nil result))
  t)

(deftest set-difference.3
  (let ((result
	 (set-difference-with-check '(a b c d e f) '(f b d))))
    (check-set-difference '(a b c d e f) '(f b d) result))
  t)

(deftest set-difference.4
  (sort
   (copy-list
    (set-difference-with-check (shuffle '(1 2 3 4 5 6 7 8))
			       '(10 101 4 74 2 1391 7 17831)))
   #'<)
  (1 3 5 6 8))

(deftest set-difference.5
  (set-difference-with-check nil '(a b c d e f g h))
  nil)

(deftest set-difference.6
  (set-difference-with-check '(a b c d e) '(d a b e)
			     :key nil)
  (c))

(deftest set-difference.7
  (set-difference-with-check '(a b c d e) '(d a b e) :test #'eq)
  (c))

(deftest set-difference.8
  (set-difference-with-check '(a b c d e) '(d a b e) :test #'eql)
  (c))

(deftest set-difference.9
  (set-difference-with-check '(a b c d e) '(d a b e) :test #'equal)
  (c))

(deftest set-difference.10
  (set-difference-with-check '(a b c d e) '(d a b e)
			     :test 'eq)
  (c))

(deftest set-difference.11
  (set-difference-with-check '(a b c d e) '(d a b e)
			     :test 'eql)
  (c))

(deftest set-difference.12
  (set-difference-with-check '(a b c d e) '(d a b e)
			     :test 'equal)
  (c))

(deftest set-difference.13
  (do-random-set-differences 100 100)
  nil)

(deftest set-difference.14
  (set-difference-with-check '((a . 1) (b . 2) (c . 3))
			     '((a . 1) (c . 3))
			     :key 'car)
  ((b . 2)))

(deftest set-difference.15
  (set-difference-with-check '((a . 1) (b . 2) (c . 3))
			     '((a . 1) (c . 3))
			     :key #'car)
  ((b . 2)))

;;
;; Verify that the :test argument is called with the arguments
;; in the correct order
;;
(deftest set-difference.16
  (block fail
    (sort
     (copy-list
      (set-difference-with-check
       '(1 2 3 4) '(e f g h)
       :test #'(lambda (x y)
		 (when (or (member x '(e f g h))
			   (member y '(1 2 3 4)))
		   (return-from fail 'fail))
		 (eqt x y))))
     #'<))
  (1 2 3 4))

(deftest set-difference.17
  (block fail
    (sort
     (copy-list
      (set-difference-with-check
       '(1 2 3 4) '(e f g h)
       :key #'identity
       :test #'(lambda (x y)
		 (when (or (member x '(e f g h))
			   (member y '(1 2 3 4)))
		   (return-from fail 'fail))
		 (eqt x y))))
     #'<))
  (1 2 3 4))

(deftest set-difference.18
  (block fail
    (sort
     (copy-list
      (set-difference-with-check
       '(1 2 3 4) '(e f g h)
       :test-not
       #'(lambda (x y)
	   (when (or (member x '(e f g h))
		     (member y '(1 2 3 4)))
	     (return-from fail 'fail))
	   (not (eqt x y)))))
     #'<))
  (1 2 3 4))

(deftest set-difference.19
  (block fail
    (sort
     (copy-list
      (set-difference-with-check
       '(1 2 3 4) '(e f g h)
       :test-not
       #'(lambda (x y)
	   (when (or (member x '(e f g h))
		     (member y '(1 2 3 4)))
	     (return-from fail 'fail))
	   (not (eqt x y)))))
     #'<))
  (1 2 3 4))

;;; Order of argument evaluation tests

(deftest set-difference.order.1
  (let ((i 0) x y)
    (values
     (set-difference (progn (setf x (incf i)) (list 1 2 3 4))
		     (progn (setf y (incf i)) (list 2 3 4)))
     i x y))
  (1) 2 1 2)

(deftest set-difference.order.2
  (let ((i 0) x y z)
    (values
     (set-difference (progn (setf x (incf i)) (list 1 2 3 4))
		     (progn (setf y (incf i)) (list 2 3 4))
		     :test (progn (setf z (incf i))
				  #'(lambda (x y) (= x (1- y)))))
     i x y z))
  (4) 3 1 2 3)

(deftest set-difference.order.3
  (let ((i 0) x y z w)
    (values
     (set-difference (progn (setf x (incf i)) (list 1 2 3 4))
		     (progn (setf y (incf i)) (list 2 3 4))
		     :test (progn (setf z (incf i))
				  #'(lambda (x y) (= x (1- y))))
		     :key (progn (setf w (incf i)) nil))
     i x y z w))
  (4) 4 1 2 3 4)


;;; Keyword tests

(deftest set-difference.allow-other-keys.1
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :bad t :allow-other-keys t))
   #'<)
  (1 5))

(deftest set-difference.allow-other-keys.2
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t :bad t))
   #'<)
  (1 5))

(deftest set-difference.allow-other-keys.3
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t :bad t :test #'(lambda (x y) (= x (1- y)))))
   #'<)
  (4 5))

(deftest set-difference.allow-other-keys.4
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t))
   #'<)
  (1 5))

(deftest set-difference.allow-other-keys.5
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys nil))
   #'<)
  (1 5))

(deftest set-difference.allow-other-keys.6
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t
     :allow-other-keys nil))
   #'<)
  (1 5))

(deftest set-difference.allow-other-keys.7
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t
     :allow-other-keys nil
     '#:x 1))
   #'<)
  (1 5))

(deftest set-difference.keywords.8
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :test #'eql :test (complement #'eql)))
   #'<)
  (1 5))

(deftest set-difference.keywords.9
  (sort
   (copy-list
    (set-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :test (complement #'eql) :test #'eql))
   #'<)
  nil)

;;; Error tests


(deftest set-difference.error.1
  (classify-error (set-difference))
  program-error)

(deftest set-difference.error.2
  (classify-error (set-difference nil))
  program-error)

(deftest set-difference.error.3
  (classify-error (set-difference nil nil :bad t))
  program-error)

(deftest set-difference.error.4
  (classify-error (set-difference nil nil :key))
  program-error)

(deftest set-difference.error.5
  (classify-error (set-difference nil nil 1 2))
  program-error)

(deftest set-difference.error.6
  (classify-error (set-difference nil nil :bad t :allow-other-keys nil))
  program-error)

(deftest set-difference.error.7
  (classify-error (set-difference (list 1 2) (list 3 4) :test #'identity))
  program-error)

(deftest set-difference.error.8
  (classify-error (set-difference (list 1 2) (list 3 4) :test-not #'identity))
  program-error)

(deftest set-difference.error.9
  (classify-error (set-difference (list 1 2) (list 3 4) :key #'cons))
  program-error)

(deftest set-difference.error.10
  (classify-error (set-difference (list 1 2) (list 3 4) :key #'car))
  type-error)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nset-difference

(deftest nset-difference.1
  (nset-difference nil nil)
  nil)

(deftest nset-difference.2
  (let ((result
	 (nset-difference-with-check '(a b c) nil)))
    (check-nset-difference '(a b c) nil result))
  t)

(deftest nset-difference.3
  (let ((result
	 (nset-difference-with-check '(a b c d e f) '(f b d))))
    (check-nset-difference '(a b c d e f) '(f b d) result))
  t)

(deftest nset-difference.4
  (sort
   (copy-list
    (nset-difference-with-check (shuffle '(1 2 3 4 5 6 7 8))
				'(10 101 4 74 2 1391 7 17831)))
   #'<)
  (1 3 5 6 8))

(deftest nset-difference.5
  (nset-difference-with-check nil '(a b c d e f g h))
  nil)

(deftest nset-difference.6
  (nset-difference-with-check '(a b c d e) '(d a b e)
			      :key nil)
  (c))

(deftest nset-difference.7
  (nset-difference-with-check '(a b c d e) '(d a b e) :test #'eq)
  (c))

(deftest nset-difference.8
  (nset-difference-with-check '(a b c d e) '(d a b e) :test #'eql)
  (c))

(deftest nset-difference.9
  (nset-difference-with-check '(a b c d e) '(d a b e) :test #'equal)
  (c))

(deftest nset-difference.10
  (nset-difference-with-check '(a b c d e) '(d a b e)
			      :test 'eq)
  (c))

(deftest nset-difference.11
  (nset-difference-with-check '(a b c d e) '(d a b e)
			      :test 'eql)
  (c))

(deftest nset-difference.12
  (nset-difference-with-check '(a b c d e) '(d a b e)
			      :test 'equal)
  (c))

(deftest nset-difference.13
  (do-random-nset-differences 100 100)
  nil)

(deftest nset-difference.14
  (nset-difference-with-check '((a . 1) (b . 2) (c . 3))
			      '((a . 1) (c . 3))
			      :key 'car)
  ((b . 2)))

(deftest nset-difference.15
  (nset-difference-with-check '((a . 1) (b . 2) (c . 3))
			      '((a . 1) (c . 3))
			      :key #'car)
  ((b . 2)))

;;
;; Verify that the :test argument is called with the arguments
;; in the correct order
;;
(deftest nset-difference.16
  (block fail
    (sort
     (copy-list
      (nset-difference-with-check
       '(1 2 3 4) '(e f g h)
       :test #'(lambda (x y)
		 (when (or (member x '(e f g h))
			   (member y '(1 2 3 4)))
		   (return-from fail 'fail))
		 (eqt x y))))
     #'<))
  (1 2 3 4))

(deftest nset-difference.17
  (block fail
    (sort
     (copy-list
      (nset-difference-with-check
       '(1 2 3 4) '(e f g h)
       :key #'identity
       :test #'(lambda (x y)
		 (when (or (member x '(e f g h))
			   (member y '(1 2 3 4)))
		   (return-from fail 'fail))
		 (eqt x y))))
     #'<))
  (1 2 3 4))

(deftest nset-difference.18
  (block fail
    (sort
     (copy-list
      (nset-difference-with-check
       '(1 2 3 4) '(e f g h)
       :test-not
       #'(lambda (x y)
	   (when (or (member x '(e f g h))
		     (member y '(1 2 3 4)))
	     (return-from fail 'fail))
	   (not (eqt x y)))))
     #'<))
  (1 2 3 4))

(deftest nset-difference.19
  (block fail
    (sort (copy-list
	   (nset-difference-with-check
	    '(1 2 3 4) '(e f g h)
	    :test-not
	    #'(lambda (x y)
		(when (or (member x '(e f g h))
			  (member y '(1 2 3 4)))
		  (return-from fail 'fail))
		(not (eqt x y)))))
	  #'<))
  (1 2 3 4))

;;; Order of argument evaluation tests

(deftest nset-difference.order.1
  (let ((i 0) x y)
    (values
     (nset-difference (progn (setf x (incf i)) (list 1 2 3 4))
		      (progn (setf y (incf i)) (list 2 3 4)))
     i x y))
  (1) 2 1 2)

(deftest nset-difference.order.2
  (let ((i 0) x y z)
    (values
     (nset-difference (progn (setf x (incf i)) (list 1 2 3 4))
		      (progn (setf y (incf i)) (list 2 3 4))
		      :test (progn (setf z (incf i))
				   #'(lambda (x y) (= x (1- y)))))
     i x y z))
  (4) 3 1 2 3)

(deftest nset-difference.order.3
  (let ((i 0) x y z w)
    (values
     (nset-difference (progn (setf x (incf i)) (list 1 2 3 4))
		      (progn (setf y (incf i)) (list 2 3 4))
		      :test (progn (setf z (incf i))
				   #'(lambda (x y) (= x (1- y))))
		      :key (progn (setf w (incf i)) nil))
     i x y z w))
  (4) 4 1 2 3 4)


;;; Keyword tests

(deftest nset-difference.allow-other-keys.1
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :bad t :allow-other-keys t))
   #'<)
  (1 5))

(deftest nset-difference.allow-other-keys.2
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t :bad t))
   #'<)
  (1 5))

(deftest nset-difference.allow-other-keys.3
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t :bad t :test #'(lambda (x y) (= x (1- y)))))
   #'<)
  (4 5))

(deftest nset-difference.allow-other-keys.4
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t))
   #'<)
  (1 5))

(deftest nset-difference.allow-other-keys.5
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys nil))
   #'<)
  (1 5))

(deftest nset-difference.allow-other-keys.6
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t
     :allow-other-keys nil))
   #'<)
  (1 5))

(deftest nset-difference.allow-other-keys.7
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :allow-other-keys t
     :allow-other-keys nil
     '#:x 1))
   #'<)
  (1 5))

(deftest nset-difference.keywords.8
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :test #'eql :test (complement #'eql)))
   #'<)
  (1 5))

(deftest nset-difference.keywords.9
  (sort
   (copy-list
    (nset-difference
     (list 1 2 3 4 5) (list 2 3 4)
     :test (complement #'eql) :test #'eql))
   #'<)
  nil)

;;; Error tests

(deftest nset-difference.error.1
  (classify-error (nset-difference))
  program-error)

(deftest nset-difference.error.2
  (classify-error (nset-difference nil))
  program-error)

(deftest nset-difference.error.3
  (classify-error (nset-difference nil nil :bad t))
  program-error)

(deftest nset-difference.error.4
  (classify-error (nset-difference nil nil :key))
  program-error)

(deftest nset-difference.error.5
  (classify-error (nset-difference nil nil 1 2))
  program-error)

(deftest nset-difference.error.6
  (classify-error (nset-difference nil nil :bad t :allow-other-keys nil))
  program-error)

(deftest nset-difference.error.7
  (classify-error (nset-difference (list 1 2) (list 3 4) :test #'identity))
  program-error)

(deftest nset-difference.error.8
  (classify-error (nset-difference (list 1 2) (list 3 4) :test-not #'identity))
  program-error)

(deftest nset-difference.error.9
  (classify-error (nset-difference (list 1 2) (list 3 4) :key #'cons))
  program-error)

(deftest nset-difference.error.10
  (classify-error (nset-difference (list 1 2) (list 3 4) :key #'car))
  type-error)
