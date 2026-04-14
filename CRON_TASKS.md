# 自动生成文章任务

- 任务目标：每天 19:00 生成一篇 A2 难度的动画电影故事。
- 文件路径：data/articles/movie_story_YYYY-MM-DD.md
- 自动化：使用 OpenClaw `cron` 功能 (或心跳配置)。

# 执行逻辑
1. 每日 19:00 触发。
2. 随机选取一部电影（Harry Potter, Zootopia, Moana, Inside Out, Toy Story, Finding Nemo 等）。
3. 调用 AI 编写故事（A2 难度，300-400 词，清晰结构）。
4. 保存文件并 push 到 GitHub。
