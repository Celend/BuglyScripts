import re, sys

skey = re.findall('token-skey=(.*?);', sys.argv[1])[0];

t = 5381
for c in skey:
    t += (t << 5 & 2147483647) + c.encode('ascii')[0]

print(str(2147483647 & t))
