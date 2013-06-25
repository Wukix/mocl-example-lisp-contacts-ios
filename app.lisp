;;;; -*- coding:utf-8 -*-
#-mocl (declaim (declaration call-in))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :vectometry)
  ;; (pushnew :drakma-no-ssl *features*)
  ;; (require :drakma)
  )
(eval-when (:compile-toplevel :load-toplevel :execute)
  (use-package '(:vectometry)))

(eval-when (:compile-toplevel :load-toplevel :execute) 
  (defun & (&rest strings)
    (apply #'concatenate 'string strings)))

(defun string-to-file (string filespec)
  (with-open-file (f filespec :direction :output :if-exists :supersede :if-does-not-exist :create)
    (write-sequence string f)))

(defun file-to-string (filespec)
  (with-open-file (f filespec)
    ;; In case the file contains multi-byte characters, we merely use file-length 
    ;; as an upper bound and then downsize to the actual character count
    (let* ((str (make-array (file-length f) :element-type 'character :adjustable t))
	   (character-length (read-sequence str f)))
      (adjust-array str character-length)
      str)))

(defstruct contact (name "") (mobile "") (email ""))

(defparameter *contacts* nil)
(defparameter *width* 640)
(defparameter *height* 640)
(defparameter *scroll-height* 0)
(defparameter *gray* (rgb-color 0.6 0.6 0.6))
(defparameter *light-gray* (rgb-color 0.8 0.8 0.8))
(defparameter *dark-gray* (rgb-color 0.3 0.3 0.3))
(defparameter *blue* (rgb-color 0.3 0.3 1.0))
(defparameter *doc-dir* nil)
(defparameter *temp-dir* nil)
(defparameter *font* nil)
(defparameter *font-path* nil)
(defparameter *current-contact* nil)

(defconstant +contact-height-px+ 50)
(defconstant +2x-contact-height-px+ 100)

#+mocl (setf vecto::*write-png-function* #'rt::write-png)

(declaim (call-in set-font-path))
(defun set-font-path (dirname)
  (setf *font-path* (truename dirname)))

(declaim (call-in set-temp-dir))
(defun set-temp-dir (dirname)
  (setf *temp-dir* (truename dirname)))

(declaim (call-in set-doc-dir))
(defun set-doc-dir (dirname)
  (setf *doc-dir* (truename dirname)))

(declaim (call-in set-view-dimensions))
(defun set-view-dimensions (width height)
  (setf *width* width
        *height* height))

(declaim (call-in handle-list-tap :result boolean))
(defun handle-list-tap (y)
  (let* ((contact-index (max 0 (1- (ceiling y #+android +2x-contact-height-px+ 
                                            #-android +contact-height-px+)))))
    (setf *current-contact* (when (< contact-index (length *contacts*))
                              (elt *contacts* contact-index)))))

(declaim (call-in draw-contact-item))
(defun draw-contact-item ()
  (let* ((height 640)
	 (file (merge-pathnames *temp-dir* "contact@2x.png")))
    (with-canvas (:width *width* :height height :close-font-loaders nil)
      (set-font *font* 40)
      (set-fill-color *white*)
      (clear-canvas)
      (set-stroke-color *light-gray*)
      (set-line-width 2)
      (rounded-rectangle (box 25 (- height 525) (- *width* 25) (- height 25)) 10 10)
      (stroke)
      (set-fill-color *dark-gray*)
      (vecto:draw-string-fast 50 (- height 80) (contact-name *current-contact*))
      (set-fill-color *blue*)
      (vecto:draw-string-fast 50 (- height 140) (contact-mobile *current-contact*))
      (vecto:draw-string-fast 50 (- height 200) (contact-email *current-contact*))
      (save-png file))
    (namestring file)))

(defmacro def-contact-getters (&body body)
  "Generates something like: 
'(progn
  (declaim (call-in get-contact-name))
  (declaim (call-in get-contact-mobile))
  ...
  (defun get-contact-name () 
    (contact-name *current-contact*))
  (defun get-contact-mobile () 
    (contact-mobile *current-contact*))
  ...)"
  `(progn
     ,@(loop for name in body collect 
	    `(declaim (call-in ,(intern (& "GET-" (string name))))))
     ,@(loop for name in body collect 
	    `(defun ,(intern (& "GET-" (string name))) ()
	       (,name *current-contact*)))))

(def-contact-getters 
  contact-name
  contact-mobile
  contact-email)

(declaim (call-in load-contacts))
(defun load-contacts ()
  (let ((file (merge-pathnames *doc-dir* "contacts.lisp"))) 
    (setf *contacts* (if (probe-file file) 
			 (read-from-string (file-to-string file))
			 (list (make-contact :name "John Doe" 
					     :mobile "(555) 555-5555" 
					     :email "john@john.doe"))))))

(declaim (call-in save-contacts))
(defun save-contacts ()
  (when (and *current-contact* (not (member *current-contact* *contacts*)))
    (push *current-contact* *contacts*)
    (setf *contacts* (sort *contacts* #'string< :key #'contact-name)))
  (let ((file (merge-pathnames *doc-dir* "contacts.lisp")))
    (string-to-file (prin1-to-string *contacts*) file)))

(declaim (call-in add-new-contact))
(defun add-new-contact ()
  (let ((new-contact (make-contact)))
    (setf *current-contact* new-contact)))

(declaim (call-in update-contact))
(defun update-contact (name mobile email)
  (setf (contact-name *current-contact*) name
	(contact-mobile *current-contact*) mobile
	(contact-email *current-contact*) email))

(declaim (call-in delete-contact))
(defun delete-contact ()
  (setf *contacts* (delete *current-contact* *contacts*))
  (setf *current-contact* nil)
  (save-contacts))

(declaim (call-in is-new-contact :result boolean))
(defun is-new-contact ()
  (not (member *current-contact* *contacts*)))

(declaim (call-in draw-contact-list))
(defun draw-contact-list ()
  (let ((file (merge-pathnames *temp-dir* "list@2x.png"))) 
    (setf *scroll-height* (max 2 (* (length *contacts*) +2x-contact-height-px+)))
    (with-canvas (:width *width* :height *scroll-height* :close-font-loaders nil)
      ;; only load the font once, since it takes time (600ms on iphone 4) to load
      (unless *font*
        (setf *font* (get-font *font-path*)))
      (set-font *font* 40)
      (set-fill-color *white*)
      (clear-canvas)
      (set-fill-color *black*)
      (loop 
	 for contact in *contacts* 
	 for i upfrom 0
	 for y = (ith-entry-y i) do
	   (draw-horizontal-separator y)
	   (draw-contact-name y contact)
	   (draw-right-arrow y))
      (draw-horizontal-separator (ith-entry-y (length *contacts*)))
      (vecto::save-png file))
    (namestring file)))

(defun draw-contact-name (y contact)
  (vecto:draw-string-fast 10 (- y 65) (contact-name contact)))

(defun ith-entry-y (i)
  (- *scroll-height* (* i +2x-contact-height-px+)))

(defun draw-horizontal-separator (y)
  (set-line-width 1)
  (set-stroke-color *light-gray*)
  (move-to (point 0 y))
  (line-to (point *width* y))
  (stroke))

(defun draw-right-arrow (y)
  (set-stroke-color *gray*)
  (set-line-width 3)
  (move-to (point (- *width* 40) (- y 30)))
  (line-to (point (- *width* 20) (- y 50)))
  (line-to (point (- *width* 40) (- y 70)))
  (stroke))

;; (declaim (call-in net-test))
;; (defun net-test ()
;;   (print (drakma:http-request "http://wukix.com")))

#-(or ios android)
(defun test-app ()
  "This function can be used in another lisp like SBCL for testing."
  (set-font-path "/Library/Fonts/Arial.ttf")
  (set-temp-dir "/tmp/")
  (set-doc-dir "/tmp/")
  (load-contacts)
  (draw-contact-list))
