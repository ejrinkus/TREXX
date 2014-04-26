#lang racket

;;; Modified by Behnam Litkouhi
;;; GENERAL GAME DOCUMENTATION IN README.TXT
(require rackunit)

; Procedure to run all tests
(define (TEST-Homework3)
  (TEST-inventory)
  (TEST-bp)
  (TEST-change-items)
  )

(provide define-verbs
         define-thing
         define-place
         define-everywhere
         
         show-current-place
         show-inventory
         save-game
         load-game
         show-help

         have-thing?
         take-thing!
         drop-thing!
         thing-state
         set-thing-state!
         
         ;; ADDITIONS
         item-count
         item-limit
         item-count-inc!
         item-count-dec!
         inventory-full?
         
         bp
         show-bp
         have-thing-bp?
         pack-thing!
         unpack-thing!
         bp-item-count
         bp-item-limit
         bp-item-count-inc!
         bp-item-count-dec!
         bp-full?
         
         brain-level
         brain-check
         
         teleport-check
         
         build-place-list
         place-list
         random-element
         
         brain-defeat
         winter-defeat
         winter-victory
         fisher-victory
         
         trade-items
         thing-name
         
         helped-programmer?
         help-programmer!
         helped-grad?
         help-grad!
         get-rid-of
          
         (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin]))

;; ADDITIONS

;;; Inventory limit
(define item-count 0)

(define item-limit 4)

(define (item-count-inc!)
  (set! item-count (+ item-count 1)))

(define (item-count-dec!)
  (set! item-count (- item-count 1)))

(define (inventory-full?)
  (if (>= item-count item-limit)
      #t
      #f))

(define (TEST-inventory)
  (test-case
   "Inventory limit test cases"
   (item-count-inc!)
   (check-equal? 1 item-count)
   (item-count-dec!)
   (check-equal? 0 item-count)
   (check-equal? #f (inventory-full?))
   (item-count-inc!)
   (item-count-inc!)
   (item-count-inc!)
   (item-count-inc!)
   (check-equal? #t (inventory-full?))
   (item-count-dec!)
   (check-equal? #f (inventory-full?))))

;;; Backpack

(define bp null)

(define (show-bp)
  (printf "The backpack contains")
  (if (null? bp)
      (printf " no items.")
      (for-each (lambda (thing)
                  (printf "\n  a ~a" (thing-name thing)))
                bp))
  (printf "\n"))

(define (have-thing-bp? t)
  (memq t bp))
(define (pack-thing! t) 
  (set-place-things! current-place (remq t (place-things current-place)))
  (set! bp (cons t bp))
  (bp-item-count-inc!)
  (set! stuff (remq t stuff))
  (item-count-dec!))
(define (unpack-thing! t) 
  (set-place-things! current-place (cons t (place-things current-place)))
  (set! bp (remq t bp))
  (bp-item-count-dec!))

(define bp-item-count 0)

(define bp-item-limit 5)

(define (bp-item-count-inc!)
  (set! bp-item-count (+ bp-item-count 1)))

(define (bp-item-count-dec!)
  (set! bp-item-count (- bp-item-count 1)))

(define (bp-full?)
  (if (>= bp-item-count bp-item-limit)
      #t
      #f))

(define (TEST-bp)
  (test-case
   "Backpack tests"
   (set! current-place (place "Test place" '() '()))
   (set! stuff '(snack wallet phone pillow shirt))
   (check-equal? #f (bp-full?))
   (check-equal? #f (have-thing-bp? 'snack))
   (pack-thing! 'snack)
   (pack-thing! 'wallet)
   (pack-thing! 'phone)
   (pack-thing! 'pillow)
   (pack-thing! 'shirt)
   (check-not-equal? #f (have-thing-bp? 'snack))
   (check-equal? #f (have-thing-bp? 'tortilla))
   (check-equal? #t (bp-full?))
   (unpack-thing! 'snack)
   (unpack-thing! 'wallet)
   (check-equal? #f (bp-full?))
   (unpack-thing! 'phone)
   (unpack-thing! 'pillow)
   (unpack-thing! 'shirt)
   (check-equal? #f (have-thing-bp? 'snack))))

;;; Brain-eating
(define brain-level 100)
(define (brain-check)
  (if (ormap (lambda (thing) (eq? (thing-name thing) 'zombie)) (place-things current-place))
      (begin
        (set! brain-level (- brain-level 50))
        (printf "The zombie grad student assails your brains.  ")
        (if (< brain-level 0)
            (brain-defeat)
            (printf "Brain health is at ~a.\n" brain-level)))
      (if (< brain-level 100)
            (begin
              (set! brain-level 100)
              (printf "Brain health at ~a.\n" brain-level))
            '())))

;;; Place change
(define (build-place-list base)
  (for-each (lambda (e) (if (place? (car e))
                            (set! place-list (cons (car e) place-list))
                            '())) base))

(define place-list '()) ; To be defined after places initialized in hash map

(define (random-element l)
  (list-ref l (random (length l))))

;;; Teleport
(define (teleport-check)
  (if (ormap (lambda (thing) (eq? (thing-name thing) 'professor)) (place-things current-place))
      (if (ormap (lambda (thing) (eq? (thing-name thing) 'research)) stuff)
          (printf "The demented professor's eyes fix greedily upon the research; he does not confuse you with his lecturing, and expresses interest in the research.\n")
          (begin
            (printf "The demented professor confuses you.  You are teleported to a different location.\n")
            (set! current-place (random-element place-list))
            (do-place)))
      '()))
   
;;; "Monster" movement
;; PLAN: For each monster in each place, take a random number between 0 and 3.  If value is 0, move monster to random location.
(define (move-monsters)
  (for-each (lambda (p) (for-each (lambda (t) (if (or (eq? (thing-name t) 'zombie) (eq? (thing-name t) 'professor))
                                                  (if (= 0 (random 4))
                                                      (move-monster t p)
                                                      '())
                                                  '())) (place-things p))) place-list))

(define (move-monster m p)
  (begin
    (set-place-things! p (remq m (place-things p)))
    (let ([n (random-element place-list)])
      (set-place-things! n (cons m (place-things n))))))
      
;;; Victory and Defeat
(define (brain-defeat)
  (printf "The zombie grad student eats your brains.  Game over!\n")
  (exit))
(define (winter-defeat)
  (printf "You go outside without a winter coat.  You freeze to death! Game over!\n")
  (exit))
(define (winter-victory)
  (printf "You go outside wearing a warm winter coat.  Victory!\n")
  (exit))
(define (fisher-victory)
  (printf "You enter Fisher Hall.  Victory!\n")
  (exit))

;;; General quest functions

;;;; Removes the 'give' item from inventory, places 'receive' item on the ground
(define(trade-items give receive)
  (begin
    (set! stuff (remq give stuff))
    (item-count-dec!)
    (set-place-things! current-place (cons receive (place-things current-place)))))

;;; Removes item from current place from the game
(define (get-rid-of t)
  (set-place-things! current-place (remq t (place-things current-place))))

(define (TEST-change-items)
  (test-case
   "Trade or get rid of items tests"
   (set! current-place (place "Test place" '() '()))
   (set! stuff '(snack wallet phone pillow shirt))
   (check-not-equal? #f (have-thing? 'wallet))
   (check-equal? #f (memq 'parcel (place-things current-place)))
   (trade-items 'wallet 'parcel)
   (check-equal? #f (have-thing? 'wallet))
   (check-not-equal? #f (memq 'parcel (place-things current-place)))
   (check-not-equal? #f (have-thing? 'snack))
   (drop-thing! 'snack)
   (check-not-equal? #f (memq 'snack (place-things current-place)))
   (get-rid-of 'snack)
   (check-equal? #f (memq 'snack (place-things current-place)))))

;;; Winter exit quest
(define helped-programmer? #f) ; Track whether traded yet with the programmer

(define (help-programmer!)
  (set! helped-programmer? #t))

;;; Fisher exit quest
(define helped-grad? #f) ; Track whether traded yet with the disgruntled grad student 

(define (help-grad!)
  (set! helped-grad? #t))
  

;; ============================================================
;; Overall module:

(define-syntax module-begin
  (syntax-rules (define-verbs define-everywhere)
    [(_ (define-verbs all-verbs cmd ...)
        (define-everywhere everywhere-actions act ...)
        decl ...
        id)
     (#%module-begin
      (define-verbs all-verbs cmd ...)
      (define-everywhere everywhere-actions act ...)
      decl ...
      (start-game (check-type id "place")
                  all-verbs
                  everywhere-actions))]))

;; ============================================================
;; Model:

;; Elements of the world:
(struct verb (aliases       ; list of symbols
              desc          ; string
              transitive?)) ; boolean
(struct thing (name         ; symbol
               [state #:mutable] ; any value
               actions))    ; list of verb--thunk pairs
(struct place (desc         ; string
               [things #:mutable] ; list of things
               actions))    ; list of verb--thunk pairs

;; Tables mapping names<->things for save and load
(define names (make-hash))
(define elements (make-hash))

(define (record-element! name val)
  (hash-set! names name val)
  (hash-set! elements val name))

(define (name->element name) (hash-ref names name #f))
(define (element->name obj) (hash-ref elements obj #f))

;; ============================================================
;; Simple type layer:

(begin-for-syntax 
 (struct typed (id type) 
   #:property prop:procedure (lambda (self stx) (typed-id self))
   #:omit-define-syntaxes))

(define-syntax (check-type stx)
  (syntax-case stx ()
    [(check-type id type)
     (let ([v (and (identifier? #'id)
                   (syntax-local-value #'id (lambda () #f)))])
       (unless (and (typed? v)
                    (equal? (syntax-e #'type) (typed-type v)))
         (raise-syntax-error
          #f
          (format "not defined as ~a" (syntax-e #'type))
          #'id))
       #'id)]))

;; ============================================================
;; Macros for constructing and registering elements:

(define-syntax-rule (define-verbs all-id
                      [id spec ...] ...)
  (begin
    (define-one-verb id spec ...) ...
    (record-element! 'id id) ...
    (define all-id (list id ...))))

(define-syntax define-one-verb
  (syntax-rules (= _)
    [(define-one-verb id (= alias ...) desc)
     (begin
       (define gen-id (verb (list 'id 'alias ...) desc #f))
       (define-syntax id (typed #'gen-id "intransitive verb")))]
    [(define-one-verb id _ (= alias ...) desc)
     (begin
       (define gen-id (verb (list 'id 'alias ...) desc #t))
       (define-syntax id (typed #'gen-id "transitive verb")))]
    [(define-one-verb id)
     (define-one-verb id (=) (symbol->string 'id))]
    [(define-one-verb id _)
     (define-one-verb id _ (=) (symbol->string 'id))]))

(define-syntax-rule (define-thing id 
                      [vrb expr] ...)
  (begin
    (define gen-id 
      (thing 'id #f (list (cons (check-type vrb "transitive verb")
                                (lambda () expr)) ...)))
    (define-syntax id (typed #'gen-id "thing"))
    (record-element! 'id id)))


(define-syntax-rule (define-place id 
                      desc 
                      (thng ...) 
                      ([vrb expr] ...))
  (begin
    (define gen-id 
      (place desc
             (list (check-type thng "thing") ...)
             (list (cons (check-type vrb "intransitive verb")
                         (lambda () expr)) 
                   ...)))
    (define-syntax id (typed #'gen-id "place"))
    (record-element! 'id id)))


(define-syntax-rule (define-everywhere id ([vrb expr] ...))
  (define id (list (cons (check-type vrb "intransitive verb")
                         (lambda () expr)) 
                   ...)))

;; ============================================================
;; Game state

;; Initialized on startup:
(define all-verbs null)          ; list of verbs
(define everywhere-actions null) ; list of verb--thunk pairs

;; Things carried by the player:
(define stuff null) ; list of things

;; Current location:
(define current-place #f) ; place (or #f until started)

;; Fuctions to be used by verb responses:
(define (have-thing? t)
  (memq t stuff))
(define (take-thing! t) 
  (set-place-things! current-place (remq t (place-things current-place)))
  (set! stuff (cons t stuff))
  (item-count-inc!))
(define (drop-thing! t) 
  (set-place-things! current-place (cons t (place-things current-place)))
  (set! stuff (remq t stuff))
  (item-count-dec!))

;; ============================================================
;; Game execution

;; Show the player the current place, then get a command:
(define (do-place)
  (show-current-place)
  (do-verb))

;; Show the current place:
(define (show-current-place)
  (printf "~a\n" (place-desc current-place))
  (for-each (lambda (thing)
              (printf "There is a ~a here.\n" (thing-name thing)))
            (place-things current-place)))

;; Get and handle a command:
(define (do-verb)
  (teleport-check)
  (brain-check)
  (move-monsters)
  (printf "> ")
  (flush-output)
  (let* ([line (read-line)]
         [input (if (eof-object? line)
                    '(quit)
                    (let ([port (open-input-string line)])
                      (for/list ([v (in-port read port)]) v)))])
    (if (and (list? input)
             (andmap symbol? input)
             (<= 1 (length input) 2))
        (let ([vrb (car input)])
            (let ([response
                   (cond
                    [(= 2 (length input))
                     (handle-transitive-verb vrb (cadr input))]
                    [(= 1 (length input))
                     (handle-intransitive-verb vrb)])])
              (let ([result (response)])
                (cond
                 [(place? result)
                  (set! current-place result)
                  (do-place)]
                 [(string? result)
                  (printf "~a\n" result)
                  (do-verb)]
                 [else (do-verb)]))))
          (begin
            (printf "I don't understand what you mean.\n")
            (do-verb)))))

;; Handle an intransitive-verb command:
(define (handle-intransitive-verb vrb)
  (or
   (find-verb vrb (place-actions current-place))
   (find-verb vrb everywhere-actions)
   (using-verb 
    vrb all-verbs
    (lambda (verb)
      (lambda () 
        (if (verb-transitive? verb)
            (format "~a what?" (string-titlecase (verb-desc verb)))
            (format "Can't ~a here." (verb-desc verb))))))
   (lambda ()
     (format "I don't know how to ~a." vrb))))

;; Handle a transitive-verb command:
(define (handle-transitive-verb vrb obj)
  (or (using-verb 
       vrb all-verbs
       (lambda (verb)
         (and 
          (verb-transitive? verb)
          (cond
           [(ormap (lambda (thing)
                     (and (eq? (thing-name thing) obj)
                          thing))
                   ; Added bp to check backpack
                   (append (place-things current-place)
                           stuff bp))
            => (lambda (thing)
                 (or (find-verb vrb (thing-actions thing))
                     (lambda ()
                       (format "Don't know how to ~a ~a."
                               (verb-desc verb) obj))))]
           [else
            (lambda ()
              (format "There's no ~a here to ~a." obj 
                      (verb-desc verb)))]))))
      (lambda ()
        (format "I don't know how to ~a ~a." vrb obj))))

;; Show what the player is carrying:
(define (show-inventory)
  (printf "You have")
  (if (null? stuff)
      (printf " no items.")
      (for-each (lambda (thing)
                  (printf "\n  a ~a" (thing-name thing)))
                stuff))
  (printf "\n"))

;; Look for a command match in a list of verb--response pairs,
;; and returns the response thunk if a match is found:
(define (find-verb cmd actions)
  (ormap (lambda (a)
           (and (memq cmd (verb-aliases (car a)))
                (cdr a)))
         actions))

;; Looks for a command in a list of verbs, and
;; applies `success-k' to the verb if one is found:
(define (using-verb cmd verbs success-k)
  (ormap (lambda (vrb)
           (and (memq cmd (verb-aliases vrb))
                (success-k vrb)))
         verbs))

;; Print help information:
(define (show-help)
  (printf "Use `look' to look around.\n")
  (printf "Use `inventory' to see what you have.\n")
  (printf "Use `save' or `load' to save or restore your game.\n")
  (printf "There are some other verbs, and you can name a thing after some verbs.\n"))

;; ============================================================
;; Save and load

;; Prompt the user for a filename and apply `proc' to it,
;; catching errors to report a reasonably nice message:
(define (with-filename proc)
  (printf "File name: ")
  (flush-output)
  (let ([v (read-line)])
    (unless (eof-object? v)
      (with-handlers ([exn? (lambda (exn)
                              (printf "~a\n" (exn-message exn)))])
        (unless (path-string? v)
          (raise-user-error "bad filename"))
        (proc v)))))

;; Save the current game state:
(define (save-game)
  (with-filename
   (lambda (v)
     (with-output-to-file v
       (lambda ()
         (write
          (list
           (map element->name stuff)
           (element->name current-place)
           (hash-map names
                     (lambda (k v)
                       (cons k
                             (cond
                              [(place? v) (map element->name (place-things v))]
                              [(thing? v) (thing-state v)]
                              [else #f])))))))))))

;; Restore a game state:
(define (load-game)
  (with-filename
   (lambda (v)
     (let ([v (with-input-from-file v read)])
       (set! stuff (map name->element (car v)))
       (set! current-place (name->element (cadr v)))
       (for-each
        (lambda (p)
          (let ([v (name->element (car p))]
                [state (cdr p)])
            (cond
             [(place? v) (set-place-things! v (map name->element state))]
             [(thing? v) (set-thing-state! v state)])))
        (caddr v))))))

;; ============================================================
;; To go:

(define (start-game in-place
                    in-all-verbs
                    in-everywhere-actions)
  (set! current-place in-place)
  (set! all-verbs in-all-verbs)
  (set! everywhere-actions in-everywhere-actions)
  (build-place-list (hash->list elements))
  (do-place))
