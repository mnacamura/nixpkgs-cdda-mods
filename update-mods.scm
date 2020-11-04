#!/usr/bin/env gosh

(use gauche.collection)
(use gauche.process)
(use rfc.http)
(use rfc.json)
(use rfc.tls)
(default-tls-class <mbed-tls>)
(use srfi-13)
(use srfi-19)

(define-constant *fallback-version*
  (date->string (current-date) "~Y-~m-~d"))

(define-constant *soundpack-overrides*
  `(("ChestHole" . (("version" . "2015-12-12")
                    ;; Remember the three checksums below because download speed from chezzo.com is
                    ;; too slow.
                    ("sha256" . "1d9p1ilxyd64r0xwzvnp30hsgp7aza16p03rwi6h9v2gbd9mmzda")))
    ("ChestOldTimey" . (("version" . "2016-09-21")
                        ("sha256" . "0v4gx1lhpc5fw55hfymf1c0agp5bacs9c3h0qgcmc62n6ys4gxhi")))
    ("ChestHoleCC" . (("version" . "2016-09-21")
                      ("sha256" . "07cw5gm7kfxzr2xadpmdv932kz4l5lf9ks8rfh6a4b5fl53lapz7")))
    ("RRFSounds" . (("version" . "2016-01-10")
                    ("url" . ,(cut regexp-replace #/\?dl=1$/ <> ""))
                    ("mod_root" . "sound/RRFSounds")))
    ("CDDA-Soundpack" . ,(let1 version "1.3"
                           `(("name" . "budg3")
                             ("version" . ,version)
                             ("url" . ,(cut regexp-replace #/(?<=archive\/)master(?=\.zip$)/ <>
                                            #"v~|version|"))
                             ("mod_root" . "CDDA-Soundpack"))))
    ("CO.AG SoundPack" . (("ignore" . #t)))  ; download path broken
    ("2ch soundpack" . (("ignore" . #t)))  ; download path broken
    ("@'s soundpack" . (("name" . "atsign")
                        ("version" . "0.2")))
    ("Otopack" . (("version" . "2020-10-28")
                  ("url" . ,(cut regexp-replace #/(?<=archive\/)master(?=\.zip$)/ <>
                                 "29a8421d4951e80a280928a595a45084dba1b5d4"))
                  ("mod_root" . "Otopack+ModsUpdates")))))

(define (get-data-from-cddagl-repo target)
  (let-values ([(status _ body)
                (http-get "raw.githubusercontent.com"
                          #"/remyroy/CDDA-Game-Launcher/master/data/~|target|.json")])
    (if (string= status "200")
        (parse-json-string body)
        (error #"Failed to get ~|target|.json from cddagl repo:" body))))

(define (build-soundpack datum :optional (indent 2))
  (let1 override (assoc-ref *soundpack-overrides*
                            (assoc-ref datum "name")
                            '())
    (define (update attr)
      (or (let1 f (assoc-ref override attr)
            (if (procedure? f)
                (f (assoc-ref datum attr))
                f))
          (assoc-ref datum attr)))
    (let* ([type (string->symbol (update "type"))]
           [name (update "name")]
           [version (or (update "version")
                        *fallback-version*)]
           [url (update "url")]
           [homepage (update "homepage")]
           [sha256 (or (update "sha256")
                       (case type
                         ((direct_download)
                          (process-output->string `(nix-prefetch-url ,url)))
                         ((browser_download)
                          (error "Missing sha256 checksum, must be provided in overrides"))
                         (else
                           (error "Unknown type:" type))))]
           [mod-root (update "mod_root")])
      (string-join (map (pa$ string-append (make-string indent #\ ))
                        `(,#"~|name| = cataclysmDDA.buildSoundPack {"
                          ,#"  modName = \"~|name|\";"
                          ,#"  version = \"~|version|\";"
                          ,@(case type
                              ((direct_download)
                               (list "  src = fetchurl {"
                                     #"    url = \"~|url|\";"
                                     #"    sha256 = \"~|sha256|\";"))
                              ((browser_download)
                               (list "  src = requireFile {"
                                     #"    name = \"~|name|-~|version|\";"
                                     #"    url = \"~|url|\";"
                                     #"    sha256 = \"~|sha256|\";"))
                              (else
                                (error "Unknown type:" type)))
                          "  };"
                          ,@(if (#/\.zip$/ url)
                                '("  nativeBuildInputs = [ unzip ];")
                                '())
                          ,@(if mod-root
                                `(,#"  modRoot = \"~|mod-root|\";")
                                '())
                          "}"))
                   "\n"))))

(define (build-soundpacks data)
  (let1 data (remove (^x (let* ([name (assoc-ref x "name")]
                                [override (assoc-ref *soundpack-overrides* name '())])
                           (assoc-ref override "ignore")))
                     data)
    (string-join `("{ cataclysmDDA, fetchurl, unzip }:\n\n{"
                   ,@(map (.$ (cut string-append <> ";")
                              build-soundpack)
                          data)
                   "}")
                 "\n")))

(define (main _)
  (let1 data (get-data-from-cddagl-repo "soundpacks")
    (with-output-to-file "soundpacks.nix"
                         (lambda () (print (build-soundpacks data))))))
