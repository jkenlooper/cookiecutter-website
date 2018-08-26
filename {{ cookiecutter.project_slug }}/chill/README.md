# Chill app for {{ cookiecutter.project_slug }}

The {{ cookiecutter.project_slug }}-chill.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp {{ cookiecutter.project_slug }}-chill.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start {{ cookiecutter.project_slug }}-chill
sudo systemctl enable {{ cookiecutter.project_slug }}-chill
```

Stop the service.

```
sudo systemctl stop {{ cookiecutter.project_slug }}-chill
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT={{ cookiecutter.project_slug }}-chill.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT={{ cookiecutter.project_slug }}-chill.service
```

View details about service.

```
sudo systemctl show {{ cookiecutter.project_slug }}-chill
```

Check the status of the service.

```
sudo systemctl status {{ cookiecutter.project_slug }}-chill.service
```

Reload if {{ cookiecutter.project_slug }}-chill.service file has changed.

```
sudo systemctl daemon-reload
```
