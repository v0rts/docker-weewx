import time
import math
import os
import weewx.wxservices

os.environ['TZ'] = 'America/Los_Angeles'
time.tzset()

# Roughly nine months of data:
start_tt = (2010, 1, 1, 0, 0, 0, 0, 0, -1)
stop_tt = (2010, 9, 3, 11, 20, 0, 0, 0, -1)
start_ts = int(time.mktime(start_tt))
stop_ts = int(time.mktime(stop_tt))

altitude_vt = (700, 'foot', 'group_altitude')
latitude = 45
longitude = -125

daily_temp_range = 40.0
annual_temp_range = 80.0
avg_temp = 40.0

# Four day weather cycle:
weather_cycle = 3600 * 24.0 * 4
weather_baro_range = 2.0
weather_wind_range = 10.0
weather_rain_total = 0.5  # This is inches per weather cycle
avg_baro = 30.0

# Archive interval in seconds:
interval = 600
interval = 3600


def genFakeRecords(start_ts=start_ts, stop_ts=stop_ts, interval=interval,
                   amplitude=1.0, day_phase_offset=math.pi/4.0, annual_phase_offset=0.0,
                   weather_phase_offset=0.0, db_manager=None):
    pressure_cooker = weewx.wxservices.PressureCooker(altitude_vt)
    rain_rater = weewx.wxservices.RainRater(3600, 3800)
    wx_types = weewx.wxservices.WXXTypes({}, altitude_vt, latitude, longitude)
    weewx.xtypes.xtypes.append(pressure_cooker)
    weewx.xtypes.xtypes.append(rain_rater)
    weewx.xtypes.xtypes.append(wx_types)

    count = 0

    for ts in range(start_ts, stop_ts + interval, interval):
        daily_phase = ((ts - start_ts) * 2.0 * math.pi ) / (3600 * 24.0) + day_phase_offset
        annual_phase = ((ts - start_ts) * 2.0 * math.pi ) / (3600 * 24.0 * 365.0) + annual_phase_offset
        weather_phase = ((ts - start_ts) * 2.0 * math.pi ) / weather_cycle + weather_phase_offset
        record = {
            'dateTime': ts,
            'usUnits': weewx.US,
            'interval': interval / 60,
            'outTemp': 0.5 * amplitude * (-daily_temp_range * math.sin(daily_phase)
                                          - annual_temp_range * math.cos(annual_phase)) + avg_temp,
            'barometer': -0.5 * amplitude * weather_baro_range * math.sin(weather_phase) + avg_baro,
            'windSpeed': abs(amplitude * weather_wind_range * (1.0 + math.sin(weather_phase))),
            'windDir': math.degrees(weather_phase) % 360.0,
            'outHumidity': 40 * math.sin(weather_phase) + 50
        }
        record['windGust'] = 1.2 * record['windSpeed']
        record['windGustDir'] = record['windDir']
        if math.sin(weather_phase) > .95:
            record['rain'] = 0.04 * amplitude if math.sin(weather_phase) > 0.98 else 0.01 * amplitude
        else:
            record['rain'] = 0.0

        # Make every 71st observation (a prime number) a null. This is a deterministic algorithm, so it
        # will produce the same results every time.
        for obs_type in ['barometer', 'outTemp', 'windDir', 'windGust', 'windGustDir', 'windSpeed']:
            count += 1
            if count % 71 == 0:
                record[obs_type] = None

        if db_manager:
            record['dewpoint'] = weewx.xtypes.get_scalar('dewpoint', record, db_manager)[0]
            record['pressure'] = weewx.xtypes.get_scalar('pressure', record, db_manager)[0]
            record['altimeter'] = weewx.xtypes.get_scalar('altimeter', record, db_manager)[0]
            record['ET'] = weewx.xtypes.get_scalar('ET', record, db_manager)[0]

        record['weather_sin'] = math.sin(weather_phase)
        yield record

count = 0
for record in genFakeRecords():
    if count % 30 == 0:
        print("Time                        outTemp   windSpeed   barometer rain dayphase")
    count += 1
    outTemp = "%10.1f" % record['outTemp'] if record['outTemp'] is not None else "       N/A"
    windSpeed = "%10.1f" % record['windSpeed'] if record['windSpeed'] is not None else "       N/A"
    barometer = "%10.1f" % record['barometer'] if record['barometer'] is not None else "       N/A"
    rain = "%10.2f" % record['rain'] if record['rain'] is not None else "       N/A"
    weather_sin = "%10.2f" % record['weather_sin']
    print(6 * "%s" % (time.ctime(record['dateTime']), outTemp, windSpeed, barometer, rain, weather_sin))
