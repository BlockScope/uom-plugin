    let defs = ./../defaults.dhall

in  let testopts = [ "-rtsopts", "-threaded", "-with-rtsopts=-N" ]

in    defs
    ⫽ { name =
          "uom-plugin"
      , synopsis =
          "Units of measure as a GHC typechecker plugin"
      , description =
          ''
          The @uom-plugin@ library adds support for units of measure to GHC
          using the new experimental facility for typechecker plugins, which
          is available in GHC 7.10 and later.  See
          "Data.UnitsOfMeasure.Tutorial" for an introduction to the library.''
      , category =
          "Type System"
      , github =
          "adamgundry/uom-plugin"
      , license =
          "BSD3"
      , license-file =
          "LICENSE"
      , stability =
          "experimental"
      , extra-source-files =
          [ "CHANGELOG.md", "README.md", "LICENSE" ]
      , library =
          { source-dirs =
              [ "doc", "src" ]
          , exposed-modules =
              [ "Data.UnitsOfMeasure"
              , "Data.UnitsOfMeasure.Convert"
              , "Data.UnitsOfMeasure.Defs"
              , "Data.UnitsOfMeasure.Internal"
              , "Data.UnitsOfMeasure.Plugin"
              , "Data.UnitsOfMeasure.Read"
              , "Data.UnitsOfMeasure.Show"
              , "Data.UnitsOfMeasure.Singleton"
              , "Data.UnitsOfMeasure.Tutorial"
              ]
          , dependencies =
                defs.dependencies
              # [ "deepseq >=1.3 && <1.5"
                , "ghc-tcplugins-extra >=0.5"
                , "template-haskell >=2.9"
                , "containers >=0.5"
                , "units-parser >=0.1"
                ]
          , when =
              [ { condition =
                    "impl(ghc >= 8.10.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.10" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.10 && <8.12"
                      , mixin =
                          [] : List Text
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              , { condition =
                    "impl(ghc >= 8.8.0) && impl(ghc < 8.10.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.8" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.8 && <8.10"
                      , mixin =
                          [ "hiding ()"
                          , "(TcRnTypes as TcRnTypes)"
                          , "(Type as Type)"
                          , "(TcRnTypes as Constraint)"
                          , "(Type as Predicate)"
                          ]
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              , { condition =
                    "impl(ghc >= 8.6.0) && impl(ghc < 8.8.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.6" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.6 && <8.8"
                      , mixin =
                          [ "hiding ()"
                          , "(TcRnTypes as TcRnTypes)"
                          , "(Type as Type)"
                          , "(TcRnTypes as Constraint)"
                          , "(Type as Predicate)"
                          ]
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              , { condition =
                    "impl(ghc >= 8.4.0) && impl(ghc < 8.6.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.4" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.4 && <8.6"
                      , mixin =
                          [ "hiding ()"
                          , "(TcRnTypes as TcRnTypes)"
                          , "(Type as Type)"
                          , "(TcRnTypes as Constraint)"
                          , "(Type as Predicate)"
                          ]
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              , { condition =
                    "impl(ghc >= 8.2.0) && impl(ghc < 8.4.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.2" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.2 && <8.4"
                      , mixin =
                          [ "hiding ()"
                          , "(TcRnTypes as TcRnTypes)"
                          , "(Type as Type)"
                          , "(TcRnTypes as Constraint)"
                          , "(Type as Predicate)"
                          ]
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              , { condition =
                    "impl(ghc >= 8.0.0) && impl(ghc < 8.2.0)"
                , source-dirs =
                    [ "src-ghc", "src-ghc-8.0" ]
                , dependencies =
                    [ { name =
                          "ghc"
                      , version =
                          ">=8.0 && <8.2"
                      , mixin =
                          [ "hiding ()"
                          , "(TcRnTypes as TcRnTypes)"
                          , "(Type as Type)"
                          , "(TcRnTypes as Constraint)"
                          , "(Type as Predicate)"
                          ]
                      }
                    ]
                , other-modules =
                    [ "GhcApi.Constraint"
                    , "GhcApi.Predicate"
                    , "GhcApi.GhcPlugins"
                    , "Internal.Type"
                    , "Internal.Constraint"
                    , "Internal.Evidence"
                    , "Internal.Compare"
                    , "Internal.Shim"
                    , "Internal.Wrap"
                    , "Internal"
                    ]
                }
              ]
          }
      , tests =
          { units =
              { dependencies =
                  [ "base", "tasty", "tasty-hunit", "uom-plugin" ]
              , ghc-options =
                  testopts
              , main =
                  "Tests.hs"
              , source-dirs =
                  "test-suite-units"
              , when =
                  { condition = "impl(ghc >= 8.4.0)", buildable = False }
              }
          , hlint =
              { dependencies =
                  "base"
              , ghc-options =
                  testopts
              , main =
                  "HLint.hs"
              , source-dirs =
                  "test-suite-hlint"
              , when =
                  [ { condition =
                        "impl(ghc >= 8.6.0)"
                    , dependencies =
                        "hlint"
                    , buildable =
                        True
                    }
                  , { condition =
                        "impl(ghc >= 8.4.0) && impl(ghc < 8.6.0)"
                    , dependencies =
                        "hlint < 2.1.18"
                    , buildable =
                        True
                    }
                  , { condition =
                        "impl(ghc < 8.4.0)"
                    , dependencies =
                        "hlint"
                    , buildable =
                        False
                    }
                  ]
              }
          }
      }
