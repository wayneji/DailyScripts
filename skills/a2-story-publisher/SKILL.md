---
name: a2-story-publisher
description: Generate an A2-level movie story, save it as a markdown article, and commit/push it to GitHub. Use when the user asks to create a new story article, run the story cron task, write a CEFR A2 movie-based story, or publish story output to the DailyScripts repo.
---

# A2 Story Publisher

## Goal
Generate one original A2-level movie story, save it under `data/articles/`, and publish it to GitHub.

## Workflow
1. Pick one movie from the approved list, or follow the user’s choice.
2. Write a short, original story in simple English.
3. Keep it inside the movie’s universe, with 1 or 2 main characters.
4. Aim for 300 to 400 words.
5. Save it as `data/articles/movie_story_YYYY-MM-DD_<story-slug>.md` unless the user asks for another filename.
6. Build `<story-slug>` from the story title using short lowercase words joined with hyphens.
7. Commit only the story file, then push `main`.

## Story Rules
- Use A2 words and short sentences.
- Use clear connectors: and, but, because, so, then, after that.
- Do not summarize the whole movie.
- Include: introduction, small problem, simple resolution, one lesson.
- Keep the tone warm, calm, and easy to read.

## Publishing Notes
- If git push fails, check SSH auth first, then retry.
- Do not stage unrelated workspace files.
- Use filename slugs to avoid overwriting multiple stories generated on the same day.
- Commit message format: `Automated story generation: <movie> - <story-slug> (<date>)`.

## Reference Prompt
Use the exact prompt template in [references/prompt.md](references/prompt.md) when a story needs to be regenerated from the standard brief.
