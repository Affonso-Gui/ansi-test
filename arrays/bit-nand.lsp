;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sun Jan 26 19:16:15 2003
;;;; Contains: Tests for BIT-NAND





 ;; (deftest bit-nand.1
;;   (let* ((s1 (make-array nil :initial-element 0 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 0 :element-type 'bit)))
;;     (values (bit-nand s1 s2) s1 s2))
;;   #0a1
;;   #0a0
;;   #0a0)
(defskip bit-nand.1 "zero-length array")

 ;; (deftest bit-nand.2
;;   (let* ((s1 (make-array nil :initial-element 1 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 0 :element-type 'bit)))
;;     (values (bit-nand s1 s2) s1 s2))
;;   #0a1
;;   #0a1
;;   #0a0)
(defskip bit-nand.2 "zero-length array")

;; (deftest bit-nand.3
;;   (let* ((s1 (make-array nil :initial-element 0 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 1 :element-type 'bit)))
;;     (values (bit-nand s1 s2) s1 s2))
;;   #0a1
;;   #0a0
;;   #0a1)
(defskip bit-nand.3 "zero-length array")

;; (deftest bit-nand.4
;;   (let* ((s1 (make-array nil :initial-element 1 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 1 :element-type 'bit)))
;;     (values (bit-nand s1 s2) s1 s2))
;;   #0a0
;;   #0a1
;;   #0a1)
(defskip bit-nand.4 "zero-length array")

;; (deftest bit-nand.5
;;   (let* ((s1 (make-array nil :initial-element 0 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 0 :element-type 'bit))
;;          (s3 (make-array nil :initial-element 0 :element-type 'bit))
;;          (result (bit-nand s1 s2 s3)))
;;     (values s1 s2 s3 result (eqt s3 result)))
;;   #0a0
;;   #0a0
;;   #0a1
;;   #0a1
;;   t)
(defskip bit-nand.5 "zero-length array")

;; (deftest bit-nand.6
;;   (let* ((s1 (make-array nil :initial-element 1 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 1 :element-type 'bit))
;;          (s3 (make-array nil :initial-element 1 :element-type 'bit))
;;          (result (bit-nand s1 s2 s3)))
;;     (values s1 s2 s3 result (eqt s3 result)))
;;   #0a1
;;   #0a1
;;   #0a0
;;   #0a0
;;   t)
(defskip bit-nand.6 "zero-length array")

;; (deftest bit-nand.7
;;   (let* ((s1 (make-array nil :initial-element 1 :element-type 'bit))
;;          (s2 (make-array nil :initial-element 0 :element-type 'bit))
;;          (result (bit-nand s1 s2 t)))
;;     (values s1 s2 result (eqt s1 result)))
;;   #0a1
;;   #0a0
;;   #0a1
;;   t)
(defskip bit-nand.7 "zero-length array")


;;; Tests on bit vectors

(deftest bit-nand.8
  (let ((a1 (copy-seq #*0011))
        (a2 (copy-seq #*0101)))
    (values (check-values (bit-nand a1 a2)) a1 a2))
  #*1110 #*0011 #*0101)

(deftest bit-nand.9
  (let* ((a1 (copy-seq #*0011))
         (a2 (copy-seq #*0101))
         (result (check-values (bit-nand a1 a2 t))))
    (values result a1 a2 (eqt result a1)))
  #*1110 #*1110 #*0101 t)

(deftest bit-nand.10
  (let* ((a1 (copy-seq #*0011))
         (a2 (copy-seq #*0101))
         (a3 (copy-seq #*1110))
         (result (check-values (bit-nand a1 a2 a3))))
    (values result a1 a2 a3 (eqt result a3)))
  #*1110 #*0011 #*0101 #*1110 t)

(deftest bit-nand.11
  (let ((a1 (copy-seq #*0011))
        (a2 (copy-seq #*0101)))
    (values (check-values (bit-nand a1 a2 nil)) a1 a2))
  #*1110 #*0011 #*0101)

;;; Tests on bit arrays

(deftest bit-nand.12
  (let* ((a1 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 1)(0 1))))
         (a2 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(1 1))))
         (result (bit-nand a1 a2)))
    (values a1 a2 result))
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.13
  (let* ((a1 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 1)(0 1))))
         (a2 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(1 1))))
         (result (bit-nand a1 a2 t)))
    (values a1 a2 result))
  #2a((1 1)(1 0))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.14
  (let* ((a1 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 1)(0 1))))
         (a2 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(1 1))))
         (result (bit-nand a1 a2 nil)))
    (values a1 a2 result))
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.15
  (let* ((a1 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 1)(0 1))))
         (a2 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(1 1))))
         (a3 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(0 0))))
         (result (bit-nand a1 a2 a3)))
    (values a1 a2 a3 result))
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0))
  #2a((1 1)(1 0)))

;;; Adjustable arrays

(deftest bit-nand.16
  (let* ((a1 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 1)(0 1))
                         :adjustable t))
         (a2 (make-array '(2 2) :element-type 'bit
                         :initial-contents '((0 0)(1 1))
                         :adjustable t))
         (result (bit-nand a1 a2)))
    (values a1 a2 result))
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

;;; Displaced arrays

(deftest bit-nand.17
  (let* ((a0 (make-array '(8) :element-type 'bit
                         :initial-contents '(0 1 0 1 0 0 1 1)))
         (a1 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 0))
         (a2 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 4))
         (result (bit-nand a1 a2)))
    (values a0 a1 a2 result))
  #*01010011
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.18
  (let* ((a0 (make-array '(8) :element-type 'bit
                         :initial-contents '(0 1 0 1 0 0 1 1)))
         (a1 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 0))
         (a2 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 4))
         (result (bit-nand a1 a2 t)))
    (values a0 a1 a2 result))
  #*11100011
  #2a((1 1)(1 0))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.19
  (let* ((a0 (make-array '(12) :element-type 'bit
                         :initial-contents '(0 1 0 1 0 0 1 1 1 1 1 0)))
         (a1 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 0))
         (a2 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 4))
         (a3 (make-array '(2 2) :element-type 'bit
                         :displaced-to a0
                         :displaced-index-offset 8))
         (result (bit-nand a1 a2 a3)))
    (values a0 a1 a2 result))
  #*010100111110
  #2a((0 1)(0 1))
  #2a((0 0)(1 1))
  #2a((1 1)(1 0)))

(deftest bit-nand.20
  (macrolet ((%m (z) z)) (bit-nand (expand-in-current-env (%m #*0011)) #*0101))
  #*1110)

(deftest bit-nand.21
  (macrolet ((%m (z) z)) (bit-nand #*1010 (expand-in-current-env (%m #*1100))))
  #*0111)

(deftest bit-nand.22
  (macrolet ((%m (z) z)) (bit-nand #*10100011 #*01101010
                                   (expand-in-current-env (%m nil))))
  #*11011101)

(deftest bit-nand.order.1
  (let* ((s1 (make-array 1 :initial-element 0 :element-type 'bit))
         (s2 (make-array 1 :initial-element 0 :element-type 'bit))
         (x 0) y z)
    (values
     (bit-nand (progn (setf y (incf x)) s1)
               (progn (setf z (incf x)) s2))
     x y z))
  #*1 2 1 2)

(def-fold-test bit-nand.fold.1 (bit-nand #*00101 #*10100))

;;; Random tests

(deftest bit-nand.random.1
  (bit-random-test-fn #'bit-nand #'lognand)
  nil)

;;; Error tests

(deftest bit-nand.error.1
  (signals-error (bit-nand) program-error)
  t)

(deftest bit-nand.error.2
  (signals-error (bit-nand #*000) program-error)
  t)

(deftest bit-nand.error.3
  (signals-error (bit-nand #*000 #*0100 nil nil)
                 program-error)
  t)
