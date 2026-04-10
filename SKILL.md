# Kids Podcast Skill

## Description
Generates a kid-friendly story (Day 1) and converts it into a dialogue podcast episode (Day 2).

## Files
- `generator.py`: Core logic for generating content, dialogue scripts, and calling TTS.
- `podcast_rss.py`: Logic for updating the RSS feed file.
- `config.json`: Configuration for ElevenLabs, S3/Github credentials.

## Usage
- Run article generation: `kidspodcast article-gen`
- Run podcast generation: `kidspodcast podcast-gen`

## Workflow
1. Day 1: `article-gen` fetches/creates a story -> `articles/YYYY-MM-DD.md`.
2. Day 2: `podcast-gen` reads article -> writes `scripts/YYYY-MM-DD.py` -> calls TTS -> updates `feed.xml` -> pushes to remote.
