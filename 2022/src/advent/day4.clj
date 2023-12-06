(ns advent.day4 
  (:require
    [advent.utils :as utils])
  (:require
    [clojure.string :as str])
  )

(defn split-range [r] 
  (let [s (str/split r #"-")]
    (map read-string s)
    )
)
(split-range "2-4")

(defn in-range? [r1 r2]
  (let [min1 (first r1)
        max1 (second r1)
        min2 (first r2)
        max2 (second r2)]
    (or 
      (and (<= min1 min2) (>= max1 max2))
      (and (<= min2 min1) (>= max2 max1))
    )
  )
)
(defn check-contains [group]
  (let [assign1 (split-range (first group))
        assign2 (split-range (second group))
        ]
    (if 
      (in-range? assign1 assign2)
      1 0
  )
  )
  )
(map check-contains (list
                   (list "2-4" "6-8")
                   (list "2-3" "4-5")
                   (list "5-7" "7-9")
                   (list "2-8" "3-7")
                   (list "6-6" "4-6")
                   (list "2-6" "4-8")
                 )
               )

(defn star1 [] 
  (let [input (utils/get-input-as-str "day4")
        ]
    (->> input 
         (str/split-lines)
         (map #(str/split % #","))
         (map check-contains)
         (reduce +)
    )
  )
)

(defn overlaps? [r1 r2]
  (let [min1 (first r1)
        max1 (second r1)
        min2 (first r2)
        max2 (second r2)]
    (or 
      (<= min1 min2 max1)
      (<= min2 min1 max2)
      (<= min1 max2 max1)
      (<= min2 max1 max2)
    )
  )
)

(defn check-overlap [group]
  (let [assign1 (split-range (first group))
        assign2 (split-range (second group))
        ]
    (if 
      (overlaps? assign1 assign2)
      1 0
  )
  )
  )

(<= 2 9 7)
(map check-overlap (list
                   (list "2-4" "6-8")
                   (list "2-3" "4-5")
                   (list "5-7" "7-9")
                   (list "2-8" "3-7")
                   (list "6-6" "4-6")
                   (list "2-6" "4-8")
                 )
               )

(defn star2 [] 
  (let [input (utils/get-input-as-str "day4")
        ]
    (->> input 
         (str/split-lines)
         (map #(str/split % #","))
         (map check-overlap)
         (reduce +)
    )
  )
)
