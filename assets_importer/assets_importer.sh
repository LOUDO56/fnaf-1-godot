#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MAP_FILE="$SCRIPT_DIR/assets_map.txt"
IMAGES_DIR="$SCRIPT_DIR/Images"
SOUNDS_DIR="$SCRIPT_DIR/Sounds"

VERBOSE=0
KEEP=0

usage() {
    cat <<USAGE
Usage: assets_importer.sh [options]

Copies every asset listed in assets_map.txt from Images/ and Sounds/ to its
location inside the Godot project, then removes both source folders.

Options:
  -v, --verbose   print one line per imported asset
  -k, --keep      keep Images/ and Sounds/ instead of deleting them
  -h, --help      show this help
USAGE
}

while [ $# -gt 0 ]; do
    case "$1" in
        -v|--verbose) VERBOSE=1 ;;
        -k|--keep)    KEEP=1 ;;
        -h|--help)    usage; exit 0 ;;
        *)            printf 'Unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
    C_RESET=$'\033[0m'
    C_RED=$'\033[1;31m'
    C_GREEN=$'\033[1;32m'
    C_YELLOW=$'\033[1;33m'
    C_BLUE=$'\033[1;34m'
    C_GRAY=$'\033[0;90m'
    C_BOLD=$'\033[1m'
else
    C_RESET=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_GRAY=""; C_BOLD=""
fi

ok()    { printf '  %s[ OK ]%s %s\n'   "$C_GREEN"  "$C_RESET" "$1"; }
fail()  { printf '  %s[FAIL]%s %s\n'   "$C_RED"    "$C_RESET" "$1"; }
warn()  { printf '  %s[WARN]%s %s\n'   "$C_YELLOW" "$C_RESET" "$1"; }
info()  { printf '  %s[INFO]%s %s\n'   "$C_BLUE"   "$C_RESET" "$1"; }
title() { printf '\n%s%s%s\n' "$C_BOLD" "$1" "$C_RESET"; }
rule()  { printf '%s%s%s\n' "$C_GRAY" "------------------------------------------------------------" "$C_RESET"; }

abort() {
    fail "$1"
    printf '\n%sImport aborted, nothing was changed.%s\n\n' "$C_RED" "$C_RESET"
    exit 1
}

printf '\n%sFNaF asset importer%s\n' "$C_BOLD" "$C_RESET"
rule
info "Project  : $PROJECT_ROOT"
info "Source   : $SCRIPT_DIR"

[ -f "$PROJECT_ROOT/project.godot" ] || abort "project.godot not found in $PROJECT_ROOT, this script must stay inside the Godot project."
[ -f "$MAP_FILE" ] || abort "Mapping file not found: $MAP_FILE"
[ -d "$IMAGES_DIR" ] || abort "Folder not found: $IMAGES_DIR"
[ -d "$SOUNDS_DIR" ] || abort "Folder not found: $SOUNDS_DIR"

total=$(grep -v '^[[:space:]]*#' "$MAP_FILE" | grep -c '|')
[ "$total" -gt 0 ] || abort "Mapping file is empty: $MAP_FILE"

info "Assets to import: $total"

title "Importing"
rule

copied=0
copied_images=0
copied_sounds=0
missing=0
failed=0
orphan=0
done_count=0
next_step=10
declare -a missing_list=()
declare -a failed_list=()
declare -a orphan_list=()

while IFS='|' read -r rel_src rel_dst; do
    case "$rel_src" in
        \#*|"") continue ;;
    esac
    [ -n "${rel_dst:-}" ] || continue

    src="$SCRIPT_DIR/$rel_src"
    dst="$PROJECT_ROOT/$rel_dst"

    done_count=$((done_count + 1))

    if [ ! -f "$src" ]; then
        missing=$((missing + 1))
        missing_list+=("$rel_src")
        fail "missing source: $rel_src"
    else
        mkdir -p "$(dirname "$dst")" 2>/dev/null
        if cp -f "$src" "$dst" 2>/dev/null; then
            copied=$((copied + 1))
            case "$rel_src" in
                Images/*) copied_images=$((copied_images + 1)) ;;
                Sounds/*) copied_sounds=$((copied_sounds + 1)) ;;
            esac
            [ "$VERBOSE" -eq 1 ] && ok "$rel_src -> $rel_dst"
            if [ ! -f "$dst.import" ]; then
                orphan=$((orphan + 1))
                orphan_list+=("$rel_dst")
            fi
        else
            failed=$((failed + 1))
            failed_list+=("$rel_dst")
            fail "cannot write: $rel_dst"
        fi
    fi

    if [ "$VERBOSE" -eq 0 ]; then
        pct=$((done_count * 100 / total))
        if [ "$pct" -ge "$next_step" ]; then
            while [ "$next_step" -le "$pct" ]; do next_step=$((next_step + 10)); done
            printf '  %s[%3d%%]%s %d/%d assets\n' "$C_GREEN" "$pct" "$C_RESET" "$done_count" "$total"
        fi
    fi
done < "$MAP_FILE"

if [ "${#orphan_list[@]}" -gt 0 ]; then
    title "Assets without a .import file"
    rule
    for item in "${orphan_list[@]}"; do
        warn "$item (Godot will regenerate it on the next project scan)"
    done
fi

found_images=$(find "$IMAGES_DIR" -maxdepth 1 -type f -name '*.png' 2>/dev/null | wc -l | tr -d ' ')
found_sounds=$(find "$SOUNDS_DIR" -maxdepth 1 -type f -name '*.wav' 2>/dev/null | wc -l | tr -d ' ')
unused_images=$((found_images - copied_images))
unused_sounds=$((found_sounds - copied_sounds))
[ "$unused_images" -lt 0 ] && unused_images=0
[ "$unused_sounds" -lt 0 ] && unused_sounds=0

title "Summary"
rule
printf '  %s%-22s%s %s%d%s\n' "$C_RESET" "Imported" "$C_RESET" "$C_GREEN" "$copied" "$C_RESET"
if [ "$missing" -gt 0 ]; then
    printf '  %s%-22s%s %s%d%s\n' "$C_RESET" "Missing sources" "$C_RESET" "$C_RED" "$missing" "$C_RESET"
fi
if [ "$failed" -gt 0 ]; then
    printf '  %s%-22s%s %s%d%s\n' "$C_RESET" "Write failures" "$C_RESET" "$C_RED" "$failed" "$C_RESET"
fi
if [ "$orphan" -gt 0 ]; then
    printf '  %s%-22s%s %s%d%s\n' "$C_RESET" "Without .import" "$C_RESET" "$C_YELLOW" "$orphan" "$C_RESET"
fi
if [ $((unused_images + unused_sounds)) -gt 0 ]; then
    printf '  %s%-22s%s %s%d image(s), %d sound(s)%s\n' "$C_RESET" "Unused by the project" "$C_RESET" "$C_GRAY" "$unused_images" "$unused_sounds" "$C_RESET"
fi

errors=$((missing + failed))

title "Cleanup"
rule
if [ "$KEEP" -eq 1 ]; then
    info "--keep used, Images/ and Sounds/ were left untouched."
elif [ "$errors" -gt 0 ]; then
    warn "Images/ and Sounds/ were kept because $errors asset(s) could not be imported."
    warn "Fix the errors above and run the script again."
else
    if rm -rf "$IMAGES_DIR" "$SOUNDS_DIR" 2>/dev/null; then
        ok "Images/ and Sounds/ removed."
    else
        fail "Could not remove Images/ and Sounds/, delete them manually."
        errors=$((errors + 1))
    fi
fi

printf '\n'
if [ "$errors" -gt 0 ]; then
    printf '%sImport finished with %d error(s).%s\n\n' "$C_RED" "$errors" "$C_RESET"
    exit 1
fi
printf '%s%d asset(s) imported successfully. Open the project in Godot to let it reimport them.%s\n\n' "$C_GREEN" "$copied" "$C_RESET"
exit 0
