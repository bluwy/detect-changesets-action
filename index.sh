#!/bin/bash

# If .changeset doesn't exist, do a fast path
if [ ! -d .changeset ]; then
  echo "has-changesets=false" >> "$GITHUB_OUTPUT"
  echo "changesets=[]" >> "$GITHUB_OUTPUT"
  exit 0
fi

# Get all .md files in the .changeset folder and construct list a
list_a=($(find .changeset -name '*.md' ! -name 'README.md' -exec basename {} .md \;))

# Initialize list b
list_b=()

# Check if .changeset/pre.json exists
if [ -f .changeset/pre.json ]; then
  # Read the changesets key from .changeset/pre.json and construct list b
  list_b=($(jq -r '.changesets[]' .changeset/pre.json))
fi

# Remove items in list b from list a
for item in "${list_b[@]}"; do
  list_a=("${list_a[@]/$item}")
done

# Remove empty elements from list a
list_a=($(echo "${list_a[@]}" | tr ' ' '\n' | grep -v '^$'))

# Check if list a still has any items
if [ ${#list_a[@]} -eq 0 ]; then
  echo "has-changesets=false" >> "$GITHUB_OUTPUT"
  echo "changesets=[]" >> "$GITHUB_OUTPUT"
else
  echo "has-changesets=true" >> "$GITHUB_OUTPUT"
  echo "changesets=$(printf '%s\n' "${list_a[@]}" | jq -R . | jq -sc .)" >> "$GITHUB_OUTPUT"
fi
