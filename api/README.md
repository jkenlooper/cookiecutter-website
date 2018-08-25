# API for Llama3 Weboftomorrow com

The llama3-weboftomorrow-com-api.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp llama3-weboftomorrow-com-api.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start llama3-weboftomorrow-com-api
sudo systemctl enable llama3-weboftomorrow-com-api
```

Stop the service.

```
sudo systemctl stop llama3-weboftomorrow-com-api
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT=llama3-weboftomorrow-com-api.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT=llama3-weboftomorrow-com-api.service
```

View details about service.

```
sudo systemctl show llama3-weboftomorrow-com-api
```

Check the status of the service.

```
sudo systemctl status llama3-weboftomorrow-com-api.service
```

Reload if llama3-weboftomorrow-com-api.service file has changed.

```
sudo systemctl daemon-reload
```

