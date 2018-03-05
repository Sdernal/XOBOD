import sys
import re

for line in sys.stdin:
    try:
        article_id, text = line.strip().split('\t',1)
        text = re.sub('[,\.;":?!\']', ' ', text)
    except ValueError as e:
        continue
    words = text.split(' ')
    for word in words:
        is_upper = False
        if word[:1].isupper():
            is_upper = True
        print("%s\t%i\t%d" %  (word.lower(), is_upper, 1))
