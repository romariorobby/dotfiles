TMPDIR = /tmp/home
CM_VERSION = $(shell chezmoi --version | grep -Eo 'v[0-9].{1,5}' | sed 's/v//')

all:
	@echo "[MAIN] installing chezmoi destination dir to \`$$HOME\`"
	@echo -n "Are you sure you wanna continue? [y/N] " && read ans && [ $${ans:-N} = y ]
	@export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"  && \
		echo "Set PASSWORD_STORE_DIR => \`${PASSWORD_STORE_DIR}\`" && sleep 2 && \
		chezmoi init --apply --refresh-externals --verbose --force $$@

test:
	@echo "[DEBUG] installing chezmoi destination dir to \`${TMPDIR}\`"
	@echo -n "Are you sure you wanna continue? [y/N] " && read ans && [ $${ans:-N} = y ]
	@mkdir -pv ${TMPDIR}
	@export PASSWORD_STORE_DIR="$HOME/.local/share/password-store" && \
		echo "Set PASSWORD_STORE_DIR => \`${PASSWORD_STORE_DIR}\`" && sleep 2 && \
		CM_DEBUG=1 chezmoi -D ${TMPDIR} init --apply --refresh-externals --verbose --force $$@

test-clean:
	@rm -rfv ${TMPDIR}

check:
	@echo -n "Are you sure wanna continue this? [y/N] " && read ans && [ $${ans:-N} = y ]

genv:
	@echo ${CM_VERSION} | tee .chezmoiversion
