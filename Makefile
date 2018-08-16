MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(dir $(mkfile_path))

# Local pip is used by creating virtualenv and running `source ./bin/activate`

#    all: the name of the default target
#    check: runs tests, linters, and style enforcers
#    clean: removes files created by all
#    install:
#    uninstall: undoes what install did

# Workflow should be:
# sudo ./init.sh; # Sets up a new ubuntu server with base stuff and dev user
# sudo ./scripts/setup.sh # should only need to be run once
# virtualenv .;
# source ./bin/activate;
# make ENVIRONMENT=development;
# sudo make ENVIRONMENT=development install;
#
# sudo make ENVIRONMENT=development uninstall;
# make ENVIRONMENT=development clean;
#

#Use order only prerequisites for making directories

# Set to tmp/ when debugging the install
# make PREFIXDIR=${PWD}/tmp inspect.SRVDIR
# make PREFIXDIR=${PWD}/tmp ENVIRONMENT=development install
PREFIXDIR :=
# Set to development or production
ENVIRONMENT := development
SRVDIR := $(PREFIXDIR)/srv/llama3-weboftomorrow-com/
NGINXDIR := $(PREFIXDIR)/etc/nginx/
SYSTEMDDIR := $(PREFIXDIR)/etc/systemd/system/
DATABASEDIR := $(PREFIXDIR)/var/lib/llama3-weboftomorrow-com/sqlite3/

# For debugging what is set in variables
inspect.%:
	@echo $($*)

ifeq ($(shell which virtualenv),)
$(error run "./scripts/setup.sh" to install virtualenv)
endif
ifeq ($(shell ls bin/activate),)
$(error run "virtualenv .")
endif
ifneq ($(shell which pip),$(project_dir)bin/pip)
$(warning run "source bin/activate" to activate the virtualenv. Using $(shell which pip). Ignore this warning if using sudo make install.)
endif

# Always run.  Useful when target is like targetname.% .
# Use $* to get the stem
FORCE:

.PHONY: all
all: bin/chill site.cfg web/llama3-weboftomorrow-com.conf

.PHONY: install
install:
	mkdir -p $(SYSTEMDDIR);
	./scripts/chill.service.sh $(project_dir) llama3-weboftomorrow-com-chill > $(SYSTEMDDIR)llama3-weboftomorrow-com-chill.service
	-systemctl start llama3-weboftomorrow-com-chill
	-systemctl enable llama3-weboftomorrow-com-chill
	./scripts/install.sh $(SRVDIR) $(NGINXDIR)

# Remove any created files in the src directory which were created by the
# `make all` recipe.
.PHONY: clean
clean:
	rm site.cfg
	pip uninstall --yes -r requirements.txt

# Remove files placed outside of src directory and uninstall app.
.PHONY: uninstall
uninstall:
	-systemctl stop llama3-weboftomorrow-com-chill
	-systemctl disable llama3-weboftomorrow-com-chill
	rm $(SYSTEMDDIR)llama3-weboftomorrow-com-chill.service
	./scripts/uninstall.sh $(SRVDIR) $(NGINXDIR)

#####

bin/chill: requirements.txt
	pip install -r requirements.txt
	touch $@;

site.cfg: site.cfg.sh
	./site.cfg.sh $(ENVIRONMENT) $(DATABASEDIR) > $(project_dir)site.cfg

web/llama3-weboftomorrow-com.conf: web/llama3-weboftomorrow-com.conf.sh
	./$^ $(ENVIRONMENT) > $@

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
