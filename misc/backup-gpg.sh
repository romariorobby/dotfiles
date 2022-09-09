#!/bin/sh
. $HOME/.local/share/chezmoi/misc/utils.sh

outdir="$(chezmoi source-path)/private_dot_local/private_share/encrypted"
outfilename="gnupg-$(date +%y%m%d-T%H%M).tar.gz"
[ ! -d "$HOME/.gnupg" ] && die "GPG: $HOME/.gnupg directory not found. there's nothing to backup.."

tar czf $outdir/$outfilename -C $HOME .gnupg
gpg --quiet --armor --symmetric $outdir/$outfilename 2>/dev/null && suc "Backup Done and Encrypted to $outdir/$outfilename.asc" || \
    { rm -f $outdir/$outfilename; die "GPG: Something went wrong"; }
# Clean up
rm -f $outdir/$outfilename
