# Workflow should be:
# make;
# make install;
# make development; OR make production;

.PHONY: all install development production clean

#Use order only prerequisites for making directories

SRV_DIR := /srv/llama3-weboftomorrow-com
SRV_DIR := tmp/srv/llama3-weboftomorrow-com



ROOT_FILES := $(wildcard root/*)
SRVROOT_FILES := $(addprefix $(SRV_DIR)/,$(ROOT_FILES))

all: $(SRVROOT_FILES)

# Use rsync to sync each root/* file to the /srv/... directory.
# TODO: how to delete files no longer in root/ ?
$(SRV_DIR)/root/% : root/% | $(SRV_DIR)/root
	rsync --archive \
		--inplace \
		--itemize-changes \
		$< $@

$(SRV_DIR)/root:
	mkdir -p $@;
	chown -R dev:dev $@;

# all
# 	create (optimize, resize) media files from source-media
# 	install python apps using virtualenv and pip
# 	curl the awstats source or just include it?
#
# development
# 	create local server certs
# 	recreate dist files (npm run build). dist files will be rsynced back to
# 		local machine so they can be added in git.
# 	update any configs to be used for the development environment
#
# production
# 	run certbot certonly script (provision-certbot.sh)
# 	install crontab for certbot
# 	update nginx production config to uncomment certs?
#
# install
# 	create sqlite database file from db.dump.sql
# 		Only if db file is not there or has older timestamp?
# 	requires running as sudo
# 	install awstats and awstats.service
# 	create all directories
# 	rsync to all directories
# 	reload services if needed
#
