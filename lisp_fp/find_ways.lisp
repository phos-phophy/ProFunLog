;;; combine answers
(defun comb_ans (ans1 ans2)
    (cond 
        ((null ans1) ans2)
        ((null ans2) ans1)
        (T (RevAppend ans1 ans2))
    )
)

;;; check whether this town has been visited
(defun check_visit (town visited)
    (cond 
        ((null visited) NIL)
        ((eq town (caar visited)) T)
        (T (check_visit town (cdr visited)))
    )
)

;;; return list of towns that can be visited from 'from'
(defun where (graph from) (_where graph from NIL))
(defun _where (graph from acc)
    (cond 
        ((null graph) acc)
        ((eq from (caar graph)) (_where (cdr graph) from (cons (cdar graph) acc))) 
        ((eq from (cadar graph)) (_where (cdr graph) from (cons (cons (caar graph) (cddar graph)) acc)))
        (T (_where (cdr graph) from acc))
    )
)

;;; increase count if road type has changed     
(defun update (next cur_type count)
    (cond 
        ((eq (cadr next) cur_type) count) 
        (T (+ 1 count))
    )
)
        
;;; return list of the suitable ways ( ((...) count length) (...) ...) 
(defun find_ways (graph from to visited cur_type count length) 
    (cond 
        ((eq from to) (cons (list visited count length) NIL))
        (T (_find_ways graph from to visited cur_type count length (where graph from)))
    )
)
(defun _find_ways (graph from to visited cur_type count length next) 
    (cond 
        ((null next) NIL)
        ((not (check_visit (caar next) visited)) 
         (comb_ans (_find_ways graph from to visited cur_type count length (cdr next)) 
                   (find_ways graph (caar next) to (cons (car next) visited) (cadar next) 
                              (update (car next) cur_type count) (+ (caddar next) length))))
        (T (_find_ways graph from to visited cur_type count length (cdr next)))
    )
)

;;; find the min value in 'ways'
(defun my_min (ways min_v extract) 
    (cond 
        ((null ways) min_v)
        ((null min_v) (my_min (cdr ways)  (funcall extract (car ways)) extract))
        ((<  (funcall extract (car ways)) min_v) (my_min (cdr ways)  (funcall extract (car ways)) extract))
        (T (my_min (cdr ways) min_v extract))
    )
)

;;; select such ways from 'ways' that match the condition
(defun select (ways num condition extract) (_select ways num condition extract NIL))
(defun _select (ways num condition extract acc) 
    (cond 
        ((null ways) acc)
        ((funcall condition num (funcall extract (car ways))) (_select (cdr ways) num condition extract (cons (car ways) acc)))
        (T (_select (cdr ways) num condition extract acc))
    )
)
        
;;; select such ways that contain this town
(defun select2 (ways town) (_select2 ways town NIL))   
(defun _select2 (ways town acc) 
    (cond 
        ((null town) ways) ; if town is not defined all ways are returned
        ((null ways) acc) 
        ((check_visit town (caar ways)) (_select2 (cdr ways) town (cons (car ways) acc)))
        (T (_select2 (cdr ways) town acc))
    )
)

;;; ascending sort by extracted value
(defun asc_sort (ways extract) 
    (cond 
        ((null ways) NIL)
        (T (append (asc_sort (select ways (funcall extract (car ways)) '> extract) extract) 
                   (select ways (funcall extract (car ways)) 'eq extract)
                   (asc_sort (select ways (funcall extract (car ways)) '< extract) extract)))
    )
)

;;; print result
(defun print_res (ways)
    (let ((min_len (my_min ways NIL 'caddr))) 
        (print ways) ; all ways from 'from' to 'to'
        (terpri)
        (print (asc_sort (select ways min_len 'eq 'caddr) 'cadr)) ; all ways with min length sorted by num of type changes
        (terpri)
        (let ((suit_ways (select ways (* min_len 1.5) '>= 'caddr))) ; all ways with {length <= 1.5 * min_len} and min num of type changes + sorted by length
            (print (asc_sort (select suit_ways (my_min suit_ways NIL 'cadr) 'eq 'cadr) 'caddr )))))

(defun main (graph from to btw) (print_res (select2 (find_ways graph from to (cons (list from NIL 0) NIL) NIL -1 0) btw)))

(main (read) (read) (read) (read))
