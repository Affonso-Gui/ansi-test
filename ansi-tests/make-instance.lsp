;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Mon May 12 21:19:36 2003
;;;; Contains: Tests of MAKE-INSTANCE

(in-package :cl-test)

;;; MAKE-INSTANCE is used in many other tests as well

(deftest make-instance.error.1
  (classify-error (make-instance))
  program-error)

(defclass make-instance-class-01 ()
  ((a :initarg :a) (b :initarg :b)))

(deftest make-instance.error.2
  (classify-error (make-instance 'make-instance-class-01 :a))
  program-error)

(deftest make-instance.error.3
  (handler-case (progn (eval '(make-instance 'make-instance-class-01 :z 1))
		       t)
		(error () :good))
  :good)

(deftest make-instance.error.4
  (handler-case (progn (eval '(make-instance
			       (find-class 'make-instance-class-01)
			       :z 1))
		       t)
		(error () :good))
  :good)

(deftest make-instance.error.5
  (classify-error (let () (make-instance) nil))
  program-error)

;; Definitions of methods

(defmethod make-instance ((x (eql 'foo)) &rest initargs &key &allow-other-keys)
  (cons x initargs))

(deftest make-instance.1
  (make-instance 'foo)
  (foo))

(deftest make-instance.2
  (make-instance 'foo :a 1 :b 2)
  (foo :a 1 :b 2))

(defclass make-instance-class-02 ()
  (a b c))

(defmethod make-instance ((class (eql (find-class 'make-instance-class-02)))
			  &rest initargs &key (x nil) (y nil) (z nil)
			  &allow-other-keys)
  (declare (ignore initargs))
  (let ((obj (allocate-instance class)))
    (setf (slot-value obj 'a) x
	  (slot-value obj 'b) y
	  (slot-value obj 'c) z)
    obj))

(deftest make-instance.3
  (let ((obj (make-instance 'make-instance-class-02)))
    (values
     (eqt (class-of obj) (find-class 'make-instance-class-02))
     (slot-value obj 'a)
     (slot-value obj 'b)
     (slot-value obj 'c)))
  t nil nil nil)

(deftest make-instance.4
  (let ((obj (make-instance 'make-instance-class-02 :z 10 :y 45 :x 'd)))
    (values
     (eqt (class-of obj) (find-class 'make-instance-class-02))
     (slot-value obj 'a)
     (slot-value obj 'b)
     (slot-value obj 'c)))
  t d 45 10)


(deftest make-instance.5
  (let ((obj (make-instance (find-class 'make-instance-class-02) :y 'g)))
    (values
     (eqt (class-of obj) (find-class 'make-instance-class-02))
     (slot-value obj 'a)
     (slot-value obj 'b)
     (slot-value obj 'c)))
  t nil g nil)

(deftest make-instance.6
  (eq (make-instance 'make-instance-class-02)
      (make-instance 'make-instance-class-02))
  nil)

;;; Order of argument evaluation

(deftest make-instance.order.1
  (let* ((i 0) x y
	 (obj (make-instance 'make-instance-class-01
			     :a (setf x (incf i))
			     :b (setf y (incf i)))))
    (values
     (map-slot-value obj '(a b))
     i x y))
  (1 2) 2 1 2)

(deftest make-instance.order.2
  (let* ((i 0) x y z w
	 (obj (make-instance 'make-instance-class-01
			     :a (setf x (incf i))
			     :b (setf y (incf i))
			     :b (setf z (incf i))
			     :a (setf w (incf i)))))
    (values
     (map-slot-value obj '(a b))
     i x y z w))
  (1 2) 4 1 2 3 4)

(deftest make-instance.order.3
  (let* ((i 0) u x y z w
	 (obj (make-instance (prog1 'make-instance-class-01
				    (setf u (incf i)))
			     :a (setf x (incf i))
			     :b (setf y (incf i))
			     :b (setf z (incf i))
			     :a (setf w (incf i)))))
    (values
     (map-slot-value obj '(a b))
     i u x y z w))
  (2 3) 5 1 2 3 4 5)