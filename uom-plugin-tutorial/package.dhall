let defs = ./../defaults.dhall

in  let testopts =
          [ "-rtsopts"
          , "-threaded"
          , "-with-rtsopts=-N"
          , "-fplugin Plugins.UoM"
          ]
    
    in    defs
        ⫽ { name =
              "uom-plugin-tutorial"
          , synopsis =
              "A tutorial for the Units of measure typechecker plugin"
          , description =
              "A tutorial for the units of measure typechecker plugin, checked with doctest."
          , category =
              "Type System"
          , license =
              "BSD3"
          , tests =
              { doctest =
                  { dependencies =
                        defs.dependencies
                      # [ "doctest >= 0.13.0"
                        , "uom-quantity"
                        , "uom-plugin"
                        , "uom-plugin-defs"
                        ]
                  , ghc-options =
                      testopts
                  , main =
                      "DocTest.hs"
                  , source-dirs =
                      [ "test-suite-doctest", "doc" ]
                  , when =
                      { condition =
                          "impl(ghc < 8.2.2) || impl(ghc > 8.2.2)"
                      , buildable =
                          False
                      }
                  }
              }
          }
