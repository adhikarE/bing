# Bing (Beep Ping)

A simple command line ping utility that plays a audio cue indicating if a ping was successful or not. 

## Usage

```bash
Usage: ./bing.sh [target_ip] [interval_seconds] [timeout_seconds]
```

- `target_ip`: The IP you want to ping. [DEFAULT=8.8.8.8]
- `interval_seconds`: Interval in seconds between pings.[DEFAULT=1]
- `timeout_seconds`: Timeout in seconds until the ICMP reply can come back. [DEFAULT=1]

## Example

```bash
./bing.sh 8.8.8.8 1 1
```