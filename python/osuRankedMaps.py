import requests
from bs4 import BeautifulSoup

def fetch_beatmaps_page(page_url):
    response = requests.get(page_url)
    if response.status_code == 200:
        return response.text
    else:
        print(f"Failed to fetch page. Status code: {response.status_code}")
        return None

base_url = "https://beatconnect.io/"
page_number = 1

while True:
    print(f"Fetching page {page_number} for ranked beatmaps...")
    page_url = f"{base_url}?page={page_number}"

    page_content = fetch_beatmaps_page(page_url)
    if not page_content:
        break

    soup = BeautifulSoup(page_content, 'html.parser')

    # update the class name based on the inspection
    beatmaps = soup.find_all('div', class_='beatmap-class')  # change this class name based on inspection

    if not beatmaps:
        print("No beatmaps found on this page.")
        break

    for beatmap in beatmaps:
        title = beatmap.find('h3', class_='beatmap-title').text.strip()  # update based on your inspection
        beatmap_id = beatmap.get('data-id')  # adjust if need be
        download_link = beatmap.find('a', class_='download-link')['href']  # adjust if need be

        print(f"Found beatmap: {title} (ID: {beatmap_id}) - Download Link: {download_link}")

    page_number += 1
  
# i tried to get this to work via webscraping but idk what im doing wrong
