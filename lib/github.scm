(define-module github
  (use gauche.collection)
  (use gauche.parameter)
  (use rfc.http)
  (use rfc.json)
  (use srfi-13)
  (export github-get
          github-get-cdda-jenkins-tags
          github-get-commit-date))

(select-module github)

(define (github-get req
                    :key (auth-token (sys-getenv "GITHUB_AUTH_TOKEN")) :allow-other-keys
                    :rest args)
  (apply http-get `("api.github.com" ,req :authorization #"token ~|auth-token|" ,@args)))

(define (github-get-cdda-jenkins-tags)
  (let1 req "/repos/CleverRaven/Cataclysm-DDA/git/matching-refs/tags/cdda-jenkins-b"
    (let-values ([(status _ body) (github-get req :accept "application/vnd.github.v3+json")]) 
      (if (string= status "200")
          (let1 obj (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                      (parse-json-string body))
            (map (^o (alist->hash-table `(("tag" . ,(~ o "ref"))
                                          ("rev" . ,(~ o "object" "sha")))
                                        'string=?))
                 obj))
          (error #"Failed to get github cdda jenkins tags:" body)))))

(define (github-get-commit-date owner repo :optional (rev #f))
  (let*([rev (or rev "master")]
        [req #"/repos/~|owner|/~|repo|/commits/~|rev|"])
    (let-values ([(status _ body) (github-get req :accept "application/vnd.github.v3+json")])
      (if (string= status "200")
          (let1 obj (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                      (parse-json-string body))
            (values (rxmatch-substring (#/^\d{4}-\d{2}-\d{2}/ (~ obj "commit" "committer" "date")))
                    (~ obj "sha")))
          (error #"Failed to get github commit date for ~|owner|/~|repo|:" body)))))
