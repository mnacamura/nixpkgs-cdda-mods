#!/usr/bin/env gosh

(use gauche.collection)
(use github)
(use nix-prefetch)
(use rfc.tls)
(use srfi-13)

;; Because there are thousands of jenkins build tags, we limit the number of builds to keep.
(define-constant *builds-to-keep* 30)

(define (%generate-nix-expr tag :optional (indent 2))
  (let* ([version (rxmatch-substring (#/(?<=cdda-)jenkins-b\d+/ tag))]
         [build-number (rxmatch-substring (#/(?<=cdda-jenkins-)b\d+/ tag))]
         [sha256 (nix-prefetch-url/cache
                   #"https://github.com/CleverRaven/Cataclysm-DDA/archive/~|tag|.tar.gz"
                   :unpack? #t
                   :name #"cataclysm-dda-git-~|version|")]
         [lines `(,#"~|build-number| = let"
                  "  args = {"
                  ,#"    version = \"~|version|\";"
                  ,#"    rev = \"~|tag|\";"
                  ,#"    sha256 = \"~|sha256|\";"
                  "  };"
                  "in {"
                  "  tiles = cataclysmDDA.git.tiles.override args;"
                  "  curses = cataclysmDDA.git.curses.override args;"
                  "};")])
    (string-join (map (pa$ string-append (make-string indent #\ )) lines) "\n")))

(define (%sort-jenkins-tags tags)
  (sort tags >= (.$ string->number rxmatch-substring #/\d+/)))

(define (generate-nix-exprs tags)
  (let* ([tags (%sort-jenkins-tags tags)]
         [latest (rxmatch-substring (#/(?<=cdda-jenkins-)b\d+/ (car tags)))])
    (string-join `("{ cataclysmDDA }:\n\nrec {"
                   ,#"  latest = ~|latest|;"
                   ,@(map %generate-nix-expr tags)
                   "}")
                 "\n")))

(define (main _)
  (default-tls-class <mbed-tls>)
  (let1 tags (take (%sort-jenkins-tags (github-get-cdda-jenkins-tags))
                   *builds-to-keep*)
    (with-output-to-file "jenkins.nix"
                         (cut print (generate-nix-exprs tags)))))
