#!/bin/bash
# Run analyze + patch over every Dell dump in a linuxhw/ACPI checkout and tally.
# usage: tests/corpus.sh /path/to/linuxhw-ACPI [Vendor]   (default vendor: Dell)
set -u
ROOT=${1:?linuxhw-ACPI checkout}; VENDOR=${2:-Dell}
TOOL=$(dirname "$0")/../bin/ec-ladder-override
OUT=$(mktemp -d); ok=0; nodptf=0; noladder=0; fail=0
printf "%-34s %-8s %s\n" model result detail
find "$ROOT/Notebook/$VENDOR" "$ROOT/Convertible/$VENDOR" -name "*.bin" 2>/dev/null | sort | while read -r b; do
  model=$(basename "$(dirname "$b")")
  a=$("$TOOL" analyze "$b" 2>&1); rc=$?
  if [ $rc -eq 2 ]; then
    if echo "$a" | grep -q "DPTF sensor table: none"; then printf "%-34s %-8s %s\n" "$model" no-dptf ""; else printf "%-34s %-8s %s\n" "$model" no-sites "$(echo "$a" | grep 'ECR1 ladder')"; fi; continue
  elif [ $rc -ne 0 ]; then printf "%-34s %-8s %s\n" "$model" ERROR "$(echo "$a" | grep -m1 error)"; continue; fi
  p=$("$TOOL" patch "$b" --out "$OUT/$model" 2>&1); prc=$?
  if [ $prc -eq 0 ]; then res=ok; echo "$p" | grep -q "patched DSDT" || res=ok-ssdt; printf "%-34s %-8s %s | %s\n" "$model" $res "$(echo "$a" | grep 'ECR1 ladder' | cut -c1-40)" "$(echo "$p" | grep rewrote)"; else printf "%-34s %-8s %s\n" "$model" PATCHFAIL "$(echo "$p" | grep -m1 error | cut -c1-100)"; fi
done | tee "$OUT/summary.txt"
echo; echo "totals: $(grep -c ' ok ' "$OUT/summary.txt") ok (both tables), $(grep -c ' ok-ssdt ' "$OUT/summary.txt") DPTF table only, $(grep -c ' no-dptf ' "$OUT/summary.txt") without DPTF table, $(grep -c ' no-sites ' "$OUT/summary.txt") without rewritable sites, $(grep -cE ' (ERROR|PATCHFAIL) ' "$OUT/summary.txt") failed   (outputs in $OUT)"
