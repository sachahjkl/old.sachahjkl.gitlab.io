{
  description = "Reproducible checks and static package for old.sachahjkl.github.io";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      perSystem =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          site = pkgs.stdenvNoCC.mkDerivation {
            name = "old-sachahjkl-site";
            src = ./.;
            nativeBuildInputs = [ pkgs.dart-sass ];
            buildPhase = ''
              runHook preBuild
              sass --no-source-map --style=expanded assets/css/site.scss site.css
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p "$out/assets/css" "$out/assets/img"
              cp index.html projets.html a-propos.html favicon.ico manifest.webmanifest "$out/"
              cp assets/cv-public-de-sacha-froment.pdf "$out/assets/"
              cp assets/img/* "$out/assets/img/"
              cp site.css "$out/assets/css/site.css"
              runHook postInstall
            '';
          };
        in
        {
          inherit pkgs site;
        };
    in
    {
      packages = forAllSystems (system: {
        default = (perSystem system).site;
      });

      checks = forAllSystems (
        system:
        let
          inherit (perSystem system) pkgs site;
        in
        {
          actionlint = pkgs.runCommand "actionlint" { nativeBuildInputs = [ pkgs.actionlint ]; } ''
            actionlint -config-file ${./.github/actionlint.yaml} ${./.github/workflows/ci.yml}
            touch "$out"
          '';
          html = pkgs.runCommand "html-validation" { nativeBuildInputs = [ pkgs.html5validator ]; } ''
            html5validator --root ${site} --also-check-css
            touch "$out"
          '';
          links = pkgs.runCommand "local-links" { nativeBuildInputs = [ pkgs.lychee ]; } ''
            SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
              lychee --offline --include-fragments --root-dir ${site} '${site}/*.html'
            touch "$out"
          '';
          package = site;
        }
      );

      formatter = forAllSystems (system: (perSystem system).pkgs.nixfmt-tree);
    };
}
