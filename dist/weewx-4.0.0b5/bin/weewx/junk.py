import weewx


class MyTypes(object):

    def get_value(self, obs_type, record, db_manager):

        if obs_type == 'dewpoint':
            if record['usUnits'] == weewx.US:
                return weewx.wxformulas.dewpointF(record.get('outTemp'), record.get('outHumidity'))
            elif record['usUnits'] == weewx.METRIC or record['usUnits'] == weewx.METRICWX:
                return weewx.wxformulas.dewpointC(record.get('outTemp'), record.get('outHumidity'))
            else:
                raise ValueError("Unknown unit system %s" % record['usUnits'])
        else:
            raise weewx.UnknownType(obs_type)

class MyVector(object):

    def get_aggregate(self, obs_type, timespan,
                      aggregate_type=None,
                      aggregate_interval=None):

        if obs_type.starts_with('ch'):
            "something"

        else:
            raise weewx.UnknownType(obs_type)