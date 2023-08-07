# DDCCli
A tool for control monitor from the command line on M2 macs.

Mainly made for myself using with Stream Deck and shell scripts, so it's not very user friendly but enough for use.

## Compability
Only tested on M2 mac mini with DP connections directly to the monitor.

Use it on your own risk.

## Usage
```
$ ./ddccli
OVERVIEW: A tool for control monitors via DDC/CI on M2 mac.

USAGE: ddc-cli [--verbose] <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  list                    List all monitors
  get                     Get VCP value from a monitor
  set                     Set VCP value to a monitor

  See 'ddc-cli help <subcommand>' for detailed help.
```

No predefined VCP code like `brightness` or `contrast` provided, accept raw VCP code only.

VCP Code and value only accepts decimal number.

No monitor compability check. If not working on your monitor, try [Better Display](https://github.com/waydabber/BetterDisplay) or [Lunar](https://github.com/alin23/Lunar/) for DDC/CI hardware support check.

## Example
```
# List all monitors
$ ./ddccli list
Found 2 monitor(s)
#0 Name: DELL U2722D (Vendor: 10AC, Model: 422D)
```

```
# Get brightness of monitor 0
$ ./ddccli get -d 0 --vcp 16
75
```

```
# Set brightness of monitor 0 to 75
$ ./ddccli set -d 0 --vcp 16 --value 75
true
```

## Credits
[MonitorControl](https://github.com/MonitorControl/MonitorControl/pull/1404/commits/757ba4af65a5556a6e7d973a3e32dd5f3b3637aa) - MIT License

## License
WTFPL