(define-module nix-prefetch
  (use file.util)
  (use gauche.parameter)
  (use gauche.process)
  (use rfc.json)
  (export nix-prefetch-url-path
          sha256-cache-path
          load-sha256-cache!
          save-sha256-cache!
          nix-prefetch-url/cache!))

(select-module nix-prefetch)

(define nix-prefetch-url-path
  (make-parameter (build-path "/" "run" "current-system" "sw" "bin" "nix-prefetch-url")))

(define sha256-cache-path (make-parameter ".sha256-cache.json"))

(define %sha256-cache)

(define (load-sha256-cache!)
  (set! %sha256-cache
        (parameterize ([json-object-handler (cut alist->tree-map <> string-comparator)])
          (or (call-with-input-file (sha256-cache-path) parse-json)
              (make-tree-map string-comparator)))))

(define (save-sha256-cache!)
  (with-output-to-file (sha256-cache-path) (cut construct-json %sha256-cache)))

(define (nix-prefetch-url/cache! url :key (unpack? #f) (name #f))
  (or (ref %sha256-cache url #f)
      (let1 sha256 (process-output->string
                     `(,(nix-prefetch-url-path) ,@(if unpack? '(--unpack) '())
                                                ,@(if name `(--name ,name) '())
                                                ,url))
        (begin
          (set! (~ %sha256-cache url) sha256)
          sha256))))
