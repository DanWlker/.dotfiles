# Cursor themes

Posy's Improved Cursors (Black) by Michiel de Boer — https://www.michieldb.nl/other/cursors/
Licensed CC BY-NC (free for non-commercial use).

Scalable port by Synth Morxemplum, release v1.3:
https://github.com/Morxemplum/posys-cursor-scalable/releases/tag/v1.3

- theme_Posys-Cursor-Scalable-Black/  hyprcursor version (HYPRCURSOR_THEME=Posys-Cursor-Scalable-Black)
    Built from source (unreleased 1.4, commit c925d6e, 2026-08-09) for the newer cursors
    (zoom, cell, grab/grabbing, per-direction resize; 36 shapes vs 22 in v1.3):
      git clone https://github.com/Morxemplum/posys-cursor-scalable && cd posys-cursor-scalable
      python3 build.py -c hyprland -t black --skip-optional-prompts   # needs inkscape + scour
      sed -i 's/^name = .*/name = Posys-Cursor-Scalable-Black/' build/hyprland/manifest.hl
      hyprcursor-util --create build/hyprland --output <out-dir>
    (The manifest name is changed from "Posy's Cursors Scalable [Black]" so HYPRCURSOR_THEME stays simple.)
- posys_cursor_scalable_black/        XCursor + SVG version (XCURSOR_THEME=posys_cursor_scalable_black)
    cursors/          XCursors built from the same master commit (used by GTK3/XWayland apps):
      cp build.py build_nobimi.py   # drop the svgtinyps step (x86_64-only binary, only needed for KWin SVGs):
        #   bimi_dependency_check() -> pass ; `bimi: bool = (comp == Compositor.KWIN)` -> `bimi: bool = False`
      python3 build_nobimi.py -c plasma -t black --skip-optional-prompts
      # render every SVG frame in build/plasma/cursors_scalable/<cursor>/ at 75/100/125/150/175% of its
      # canvas with Inkscape into <pix>/x<scale>/<stem>.png, then:
      plasma_themes/src/build_tools/generate_cursors <real cursor dirs> <pix> <out>/cursors 75 100 125 150 175
      # recreate build.py's alias symlinks in <out>/cursors, plus legacy names it lacks
      # (top/bottom_left/right_corner, *_side -> directional resize; old arrow/hash names as in v1.3)
      # needs inkscape, scour, xcursorgen
    cursors_scalable/ + index.theme: still from the v1.3 release (only KDE Plasma reads these; master's
      versions need the svgtinyps conversion that can't run on aarch64)

Each theme folder is symlinked individually into ~/.local/share/icons/ (that directory stays a real
directory, since apps install their own icons there).
