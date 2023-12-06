(ns advent.day6 
  (:require
    [advent.utils :as utils]
    [clojure.string :as str]))

(defn find-start ([message] (find-start message 0))
  ([message index]

    (let [one (first message)
          two (second message)
          three (nth message 2)
          four (nth message 3)]
      (if (not (or (= one two) (= one three) (= one four)
              (= two three) (= two four)
              (= three four))) (+ 4 index) (recur (drop 1 message) (inc index))
      )
    )
  )
)

(defn star1 []
  (let [input (utils/get-input-as-str "day6")]
    (find-start input)
    )
  )

(defn check-window [window] 
    (cond
      (empty? window) false
      (= 1 (count window)) false
      (not (nil? (clojure.string/index-of (rest window) (first window)))) true
      :else (recur (rest window))
  )
    )

(defn contains-duplicate? [window] 
    (cond
      (empty? window) false
      (= 1 (count window)) false
      (not (nil? (clojure.string/index-of (subs window 1) (first window)))) true
      :else (recur (subs window 1))
    )
)

(defn find-start-message ([message] (find-start-message message 0))
  ([message index]

    (let [window (subs message 0 14)
          dup? (contains-duplicate? window)]
        ; (println "window: " window)
        ; (println "duplicate?: " dup?)
        (if dup? 
          (recur (subs message 1) (inc index))
          (+ 14 index))
    )
  )
)

(str/index-of (subs "mgbljsphdztnvjfqwrcgsmlb" 0 14) \q)
(find-start-message "bvwbjplbgvbhsrlpgdmjqwftvncz")

(def message "cdefgd")
(first message)
(rest message)
(duplicate?  message)

(defn star2 []
  (let [input (utils/get-input-as-str "day6")]
    (find-start-message input)
    )
  )
