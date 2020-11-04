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

(define-constant *tilesets*
  '(("UndeadPeople" . (("type" . "direct_download")
                       ("name" . "UndeadPeople")
                       ("url" . "https://github.com/SomeDeadGuy/UndeadPeopleTileset/archive/master.zip")
                       ("homepage" . "https://github.com/SomeDeadGuy/UndeadPeopleTileset")))))

(define-constant *tileset-overrides*
  `(("UndeadPeople" . (("version" . "2020-11-04")
                       ("url" . ,(cut regexp-replace #/(?<=archive\/)master(?=\.zip$)/ <>
                                      "a0497221a22fb3264685f8c7e10cb7829470cc58"))
                       ("mod_root" . "MSX++UnDeadPeopleEdition")))))

(define (get-data-from-cddagl-repo target)
  (let-values ([(status _ body)
                (http-get "raw.githubusercontent.com"
                          #"/remyroy/CDDA-Game-Launcher/master/data/~|target|.json")])
    (if (string= status "200")
        (parse-json-string body)
        (error #"Failed to get ~|target|.json from cddagl repo:" body))))

(define (build-mod class datum :optional (indent 2))
  (let1 override (assoc-ref (case class
                              ((soundpack) *soundpack-overrides*)
                              ((tileset) *tileset-overrides*)
                              (else (error "Unknown mod class:" class)))
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
                        `(,(let1 class (case class
                                         ((soundpack) "SoundPack")
                                         ((tileset) "TileSet")
                                         (else (error "Unknown mod class:" class)))
                             #"~|name| = cataclysmDDA.build~|class| {")
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

(define (build-mods class data)
  (let1 data (remove (^x (let* ([name (assoc-ref x "name")]
                                [override (assoc-ref (case class
                                                       ((soundpack) *soundpack-overrides*)
                                                       ((tileset) *tileset-overrides*)
                                                       (else (error "Unknown mod class:" class)))
                                                     name '())])
                           (assoc-ref override "ignore")))
                     data)
    (string-join `("{ cataclysmDDA, fetchurl, unzip }:\n\n{"
                   ,@(map (.$ (cut string-append <> ";")
                              (cut build-mod class <>))
                          data)
                   "}")
                 "\n")))

(define (main _)
  (with-output-to-file "soundpacks.nix"
                       (lambda ()
                         (print (build-mods 'soundpack (get-data-from-cddagl-repo "soundpacks")))))
  (with-output-to-file "tilesets.nix"
                       (lambda ()
                         (print (build-mods 'tileset *tilesets*)))))
