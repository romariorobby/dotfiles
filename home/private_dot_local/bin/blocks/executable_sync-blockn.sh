#!/bin/sh

. sb-config

# Program that intergrated with dwmblocks
# - sxhkd
# - blocks/

dwm_dir="$HOME/.local/src/dwmf"
dwmblocks_dir="$HOME/.local/src/dwmblocks-async"

blocks_changenum(){
	grep -q "$1 $2$" "$dwmblocks_dir"/blockn.h && printf "%s[$2] up to date\n" "$1" ||\
		(sed -Ei "s/($1)\s([0-9]+)/\1 $2/" "$dwmblocks_dir"/blockn.h && printf "%s\n" "set $1 -> $2") || printf "Cannot set: %s\n" "$1"
}

if [ -d "$dwmblocks_dir" ]; then
	# Sync statubar.hook (archlinux)
	blocks_changenum "BLOCKN_PACKAGE" "$BLOCKN_PACKAGE"
	if [ -f "$dwmblocks_dir/statusbar.hook" ]; then 
		(grep -q "\-RTMIN+$BLOCKN_PACKAGE" "$dwmblocks_dir/statusbar.hook" && printf "%s\n" "statusbar.hook[$BLOCKN_PACKAGE] up to date") \
			|| { printf "%s\n" "Update statusbar.hook -> $BLOCKN_PACKAGE"; sed -i "s/\(-RTMIN+\)\([0-9]\+\)/\1$BLOCKN_PACKAGE/" "$dwmblocks_dir"/statusbar.hook; }
	fi
	# Sync 

	blocks_changenum "BLOCKN_BATTERY" "$BLOCKN_BATTERY"
	blocks_changenum "BLOCKN_VOLUME" "$BLOCKN_VOLUME"
	blocks_changenum "BLOCKN_CLOCK" "$BLOCKN_CLOCK"
	blocks_changenum "BLOCKN_NEWS" "$BLOCKN_NEWS"
	
	# menurecord
	if [ -f "$HOME/.local/bin/menurecord" ]; then
		blocks_changenum "BLOCKN_RECORD" "$BLOCKN_RECORD"
		(grep -q "\-RTMIN+$BLOCKN_RECORD" "$HOME/.local/bin/menurecord" && echo "menurecord[$BLOCKN_RECORD] up to date") ||\
			{ sed -i "s/\(-RTMIN+\)\([0-9]\+\)/\1$BLOCKN_RECORD/" "$HOME/.local/bin/menurecord" && echo "Update menurecord -> $BLOCKN_RECORD"; }
	fi

fi
