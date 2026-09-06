# dell-ec-ladder-override

Take the embedded-controller if-ladder out of Dell's DPTF sensor path, from a
running Linux system or from a firmware dump, and load the patched table at boot
through an initramfs hook.

## The problem

Dell laptop firmware reads and writes embedded-controller (EC) registers through
two generic accessors, `ECW1(reg, value)` and `ECR1(reg)`, written in ASL as flat
if-ladders with one block per register and no early return:

```
Method (ECR1, 1, Serialized)
{
    ...
    If ((Arg0 == 0x33)) { Local0 = EC51 }
    If ((Arg0 == 0x34)) { Local0 = EC52 }
    ...   117 blocks on an XPS 15 9500, 137 on a Precision 5570
    Return (Local0)
}
```

Every DPTF temperature sensor's `_TMP` method goes through both accessors, so
one sensor read costs the kernel's AML interpreter about 880 parse ops and 1100
state objects for two EC bytes. thermald reads three sensors every few seconds;
Intel's DPTF service on Windows reads the same methods. Measured on an XPS 15
9500 (Ubuntu 26.04, kernel 7.0):

| per `_TMP` read | stock firmware | with this override |
|---|---|---|
| parse ops | 881 | 37 |
| CPU time | 2.65 ms | about 0.5 ms |
| package energy above idle | 11.5 mJ | about 6 mJ (the EC floor) |

A survey of 783 public ACPI dumps found the pattern on 55 of 61 Dell notebooks,
from 2011 to 2023, and on no other vendor's. Lenovo, HP and ASUS read the same
kind of sensor through a direct field or a three-way switch. The full story,
measurements and the survey are in the write-up linked at the bottom.

## What the tool does

`ec-ladder-override patch` disassembles the firmware tables, parses the two
ladders in the DSDT to learn which EC field each register number names, and
rewrites every call site in the DPTF SSDT that uses a constant register number:

```
\_SB.PCI0.LPCB.ECDV.ECW1 (0x33, Arg0)          If (\ECRD)
                                          ->    {
                                                    \_SB.PCI0.LPCB.ECDV.EC51 = Arg0
                                                }
                                                Else
                                                {
                                                    \_SB.PCI0.LPCB.ECDV.ECW1 (0x33, Arg0)
                                                }
```

The original call stays as the fallback for the early-boot window in which the
EC operation region is not yet available (`ECRD == 0`), which is exactly what the
accessors themselves check. Reads, writes, and the newer `EXRW(index, reg, 0, 0)`
helper used by 2021 and later Dells are handled. Nothing else in the table
changes; the OEM revision is bumped by one so the loaded table is identifiable.

`ec-ladder-override install` puts the table in `/lib/firmware/acpi-override/`,
installs an initramfs-tools hook that prepends it as an uncompressed early cpio
(the same mechanism the CPU microcode hooks use), and rebuilds every initrd. The
kernel's ACPI table-upgrade mechanism then replaces the firmware's copy before
ACPICA loads, on every boot, through kernel updates, with no GRUB changes.

## Requirements

- Linux with `CONFIG_ACPI_TABLE_UPGRADE=y` (Debian, Ubuntu, Fedora and most
  others have it) and Secure Boot off or kernel lockdown not in integrity mode:
  the kernel refuses table overrides when locked down. Check with
  `cat /sys/kernel/security/lockdown`.
- `iasl` and `acpixtract` (`apt install acpica-tools`), Python 3.8 or later.
- `initramfs-tools` for `install`. On dracut systems, generate the table with
  `patch` and add it with dracut's `acpi_override` / `acpi_table_dir` options.

## Usage

```
# what would be done, without touching anything (root, to read /sys)
sudo ec-ladder-override analyze /sys/firmware/acpi/tables

# generate the table into ./patched (aml, dsl, and a diff against stock)
sudo ec-ladder-override patch /sys/firmware/acpi/tables --out patched

# install: patches the running firmware, keeps a copy of the stock tables,
# installs the hook, rebuilds initrds
sudo ec-ladder-override install
sudo reboot

# afterwards
sudo ec-ladder-override verify
#   loaded /sys/firmware/acpi/tables/SSDT2: 'DptfTabl' OEM rev 0x1001; installed override rev 0x1001: ACTIVE
#     ACPI: Table Upgrade: override [SSDT-INTEL -DptfTabl]

# remove
sudo ec-ladder-override uninstall && sudo reboot
```

`analyze` and `patch` also accept an `acpidump` text file or a directory of
`.aml`/`.dat` tables, so a table set from another machine can be examined
without booting it:

```
acpidump > tables.txt          # on the target machine
ec-ladder-override analyze tables.txt
```

## After a BIOS update

The hook records the BIOS version the table was made for and refuses to add the
override at initramfs build time if the running BIOS differs. That protects
rebuilds, not the initrds that already exist. After a BIOS update: run
`uninstall`, reboot on the stock tables, run `install` again, reboot. The stock
tables the override was generated from are kept in
`/lib/firmware/acpi-override/stock/` for comparison.

## Tested

`tests/corpus.sh` runs `analyze` and `patch` over every Dell dump in a checkout
of [linuxhw/ACPI](https://github.com/linuxhw/ACPI). Results for the September
2026 collection are in `docs/corpus-results.md`. Booted and measured on an XPS
15 9500 (BIOS 1.40.0).

## Safety

The rewrite is mechanical and every statement keeps its original as the fallback
branch, so the patched table behaves identically when the EC region is not
available and reads the same bytes when it is. Still: this replaces a firmware
table. Read the diff `patch` writes before installing it, keep the ability to
boot from a live medium, and do not run it on a machine you cannot afford to
have misbehave. If the kernel logs `ACPI Error` lines after the reboot that it
did not log before, run `uninstall`.

## Why not fix it properly

The proper fix is twenty lines in Dell's DPTF table, once, in Dell's common EC
code. Dell does not take firmware patches from outside and the affected models
receive security updates only. This tool exists so the measurement can be
reproduced and so an owner of one of these machines can have the fix today.

## Background

Investigation notes, perf profiles, the firmware survey and the article draft:
`dell-wake-on-lan/docs/standby/` (Acts 14 to 18 of the investigation log).
