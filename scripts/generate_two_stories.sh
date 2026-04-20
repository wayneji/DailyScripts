#!/bin/bash
set -euo pipefail

cd /Users/weimingji/.openclaw/workspace || exit 1
mkdir -p data/articles

DRIVE_DIR="/Users/weimingji/My Drive/Docs/KidsStory"
mkdir -p "$DRIVE_DIR"

DATE=$(date +%F)

write_story() {
  local slug="$1"
  local title="$2"
  local movie="$3"
  local content="$4"
  local filename="data/articles/movie_story_${DATE}_${slug}.md"

  cat > "$filename" <<EOF
# $title

$content
EOF

  cp "$filename" "$DRIVE_DIR/$(basename "$filename")"

  echo "$filename"
}

FILE1=$(write_story \
  "zootopia-the-rainy-day-case" \
  "Zootopia and the Rainy Day Case" \
  "Zootopia" \
  "It was a rainy morning in Zootopia. Judy Hopps looked out of the window at the grey sky. She wanted a busy day, but the streets were quiet because of the rain. Then Nick Wilde came into the police station with two hot drinks and a big smile.\n\n\"Good morning, Officer Hopps,\" Nick said. \"I think today will still be interesting.\"\n\nJudy laughed and took a drink. Just then, Clawhauser called them. A small shop owner needed help. A bag of carrots was missing, and the owner was very worried because the carrots were for a family dinner that night.\n\nJudy and Nick went to the shop at once. The floor was wet, and there were little marks near the door. Judy looked carefully at the marks. Nick looked outside and saw something orange under a bench across the street.\n\n\"I think we have our first clue,\" Nick said.\n\nThey crossed the street and found one wet carrot. After that, they followed more carrots to a bus stop. There they saw a young goat with a broken bag. He looked scared and cold.\n\nJudy spoke in a kind voice. \"Did you take these carrots?\"\n\nThe goat nodded. \"I am sorry,\" he said. \"My mother is sick, and I wanted to make soup for her. I had no money, so I made a bad choice.\"\n\nJudy understood his problem, but she also knew stealing was wrong. Nick talked to the shop owner, and Judy talked to the goat. In the end, the goat said sorry and promised to work in the shop after school for one week. The shop owner agreed because he saw that the goat was honest now.\n\nWhen the rain stopped, Judy smiled. The carrots were not all lost, the goat learned a lesson, and the family could still have dinner.\n\nThat day, Judy and Nick learned that a good police officer must look for the truth, but also remember kindness."
)

FILE2=$(write_story \
  "inside-out-the-missing-smile" \
  "Inside Out and the Missing Smile" \
  "Inside Out" \
  "It was a quiet afternoon in Headquarters. Joy moved quickly from one place to another and checked the memory shelves. Everything looked normal at first, but then she stopped. One bright yellow memory orb was not in its place.\n\n\"Sadness, can you come here?\" Joy asked.\n\nSadness walked over slowly. She looked at the empty space on the shelf and said, \"Maybe it rolled away.\"\n\nJoy shook her head. \"This is Riley’s happy memory from school. We need to find it before the end of the day.\"\n\nSo Joy and Sadness started to search. First, they looked under the control panel. Then they checked the long floor near the memory tube. After that, they visited Imagination Land because Bing Bong sometimes picked up interesting things by mistake. But the memory was not there.\n\nJoy began to worry. \"If we do not find it, Riley may forget this nice moment,\" she said.\n\nSadness sat quietly for a minute. Then she looked at a small blue mark near the shelf. \"Joy, look at this,\" she said. \"Something rolled this way.\"\n\nThey followed the mark to a dark corner behind some old boxes. There, they found the yellow memory orb. But there was also another memory orb next to it. It was blue.\n\nJoy picked up the yellow one with relief. Then Sadness touched the blue one and smiled a little. \"This is from the same day,\" she said. \"Riley was happy at school, but later she missed home. Both feelings were important.\"\n\nJoy was quiet for a moment. Then she nodded. \"You are right. A day can have more than one feeling.\"\n\nTogether they put both memory orbs back in the right place. At once, Headquarters felt calm again.\n\nThat afternoon, Joy learned a simple lesson: happiness is special, but it becomes stronger when we understand every feeling around it."
)

git add -- "$FILE1" "$FILE2"
if ! git diff --cached --quiet; then
  git commit -m "Automated story generation: daily pair ($DATE)"
  git push origin main
fi

echo "Generated, pushed, and copied to Google Drive: $FILE1 $FILE2"
