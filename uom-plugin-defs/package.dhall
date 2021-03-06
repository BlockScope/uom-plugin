let defs = ./../defaults.dhall

in  let testopts = [ "-rtsopts", "-threaded", "-with-rtsopts=-N" ]
    
    in    defs
        ⫽ { name =
              "uom-plugin-defs"
          , synopsis =
              "Units of measure definitions"
          , description =
              ''
              The @uom-plugin@ library adds support for units of measure to GHC
              using the new experimental facility for typechecker plugins. This
              package adds some unit definitions.''
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
              [ "LICENSE" ]
          , library =
              { source-dirs =
                  "src"
              , exposed-modules =
                  "Data.UnitsOfMeasure.Defs"
              , dependencies =
                    defs.dependencies
                  # [ "template-haskell >=2.9", "uom-quantity", "uom-plugin" ]
              }
          }
