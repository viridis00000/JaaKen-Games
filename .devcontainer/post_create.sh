#!/bin/bash
echo "-----POST CREATE COMMAND START-----"

# Login to GitHub (can be skipped with Ctrl+C)
gh auth login -h github.com -p https -w
/app/.devcontainer/set_git_conig_from_gh.sh || true

echo "-----POST CREATE COMMAND END-----"
