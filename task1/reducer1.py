import sys

current_key = None
sum_count = 0
is_upper_key = True
for line in sys.stdin:
    try:
        key, is_upper, count = line.strip().split('\t', 2)
        count = int(count)
    except ValueError as e:
        continue
    is_upper = bool(is_upper)
    if current_key != key:
        if current_key and is_upper_key and 9 >= len(current_key) >= 6:
            print("%s\t%d" % (current_key, sum_count))
        sum_count = 0
        current_key = key
        is_upper_key = True
    sum_count += count
    if not is_upper:
        is_upper_key = False

if current_key and is_upper_key and 9 >= len(current_key) >= 6:
    print("%s\t%d" % (current_key, sum_count))