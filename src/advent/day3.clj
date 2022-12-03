(ns advent.day3
  (:require [advent.utils :as utils])
  ; (:require [clojure.core.async :as a])
  (:require [clojure.string :as str])
  )

(defn split-bag [bag] 
  (let [middle (/ (.length bag) 2)
        compartment1 (subs bag 0 middle)
        compartment2 (subs bag middle)
        ]
    (list compartment1 compartment2)
    )
  )

(defn find-dup
  ([bag] (find-dup bag 0))
  ([bag index]
    (let [c (nth (first bag) index)]
      (if (and (not (str/index-of (second bag) c)) (< index (.length (second bag))))
        (recur bag (inc index))
        c
    )
   )
  )
)


(def val-a (- (int \a) 1))

(find-dup (split-bag "abcdefgb"))
(defn get-value [c] 
  (let [isUpper (Character/isUpperCase c)
        value (- (int (Character/toLowerCase c)) val-a)]
       (if isUpper (+ value 26) value)
    )
  )

(defn star1 [] 
  (let [input (utils/get-input-as-str "day3")
        bags (map split-bag (str/split-lines input))]
    (reduce + (map get-value (map find-dup bags)))
    )
)

(defn find-badge 
  ([bags] (find-badge bags 0))
  ([bags index]
  (let [c (nth (first bags) index)
        s (second bags)
        t (nth bags 2)]
      (if (and (str/index-of s c) (str/index-of t c))
        c
        (recur bags (inc index))
    )

   )

  )
)


(def bags (str/split-lines (utils/get-input-as-str "day3")))

(defn split-groups 
  ([bags] (split-groups bags '()))
  ([bags groups] (if (empty? bags) groups (recur (drop 3 bags) (cons (take 3 bags) groups))))


  )

(if (empty? bags) 1 2)
(def groups (split-groups '("vJrwpWtwJgWrhcsFMMfFFhFp"
"jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
"PmmdzqPrVvPwwTWBwg"
                 "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"
"ttgJtRGJQctTZtZT"
"CrZsJsPPZsGzwwsLwLmpwMDw"
))
)
(map find-badge groups)

(defn star2 []
  (let [input (utils/get-input-as-str "day3")
        groups (split-groups (str/split-lines input))]
     (reduce + (map get-value (map find-badge groups)))
    )
  )
