FROM hetsh/steamcmd:1.1-12

# App user
ARG APP_USER="ark"
ARG APP_UID=1366
ARG DATA_DIR="/ark"
RUN useradd --uid "$APP_UID" --user-group --create-home --home "$DATA_DIR" --shell /sbin/nologin "$APP_USER"

# Application
ARG APP_ID=376030
ARG DEPOT_ID=376031
ARG MANIFEST_ID=5341765977120245679
ARG APP_DIR="$STEAM_DIR/linux32/steamapps/content/app_$APP_ID/depot_$DEPOT_ID"
RUN steamcmd.sh +login anonymous +download_depot "$APP_ID" "$DEPOT_ID" "$MANIFEST_ID" +quit && \
    touch "$APP_DIR/Engine/Config/Base.ini" && \
    chown -R "$APP_USER":"$APP_USER" "$APP_DIR"

# Volume
ARG LOG_DIR="/var/log/ark"
RUN mkdir "$LOG_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$LOG_DIR"
VOLUME ["$DATA_DIR", "$LOG_DIR"]

#      GAME     RAW      RCON      QUERY
EXPOSE 7777/udp 7778/udp 27020/tcp 27015/udp

# Launch parameters
USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENV BIN_DIR="$APP_DIR/ShooterGame/Binaries/Linux"
ENV MAP="TheIsland"
ENTRYPOINT exec "$BIN_DIR/ShooterGameServer" "$MAP"?listen$SERVER_OPTS
