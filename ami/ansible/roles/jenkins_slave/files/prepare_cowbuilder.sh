#!/bin/bash

set -e

distri=${1:-trixie}
arch=${2:-amd64}
UPDATE=${UPDATE:-true}

export distribution=${distri} # for usage in pbuilderrc

prepare_cowbuilder() {
  if ! [ -d "/var/cache/pbuilder/base-${distri}-${arch}.cow" ] ; then
    (
      # shellcheck disable=SC2030
      export architecture=${arch} # for usage in pbuilderrc
      # shellcheck disable=SC1091
      source /etc/jenkins/pbuilderrc
      eatmydata cowbuilder --create \
        --basepath "/var/cache/pbuilder/base-${distri}-${arch}.cow" \
        --distribution "${distri}" --debootstrapopts --arch \
        --debootstrapopts "${arch}" --debootstrapopts --variant=buildd \
        --configfile=/etc/jenkins/pbuilderrc \
        --mirror "${MIRRORSITE}" \
        --othermirror="${OTHERMIRROR}"
    )
  else
    if $UPDATE ; then
      echo "!!! Executing update for cowbuilder as requested !!!"
      (
        # shellcheck disable=SC2031
        export architecture=${arch} # for usage in pbuilderrc
        # shellcheck disable=SC1091
        source /etc/jenkins/pbuilderrc
        eatmydata cowbuilder --update \
          --basepath "/var/cache/pbuilder/base-${distri}-${arch}.cow" \
          --distribution "${distri}" \
          --configfile=/etc/jenkins/pbuilderrc \
          --mirror "${MIRRORSITE}" \
          --othermirror="${OTHERMIRROR}" --override-config
      )
    else
      echo "!!! /var/cache/pbuilder/base-${distri}-${arch}.cow exists already (execute '$0 --update' to refresh it) !!!"
    fi
  fi

  if $UPDATE ; then
    echo "!!! (Re)creating tarballs for piuparts usage as requested !!!"
    echo "Creating /var/cache/pbuilder/base-${distri}-${arch}.tgz for piuparts usage"
    pushd "/var/cache/pbuilder/base-${distri}-${arch}.cow" >/dev/null
    tar acf "/var/cache/pbuilder/base-${distri}-${arch}.tgz" ./*
    popd >/dev/null
  else
    if [ -r "/var/cache/pbuilder/base-${distri}-${arch}.tgz" ] ; then
      echo "!!! /var/cache/pbuilder/base-${distri}-${arch}.tgz exists already (execute '$0 --update' to force (re)building) !!!"
    else
      echo "Creating /var/cache/pbuilder/base-${distri}-${arch}.tgz for piuparts usage"
      pushd "/var/cache/pbuilder/base-${distri}-${arch}.cow" >/dev/null
      tar acf "/var/cache/pbuilder/base-${distri}-${arch}.tgz" ./*
      popd >/dev/null
    fi
  fi
}

for arch in ${arch} ; do
  prepare_cowbuilder
done
