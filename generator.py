import os
from datetime import datetime

def generate_article(topic):
    # Logic: Call LLM to generate kid-friendly story
    today = datetime.now().strftime("%Y-%m-%d")
    path = f"data/articles/{today}.md"
    # Placeholder: write dummy content for now
    content = f"# Today's Story: {topic}\n\nOnce upon a time..."
    os.makedirs("data/articles", exist_ok=True)
    with open(path, "w") as f:
        f.write(content)
    print(f"Article saved to {path}")

def generate_podcast_script(article_date):
    # Logic: Read article, call LLM to convert to dialogue script
    path = f"data/articles/{article_date}.md"
    if not os.path.exists(path):
        print("Article not found.")
        return
    with open(path, "r") as f:
        content = f.read()
    print(f"Converting {path} to script...")
    # Add LLM call here

if __name__ == "__main__":
    import sys
    if sys.argv[1] == "article-gen":
        generate_article("The Adventure of Little Star")
    elif sys.argv[1] == "podcast-gen":
        generate_podcast_script(datetime.now().strftime("%Y-%m-%d"))
