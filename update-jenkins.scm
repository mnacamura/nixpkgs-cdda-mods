#!/usr/bin/env gosh

(use gauche.collection)
(use gauche.parameter)
(use gauche.process)
(use rfc.http)
(use rfc.json)
(use rfc.tls)
(default-tls-class <mbed-tls>)
(use srfi-13)
(use srfi-19)

;; Because there are thousands of jenkins build tags, we limit the number of builds to keep.
(define-constant *builds-to-keep* 30)

(define (get-github-cdda-jenkins-tags)
  (let-values ([(status _ body)
                (http-get "api.github.com"
                          "/repos/CleverRaven/Cataclysm-DDA/git/matching-refs/tags/cdda-jenkins-b")])
    (if (string= status "200")
        (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
          (let1 obj (parse-json-string body)
            (map (.$ rxmatch-substring  #/cdda-jenkins-b\d+/ (cut ref <> "ref")) obj)))
        (error #"Failed to get github cdda jenkins tags:" body))))

(define sha256-cache-path (make-parameter ".sha256-cache.json"))

(define (nix-prefetch-url/cache :key (unpack? #f) (name #f) url)
  (let1 cache (or (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
                    (with-input-from-file (sha256-cache-path) (cut parse-json)))
                  (make-hash-table 'string=?))
    (or (ref cache url #f)
        (let1 sha256 (process-output->string
                       `(nix-prefetch-url ,@(if unpack? '(--unpack) '())
                                          ,@(if name `(--name ,name) '())
                                          ,url))
          (begin
            (set! (~ cache url) sha256)
            (with-output-to-file (sha256-cache-path) (cut construct-json cache))
            sha256)))))

(define (%generate-nix-expr tag :optional (indent 2))
  (let* ([version (rxmatch-substring (#/(?<=cdda-)jenkins-b\d+/ tag))]
         [build-number (rxmatch-substring (#/(?<=cdda-jenkins-)b\d+/ tag))]
         [sha256 (nix-prefetch-url/cache
                   :unpack? #t
                   :name #"cataclysm-dda-git-~|version|"
                   :url #"https://github.com/CleverRaven/Cataclysm-DDA/archive/~|tag|.tar.gz")]
         [lines `(,#"~|build-number| = {"
                  ,#"  tiles = cataclysmDDA.git.tiles.override {"
                  ,#"    version = \"~|version|\";"
                  ,#"    rev = \"~|tag|\";"
                  ,#"    sha256 = \"~|sha256|\";"
                  "  };"
                  ,#"  curses = cataclysmDDA.git.curses.override {"
                  ,#"    version = \"~|version|\";"
                  ,#"    rev = \"~|tag|\";"
                  ,#"    sha256 = \"~|sha256|\";"
                  "  };"
                  "};")])
    (string-join (map (pa$ string-append (make-string indent #\ )) lines) "\n")))

(define (generate-nix-exprs tags)
  (let1 latest (rxmatch-substring (#/(?<=cdda-jenkins-)b\d+/ (car tags)))
    (string-join `("{ cataclysmDDA }:\n\nrec {"
                   ,#"  latest = ~|latest|;"
                   ,@(map %generate-nix-expr tags)
                   "}")
                 "\n")))

(define (main _)
  (let1 tags (take (reverse (get-github-cdda-jenkins-tags))
                   *builds-to-keep*)
    (with-output-to-file "jenkins.nix"
                         (cut print (generate-nix-exprs tags)))))
