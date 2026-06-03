docker run -it -v /home/goran/projects/ulx5m-m2-git:/kikit yaqwsx/kikit:nightly-v9 panelize \
                --source    'tolerance: 0.2mm;'                    \
                --layout    'grid; rows: 1; cols: 1; space: 2mm;' \
                --tabs      'fixed; width: 10mm;'  \
                --cuts      'vcuts;'                              \
                --framing   'railslr; width: 6mm; space: 2mm;'    \
                --copperfill 'solid;'                             \
                --post      'millradius: 1mm;'                    \
                --fiducials '3fid; hoffset: 3mm; voffset: 10mm; coppersize: 2mm; opening: 2.5mm;' \
                --tooling   '4hole; hoffset: 3mm; voffset: 3mm; size: 3.2mm;' \
                --text      'simple; text: Intergalaktik d.o.o. ULX5M-M2-v001; anchor: ml; voffset: 0mm; hjustify: center; vjustify: center;' \
                --text2 'simple; text: Created on {date}; anchor: mr; voffset: 0mm; hjustify: center; vjustify: center;' \
                --post 'millradius: 0.5mm;' \
ulx5m-m2.kicad_pcb panel/ulx5m-m2_panel.kicad_pcb