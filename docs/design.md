# Design notes

## Why rewrite call sites and not the accessors

The ladders `ECR1`/`ECW1` live in the DSDT and are called from many places; the
DSDT is 300 to 550 KB and replacing it wholesale is a much larger override with a
much larger blast radius. The DPTF SSDT is 25 KB, is the only table on the hot
path, and every rewritten statement keeps its original as the `Else` branch, so
the change is local and reversible statement by statement.

## The ECRD guard

`ECRD` is set to 1 by the EC device's `_REG` handler when the EmbeddedControl
operation region becomes available and is 0 before that. The accessors test it
and fall back to an SMI path (`EISC`) when it is 0. A direct field access with
`ECRD == 0` would fail with an AE_NOT_EXIST region error, so every rewritten
statement is `If (\ECRD) { direct } Else { original }`. The extra `\ECRD` test
costs two parse ops.

## What is rewritten

| form in the DPTF table | rewritten to |
|---|---|
| `ECW1 (C, X)` | `FIELD_W[C] = X` |
| `T = ECR1 (C)` | `T = FIELD_R[C]` |
| `T = EXRW (I, C, Zero, Zero)` (2021+ helper) | `FIELD_W[0x33] = I; T = FIELD_R[C]` |
| `EXRW (I, C, One, V)` | `FIELD_W[0x33] = I; FIELD_W[C] = V` |

`FIELD_R` and `FIELD_W` are parsed from the ladders themselves, so the tool never
assumes a register layout. Calls with a variable register number are left alone.

## Loading

The kernel's `CONFIG_ACPI_TABLE_UPGRADE` scans the initrd for
`kernel/firmware/acpi/*.aml` and replaces a firmware table whose signature, OEM
ID and OEM table ID match. The initramfs-tools hook builds that cpio at
`update-initramfs` time and prepends it with `prepend_earlyinitramfs`, which is
how CPU microcode is delivered, so it survives kernel updates and needs no GRUB
changes. The hook refuses to add the table when the running BIOS version differs
from the one recorded at install time.
