# APT packages
APT_PACKAGES="ocaml ocaml-native-compilers camlp4-extra opam coffeescript"

# OPAM packages needed to build tests
OPAM_PACKAGES="cow ssl cowabloga"

# install OPAM
case "$OCAML_VERSION,$OPAM_VERSION" in
    3.12.1,1.1.0) ppa=avsm/ocaml312+opam11 ;;
    4.00.1,1.1.0) ppa=avsm/ocaml40+opam11 ;;
    4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
    *) echo Unsupported $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ${APT_PACKAGES}

export OPAMYES=1
opam init
eval `opam config env`

opam remote add -k git upstream https://github.com/ocaml/opam-repository
opam remote remove default
opam remote add -k git mirage-1.1.0 \
    https://github.com/mirage/opam-repository#mirage-1.1-release

opam update -u

# install Mirage
export OPAMVERBOSE=1
opam install mirage ${OPAM_PACKAGES}
mirage --version

# build mort-www
make configure MODE=$MIRAGE_BACKEND FS=fat NET=direct IPADDR=live
make build
