TMPDIR = /tmp/home
CM_VERSION = $(shell chezmoi --version | grep -Eo 'v[0-9].{1,5}' | sed 's/v//')

help:
	@echo "Make for chezmoi"
	@echo "Usage: make <RECIPE> <ENV>"
	@echo
	@echo "Recipe:"
	@echo " make help     show this help"
	@echo " make main     install all"
	@echo " make test     testing HOME=/tmp/home"
	@echo " make remove-target       remove all target"
	@echo " make remove-target-test  remove all target test"
	@echo " make backup-gpg    backup gpg and put in automatically in chezmoi directory .local/share/encrypted"
	@echo
	@echo "Environment Variable:"
	@echo " CM_PROFILE         <string> select profile [server/headless,base,minimal,full]"
	@echo " CM_PASSMGR         <string> select password manager [bitwarden,pass]"
	@echo "                    choose \`pass\` would automatically set \`CM_ENCRYPTOOL\` to \`GPG\`"
	@echo
	@echo " CM_ENCRYPTOOL      <string> select encryption program [gpg,age]"
	@echo " CM_ASK             prompt (username,git,etc)"
	@echo " CM_NAME            <string> username"
	@echo " CM_GIT_NAME        <string> git name"
	@echo " CM_GIT_EMAIL       <string> git email"
	@echo " CM_GITHUB_NAME     <string> github username"
	@echo " CM_GITHUB_TOKEN    <string> github token for authentication with password "
	@echo " CM_LOG             <boolean> create log for chezmoiscripts (~/.cache/chezmoi/install.log)"
	@echo
	@echo "Example:"
	@echo ' make main CM_TYPE=minimal CM_LOG=true CM_GITHUB_TOKEN=<TOKEN> CM_PASSMGR=pass'
main:
	@echo "[MAIN] installing chezmoi destination dir to \`$$HOME\`"
	@echo -n "Are you sure you wanna continue? [y/N] " && read ans && [ $${ans:-N} = y ]
	@export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"  && \
		echo "Set PASSWORD_STORE_DIR => \`${PASSWORD_STORE_DIR}\`" && sleep 2 && \
		chezmoi init --apply --refresh-externals --force $$@

test:
	@echo "[DEBUG] installing chezmoi destination dir to \`${TMPDIR}\`"
	@echo -n "Are you sure you wanna continue? [y/N] " && read ans && [ $${ans:-N} = y ]
	@mkdir -pv ${TMPDIR}
	@export PASSWORD_STORE_DIR="$HOME/.local/share/password-store" && \
		echo "Set PASSWORD_STORE_DIR => \`${PASSWORD_STORE_DIR}\`" && sleep 2 && \
		CM_DEBUG=1 chezmoi -D ${TMPDIR} init --apply --refresh-externals --verbose --force $$@

remove-target-test:
	@rm -rfv $(shell chezmoi managed | sed 's,\(^.\),/tmp/home/\1,g')

# Use with caution
remove-target:
	@rm -fv $(shell chezmoi managed --include=files,symlinks | sed 's,\(^.\),~/\1,g')

check:
	@echo -n "Are you sure wanna continue this? [y/N] " && read ans && [ $${ans:-N} = y ]

backup-gpg:
	@./misc/backup-gpg.sh

genv:
	@echo ${CM_VERSION} | tee .chezmoiversion

.PHONY: main remove-target remove-target-test test
