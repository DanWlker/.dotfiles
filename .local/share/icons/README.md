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
    From the v1.3 release tarball; the build script can't produce XCursors, so this stays at v1.3.

Each theme folder is symlinked individually into ~/.local/share/icons/ (that directory stays a real
directory, since apps install their own icons there).
