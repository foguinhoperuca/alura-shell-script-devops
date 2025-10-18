import re
import requests


def get_headings() -> None:
    # pattern = r'<(h[1-2])[^>]*>(.*?)<\/(h[1-2])>'
    pattern = r'<(h[1|2])[^>]*>(.*?)<\/\1>'  # backreference
    headings = re.findall(pattern, html_content, re.DOTALL)
    for heading in headings:
        print(f'--- {heading}')


def get_word_boundary() -> None:
    pattern = r'\bbank\b'
    lines = html_content.split('\n')
    for index, line in enumerate(lines, start=1):
        if re.search(pattern, line, re.IGNORECASE):
            print(f'Line {index}: {line}')


url: str = 'https://monicahillman.github.io/monibank/'
response = requests.get(url)
html_content = response.text
get_headings()
print('-------')
get_word_boundary()
