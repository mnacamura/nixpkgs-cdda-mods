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

(define (get-github-commit-date owner repo :optional rev)
  (let-values ([(status _ body) (http-get "api.github.com"
                                          #"/repos/~|owner|/~|repo|/commits/~(or rev 'master)")])
    (if (string= status "200")
        (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
          (let1 obj (parse-json-string body)
            (values (rxmatch-substring (#/^\d{4}-\d{2}-\d{2}/ (~ obj "commit" "committer" "date")))
                    (~ obj "sha"))))
        (error "Failed to get github last commit info:" body))))

(define (build-mod class datum :optional (indent 2))
  (let* ([mod-name (ref datum "mod_name")]
         [version (ref datum "version" #f)]
         [download-type (string->symbol (ref datum "download_type"))]
         [url (ref datum "url" #f)]
         [ext (if url
                  (rxmatch-case url
                    (#/\.zip$/ (e) e)
                    (else (error "Unknown file extention:" url))))]
         [sha256 (ref datum "sha256" #f)]
         [homepage (ref datum "homepage")]
         [file_name (ref datum "file_name" #f)]
         [owner (ref datum "owner" #f)]
         [repo (ref datum "repo" #f)]
         [rev (ref datum "rev" #f)]
         [mod-root (ref datum "mod_root" #f)])
    (let-values ([(version rev)
                  (case download-type
                    [(direct browser)
                     (if version
                         (values version #f)
                         (error "Missing \"version\" in direct/browser download"))]
                    [(github)
                     (cond
                       [version
                         (if rev
                             (values version rev)
                             (error "Missing \"rev\" while \"version\" is provided in github download"))]
                       [else
                         (if (and owner repo)
                             (get-github-commit-date owner repo rev)
                             (error "Missing \"owner\" and/or \"repo\" in github download"))])]
                    [else
                      (error "Unknown download type:" download-type)])])
      (let1 sha256 (case download-type
                     [(direct)
                      (or sha256
                          (if url
                              (process-output->string
                               `(nix-prefetch-url --name ,#"~|mod-name|-~|version|~|ext|" ,url))
                              (error "Missing \"url\" in direct download")))]
                     [(browser)
                      (or sha256
                          (error "Missing \"sha256\" in browser download"))]
                     [(github)
                      (or sha256
                          (process-output->string
                            `(nix-prefetch-url
                               --unpack --name ,#"~|mod-name|-~|version|"
                               ,#"https://github.com/~|owner|/~|repo|/archive/~|rev|.tar.gz")))])
        (string-join (map (pa$ string-append (make-string indent #\ ))
                          `(,(let1 class (case class
                                           [(mod) "Mod"]
                                           [(soundpack) "SoundPack"]
                                           [(tileset) "TileSet"]
                                           [else (error "Unknown mod class:" class)])
                               #"~|mod-name| = cataclysmDDA.build~|class| {")
                            ,#"  modName = \"~|mod-name|\";"
                            ,#"  version = \"~|version|\";"
                            ,@(case download-type
                                [(direct)
                                 (list "  src = fetchurl {"
                                       #"    name = \"~|mod-name|-~|version|~|ext|\";"
                                       #"    url = \"~|url|\";"
                                       #"    sha256 = \"~|sha256|\";")]
                                [(browser)
                                 (list "  src = requireFile {"
                                       #"    name = \"~|mod-name|-~|version|~|ext|\";"
                                       #"    url = \"~|url|\";"
                                       #"    sha256 = \"~|sha256|\";")]
                                [(github)
                                 (list "  src = fetchFromGitHub {"
                                       #"    owner = \"~|owner|\";"
                                       #"    repo = \"~|repo|\";"
                                       #"    rev = \"~|rev|\";"
                                       #"    sha256 = \"~|sha256|\";")]
                                [else
                                  (error "Unknown download type:" download-type)])
                            "  };"
                            ,@(if (and url (#/\.zip$/ url))
                                  '("  nativeBuildInputs = [ unzip ];")
                                  '())
                            ,@(if mod-root
                                  `(,#"  modRoot = \"~|mod-root|\";")
                                  '())
                            "  meta = with lib; {"
                            ,#"    homepage = \"~|homepage|\";"
                            "  };"
                            "}"))
                     "\n")))))

(define (build-mods class data)
  (string-join `("{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:\n\n{"
                 ,@(map (.$ (cut string-append <> ";")
                            (cut build-mod class <>))
                        (remove (cut ref <> "ignore" #f) data))
                 "}")
               "\n"))

(define (main _)
  (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
    (let ([mods (with-input-from-file "mods.json" (cut parse-json))]
          [soundpacks (with-input-from-file "soundpacks.json" (cut parse-json))]
          [tilesets (with-input-from-file "tilesets.json" (cut parse-json))])
      (with-output-to-file "mods.nix"
                           (cut print (build-mods 'mod mods)))
      (with-output-to-file "soundpacks.nix"
                           (cut print (build-mods 'soundpack soundpacks)))
      (with-output-to-file "tilesets.nix"
                           (cut print (build-mods 'tileset tilesets))))))
