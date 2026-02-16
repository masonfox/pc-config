#!/bin/sh
set -eu

SRC="/volume3/nvme/ebooks"
DST="/volume3/nvme/ebooks-flat"

mkdir -p "$DST"

find "$SRC" -type f -iname '*.epub' -print0 |
  while IFS= read -r -d '' f; do
    raw="$(basename "$f" .epub)"

    # 1) underscores → spaces
    name="$(printf '%s' "$raw" | tr '_' ' ')"

    # 2) normalize all separator junk to " - "
    #    fixes: �  –  —
    name="$(printf '%s' "$name" | sed 's/[�–—]/ - /g')"

    # 3) normalize spacing around hyphens
    name="$(printf '%s' "$name" | sed 's/[[:space:]]*-[[:space:]]*/ - /')"

    # 4) collapse whitespace + trim
    name="$(printf '%s' "$name" | sed 's/  */ /g; s/^ *//; s/ *$//')"

    out="$DST/$name.epub"

    rsync -t --protect-args "$f" "$out"
  done
