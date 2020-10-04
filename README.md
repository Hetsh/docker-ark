# ARK
Simple to set up dedicated ARK server.

## Running the server
```bash
docker run --detach --name ark --publish 7777/udp --publish 27015/udp hetsh/ark
```

## Stopping the container
```bash
docker stop ark
```

## Updates
This image contains a specific version of the game and will not update on startup, this decreases starting time and disk space usage. Version number is the manifest id that can also be found on [SteamDB](https://steamdb.info/depot/376031/). This id and therefore the image on docker hub is updated hourly.

## Configuration
The ARK server can be configured with the configuration files in `/ark/Config/LinuxServer`. This [wiki](https://ark.gamepedia.com/Server_Configuration) contains an exhaustive list of adjustable parameters.
To switch maps use the parameter `--env MAP=<DesiredMap>` when launching the container.
More cli-only commands can be applied with parameter `--env SERVER_OPTS=<CLIOptions>`.

## Creating persistent storage
```bash
DATA="/path/to/data"
mkdir -p "$DATA"
chown -R 1366:1366 "$DATA"
```
`1366` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the data directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/data,target=/ark ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-ark).
```bash
systemctl enable ark@<map> --now
```
Individual instances are distinguished by map.
By default, the systemd service assumes `/apps/ark/<map>` for data and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-ark)).
Please feel free to ask questions, file an issue or contribute to it.