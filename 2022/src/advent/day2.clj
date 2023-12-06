(ns advent.day2
  (:require [clojure.string :as str])
  (:require [advent.utils :as utils])
)

(def input (utils/get-input-as-str "day2"))
(def games (map #(str/split % " ") (str/split input #"\n")))
(defn win? [l r] (cond
               (= l r) 0
               (or (and (= r 1) (= l 3)) (and (= r 2) (= l 1)) (and (= r 3) (= l 2))) 1
               :else -1

                  ))

(defn score [l r] 
  (let [l-score (case l
                  "A" 1
                  "B" 2
                  "C" 3
                  )
        r-score (case r
                  "X" 1
                  "Y" 2
                  "Z" 3
                  )
        w (win? l-score r-score)
        ]
    (cond
      (= w -1) r-score
      (= w 0) (+ r-score 3)
      (= w 1) (+ r-score 6)
      )
    )
)

(win? 1 1)
(= (score "A" "X") 4)
(= (score "A" "Z") 3)
(= (score "C" "Y") 2)



(defn star1 [] 
  (let [input (utils/get-input-as-str "day2")
        games (map #(str/split % #" ") (str/split input #"\n"))]
    (apply + (map #(apply score %) games))
  )
)

(defn score-2 [l r] 
  (case r
    "X" (case l ; We want to lose
          "A" 3
          "B" 1
          "C" 2)
    "Y" (case l
          "A" (+ 1 3)
          "B" (+ 2 3)
          "C" (+ 3 3)
          )
    "Z" (case l
          "A" (+ 2 6)
          "B" (+ 3 6)
          "C" (+ 1 6)
          )
    )
)
(score-2 "C" "Z")

(defn star2 [] 
  (let [input (utils/get-input-as-str "day2")
        games (map #(str/split % #" ") (str/split input #"\n"))]
    (apply + (map #(apply score-2 %) games))
  )
)
