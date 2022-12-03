(ns advent.utils)

(defn get-input-as-str [file] 
  (slurp 
    (clojure.core/str "inputs/" file ".txt")
  )
)
