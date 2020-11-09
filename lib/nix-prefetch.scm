(define-module nix-prefetch
  (use file.util)
  (use gauche.parameter)
  (use gauche.process)
  (use rfc.json)
  (export sha256-cache-path
          nix-prefetch-url/cache))

(select-module nix-prefetch)

(define sha256-cache-path (make-parameter ".sha256-cache.json"))

(define (nix-prefetch-url/cache url :key (unpack? #f) (name #f))
  (with-lock-file
    ".lock-sha256-cache"
    (lambda ()
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
                sha256)))))))
