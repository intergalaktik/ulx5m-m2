REPO=/home/goran/projects/ulx5m-m2-git
DOCKER="docker run -it --rm -u $(id -u):$(id -g) -e HOME=/tmp -v $REPO:/kikit -w /kikit"

# tabs: 2 on each long edge (1/4, 3/4) + 2 on the screw end (0.2, 0.8, clear of the notch), none on the gold fingers
cat > panel/tabs_m2.py <<'PY'
from kikit.plugin import TabsPlugin
from kikit.annotations import TabAnnotation
class Tabs(TabsPlugin):
    def buildTabAnnotations(self, panel):
        w = self.preset["tabs"]["hwidth"]
        for s in panel.substrates:
            x0, y0, x1, y1 = s.bounds()
            for f in (0.25, 0.75):
                y = y0 + f * (y1 - y0)
                s.annotations.append(TabAnnotation(None, (x0, y), [1, 0], w))
                s.annotations.append(TabAnnotation(None, (x1, y), [-1, 0], w))
            for f in (0.2, 0.8):
                s.annotations.append(TabAnnotation(None, (x0 + f * (x1 - x0), y0), [0, 1], w))
PY

$DOCKER yaqwsx/kikit:nightly-v10 panelize \
                --page      'anchor: c; posx: 58.25mm; posy: 104.05mm;' \
                --source    'tolerance: 0.2mm;'                    \
                --layout    'grid; rows: 1; cols: 1; space: 2mm;' \
                --tabs      'plugin; code: panel/tabs_m2.py.Tabs; width: 5mm;' \
                --cuts      'vcuts;'                              \
                --framing   'frame; width: 6mm; space: 2mm; cuts: none;' \
                --copperfill 'solid;'                             \
                --post      'millradius: 1mm;'                    \
                --fiducials '3fid; hoffset: 3mm; voffset: 10mm; coppersize: 2mm; opening: 2.5mm;' \
                --tooling   '4hole; hoffset: 3mm; voffset: 3mm; size: 3.2mm;' \
                --text      'simple; text: Intergalaktik d.o.o. ULX5M-M2-v0.2; anchor: ml; hoffset: 3mm; voffset: 0mm; orientation: 90deg; width: 1.2mm; height: 1.2mm; thickness: 0.2mm; hjustify: center; vjustify: center;' \
                --text2     'simple; text: Created on {date}; anchor: mr; hoffset: -3mm; voffset: 0mm; orientation: 90deg; width: 1.2mm; height: 1.2mm; thickness: 0.2mm; hjustify: center; vjustify: center;' \
                --post 'millradius: 0.5mm;' \
ulx5m-m2.kicad_pcb panel/ulx5m-m2_panel.kicad_pcb

# stackup table + title (Cmts.User) from the board, same place on the sheet
$DOCKER --entrypoint python3 yaqwsx/kikit:nightly-v10 -c "
import pcbnew
src = pcbnew.LoadBoard('ulx5m-m2.kicad_pcb')
dst = pcbnew.LoadBoard('panel/ulx5m-m2_panel.kicad_pcb')
for it in src.GetDrawings():
    if it.GetLayer() == pcbnew.Cmts_User and (it.GetClass() == 'PCB_TABLE' or (it.GetClass() == 'PCB_TEXT' and 'JLC' in it.GetText())):
        dst.Add(it.Duplicate())
dst.Save('panel/ulx5m-m2_panel.kicad_pcb')
"
rm -f panel/tabs_m2.py
