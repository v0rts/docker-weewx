import weeutil.weeutil
import weewx.manager
import weewx.xtypes
from weeutil.weeutil import TimeSpan

timespan = TimeSpan(1573245000, 1573246800)
print(timespan)
archive_sqlite = {'database_name': '/home/weewx/archive/weepwr.sdb', 'driver': 'weedb.sqlite'}

with weewx.manager.Manager.open(archive_sqlite) as db_manager:
    value = weewx.xtypes.get_aggregate('ch8_a_energy2', timespan, 'tderiv', db_manager)