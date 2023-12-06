(ns advent.day1
  (:require [clojure.string :as str])
  (:require [clojure.edn :as edn])
  (:require [advent.utils :as utils])
)


(defn count-calories [elf] 
  (reduce + 
          (map edn/read-string 
               (clojure.string/split elf #"\n"))))

(defn part1 [] 
  (let 
    [input (utils/get-input-as-str "day1")]
    (apply max (map count-calories (clojure.string/split input #"\n\n")
    ))))

(def calories (map count-calories (str/split (utils/get-input-as-str "day1") #"\n\n")))
(println calories)
(def max-calories (apply clojure.core/max calories))
(println max-calories)

(defn max-n [n remaining & maxs] 
  (let [m (apply max remaining)
        r (filter #(< % m) remaining)]
    (if (> n 0) (recur (- n 1) r (cons m maxs)) maxs)
    ))


(> 2 -1)
(def l '(1 2 3 4 10 5 6 7))
(def m (apply max l))
(filter #(< % m) l)
(max-n 2 l)

(defn part2 [] 
  (apply + (max-n 3 calories)))
