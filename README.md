# ARK
Simple ark server.

## Running the server
```bash
docker run --detach --name ark --publish 27500:27500/udp --publish 27015:27015/udp hetsh/ark
```

## Stopping the container
```bash
docker stop ark
```

## Configuring Maps
Maps (worlds) are configured via environment variables `WORLD_TYPE` and `WORLD_NAME` with default values `Moon` and `Base`.
To create a new world use additional parameters (Mars only example) `--env WORLD_TYPE=Mars --env WORLD_NAME=MarsBase` when launching the container.
If `WORLD_NAME` already exists, the save is loaded instead and `WORLD_TYPE` is ignored.

## Creating persistent storage
```bash
MP="/path/to/storage"
mkdir -p "$MP"
chown -R 1358:1358 "$MP"
```
`1358` is the numerical id of the user running the server (see Dockerfile).
Start the server with the additional mount flag:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/ark ...
```

## Automate startup and shutdown via systemd
```bash
systemctl enable ark@<world> --now
```
The systemd unit can be found in my [GitHub](https://github.com/Hetsh/docker-ark) repository.
Individual server instances are distinguished by world.
By default, the systemd service assumes `/srv/ark_<world>` for persistent storage.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-ark)). Please feel free to ask questions, file an issue or contribute to it.