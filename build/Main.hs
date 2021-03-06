import Development.Shake
    ( Rules, CmdOption(Cwd, Shell), (%>)
    , phony, cmd, need, shakeArgs, shakeOptions, want
    )
import Development.Shake.FilePath ((<.>), (</>))

main :: IO ()
main = shakeArgs shakeOptions $ do
    want ["cabal-files"]

    sequence_ $ formatRoot <$> dhallRootImports
    sequence_ $ formatPkg <$> dhallPkgs
    sequence_ $ hpack <$> dhallPkgs
    sequence_ $ cabal <$> dhallCabal
    phony "dhall-format" $ need $ (\x -> "dhall-format-" ++ x) <$> dhallPkgs ++ dhallRootImports
    phony "hpack-dhall" $ need $ (\x -> "hpack-dhall-" ++ x) <$> dhallPkgs
    phony "cabal-files" $ need $ (\(x, y) -> x </> y <.> "cabal") <$> dhallCabal

type Folder = String
type Pkg = String

-- | The names of the folders for dhall-format and hpack-dhall.
dhallPkgs :: [Folder]
dhallPkgs = fst <$> dhallCabal

-- | Pairs of package folder name used by dhall and the produced cabal file
-- name.
dhallCabal :: [(Folder, Pkg)]
dhallCabal =
    [ ("build", "build-uom-plugin")
    , ("ghc-corroborate", "ghc-corroborate")
    , ("ghc-tcplugins-extra", "ghc-tcplugins-extra")
    , ("ghc-tcplugins-trace", "ghc-tcplugins-trace")
    , ("thoralf", "thoralf-plugin")
    , ("uom-plugin", "uom-plugin")
    , ("uom-plugin-defs", "uom-plugin-defs")
    , ("uom-plugin-examples", "uom-plugin-examples")
    , ("uom-plugin-tutorial", "uom-plugin-tutorial")
    , ("uom-quantity", "uom-quantity")
    , ("uom-th", "uom-th")
    ]

dhallRootImports :: [String]
dhallRootImports = ["defaults"]

formatPkg :: Folder -> Rules ()
formatPkg folder =
    phony ("dhall-format-" ++ folder)
    $ cmd Shell ("dhall format --inplace " ++ (folder </> "package.dhall"))

formatRoot :: String -> Rules ()
formatRoot x =
    phony ("dhall-format-" ++ x)
    $ cmd Shell ("dhall format --inplace " ++ (x <.> ".dhall"))

hpack :: Folder -> Rules ()
hpack folder =
    phony ("hpack-dhall-" ++ folder) $ do
        need ["dhall-format-" ++ folder]
        cmd (Cwd folder) Shell ("dhall-hpack-cabal --package-dhall=package.dhall")

cabal :: (Folder, Pkg) -> Rules ()
cabal (folder, pkg) =
    folder </> pkg <.> "cabal" %> \_ -> need ["hpack-dhall-" ++ folder]
