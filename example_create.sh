#!/bin/sh
# - Makes index for repositories in a single directory.
# - Makes static pages for each repository directory.
#
# NOTE, things to do manually (once) before running this script:
# - copy style.css, logo.png and favicon.png manually, a style.css example
#   is included.
#
# - write clone url, for example "git://git.codemadness.org/dir" to the "url"
#   file for each repo.
# - write owner of repo to the "owner" file.
# - write description in "description" file.
#
# Usage:
# - mkdir -p htmldir && cd htmldir
# - sh example_create.sh

# path must be absolute
reposdir="/srv/git"
webdir="/srv/git/html"
defaultdir="/usr/local/share/doc/stagit"

mkdir -p "$webdir" || exit 1

# set assets if not already there
ln -s "$defaultdir/style.css" "$webdir/style.css" 2> /dev/null
ln -s "$defaultdir/logo.png" "$webdir/logo.png" 2> /dev/null
ln -s "$defaultdir/favicon.png" "$webdir/favicon.png" 2> /dev/null

# clean
for dir in "$webdir/"*/; do
    rm -rf "$dir"
done

repos=""

# make files per repo
for dir in "$reposdir/"*.git/; do
    [ ! -f "$dir/git-daemon-export-ok" ] && continue
    repos="$repos $dir"

    # strip .git suffix
    r=$(basename "$dir")
    d=$(basename "$dir" ".git")
    printf "%s... " "$d"

    mkdir -p "$webdir/$d"
    cd "$webdir/$d" || continue
    stagit -c ".stagit-build-cache" "$reposdir/$r"

    # symlinks
    [ -f "about.html" ] \
        && ln -sf about.html index.html \
        || ln -sf log.html index.html
    ln -sf "$reposdir/$r" ".git"

    echo "done"
done

# make index
echo "$repos" | xargs stagit-index > "$webdir/index.html"
