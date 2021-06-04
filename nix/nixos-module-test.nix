{ sources ? import ./sources.nix
, pkgs ? import ./pkgs.nix { inherit sources; }
}:
let
  shortblito-production = import (./nixos-module.nix) { envname = "production"; shortblitoPackages = pkgs.shortblitoPackages; };
  port = 8001;
in
pkgs.nixosTest (
  { lib, pkgs, ... }: {
    name = "shortblito-module-test";
    machine = {
      imports = [
        shortblito-production
      ];
      services.shortblito.production = {
        enable = true;
        web-server = {
          enable = true;
          inherit port;
        };
      };
    };
    testScript = ''
      from shlex import quote

      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.wait_for_open_port(${builtins.toString port})
    '';
  }
)
