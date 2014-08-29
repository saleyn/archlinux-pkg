#!/bin/bash -e

if [ $# -eq 0 ]; then
    echo "This script will erase stale git history"
    echo "Usage: ${0##*/} NumberOfCommitsToPreserve"
    exit 1
elif [ $1 -lt 0 -o $1 -gt 100 ]; then
    echo "Invalid parameter $1. Must be in range [0 ... 100]"
    exit 1
fi

last=$(( $1 - 1 ))

b="$(git br | awk '/^\*/{print $2}')"
h="$(git rev-parse $b)"

echo "Current branch: $b $h"

c="$(git rev-parse $b~$last)"

echo "Recreating $b branch with initial commit $c ..."

git checkout --orphan new-start $c
git commit -C $c
git rebase --onto new-start $c $b
git branch -d new-start
git gc
