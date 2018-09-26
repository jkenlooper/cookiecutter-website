# {{ cookiecutter.project_name }}

{{ cookiecutter.project_short_description }}

This site is hosted at [{{ cookiecutter.site_domain }}]({{ cookiecutter.site_protocol }}://{{ cookiecutter.site_domain }}).

The deployment and structure has been generated from this [cookiecutter](https://github.com/jkenlooper/cookiecutter-website).

Written for a Linux machine that is Debian based.  Only tested on Ubuntu.  Use
 [VirtualBox](https://www.virtualbox.org/) or something similar if not on
 a Linux machine.

## Get started

Run the `bin/init.sh` script to configure the server with ssh and a user if needed.

The `bin/setup.sh` is used to install dependencies for the server.

To have TLS (SSL) on your development machine run the `bin/provision-local.sh`
script. That will use `openssl` to create some certs in the web/ directory.
The rootCA.pem should be imported to Keychain Access and marked as always trusted.

## Development

The website apps are managed as 
[systemd](https://freedesktop.org/wiki/Software/systemd/) services.
The service config files are created by running `make` and installed with 
`sudo make install`.  It is recommended to use Python's `virtualenv .`
and activating each time for a new shell with `source bin/activate` before
running `make`.

In summary:

```
virtualenv .;
source bin/activate;
make;
sudo make install;
```


## Deploying on a production server

The `bin/init.sh` creates a dev user that could be used to ssh to the server.
It is recommended to create a versioned distribution with `make dist`.  That tar
file can then be uploaded to the server and expanded into /usr/local/src/ directory 
(`tar --directory=/usr/local/src/ --extract --gunzip -f 0.3.1.tar.gz`).

A similar workflow from development except the ENVIRONMENT should be passed to
the Makefile.  

```
virtualenv .;
source bin/activate;
make ENVIRONMENT=production;
sudo make ENVIRONMENT=production install;
```

Run the `bin/provision-certbot.sh /srv/{{ cookiecutter.project_slug }}/`
script to set up a production server with TLS certs.
[certbot](https://certbot.eff.org/) is used to
deploy [Let's Encrypt](https://letsencrypt.org/) certificates.
