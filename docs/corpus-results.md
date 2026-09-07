# Corpus results, linuxhw/ACPI, September 2026

`tests/corpus.sh` over every Dell notebook and convertible dump (61 machines). `ok` means both the DPTF table and the rebalanced DSDT were produced and compiled; `ok-ssdt` means the DPTF table only, because the DSDT did not recompile for a reason outside the accepted list.

```
model                              result   detail
Latitude 7400 2-in-1               ok-ssdt  ECR1 ladder: 107 blocks (107 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
G3 3500                            ok       ECR1 ladder: 111 blocks (111 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
G3 3579                            ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Inspiron 14-3462                   no-sites ECR1 ladder: 0 blocks (0 registers mapped); ECW1 ladder: 0 blocks (0 mapped)
Inspiron 15-3567                   ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Inspiron 3558                      no-sites ECR1 ladder: 50 blocks (50 registers mapped); ECW1 ladder: 15 blocks (15 mapped)
Inspiron 3593                      ok       ECR1 ladder: 107 blocks (107 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Inspiron 5537                      no-dptf  
Inspiron 5566                      no-sites ECR1 ladder: 50 blocks (50 registers mapped); ECW1 ladder: 15 blocks (15 mapped)
Inspiron 5570                      ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Inspiron 5759                      no-sites ECR1 ladder: 50 blocks (50 registers mapped); ECW1 ladder: 15 blocks (15 mapped)
Inspiron 7577                      ok       ECR1 ladder: 107 blocks (107 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Inspiron N7110                     no-sites ECR1 ladder: 0 blocks (0 registers mapped); ECW1 ladder: 0 blocks (0 mapped)
Latitude 3590                      ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5414                      no-sites ECR1 ladder: 60 blocks (60 registers mapped); ECW1 ladder: 23 blocks (23 mapped)
Latitude 5420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 13 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 13 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 13 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5480                      ok       ECR1 ladder: 65 blocks (65 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5511                      ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 5521                      ok       ECR1 ladder: 118 blocks (118 registers m | rewrote 19 call sites through 7 EC fields: EC32 EC33 EC34 EC35 
Latitude 7370                      ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 7390 2-in-1               ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 7420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 13 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 7420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 13 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 7480                      ok       ECR1 ladder: 58 blocks (58 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude 9420                      ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 19 call sites through 7 EC fields: EC32 EC33 EC34 EC35 
Latitude E5420                     no-dptf  
Latitude E5520                     no-dptf  
Latitude E6230                     no-dptf  
Latitude E6330                     no-dptf  
Latitude E6420                     no-dptf  
Latitude E7270                     ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Latitude E7470                     ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Precision 3571                     ok       ECR1 ladder: 120 blocks (120 registers m | rewrote 13 call sites through 7 EC fields: EC32 EC33 EC34 EC35 
Precision 5530                     ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Precision 5560                     ok       ECR1 ladder: 135 blocks (135 registers m | rewrote 24 call sites through 18 EC fields: EC32 EC33 EC34 EC35
Precision 5570                     ok       ECR1 ladder: 137 blocks (137 registers m | rewrote 24 call sites through 18 EC fields: EC32 EC33 EC34 EC35
Precision 5570                     ok       ECR1 ladder: 137 blocks (137 registers m | rewrote 24 call sites through 18 EC fields: EC32 EC33 EC34 EC35
Precision 5680                     ok       ECR1 ladder: 122 blocks (122 registers m | rewrote 15 call sites through 8 EC fields: EC32 EC33 EC34 EC35 
Precision 7550                     ok       ECR1 ladder: 108 blocks (108 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Precision 7710                     ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Precision 7710                     ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
Precision M4500                    no-dptf  
Venue 8 Pro 5830                   no-sites ECR1 ladder: 0 blocks (0 registers mapped); ECW1 ladder: 0 blocks (0 mapped)
Vostro 5471                        ok-ssdt  ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 13 7390                        ok       ECR1 ladder: 107 blocks (107 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 13 9350                        ok       ECR1 ladder: 57 blocks (57 registers map | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 13 9360                        ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 13 9380                        ok       ECR1 ladder: 116 blocks (116 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 15 7590                        ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 15 9500                        ok       ECR1 ladder: 117 blocks (117 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS 15 9510                        ok       ECR1 ladder: 135 blocks (135 registers m | rewrote 24 call sites through 18 EC fields: EC32 EC33 EC34 EC35
XPS 15 9570                        ok       ECR1 ladder: 106 blocks (106 registers m | rewrote 19 call sites through 7 EC fields: EC50 EC51 EC52 EC53 
XPS L501X                          no-dptf  

totals: 38 ok (both tables), 2 DPTF table only, 8 without DPTF table, 7 without rewritable sites, 0 failed  
```

`no-dptf`: pre-2015 machines without a DPTF sensor table, nothing to do. `no-sites`: a DPTF table exists but its sensor methods do not call the ladders with constant register numbers (2015-era Inspiron and the Latitude 5414 use a different sensor path); those machines are left alone. Two machines get the DPTF table only. The Precision 5560/5570 and XPS 15 9510 rewrite 24 sites because their tables also drive fan and threshold registers through the accessors.
