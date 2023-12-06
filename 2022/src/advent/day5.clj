(ns advent.day5 
  (:require
    [advent.utils :as utils]
    [clojure.string :as str]))

;    [P]                 [Q]     [T]
;[F] [N]             [P] [L]     [M]
;[H] [T] [H]         [M] [H]     [Z]
;[M] [C] [P]     [Q] [R] [C]     [J]
;[T] [J] [M] [F] [L] [G] [R]     [Q]
;[V] [G] [D] [V] [G] [D] [N] [W] [L]
;[L] [Q] [S] [B] [H] [B] [M] [L] [D]
;[D] [H] [R] [L] [N] [W] [G] [C] [R]
; 1   2   3   4   5   6   7   8   9 

(def start
  (sorted-map 
    1 (reverse (list \D \L \V \T \M \H \F))
    2 (reverse (list \H \Q \G \J \C \T \N \P))
    3 (reverse (list \R \S \D \M \P \H))
    4 (reverse (list \L \B \V \F))
    5 (reverse (list \N \H \G \L \Q))
    6 (reverse (list \W \B \D \G \R \M \P))
    7 (reverse (list \G \M \N \R \C \H \L \Q))
    8 (reverse (list \C \L \W))
    9 (reverse (list \R \D \L \Q \J \Z \M \T))
    )
  )

(defn move-item [from to c] 
  (let [item (first from)]
  (if (> c 0) (recur (drop 1 from) (cons item to) (dec c)) (list from to)
                        )))

(defn handle-move [state move] 
  (let [c (first move)
        from (second move)
        to (nth move 2)
        updated (move-item (get state from) (get state to) c)
        ]
      (merge state (hash-map from (first updated) to (second updated)))
      
    )
  )
(str/join (map #(first (second %)) start))

(defn star1 [] 
  (let [input (utils/get-input-as-str "day5")]
    (->> input 
         (str/split-lines)
         (map #(re-seq #"\d+" %))
         (map #(map read-string %))
         (reduce handle-move start)
         (map #(first (second %)))
         (str/join)
         )
    )
  )

(defn move-group [from to c]
  (list (drop c from) (concat (take c from ) to)))


(defn handle-group-move [state move] 
  (let [c (first move)
        from (second move)
        to (nth move 2)
        updated (move-group (get state from) (get state to) c)
        ]
      (merge state (hash-map from (first updated) to (second updated)))
      
    )
  )

(defn star2 [] 
  (let [input (utils/get-input-as-str "day5")]
    (->> input 
         (str/split-lines)
         (map #(re-seq #"\d+" %))
         (map #(map read-string %))
         (reduce handle-group-move start)
         (map #(first (second %)))
         (str/join)
         )
    )
  )
