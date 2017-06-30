{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  sshd = "schrome";
  exec = pkgs.writeScript "schrome" ''
#!/usr/bin/env bash
ps -eo pid,args | grep "ssh -D 3138" | awk '{ print $1 }' | sed '$ d' | xargs kill
ssh -D 3138 -f -C -q -N ${sshd}
google-chrome-stable --proxy-server="socks://127.0.0.1:3138" $@
'';
in

  stdenv.mkDerivation rec {
    name = "schrome";
    src = ./.;
    buildInstall = [ google-chrome ];
    installPhase = ''
mkdir -p $out/bin
ln -s ${exec} $out/bin/schrome
    '';
}
