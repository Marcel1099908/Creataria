#!/bin/bash
# servermanager

set -Eeuo pipefail

# ==============================================================================
# CONFIGURATION
# ==============================================================================
STEAM_APP="443030"
SERVER_DIR="/home/steam/conanexiles"

# Example:
# SERVER_START="xvfb-run [XVFB_OPTION] wine [SERVER_EXE] [SERVER_EXE_OPTION]"
SERVER_START="xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine ConanSandbox/Binaries/Win64/ConanSandboxServer-Win64-Shipping.exe -log"

LOG_FILE="${SERVER_DIR}/server.log"
PID_FILE="${SERVER_DIR}/server.pid"
# ==============================================================================

trap 'logMessage "ERROR" "Script failed at line $LINENO."' ERR

logMessage() {
    local level="$1"
    local message="$2"
	local timestamp="$(date '+%F %T')"
    echo "[$timestamp] [$level] $message"
}

checkDependencies() {
	local dep
    local deps=(
        steamcmd
        wine
        xvfb-run
    )

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            logMessage "ERROR" "Missing dependency: $dep"
            exit 1
        fi
    done
}

validateConfig() {
    [[ -n "$STEAM_APP" ]] || {
        logMessage "ERROR" "STEAM_APP is not configured."
        exit 1
    }

    [[ -n "$SERVER_DIR" ]] || {
        logMessage "ERROR" "SERVER_DIR is not configured."
        exit 1
    }

    [[ -n "$SERVER_START" ]] || {
        logMessage "ERROR" "SERVER_START is not configured."
        exit 1
    }
}

serverRunning() {
    [ -f "$PID_FILE" ] || return 1

	local pid=$(cat "$PID_FILE")

    if kill -0 "$pid" 2>/dev/null; then
        return 0
    else
        rm -f "$PID_FILE"
        return 1
    fi
}

serverInstall() {
    logMessage "INFO" "Installing server..."

    if steamcmd \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir "$SERVER_DIR" \
        +login anonymous \
        +app_update "$STEAM_APP" validate \
        +quit; then

        logMessage "SUCCESS" "Installation finished."
    else
        logMessage "ERROR" "Installation failed."
        return 1
    fi
}

serverStart() {
    if serverRunning; then
        logMessage "FAILED" "Server is already running."
        return 1
    fi

    if ! cd "$SERVER_DIR"; then
        logMessage "ERROR" "Failed to cd into $SERVER_DIR"
        exit 1
    fi

    logMessage "INFO" "Starting server..."
    nohup bash -c "$SERVER_START" > "$LOG_FILE" 2>&1 &

    echo $! > "$PID_FILE"
    logMessage "SUCCESS" "Server started with PID $(cat "$PID_FILE")."
}

serverStop() {
    if ! serverRunning; then
        logMessage "FAILED" "No server is running."
        return 1
    fi

	local pid=$(cat "$PID_FILE")
    logMessage "INFO" "Stopping server with PID $pid..."
    pkill -P "$pid" 2>/dev/null
    kill -SIGTERM "$pid" 2>/dev/null
    
    local timeout=30
    while kill -0 "$pid" 2>/dev/null || pgrep -P "$pid" >/dev/null; do
        if [ "$timeout" -le 0 ]; then
            logMessage "WARN" "Server did not stop in time, forcing kill..."
            pkill -P "$pid" 2>/dev/null
            kill -KILL "$pid" 2>/dev/null
            break
        fi
        logMessage "INFO" "Waiting for server to stop... ($timeout)"
        sleep 1
        ((timeout--))
    done

    if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$PID_FILE"
        logMessage "SUCCESS" "Server stopped."
    else
        logMessage "ERROR" "Server could not be stopped."
    fi
}

serverRestart() {
    logMessage "INFO" "Restarting server..."
    serverStop
    sleep 3
    serverStart
}

serverUpdate() {
    logMessage "INFO" "Updating server..."

    if serverRunning; then
        logMessage "INFO" "Server is running, stopping first..."
        serverStop
    fi

    serverInstall
    logMessage "SUCCESS" "Update finished."

    if [ "$1" = "--restart" ]; then
        serverStart
    fi
}

serverStatus() {
    if serverRunning; then
        logMessage "INFO" "Server is running."
    else
        logMessage "INFO" "Server is not running."
    fi
}

serverMonitor() {
    if [ ! -f "$LOG_FILE" ]; then
        logMessage "ERROR" "Log file does not exist."
        return 1
    fi

	logMessage "INFO" "Attached to live log monitoring. Press Ctrl+C to detach."
    tail -f "$LOG_FILE"
}

serverHelp() {
    cat <<- EOF
Usage: $0 <command>

Available commands:

  install
      Install the server via SteamCMD

  start
      Start the server

  stop
      Stop the server gracefully

  restart
      Restart the server

  update [--restart]
      Update the server

  status
      Show server status

  monitor
      Monitor server logs

  help
      Show  help message
EOF
}

checkDependencies
validateConfig

case "${1:-help}" in
    install) serverInstall ;;
    start)   serverStart ;;
    stop)    serverStop ;;
    restart) serverRestart ;;
    update)  serverUpdate "$2" ;;
	status)    serverStatus ;;
	monitor)    serverMonitor ;;
    help)    serverHelp ;;
    *) logMessage "ERROR" "Command not found: \"$1\"!"; serverHelp; exit 1 ;;
esac