#!/bin/bash
# servermanager

# ==============================================================================
# CONFIGURATION
# ==============================================================================
STEAM_APP="[STEAM_ID]"
SERVER_DIR="/home/steam/[NAME]"
SERVER_START="xvfb-run [XVFB_OPTION] wine [SERVER_EXE] [SERVER_EXE_OPTION]"
LOG_FILE="${SERVER_DIR}/server.log"
PID_FILE="${SERVER_DIR}/server.pid"
# ==============================================================================

log() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%F %T')] [$level] $message"
}

serverInstall() {
    log "INFO" "Installing server..."
    steamcmd +@sSteamCmdForcePlatformType windows \
             +force_install_dir "$SERVER_DIR" \
             +login anonymous \
             +app_update "$STEAM_APP" validate \
             +quit
	log "SUCCESS" "Installation finished."
}

serverStart() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        log "FAILED" "Server is already running."
        return 1
    fi

    if ! cd "$SERVER_DIR"; then
        log "ERROR" "Failed to cd into $SERVER_DIR"
        exit 1
    fi

    log "INFO" "Starting server..."
    nohup bash -c "$SERVER_START" > "$LOG_FILE" 2>&1 &

    echo $! > "$PID_FILE"
    log "SUCCESS" "Server started with PID $(cat "$PID_FILE")."
}

serverStop() {
    if [ ! -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        log "FAILED" "No server is running."
        return 1
    fi

    local pid
    pid=$(cat "$PID_FILE")
    log "INFO" "Stopping server with PID $pid..."

    pkill -P "$pid" 2>/dev/null
    kill -SIGTERM "$pid" 2>/dev/null
    
    local timeout=30
    while kill -0 "$pid" 2>/dev/null || pgrep -P "$pid" >/dev/null; do
        if [ "$timeout" -le 0 ]; then
            log "WARN" "Server did not stop in time, forcing kill..."
            pkill -P "$pid" 2>/dev/null
            kill -KILL "$pid" 2>/dev/null
            break
        fi
        log "INFO" "Waiting for server to stop... ($timeout)"
        sleep 1
        ((timeout--))
    done

    if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$PID_FILE"
        log "SUCCESS" "Server stopped."
    else
        log "ERROR" "Server could not be stopped."
    fi
}

serverRestart() {
    log "INFO" "Restarting server..."
    serverStop
    sleep 3
    serverStart
}

serverUpdate() {
    log "INFO" "Updating server..."

    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        log "INFO" "Server is running, stopping first..."
        serverStop
    fi

    serverInstall
    log "SUCCESS" "Update finished."

    if [ "$1" = "--restart" ]; then
        serverStart
    fi
}

serverHelp() {
    echo "Usage: $0 {install|start|stop|restart|update [--restart]}"
    echo "Available commands:"
    echo "  install   - Install the server via SteamCMD."
    echo "  start     - Start the server."
    echo "  stop      - Shutdown the server gracefully."
    echo "  restart   - Restart the server."
    echo "  update    - Update the server (use '--restart' to start it up again automatically)."
}

case "$1" in
    install) serverInstall ;;
    start)   serverStart ;;
    stop)    serverStop ;;
    restart) serverRestart ;;
    update)  serverUpdate "$2" ;;
    help)    serverHelp ;;
    *) echo "Command not found: \"$1\"! Use \"$0 help\" for more info." && exit 1 ;;
esac
