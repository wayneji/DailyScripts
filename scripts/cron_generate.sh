#!/bin/bash
# 自动化文章生成脚本 (cron_generate.sh)
# 路径：/Users/weimingji/.openclaw/workspace/scripts/cron_generate.sh

set -euo pipefail

cd /Users/weimingji/.openclaw/workspace || exit 1
mkdir -p data/articles

# 电影列表
MOVIES=("Harry Potter" "Zootopia" "Moana" "Inside Out" "Toy Story" "Finding Nemo")
RANDOM_INDEX=$(( RANDOM % ${#MOVIES[@]} ))
SELECTED_MOVIE=${MOVIES[$RANDOM_INDEX]}
DATE=$(date +%Y-%m-%d)
FILENAME="data/articles/movie_story_${DATE}.md"

python3 - "$SELECTED_MOVIE" "$DATE" "$FILENAME" <<'PY'
import random
import sys
from pathlib import Path

movie = sys.argv[1]
date = sys.argv[2]
outfile = Path(sys.argv[3])

random.seed(f"{movie}-{date}")

settings = {
    "Harry Potter": {
        "hero": "Harry",
        "friend": "Hermione",
        "place": "the library at Hogwarts",
        "item": "a silver key",
        "challenge": "a locked cabinet made a whispering sound",
        "lesson": "clever thinking is stronger than fear",
    },
    "Zootopia": {
        "hero": "Judy Hopps",
        "friend": "Nick Wilde",
        "place": "the busy streets of Zootopia",
        "item": "a missing donut box",
        "challenge": "the clues pointed in three different directions",
        "lesson": "teamwork makes hard problems smaller",
    },
    "Moana": {
        "hero": "Moana",
        "friend": "Maui",
        "place": "the blue ocean near Motunui",
        "item": "a basket of festival shells",
        "challenge": "a strong wind pushed their canoe away from the reef",
        "lesson": "bravery grows when you keep moving",
    },
    "Inside Out": {
        "hero": "Joy",
        "friend": "Sadness",
        "place": "Headquarters",
        "item": "a bright memory orb",
        "challenge": "the control panel suddenly stopped glowing",
        "lesson": "every feeling can help in the right moment",
    },
    "Toy Story": {
        "hero": "Woody",
        "friend": "Buzz Lightyear",
        "place": "Andy’s room",
        "item": "a tiny paper map",
        "challenge": "the toys had to cross the room before Andy came back",
        "lesson": "good leaders listen to their friends",
    },
    "Finding Nemo": {
        "hero": "Nemo",
        "friend": "Dory",
        "place": "the warm ocean near the reef",
        "item": "a shiny sea badge",
        "challenge": "the current carried the badge into a dark cave",
        "lesson": "small steps can solve big worries",
    },
}

openers = [
    "The morning was calm and full of promise.",
    "It was a bright day, and something unusual was about to happen.",
    "Everyone thought it would be a normal day, but they were wrong.",
]
middles = [
    "They looked carefully, asked smart questions, and stayed kind to each other.",
    "They made a simple plan and followed it one step at a time.",
    "They almost gave up, but a small clue helped them try again.",
]
enders = [
    "When the problem was solved, they smiled and shared the good news.",
    "In the end, the day became a story worth telling again.",
    "After that, they felt proud, calm, and ready for the next adventure.",
]

c = settings[movie]
title = f"A Small Adventure in {movie}"
paragraphs = [
    f"# {title}",
    f"*Generated on {date}*",
    "",
    f"{random.choice(openers)} {c['hero']} was with {c['friend']} in {c['place']}. They found {c['item']}, and that was the start of their adventure.",
    "",
    f"Soon, {c['challenge']}. {random.choice(middles)} {c['hero']} said they should stay calm, and {c['friend']} agreed. Together they watched, listened, and noticed details that others missed.",
    "",
    f"At last, they understood what to do. They fixed the problem, protected {c['item']}, and helped everyone around them feel safe. {random.choice(enders)}",
    "",
    f"**Lesson:** {c['lesson'].capitalize()}.",
]

outfile.write_text("\n".join(paragraphs), encoding="utf-8")
print(f"Story saved to {outfile}")
PY

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add "$FILENAME"
  if ! git diff --cached --quiet; then
    git commit -m "Automated story generation: $SELECTED_MOVIE ($DATE)"
    git push origin main
  else
    echo "No changes to commit."
  fi
else
  echo "Not a git repository, skipping git operations."
fi
