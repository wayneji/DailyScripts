# 自动生成文章任务

- 任务目标：每天 19:00 生成一篇 A2 难度的动画电影故事。
- 文件路径：data/articles/movie_story_YYYY-MM-DD.md
- 自动化：使用 OpenClaw `cron` 功能。

# 执行逻辑
1. 每日 19:00 触发。
2. 随机选取一部电影（Harry Potter, Zootopia, Moana, Inside Out, Toy Story, Finding Nemo 等）。
3. 使用以下 Prompt 生成内容：

---
Role: You are an expert English language teacher and story writer.

Task: Randomly choose one movie from this list: [Harry Potter, Zootopia, Moana, Inside Out, Toy Story, Finding Nemo and other Disney,Pixar and dreamworks,Universal Movies]. Write a story based on it. Make sure the story is different each time.

Difficulty Level: A2 Key for Schools (KET).

Use the CEFR A2 vocabulary list.

Avoid complex idioms or long, complicated sentences.

Use clear connectors (and, but, because, so, then, after that).

Word Count: 300 - 400 words.

Story Guidelines:

No Crossovers: Keep the story strictly within the original movie's universe.

Character: Focus on 1 or 2 main characters from the movie.

Plot: Create a simple, original short story (an everyday adventure or a specific scene). Do not just summarize the movie plot.

Structure: 
- Introduction: Set the scene and introduce the characters.
- Body: Describe a small problem or challenge they face.
- Conclusion: How they solve it and a simple lesson learned (about friendship, bravery, or kindness).
---

4. 保存文件并 push 到 GitHub。
