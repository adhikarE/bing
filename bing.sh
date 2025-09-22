#!/run/current-system/sw/bin/bash
# Repeatedly ping a host and play different tones for success vs failure.
# Usage: ./self.sh target [interval_seconds] [timeout_seconds]
# Example: ./self.sh 8.8.8.8 1 1

TARGET="${1:-8.8.8.8}"
INTERVAL="${2:-1}"   # seconds between pings
TIMEOUT="${3:-1}"    # ping timeout in seconds (best-effort)
LOG=""

sound_method=""
command -v play >/dev/null 2>&1 && sound_method="play"
command -v beep >/dev/null 2>&1 && [[ -z $sound_method ]] && sound_method="beep"

tune_success() {
   play -q -n synth 0.08 sine 880 trim 0 0.08 \
        synth 0.06 sine 1320 trim 0 0.06 >/dev/null 2>&1
}

tune_failure() {
   play -q -n synth 0.18 sine 1200 trim 0 0.18 \
        synth 0.18 sine 600 trim 0 0.18 \
        synth 0.18 sine 400 trim 0 0.18 >/dev/null 2>&1
}

PING_CMD="ping"
PING_OPTS=""
PING_OPTS="-c 1 -W ${TIMEOUT}"

# trap to cleanly exit
trap 'echo; echo "Interrupted — exiting."; exit 0' INT TERM

echo "Pinging ${TARGET} every ${INTERVAL}s (timeout ${TIMEOUT}s)."
echo "Sound method: ${sound_method:-bell} (install 'sox' for best tones)."
echo "Press Ctrl-C to stop."

while true; do
  # run ping, suppress output; use return code to determine success
  if ${PING_CMD} ${PING_OPTS} "${TARGET}" >/dev/null 2>&1; then
    # success
    LOG="! "
    tune_success &
  else
    # failure
    LOG=". "
    tune_failure &
  fi

  echo -n $LOG
  sleep "${INTERVAL}"
done
