# OPAM packages needed to build tests.
OPAM_PACKAGES="mirage"

# install OPAM
case "$OCAML_VERSION,$OPAM_VERSION" in
    3.12.1,1.1.0) ppa=avsm/ocaml312+opam11 ;;
    4.00.1,1.1.0) ppa=avsm/ocaml40+opam11 ;;
    4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
    *) echo Unsupported $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
export OPAMVERBOSE=1
opam init
eval `opam config env`

# install Mirage
opam install ${OPAM_PACKAGES}

# build mort-www
cp .travis-config.ml src/config.ml
mirage --version
make MODE=$MIRAGE_BACKEND
