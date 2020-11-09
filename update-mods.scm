#!/usr/bin/env gosh

(use file.util)
(use gauche.collection)
(use gauche.parameter)
(use github)
(use nix-prefetch)
(use rfc.json)
(use rfc.tls)
(use srfi-13)

(define (%generate-nix-expr class datum :optional (indent 2))
  (let ([mod-name (or (ref datum "mod_name" #f)
                      (error "\"mod_name\" missing:" (hash-table->alist datum)))]
        [version (ref datum "version" #f)]
        [download-type (string->symbol (or (ref datum "download_type" #f)
                                           (error "\"download_type\" missing:"
                                                  (hash-table->alist datum))))]
        [url (ref datum "url" #f)]
        [sha256 (ref datum "sha256" #f)]
        [file_name (ref datum "file_name" #f)]
        [owner (ref datum "owner" #f)]
        [repo (ref datum "repo" #f)]
        [rev (ref datum "rev" #f)]
        [homepage (or (ref datum "homepage" #f)
                      (error "\"homepage\" missing:" (hash-table->alist datum)))]
        [mod-root (ref datum "mod_root" #f)])
    (let-values ([(version rev) (case download-type
                                  [(direct browser)
                                   (if version
                                       (values version #f)
                                       (error "\"version\" missing in direct/browser download:"
                                              (hash-table->alist datum)))]
                                  [(github)
                                   (cond
                                     [(and version rev)
                                      (values version rev)]
                                     [(and version (not rev))
                                      (error "\"rev\" missing while \"version\" is pinned:"
                                             (hash-table->alist datum))]
                                     [(and owner repo)
                                      (github-get-commit-date owner repo rev)]
                                     [else
                                       (error "\"owner\" and/or \"repo\" missing:"
                                              (hash-table->alist datum))])]
                                  [else
                                    (error "Unknown download type:" download-type)])])
      (let* ([ext (if url
                      (rxmatch-case url
                        (#/\.(zip|tar\.gz)$/ (e) e)
                        (else (error "Unknown file extention:" url))))]
             [sha256 (or sha256
                         (case download-type
                           [(direct)
                            (if url
                                (nix-prefetch-url/cache url :name #"~|mod-name|-~|version|~|ext|")
                                (error "\"url\" missing in direct download:"
                                       (hash-table->alist datum)))]
                           [(browser)
                            (error "\"sha256\" missing in browser download:"
                                   (hash-table->alist datum))]
                           [(github)
                            (if (and owner repo rev)
                                (nix-prefetch-url/cache
                                  #"https://github.com/~|owner|/~|repo|/archive/~|rev|.tar.gz"
                                  :unpack? #t
                                  :name #"~|mod-name|-~|version|")
                                (error "\"owner\", \"repo\", and/or \"rev\" missing:"
                                       (hash-table->alist datum)))]))]
             [lines `(,(let1 class (case class
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
                      ,@(cond
                          [(and url (string= ".zip" ext))
                           '("  nativeBuildInputs = [ unzip ];")]
                          [else
                            '()])
                      ,@(if mod-root
                            `(,#"  modRoot = \"~|mod-root|\";")
                            '())
                      "  meta = with lib; {"
                      ,#"    homepage = \"~|homepage|\";"
                      "  };"
                      "};")])
        (string-join (map (pa$ string-append (make-string indent #\ )) lines) "\n")))))

(define (generate-nix-exprs class data)
  (let1 data (remove (cut ref <> "ignore" #f) data)
    (string-join `("# Automatically generated by `update-mods.scm`. DO NOT EDIT!"
                   "{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:\n\n{"
                   ,@(map (pa$ %generate-nix-expr class) data)
                   "}")
                 "\n")))

(define (main _)
  (default-tls-class <mbed-tls>)
  (parameterize ([json-object-handler (cut alist->hash-table <> 'string=?)])
    (let ([mods (with-input-from-file "mods.json" (cut parse-json))]
          [soundpacks (with-input-from-file "soundpacks.json" (cut parse-json))]
          [tilesets (with-input-from-file "tilesets.json" (cut parse-json))])
      (with-output-to-file (build-path "./generated" "mods.nix")
                           (cut print (generate-nix-exprs 'mod mods)))
      (with-output-to-file (build-path "./generated" "soundpacks.nix")
                           (cut print (generate-nix-exprs 'soundpack soundpacks)))
      (with-output-to-file (build-path "./generated" "tilesets.nix")
                           (cut print (generate-nix-exprs 'tileset tilesets)))))
  (exit))
