;; Vowel reduction rules for Russian.
;; I'm using a cart tree,
;; because it can be converted to Flite format automaticly.
;; Less C code and just one place to make changes.

(set!
 ru_vowel_reduction_tree
 '((R:SylStructure.parent.stress is 1)
   ((name is a)
    ((aa))
    ((name is o)
     ((oo))
     ((name is u)
      ((uu))
      ((name is e)
       ((ee))
       ((name is y)
        ((yy))
        ((name is i)
         ((p.ph_csoft is -)
          ((yy))
          ((ii)))
         ((N))))))))
   ((p.name is pau)
    ((name is o)
     ((a))
     ((N)))
    ((n.name is pau)
     ((name is o)
      ((a))
      ((N)))
     ((p.ph_vc is +)
      ((name is o)
       ((a))
       ((N)))
      ((R:Transcription.p.name is 0)
       ((name is o)
        ((a))
        ((name is i)
         ((p.ph_csoft is -)
          ((y))
          ((N)))
         ((N))))
       ((R:SylStructure.parent.n.stress is 1)
        ((p.ph_csoft is +)
         ((name is a)
          ((i))
          ((name is o)
           ((i))
           ((name is e)
            ((i))
            ((N)))))
         ((name is o)
          ((a))
          ((name is e)
           ((y))
           ((N)))))
        ((R:SylStructure.parent.parent.gpos is proc)
         ((R:SylVowel.parent.n.stress is 1)
          ((p.ph_csoft is +)
           ((name is e)
            ((i))
            ((N)))
           ((name is o)
            ((a))
            ((N))))
          ((name is u)
           ((ur))
           ((p.ph_csoft is +)
            ((ae))
            ((ay)))))
         ((R:Transcription.n.name is 0)
          ((p.ph_csoft is +)
           ((name is o)
            ((ae))
            ((N)))
           ((name is o)
            ((a))
            ((N))))
          ((name is u)
           ((ur))
           ((p.ph_csoft is +)
            ((ae))
            ((ay)))))))))))))

(define (ru_reduce_vowels utt)
  (let ((syl) (seg) (r))
    (set! syl (utt.relation.first utt 'SylVowel))
    (while
     syl
     (set! seg (item.relation (item.daughter1 syl) 'Segment))
     (if
      (and
       (not (string-equal (item.feat syl "R:SylStructure.parent.no_vr") "1"))
       (member_string (item.name seg) '(a o u y e i)))
      (begin
        (set! r (wagon_predict seg ru_vowel_reduction_tree))
        (if (not (string-equal r "N"))
            (item.set_name seg r)))
      (if
       (and
        (string-equal (item.name seg) "ii")
        (string-equal (item.feat seg "p.ph_csoft") "-"))
       (item.set_name seg "yy")))
     (set! syl (item.next syl)))))

(provide 'ru_vowel_reduction)