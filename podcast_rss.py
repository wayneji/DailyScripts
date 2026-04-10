import xml.etree.ElementTree as ET
from datetime import datetime

def add_episode(title, mp3_url, duration):
    tree = ET.parse("podcast.xml")
    root = tree.getroot()
    channel = root.find("channel")

    item = ET.SubElement(channel, "item")
    ET.SubElement(item, "title").text = title
    ET.SubElement(item, "enclosure", url=mp3_url, type="audio/mpeg", length="0")
    ET.SubElement(item, "pubDate").text = datetime.now().strftime("%a, %d %b %Y %H:%M:%S +0000")
    ET.SubElement(item, "itunes:duration").text = duration

    tree.write("podcast.xml", encoding="UTF-8", xml_declaration=True)
    print("Podcast RSS updated.")

if __name__ == "__main__":
    # Test update
    add_episode("Test Episode", "https://wayneji.github.io/DailyScripts/test.mp3", "10:00")
