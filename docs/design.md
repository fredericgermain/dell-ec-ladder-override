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

## The DSDT: rebalancing the ladders

Call-site rewriting only reaches constant register numbers, and the DSDT's own
users (`ECRB`, `ECWB`, `ECBT`, `ECR2`, hence `_BST`, `_LID`, `_PSR`, `_WED`) pass
the register through a wrapper, so the constant lives one level up in hundreds of
callers. The tool therefore also replaces the ladder bodies of `ECR1` and `ECW1`
with a balanced tree:

```
If ((Arg0 < 0x3E))          # range test
{
    If ((Arg0 < 0x1D))
    ...
            If ((Arg0 == 0x00)) { Local0 = EC00 }   # the original leaf test
```

The `ECRD == 0` preamble and `Return` stay; leaves keep the equality test, so a
register with no field still matches nothing, as before. 117 blocks become a
tree of depth 7.

## Recompiling a decompiled DSDT

What breaks and what the tool does about it:

- iasl writes ACPICA diagnostics from loading the external tables into the
  `.dsl` itself (`Firmware Error (ACPI): ...` lines). Stripped.
- Two SSDTs in the dump define the same object (a firmware ships variants and
  loads one at runtime), so loading all of them as externals aborts with
  `AE_ALREADY_EXISTS`. The table duplicating the named object is dropped from
  the external set and the disassembly retried.
- Calls into methods that only exist in runtime-loaded tables come out as a
  name, a comment and bare argument lines. Stitched back into a call.
- iasl then still reports, as errors, properties of the original firmware:
  objects it cannot find (6084, 6161), a name the static dump declares as data
  but the firmware calls as a method (6086), devices without `_HID`/`_ADR`
  (6141), a method that calls itself (6152), a Name created in one method and
  read from another (6163). With `-f` it emits the AML the firmware was built
  from. The tool retries with `-f` only when every error is on that list, and
  otherwise keeps the DPTF table alone.
