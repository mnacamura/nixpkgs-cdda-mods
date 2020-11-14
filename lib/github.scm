(define-module github
  (use gauche.collection)
  (use gauche.parameter)
  (use rfc.http)
  (use rfc.json)
  (use srfi-13)
  (export github-get
          github-get-cdda-jenkins-tags
          github-get-cbn-release-tags
          github-get-commit-date))

(select-module github)

(define (github-get req :key (token (sys-getenv "GITHUB_TOKEN")) :allow-other-keys :rest args)
  (if token
      (apply http-get `("api.github.com" ,req :authorization ,#"token ~|token|" ,@args))
      (error "Please set GITHUB_TOKEN to your github access token")))

(define (github-get-cdda-jenkins-tags)
  (let1 req "/repos/CleverRaven/Cataclysm-DDA/git/matching-refs/tags/cdda-jenkins-b"
    (let-values ([(status _ body) (github-get req :accept "application/vnd.github.v3+json")]) 
      (if (string= status "200")
          (let ([coll (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                        (parse-json-string body))]
                [tmap (let1 build-number> (^[l r] (> (x->integer (rxmatch-substring (#/\d+/ l)))
                                                     (x->integer (rxmatch-substring (#/\d+/ r)))))
                        (make-tree-map (make-comparator #t string= build-number> #f)))]
                [basename (.$ rxmatch-substring #/[^\/]+$/)])
            (fold (^[item tmap]
                    (tree-map-put! tmap (basename (~ item "ref")) (~ item "object" "sha"))
                    tmap)
                  tmap coll))
          (error #"Failed to get github cdda jenkins tags:" body)))))

(define (github-get-cbn-release-tags)
  (let1 req "/repos/cataclysmbnteam/Cataclysm-BN/git/matching-refs/tags"
    (let-values ([(status _ body) (github-get req :accept "application/vnd.github.v3+json")]) 
      (if (string= status "200")
          (let ([coll (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                        (parse-json-string body))]
                [tmap (let1 build-number> (^[l r] (> (x->integer l) (x->integer r)))
                        (make-tree-map (make-comparator #t string= build-number> #f)))]
                [basename (.$ rxmatch-substring #/[^\/]+$/)])
            (fold (^[item tmap]
                    (let ([tag (basename (~ item "ref"))]
                          [rev (~ item "object" "sha")])
                      (when (#/^\d+$/ tag)
                        (tree-map-put! tmap tag rev)))
                    tmap)
                  tmap coll))
          (error #"Failed to get github cdda jenkins tags:" body)))))

(define (github-get-commit-date owner repo :optional (rev #f))
  (let*([rev (or rev "master")]
        [req #"/repos/~|owner|/~|repo|/commits/~|rev|"])
    (let-values ([(status _ body) (github-get req :accept "application/vnd.github.v3+json")])
      (if (string= status "200")
          (let ([obj (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                       (parse-json-string body))]
                [yyyy-mm-dd (.$ rxmatch-substring #/^\d{4}-\d{2}-\d{2}/)])
            (values (yyyy-mm-dd (~ obj "commit" "committer" "date"))
                    (~ obj "sha")))
          (error #"Failed to get github commit date for ~|owner|/~|repo|:" body)))))
