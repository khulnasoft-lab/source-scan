#!/bin/bash
# shellcheck disable=SC2044
# This is a test script to perform a test against a single repo

TAG=$2

if [ ${#TAG} -gt 0 ] ; then
  echo "Testing: ${TAG}"  
  docker run -it -e SNYK_TOKEN source-scan:"${TAG}" --test --target . --remote-repo-url https://github.com/khulnasoft-lab/source-scan --test-count $1
else
  for FILENAME in $(find . -type f -name 'Dockerfile-*'); do
    TAG=${FILENAME#*-}
    # we can't assume that the testrepo is in every path, so we assume we set workdir in the image to the testrepo we want to use 
    # in a pipeline usually the container is mounted in the root of the repo, so this mimics that setup
    echo "Testing: ${TAG}"
    docker run -it -e SNYK_TOKEN source-scan:"${TAG}" --test --target . --remote-repo-url https://github.com/khulnasoft-lab/source-scan --test-count $1
    echo ""
  done
fi
