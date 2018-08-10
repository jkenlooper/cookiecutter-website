MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

# Local pip is used by creating virtualenv and running `source ./bin/activate`

#    all: the name of the default target
#    check: runs tests, linters, and style enforcers
#    clean: removes files created by all
#    install:
#    uninstall: undoes what install did

# Workflow should be:
# ./init.sh; # Sets up a new ubuntu server with base stuff and dev user
# sudo make setup; # should only need to be run once
# virtualenv .;
# source ./bin/activate;
# make;
# sudo make install;
# sudo make install.development; OR make production;
#

#Use order only prerequisites for making directories

# Set to tmp/ when debugging the install.
# make PREFIXDIR=${PWD}/tmp inspect.SRVDIR
# make PREFIXDIR=${PWD}/tmp install.development
PREFIXDIR :=
SRVDIR := $(PREFIXDIR)/srv/llama3-weboftomorrow-com/
NGINXDIR := $(PREFIXDIR)/etc/nginx/

# For debugging what is set in variables
inspect.%:
	@echo $($*)

ifeq ($(shell which pip),)
$(error run "make setup" to install pip)
endif

# Always run.  Useful when target is like install.% .
FORCE:

.PHONY: all
all: bin/chill

# make install.development
# make install.production
install.%: FORCE
	./scripts/install.sh $* $(SRVDIR) $(NGINXDIR)

# Remove any created files in the src directory which were created by the
# `make all` recipe.
.PHONY: clean
clean:

# Remove files placed outside of src directory and uninstall app.
uninstall:
	./scripts/uninstall.sh

#TODO: Update init.sh so it can be run without interaction.  Rename to setup.sh.
setup: .setup
	./scripts/init.sh
	touch .setup


bin/chill: requirements.txt
	pip install -r requirements.txt
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
