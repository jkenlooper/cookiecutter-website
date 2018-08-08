# Workflow should be:
# make;
# make install;
# make development; OR make production;

SHELL=/bin/bash
.PHONY: all install development production clean rootfiles

#Use order only prerequisites for making directories

SRV_DIR := /srv/llama3-weboftomorrow-com
#SRV_DIR := tmp/srv/llama3-weboftomorrow-com

all: bin/chill

install: rootfiles

# Remove any created files in the src directory which were created by the
# `make all` recipe.
clean:

# Remove files placed outside of src directory and uninstall app.
uninstall:
	./scripts/uninstall.sh

# Run rsync everytime (rootfiles target is phony)
rootfiles: | $(SRV_DIR)/root
	@rsync --archive \
		--inplace \
		--delete \
		--exclude=.well-known \
		--itemize-changes \
		root/ $(SRV_DIR)/root/

$(SRV_DIR)/root:
	mkdir -p $@;
	chown -R dev:dev $@;

# Run rsync checksum on nginx default.conf since other sites might also update
# this file.
/etc/nginx/sites-available/default.conf : web/snippets/server--default-server-ignore-all-other.conf
	rsync --inplace \
		--itemize-changes \
		--dry-run \
		--checksum \
		$^ $@

/etc/nginx/sites-available/llama3-weboftomorrow-com.conf : web/web-nginx.development.conf
	rsync --inplace \
		--itemize-changes \
		--dry-run \
		$^ $@


# Build python apps and set virtualenv with pip
bin/chill: requirements.txt bin/pip
	./bin/pip install -r requirements.txt
	touch $@;

bin/pip:
	virtualenv .
	touch $@;



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
# 	install watcher service for changes to nginx confs that will reload
# 	create all directories
# 	rsync to all directories
# 	reload services if needed
#
