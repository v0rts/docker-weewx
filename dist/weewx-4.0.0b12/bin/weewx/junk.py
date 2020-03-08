from functools import reduce
import six
response = b"\x01\x02\x03"

r=()
for b in six.iterbytes(response):
    r += (b % 16, b // 16)
# flatten = lambda a, b: a + (six.byte2int(b) % 16, six.byte2int(b) / 16)
# r = reduce(flatten, response, ())
print(r[:2])
