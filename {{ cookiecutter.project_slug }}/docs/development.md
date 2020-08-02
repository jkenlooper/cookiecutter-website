# Local Development Guide

Get a local development version of the website to run on your machine by
following these instructions.

Written for a Linux machine that is Debian based. Only tested on 
[Ubuntu 18.04.4 LTS (Bionic Beaver)](http://releases.ubuntu.com/18.04/).
It is recommended to use a virtual machine of some sort to keep dependencies for
the website services isolated and manageable. Some virtualization software suggestions
are listed below.

- [VirtualBox](https://www.virtualbox.org/) - can be used with Vagrant.
- [Vagrant](https://www.vagrantup.com/) - a Vagrantfile has already been made.
- [KVM](https://wiki.debian.org/KVM) - Kernel Virtual Machine is available for
  Linux machines.

<dl>
  <dt>local machine</dt>
  <dd>
  This is your own computer (localhost) that you edit source files on using your
  text editor or IDE of choice.
  </dd>
  <dt>development machine</dt>
  <dd>
  The Ubuntu 18 machine that will be setup to run the website services.
  Source files will be uploaded to it from the local machine each time they
  change. This is commonly a virtual machine, but can be localhost. You should
  have ssh access to it and have permissions to add a dev user.
  </dd>
</dl>

Update your `/etc/hosts` to have local-{{ cookiecutter.project_slug }} map to your development machine. This IP can either be localhost (127.0.0.1) or the IP of a virtual
machine. It is recommended that access to this development machine should be
limited so be careful if you use a development machine that is hosted in the
cloud. The local development version of the website will be at
http://local-{{ cookiecutter.project_slug }}/ . If using vagrant for the virtual machine then
you'll need to use the 8080 port http://local-{{ cookiecutter.project_slug }}:8080/ . 

Append "127.0.0.1 local-{{ cookiecutter.project_slug }}" to your `/etc/hosts` file on the local
machine (not the development machine). You'll then be able to access your local
version of the site at the http://local-{{ cookiecutter.project_slug }}/ URL. If installed on
a virtual machine; then change the 127.0.0.1 to that IP of the virtual machine.
This IP can be found by logging into the virtual machine and using this command:
`ip -4 -br addr show`

```bash
# Update 127.0.0.1 to be the IP of the development machine
echo "127.0.0.1 local-{{ cookiecutter.project_slug }}" >> /etc/hosts
```

## Initial setup

Open a terminal
and `cd` to the projects directory. The project directory or folder is usually the same
name as the git repo that was cloned ({{ cookiecutter.project_slug }}).

The instructions shown here assume that you are logged into a Linux system
(`uname -o`) and are running Ubuntu 18 (`lsb_release -a`).

### Create `dev` user and project source directory

Use `ssh` to login into the development machine either as root 
(`ssh root@local-{{ cookiecutter.project_slug }}`)
or as a user that has `sudo`
permissions.

Example ways of logging into the development machine using `ssh`.
```bash
# As root user
ssh root@local-{{ cookiecutter.project_slug }};

# Or with a vagrant setup
vagrant ssh;
```

Create the `dev` user for the development machine. This user will own the sqlite
database among other things. There are other commands that set up ssh and adds
your public key to your virtual machine. See the bin/init.sh for that if you are
using a separate machine (virtual machine) as your development machine.

While logged into the development machine.

```bash
# Run only some commands from bin/init.sh to create the 'dev' user:
sudo adduser dev
# Set the user to have sudo privileges by placing in the sudo group
sudo usermod -aG sudo dev
```

Create the initial source directory that files will be `rsync`ed to on the
development machine.

```bash
sudo mkdir -p /usr/local/src/{{ cookiecutter.project_slug }};
sudo chown dev:dev /usr/local/src/{{ cookiecutter.project_slug }};
```

Logout (exit) from the development machine. Most of the time this will be
implied in the different sections of this guide.

```bash
# Get back to your local machine by exiting the development machine.
exit;
```

### Add initial files to `/usr/local/src/{{ cookiecutter.project_slug }}`

Development can be done with any text editor or IDE that you are comfortable
with. To better match a production environment the project's source files are
copied over to the 
/usr/local/src/{{ cookiecutter.project_slug }}/ 
directory on the development machine.

The `bin/devsync.sh` script is a wrapper around `rsync` that will upload the
source files to the development machine. The destination path is by default the 
`/usr/local/src/{{ cookiecutter.project_slug }}/`
directory that was created when the dev user was made.

```bash
# On the local machine
./bin/devsync.sh;
```

### Install dependencies

Should be logged into the development machine

```bash
ssh dev@local-{{ cookiecutter.project_slug }};
```

Run the initial setup script that will install many of the dependencies with
apt-get the Debian based package manager. 

```bash
# Install other software dependencies with apt-get.
sudo ./bin/setup.sh;
```

### Create local SSL certs (optional)

Should be logged into the development machine

```bash
ssh dev@local-{{ cookiecutter.project_slug }};
```

To have TLS (SSL) on your development machine run the
`provision-local-ssl-certs.sh` script. That will use `openssl` to create some
certs in the web/ directory. The `localhost-CA.pem` file that is created in the
home directory by default should be imported to Keychain Access and marked as
always trusted. The Firefox web browser will require importing the
`localhost-CA.pem` certificate authority file.

```bash
cd /usr/local/src/{{ cookiecutter.project_slug }}/;
./bin/provision-local-ssl-certs.sh
```

### Create the `.env` and `.htpasswd` files

Use these scripts to create the `.env` file and the `.htpasswd` file. These should
**not** be added to the distribution or to source control (git). Edit them as
needed for your use case. They should both stay within the project's directory.

Run these on the _local machine_ from within the project's directory (use `exit`
command if still logged into development machine).

```bash
# Creates the .env file
./bin/create_dot_env.sh;

# Creates the .htpasswd file
./bin/create_dot_htpasswd.sh;
```

## Setup For Building

The website apps are managed as
[systemd](https://freedesktop.org/wiki/Software/systemd/) services.
The service config files are created by running `make` and installed with
`sudo make install`. It is recommended to use Python's `virtualenv . -p python3`
and activating each time for a new shell with `source bin/activate` before
running `make`.

Some git commit hooks are installed and rely on commands to be installed to
format the python code (black) and format other code (prettier). Committing
before following the below setup will result in an error if these commands
haven't been installed on the development machine.

### Install `nvm`

If `nvm` isn't available on the dev machine then install it. See
[github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm) for more
information.

Run these on the local machine from within the project's directory.

```bash
# Install Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
source ~/.bashrc

# Install and use the version set in .nvmrc
nvm install
nvm use
```

### Initialize the project

On the local machine install dependencies for prettier and black. These tools
are needed to autoformat the changed code before committing. The `virtualenv`
can be installed on your local machine with a package manager
(`sudo apt-get install virtualenv`). 
Or skip using virtualenv and create one with `python3 -m venv .` .

```bash
# Setup to use a virtual python environment
virtualenv . -p python3;
source bin/activate;

# Install black to format python code when developing
pip install black;

# Install build dependencies with npm
nvm use;
npm install;

# Checkout any git submodules in this repo if didn't
# `git clone --recurse-submodules ...`.
git submodule init;
git submodule update;

# Build the dist files for local development
npm run build;

# Upload the changes to the development machine
./bin/devsync.sh
```

### Initialize the development machine

Should be logged into the development machine.

```bash
ssh dev@local-puzzle-massive;
```

```bash
cd /usr/local/src/puzzle-massive/;

# Setup to use a virtual python environment
virtualenv . -p python3;
source bin/activate;

# Makes the initial development version
make;

# Install the files that were compiled.
sudo make install;

# Test and reload the nginx configurations
sudo nginx -t;
sudo systemctl reload nginx;

# Monitor the logs
sudo ./bin/log.sh;
```

### Building the `dist/` files

The javascript and CSS files in the `dist/` directory are built from the source
files in `src/` by running the `npm run build` command. This uses
[webpack](https://webpack.js.org/) and is configured with the
`webpack.config.js`. The entry file is `src/index.js` and following that the
main app bundle (`app.bundle.js`, `app.css`) is built from
`src/app.js`.

The source files for javascript and CSS are organized mostly as components. The
`src/site/` being an exception as it includes CSS and javascript used across the
whole site. Each component includes its own CSS (if applicable) and the CSS
classes follow the
[SUIT CSS naming conventions](https://github.com/suitcss/suit/blob/master/doc/naming-conventions.md).

When editing files in `src/` either run `npm run debug` or `npm run watch`. The
production version is done with `npm run build` which will create compressed
versions of the files. To upload the just compiled files in the `dist/`
directory use the `bin/devsync.sh` command.

```bash
# Build the dist files and rsync them to the development machine
npm run debug && ./bin/devsync.sh;

# Or watch for changes in src/, build, and rsync to development machine
./bin/distwatch.mjs &
npm run watch;
pkill --full -u $(whoami) "\./bin/distwatch\.mjs";
```

## Creating a versioned dist for deployment

After making any changes to the source files; commit those changes to git in
order for them to be included in the distribution file. The distribution file
is uploaded to the server and the guide to do deployments should then be
followed.

To create the versioned distribution file (like `{{ cookiecutter.project_slug }}-{{ cookiecutter.version }}.tar.gz`) use the
`make dist` command.  Note that the version is set in the `package.json`.

The script to create the distribution file only includes the files that have
been committed to git. It will also limit these to what is listed in the
`MANIFEST`.

## Committing database data to source control

Any data that is required for the site to operate should be stored along with
the source files. Chill specific data is stored as `chill-data.yaml` and any
other `chill-data-*.yaml` files. Other data that chill would query for should be
stored in a `site-data.sql` file. The `bin/create-site-data-sql.sh` can be
edited and run when needed in development. It should export database table data
to the `site-data.sql` file. The `site-data.sql` should be committed to source
control and will be used when deploying the site to a server.

The `chill-data.yaml` and `chill-data-*.yaml` files can be manually edited or
recreated by running the `chill dump` command. The dump command will export
chill specific data to these files.

It is good practice to dump feature branch specific chill data to separate files
like `chill-data-[feature-name].yaml`. That way those changes will not conflict
with other changes that may be committed to `chill-data.yaml`. When the feature
branch has been merged to the develop branch, the
`chill-data-feature-[feature-name].yaml` file contents should be appended to the
`chill-data.yaml` file. The `chill-data-feature-[feature-name].yaml` file should
then be removed.

The `chill-data-feature-[feature-name].yaml` file should also be edited to
_only_ include changes that are being added for that feature branch.

On updates to any `chill-data*.yaml` or `site-data.sql` files; run the below
commands to reload the chill database.

```bash
# stop the apps first
sudo ./bin/appctl.sh stop;

# Builds new db.dump.sql
make;

# Update the database with what is in db.dump.sql
sudo make install;
```

## Uninstalling the app

Run the below commands to remove {{ cookiecutter.project_slug }} from your
development machine.  This will uninstall and disable the services, remove any
files installed outside of the project's directory including the sqlite3
database. _Only do this on a development machine if it's database and other
data is no longer needed._

```bash
source bin/activate;
sudo ./bin/appctl.sh stop;

# Removes any installed files outside of the project
sudo make uninstall;

# Remove files generated by make
make clean;
deactivate;

# Remove any source files and directories that are ignored by git...
# Swap -n for -f for deleting files
git clean -dX -n

# ...or just clean up and preserve some files.
# Swap -n for -f for deleting files
git clean -dx -e /.htpasswd -e /.env -e /.has-certs -e /web -n

# Removes all data including the sqlite3 database
sudo rm -rf /var/lib/{{ cookiecutter.project_slug }}/
```

## Regenerating with cookiecutter

Get the latest changes from the cookiecutter that initially generated the
project
([jkenlooper/cookiecutter-website](https://github.com/jkenlooper/cookiecutter-website))
by uninstalling the app, running the cookiecutter in a different directory, and
then rsync the changed files back in. Use `git` to then patch files as needed.

```bash
now=$(date --iso-8601 --utc)
# In the project directory of {{ cookiecutter.project_slug }}.
cd ../;
mkdir {{ cookiecutter.project_slug }}--${now};
cd {{ cookiecutter.project_slug }}--${now};

# Regenerate using last entered config from initial project.  Then git clean the
# new project files that were just created.
cookiecutter \
  --config-file ../{{ cookiecutter.project_slug }}/.cookiecutter-regen-config.yaml \
  gh:jkenlooper/cookiecutter-website renow=${now};
cd {{ cookiecutter.project_slug }};
git clean -fdx;

# Back to parent directory
cd ../../;

# Create backup tar of project directory before removing all untracked files.
tar --auto-compress --create --file {{ cookiecutter.project_slug }}-${now}.bak.tar.gz {{ cookiecutter.project_slug }};
cd {{ cookiecutter.project_slug }};
git clean -fdx --exclude=.env --exclude=.htpasswd;
cd ../;

# Use rsync to copy over the generated project 
# ({{ cookiecutter.project_slug }}--${now}/{{ cookiecutter.project_slug }})
# files to the initial project.
# This will delete all files from the initial project.
rsync -a \
  --itemize-changes \
  --delete \
  --exclude=.git/ \
  --exclude=.env \
  --exclude=.htpasswd \
  {{ cookiecutter.project_slug }}--${now}/{{ cookiecutter.project_slug }}/ \
  {{ cookiecutter.project_slug }}

# Remove the generated project after it has been rsynced.
rm -rf {{ cookiecutter.project_slug }}--${now};

# Patch files (git add) and drop changes (git checkout) as needed.
# Refer to the backup {{ cookiecutter.project_slug }}-${now}.bak.tar.gz
# if a file or directory that was not tracked by git is missing.
cd {{ cookiecutter.project_slug }};
git add -i .;
git checkout -p .;
```
