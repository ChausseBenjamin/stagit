#!/bin/sh
# generic git post-receive hook.
# change the config options below and call this script in your post-receive
# hook or symlink it.
#
# usage: $0 [name]
#
# if name is not set the basename of the current directory is used,
# this is the directory of the repo when called from the post-receive script.

# NOTE: needs to be set for correct locale (expects UTF-8) otherwise the
#       default is LC_CTYPE="POSIX".
export LC_CTYPE="en_US.UTF-8"

name="$1"
if test "${name}" = ""; then
    name=$(basename "$(pwd)")
fi

# paths must be absolute
reposdir="/srv/git"
dir="${reposdir}/${name}"
destdir="/srv/git/html"
cachefile=".stagit-build-cache"

if ! test -d "${dir}"; then
    echo "${dir} does not exist" >&2
    exit 1
fi
cd "${dir}" || exit 1

[ -f "${dir}/git-daemon-export-ok" ] || exit 0

# detect git push -f
force=0
while read -r old new ref; do
    test "${old}" = "0000000000000000000000000000000000000000" && continue
    test "${new}" = "0000000000000000000000000000000000000000" && continue

    hasrevs=$(git rev-list "${old}" "^${new}" | sed 1q)
    if test -n "${hasrevs}"; then
        force=1
        break
    fi
done

# strip .git suffix
r=$(basename "${name}")
d=$(basename "${name}" ".git")
printf "[%s] stagit HTML pages... " "${d}"

# remove folder if forced update
[ "${force}" = "1" ] && printf "forced update... " && rm -rf "${destdir}/${d}"

mkdir -p "${destdir}/${d}"
cd "${destdir}/${d}" || exit 1

# make pages
stagit -c "${cachefile}" "${reposdir}/${r}"
ln -sf log.html index.html
ln -sf "${dir}" .git

# make index
repos=""
for dir in "$reposdir/"*.git/; do
    [ -f "$dir/git-daemon-export-ok" ] && repos="$repos $dir"
done
echo "$repos" | xargs stagit-index > "${destdir}/index.html"

echo "done"
