#!/usr/bin/env bash
#
#  WordNet lookup script for the nvim thesaurus plugin.
# Called by the plugin as:  bash -c "scripts/thesaurus.sh <word>"
#
# For the given word it prints:
#   * each meaning (sense), grouped by part of speech, with its definition
#     and synonyms                         (from `wn <word> -over`)
#   * antonyms, grouped by part of speech  (from `wn <word> -ants{n,v,a,r}`)
#
set -uo pipefail

word="${1:-}"

if [[ -z "$word" ]]; then
  echo 'thesaurus: no word given\nusage: thesaurus.sh <word>'
  exit 0
fi

command -v wn >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo "thesaurus: 'wn' (WordNet) not found. Install the "wordnet" package via"
  [[ "$OSTYPE"  = "linux-gnu" ]] \
    &&  echo "sudo apt install wordnet" \
    ||  echo "brew install wordnet"
  exit 1
fi

# ── Meanings + synonyms ──────────────────────────────────────────────
# `wn -over` prints one line per sense:
#   "N. (freq) syn1, syn2, ... -- (definition)"
overview=$(wn "$word" -over 2>/dev/null)
[ -z "$overview" ] && echo "nothing found for ${word}" && exit 0

printf '══ Overview: %s ════════════════════════════════\n' "$word"
echo "$overview"

# ── Antonyms ─────────────────────────────────────────────────────────
# First-level relations in wn's text output are indented exactly 7 spaces
# and begin with "=> " (noun/verb/adverb) or "(vs.) " (adjective).
collect_antonyms() {
  local pos="$1"
  local label="$2"
  wn "$word" -go -ants"$pos" 2>/dev/null

}

printf '════════════════════════════════════════════\n'

collect_antonyms n no
collect_antonyms v verb
collect_antonyms a adjective
collect_antonyms r adverb

exit 0
