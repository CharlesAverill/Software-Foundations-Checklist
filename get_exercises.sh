# ignore that this should just be a python file... it started out as more bash
for filename in "$@"; do
    rp=$(realpath "$filename")
    comments=$(grep "(** *" "$rp")
    python -c "
l = '''${comments}'''.strip().split('\n')
l = [s for s in l if s.startswith('(** *')]
levels = []
titles = []
for i, s in enumerate(l):
    levels.append(s.split(' ')[1].count('*'))
    if levels[-1] != 4 and i != 0:
        levels[-1] += 1
    title = ' '.join(s.split(' ')[2:])
    if i == 0:
        title = title[title.index(':') + 2:]
    if title.endswith(' *)'):
        title = title[:-3]
    titles.append(title)

for i, (level, title) in enumerate(zip(levels, titles)):
    try:
        if level != 4 and level == levels[i + 1]:
            continue
        print('-' + ' -' * level, '[ ]', title)
    except:
        pass"
done
