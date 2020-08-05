FROM hetsh/steamcmd:1.1-14

# App user
ARG APP_USER="ark"
ARG APP_UID=1366
RUN useradd --uid "$APP_UID" --user-group --no-create-home --shell /sbin/nologin "$APP_USER"

# Application
ARG APP_ID=376030
ARG DEPOT_ID=376031
ARG MANIFEST_ID=1853580828081770768
ARG APP_DIR="$STEAM_DIR/linux32/steamapps/content/app_$APP_ID/depot_$DEPOT_ID"
RUN steamcmd.sh +login anonymous +download_depot "$APP_ID" "$DEPOT_ID" "$MANIFEST_ID" +quit && \
    touch "$APP_DIR/Engine/Config/Base.ini" && \
    chown -R "$APP_USER":"$APP_USER" "$APP_DIR"
# Creating empty Base.ini prevents game crashing on startup

# Volumes
ARG DATA_DIR="/ark"
RUN mkdir "$DATA_DIR" && \
    chown "$APP_USER":"$APP_USER" "$DATA_DIR" && \
    ln -s "$DATA_DIR" "$APP_DIR/ShooterGame/Saved"
VOLUME ["$DATA_DIR"]

#      GAME     RAW      QUERY     RCON
EXPOSE 7777/udp 7778/udp 27015/udp 27020/tcp

# Launch parameters
USER "$APP_USER"
WORKDIR "$APP_DIR"
ENV MAP="TheIsland"
ENV PLAYERS="10"
ENV SERVER_OPTS=""
STOPSIGNAL SIGINT
ENTRYPOINT exec "ShooterGame/Binaries/Linux/ShooterGameServer" "$MAP?listen?MaxPlayers=$PLAYERS" $SERVER_OPTS
# MaxPlayers in GameUserSettings.ini will always be overridden and must be declared as command line option
