#!/bin/sh

# version branch names in descending order
VERSIONS=(master v1.9 v1.8 v1.7 v1.6 v1.5 v1.4 v1.3 v1.2 v1.1)

# clean
git checkout master
make clean

# build each version in order
for i in "${VERSIONS[@]}"; do
    echo "Branch [$i]: Generating HTML and local directories"
    git checkout $i && git pull && make html publish
done

# Prompt in case errors encountered
read -p "Proceed with deploy? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

# deploy
for i in "${VERSIONS[@]}"; do
    echo "Deploying [$i]"
    git checkout $i && yes | make deploy
done

echo "Deployment complete!"
