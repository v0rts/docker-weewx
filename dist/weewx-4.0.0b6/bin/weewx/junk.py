epsilon = 5


class TimeStamp(object):
    """This class represents a timestamp. It uses a 'fuzzy' compare.
    That is, if the times are within epsilon seconds of each other, they compare true."""

    def __init__(self, ts):
        self.ts = ts

    def __cmp__(self, other_ts):
        if self.__eq__(other_ts):
            return 0
        return 1 if self.ts > other_ts.ts else -1

    def __hash__(self):
        # return hash(self.ts)
        return 1

    def __eq__(self, other_ts):
        return abs(self.ts - other_ts.ts) <= epsilon

    def __lt__(self, other_ts):
        return self.ts < other_ts.ts

    def __str__(self):
        return str(self.ts)


wu_epoch = [
    1576299899,
    1576300199,
    1576300499,
    1576300799,
    1576301099,
    1576301399,
    1576301699,
    1576301940,
    1576302299,
]

archive_epoch = [
    1576299600,
    1576299900,
    1576300200,
    1576300500,
    1576300800,
    1576301100,
    1576301400,
    1576301700,
    1576302000,
    1576302300,
]

wu_TS = [TimeStamp(ts) for ts in wu_epoch]
archive_TS = [TimeStamp(ts) for ts in archive_epoch]

wu_set = set(wu_TS)
archive_set = set(archive_TS)
diff = archive_set.difference(wu_set)
print(len(diff))
print(diff)
