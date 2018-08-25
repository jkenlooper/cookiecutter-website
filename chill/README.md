# Chill app for llama3-weboftomorrow-com

The llama3-weboftomorrow-com-chill.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp llama3-weboftomorrow-com-chill.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start llama3-weboftomorrow-com-chill
sudo systemctl enable llama3-weboftomorrow-com-chill
```

Stop the service.

```
sudo systemctl stop llama3-weboftomorrow-com-chill
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT=llama3-weboftomorrow-com-chill.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT=llama3-weboftomorrow-com-chill.service
```

View details about service.

```
sudo systemctl show llama3-weboftomorrow-com-chill
```

Check the status of the service.

```
sudo systemctl status llama3-weboftomorrow-com-chill.service
```

Reload if llama3-weboftomorrow-com-chill.service file has changed.

```
sudo systemctl daemon-reload
```
