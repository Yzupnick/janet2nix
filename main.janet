(import spork/math)
(use sh)

(defn main [& args]
  ($ echo "hello")
  (print (math/factorial 3)))
