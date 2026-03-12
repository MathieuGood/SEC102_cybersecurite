#!/bin/bash
# Usage: ./generate_pdf.sh <fichier.md> [v1|v2]
# Génère un PDF dans le même dossier que le fichier source.
# v1 (défaut) : style centré, épuré  |  v2 : bandeau sombre, accents gauche

set -e

# ---- Dépendances -------------------------------------------
if ! command -v pandoc &>/dev/null; then
  echo "❌  pandoc non trouvé"
  exit 1
fi
if ! command -v weasyprint &>/dev/null && ! find ~/Library/Python -name "weasyprint" -type f &>/dev/null 2>&1; then
  echo "❌  weasyprint non trouvé. Installe-le avec : brew install weasyprint"
  exit 1
fi

# ---- Arguments ---------------------------------------------
INPUT="$1"
if [ -z "$INPUT" ]; then
  echo "Usage: $0 <fichier.md>"
  exit 1
fi

VERSION="${2:-v1}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT_ABS="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"
OUTPUT="${INPUT_ABS%.md}_${VERSION}.pdf"
LOGO="$SCRIPT_DIR/logo_cnam.svg"
LOGO_WHITE="$SCRIPT_DIR/logo_cnam_white.svg"

case "$VERSION" in
  v2)
    TEMPLATE="$SCRIPT_DIR/_template/template_v2.html"
    CSS="$SCRIPT_DIR/_template/style_v2.css"
    ;;
  v3)
    TEMPLATE="$SCRIPT_DIR/_template/template_v3.html"
    CSS="$SCRIPT_DIR/_template/style_v3.css"
    ;;
  *)
    TEMPLATE="$SCRIPT_DIR/_template/template_v1.html"
    CSS="$SCRIPT_DIR/_template/style_v1.css"
    ;;
esac

# ---- Extraction des métadonnées ----------------------------
TITLE=$(grep -m1 "^# " "$INPUT_ABS" | sed 's/^# //')
AUDITEUR=$(grep -m1 "^Auditeur" "$INPUT_ABS" | sed 's/Auditeur : //' | sed 's/Auditeur: //')
UE=$(grep -m1 "^UE " "$INPUT_ABS")
ANNEE=$(grep -m1 "^Année" "$INPUT_ABS")
YEAR=$(echo "$ANNEE" | grep -oE '[0-9]{4}-[0-9]{4}')

# ---- Fichier temporaire (corps sans les lignes d'en-tête) --
TEMP=$(mktemp /tmp/cnam_XXXXXX.md)
trap 'rm -f "$TEMP"' EXIT

cat > "$TEMP" <<YAML
---
title: "$TITLE"
author: "$AUDITEUR"
subject: "$UE"
date: "$ANNEE"
logo: "$LOGO"
logo_white: "$LOGO_WHITE"
year: "$YEAR"
---
YAML

# Ajoute le corps en supprimant le titre H1 et les lignes de métadonnées
awk '
  /^# /     { next }
  /^UE /    { next }
  /^Auditeur/ { next }
  /^Année/  { next }
  { print }
' "$INPUT_ABS" | sed '/./,$!d' >> "$TEMP"

# ---- Génération du PDF -------------------------------------
WEASYPRINT=$(command -v weasyprint 2>/dev/null \
  || find ~/Library/Python -name "weasyprint" -type f 2>/dev/null | head -1)

pandoc "$TEMP" \
  --template="$TEMPLATE" \
  --css="$CSS" \
  --pdf-engine="$WEASYPRINT" \
  --resource-path="$SCRIPT_DIR" \
  -o "$OUTPUT"

echo "✅  PDF généré : $OUTPUT"
