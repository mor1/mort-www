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

# deploy?
if [ "$DEPLOY" = "1" -a "$TRAVIS_PULL_REQUEST" = "false" ]; then
  # get the secure key out for deployment
  opam install travis-senv

  mkdir -p ~/.ssh
  SSH_DEPLOY_KEY=~/.ssh/id_dsa
  travis-senv decrypt > $SSH_DEPLOY_KEY
  chmod 600 $SSH_DEPLOY_KEY

  echo "Host mor1deploy github.com"     >> ~/.ssh/config
  echo "  Hostname github.com"          >> ~/.ssh/config
  echo "  StrictHostKeyChecking no"     >> ~/.ssh/config
  echo "  CheckHostIP no"               >> ~/.ssh/config
  echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config

  git config --global user.email "travis@mort.io"
  git config --global user.name "Travis the Build Bot"

  git clone git@mor1deploy:mor1/mort-www-deployment
  case "$MIRAGE_BACKEND" in
      xen)
          cd mirage-www-deployment
          rm -rf xen/$TRAVIS_COMMIT
          mkdir -p xen/$TRAVIS_COMMIT
          cp ../src/mir-mort-www.xen ../src/config.ml xen/$TRAVIS_COMMIT
          bzip2 -9 xen/$TRAVIS_COMMIT/mir-www.xen
          git pull --rebase
          echo $TRAVIS_COMMIT > xen/latest
          git add xen/$TRAVIS_COMMIT xen/latest
          ;;
      *)
          echo unsupported deploy mode: $MIRAGE_BACKEND
          exit 1
          ;;
  esac

  git commit -m "adding $TRAVIS_COMMIT for $MIRAGE_BACKEND"
  git push
fi
