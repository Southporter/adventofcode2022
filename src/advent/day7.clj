(ns advent.day7
  (:require [clojure.string :as str]
            [advent.utils :as utils])
  )

(def test-input "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k")

(defn parse-line [line]
  (let [parts (str/split line #" ")]
    (cond 
      (and (= \$ (first line)) (= (second parts) "cd")) (list :cd (nth parts 2))
      (and (= \$ (first line)) (= (second parts) "ls")) (list :ls)
      (= \$ (first line)) (list :command (rest parts))
      (= "dir" (first parts)) (list :directory (second parts))
      :else (list :file (read-string (first parts)) (second parts))
      )
    )
  )

(parse-line "$ cd /")
(parse-line "$ ls")
(parse-line "dir d")
(parse-line "4060174 j")
(defn file-name [file] (str/join "::" (list "file" file)))

(defn reduce-line [state line]
  (case (first line)
    :cd (merge state (case (second line)
                      ".." {:cwd (rest (get state :cwd))}
                      {:cwd (cons (second line) (get state :cwd))}
                     )
         )
    :file (merge state (let [currentdir (first (get state :cwd))
                              filename (file-name (nth line 2))]
                          {currentdir (cons filename (get state currentdir))
                           filename (second line)
                           }
                          )
             )
    :directory (merge state (let [currentdir (first (get state :cwd))
                            dirname (second line)]
                        { currentdir (cons dirname (get state currentdir))}
                        ))
    state
    )
  )


(def base-state (hash-map :cwd '("/")))
(reduce-line base-state '(:cd "a"))
(reduce-line base-state '(:file 111 "a"))
(reduce-line base-state '(:dir "b"))
(def result (->> test-input
     (str/split-lines)
     (map parse-line)
     (reduce reduce-line (hash-map))
     )
  )


(defn sum-dir [state sum contents]
  ; (println "sum-dir" contents sum (get state (first contents)))
  ; (println "list? " (seq? (get state (first contents))))
  (cond
    (empty? contents) sum 
    (seq? (get state (first contents)))
      (do
        ; (println "got a list")
        (recur state sum (get state (first contents)))
        )
    :else 
    (do
      ; (println "got a terminal" (rest contents) (get state (first contents)))
      (recur state (+ sum (get state (first contents))) (rest contents))
      )
    )
  )
(sum-dir result 0 '("a"))
(defn get-sizes [state] 
  (->> state
       (#(dissoc % :cwd))
       (keys)
       (filter #(seq? (get state %)))
       (map #(sum-dir state 0 (list %)))
       )
  )
(get-sizes result)
(dissoc result :cwd)
(filter #(seq? (get result %)) (keys result))

; DOES NOT WORK
; Had to switch to python for star1
(defn star1 [] 
  (->> (utils/get-input-as-str "day7")
    (str/split-lines)
    (map parse-line)
    ((fn [state] (println "Parsed lines. Reducing...") state))
    (reduce reduce-line (hash-map))
    ((fn [state] (println state) state))
    (get-sizes)
    ((fn [state] (println state) state))
    (filter #(<= % 100000))
    ((fn [state] (println state) state))
    (reduce +)
    )
  )

(defn star2 []
  (->> (utils/get-input-as-str "day7")
    (str/split-lines)
    (map parse-line)
    ((fn [state] (println "Parsed lines. Reducing...") state))
    (reduce reduce-line (hash-map))
    ((fn [state] (println state) state))
    (get-sizes)
    ((fn [state] (println state) state))
    (filter #(>= % 30000000))
    ((fn [state] (println state) state))
    (min)
    )
  )

