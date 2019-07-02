# Local Development Guide

Get a local development version of the website to run on your machine by
following these instructions.

Written for a Linux machine that is Debian based.  Only tested on Ubuntu.  Use
 [VirtualBox](https://www.virtualbox.org/) and
 [Vagrant](https://www.vagrantup.com/) or something similar if not on a Linux
 machine.

If using Vagrant; then run `vagrant up` and ssh in (`vagrant ssh`) and go to
the /vagrant/ shared directory when running the rest of the commands.

Run the `bin/init.sh` script to configure the server with ssh and a user if
needed.  Don't need to run this if using Vagrant.

The `bin/setup.sh` is used to install dependencies for the server.

To have TLS (SSL) on your development machine run the `bin/provision-local.sh`
script. That will use `openssl` to create some certs in the web/ directory.
The rootCA.pem should be imported to Keychain Access and marked as always trusted.

The website apps are managed as 
[systemd](https://freedesktop.org/wiki/Software/systemd/) services.
The service config files are created by running `make` and installed with 
`sudo make install`.  It is recommended to use Python's `virtualenv . -p python3`
and activating each time for a new shell with `source bin/activate` before
running `make`.

The db file is owned by dev with group dev.  If developing with
a different user then run `adduser nameofuser dev` to include the 'nameofuser'
to the dev group.

If using Vagrant then change the password for dev user and login as that user.

```bash
sudo passwd dev;
su dev;
```

Create the `.env` and `.htpasswd` files.  These should not be added to the
distribution or to source control (git).

```bash
echo "EXAMPLE_PUBLIC_KEY=fill-this-in" > .env;
echo "EXAMPLE_SECRET_KEY=fill-this-in" >> .env;
htpasswd -c .htpasswd admin;
```

When first installing on the dev machine run:

```bash
virtualenv . -p python3;
source bin/activate;
make;

# Build the dist files for local development
# TODO: uncomment if needing to build static files
#npm install;
#npm run build;

sudo make install;
sudo systemctl reload nginx
```

Update `/etc/hosts` to have local-{{ cookiecutter.project_slug }} map to your machine.
Access your local development version of the website at
http://local-{{ cookiecutter.project_slug }}/ .  If using vagrant you'll need to use the
8080 port http://local-{{ cookiecutter.project_slug }}:8080/ .
