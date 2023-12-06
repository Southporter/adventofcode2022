(ns advent.utils)

(defn get-input-as-str [file] 
  (slurp 
    (clojure.core/str "inputs/" file ".txt")
  )
)

(defn split-groups 
  ([bags] (split-groups bags '()))
  ([bags groups] (split-groups bags 3 groups))
  ([bags group-size groups]
   (if (empty? bags) groups (recur (drop group-size bags) (cons (take group-size bags) groups) group-size)))

  )
