(ros::load-ros-manifest "hrpsys_gazebo_atlas")
(ros::roseus "atlas-joint-state-compresser")
(load "package://hrpsys_gazebo_atlas/euslisp/atlas-joint-state-compresser-settings.l")
(setq js-topic-name "/atlas/joint_states")
(setq js-compressed-topic-name "/atlas/joint_states_compressed")


(defun get-joint-index (joint-name)
  (cdr (assoc joint-name joint-index-list :key #'car :test #'string=))
)

(defun compress-callback (msg)
  (let ((js-compressed (instance hrpsys_gazebo_atlas::JointStateCompressed :init))
	joint-indexes joint-index joint-angles joint-name
	)
    (setq hoge msg)
    (send js-compressed :header (send msg :header))
    (dotimes (i (length (send msg :name)))
      (setq joint-index (get-joint-index (elt (send msg :name) i)))
      (when joint-index
	(push joint-index joint-indexes)
	(push (elt (send msg :position) i) joint-angles)
	)
      )
    (send js-compressed :index (coerce joint-indexes string))
    (send js-compressed :position (coerce joint-angles float-vector))
    (ros::publish js-compressed-topic-name js-compressed)
    (print "published")
    )
  )

(defun main
  ()
  (joint-index-init)
  (ros::subscribe js-topic-name
		  sensor_msgs::JointState #'compress-callback)
  (ros::advertise js-compressed-topic-name hrpsys_gazebo_atlas::JointStateCompressed 1)

  (ros::rate 10)
  (do-until-key
   (print "loop")
   (ros::spin-once)
   (ros::sleep)
   (unless (ros::ok) (return)))
  )

(main)


