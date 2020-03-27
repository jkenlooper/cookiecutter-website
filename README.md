# Cookiecutter for making a [chill](https://github.com/jkenlooper/chill) website

Version 0.1.0 <!-- Update cookiecutter.json generated_by_cookiecutter_website_version value as well. -->

Use the [python cookiecutter](https://github.com/cookiecutter/cookiecutter) to
create a new starter website and follow the prompts.

```
cookiecutter gh:jkenlooper/cookiecutter-website now=$(date --iso-8601 --utc)
```

Then read the README.md that was created along with all the other files.

## Features

- Documentation for development and deployment.
- Creates a production or development environment stack.
  - ubuntu-18.04
  - systemd
  - NGINX
  - Python 3
  - sqlite3
  - Flask
  - Chill
  - webpack

- Example Python API app in Flask.
- Database driven static website content created by chill.
- Example automated image processing using Makefiles and imagemagick.
- Client-side resources (Javascript, CSS) are built with webpack.
- Deployment files are all generated and isolated in a tar.gz file. This
  includes compiled CSS and Javascript files.
- CSS is structured to follow best practices.
- Uses [design-tokens]({{ cookiecutter.project_slug }}/design-tokens/README.md).
- HTML is rendered on server side via Jinja2 templates.
- Development can be done with a [Vagrant](https://www.vagrantup.com/) virtual machine using [VirtualBox](https://www.virtualbox.org/).
- Deployment includes setup for https:// support with [Let's Encrypt](https://letsencrypt.org/).
- Includes AWStats. <!-- TODO: replace AWStats with https://goaccess.io/ -->
- Changelog for keeping a history of version updates for the website.


**[Changelog since 0.1.0](CHANGELOG.md)**


[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
