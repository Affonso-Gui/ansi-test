(in-package "LISP")

(defmethod ratio
 (:init (num denom)
  (setq numerator num
        denominator denom)
  self)