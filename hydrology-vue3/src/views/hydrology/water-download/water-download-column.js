import dayjs from "dayjs";

export const columns = {
    hy_download_water_sk: [
        {prop: "basin_name", label: "流域", minWidth: 140,fixed:'left'},
        {prop: "river_name", label: "河名", minWidth: 140,fixed:'left'},
        {prop: "province_name", label: "行政区划", minWidth: 140,fixed:'left'},
        {prop: "station_name", label: "站名", minWidth: 140,fixed:'left'},
        {prop: "monitor_time", label: "监测时间", minWidth: 140},
        {prop: "origin_monitor_time", label: "(原)监测时间", minWidth: 140},
        {prop: "monitor_value", label: "库水位(m)", minWidth: 140},
        {prop: "monitor_value_diff", label: "日变幅(m)", minWidth: 140},
        {prop: "create_time", label: "创建时间", minWidth: 140},
    ],
    hy_download_water_yq: [
        {prop: "basin_name", label: "流域", minWidth: 140,fixed:'left'},
        {prop: "river_name", label: "河名", minWidth: 140,fixed:'left'},
        {prop: "province_name", label: "行政区划", minWidth: 140,fixed:'left'},
        {prop: "station_name", label: "站名", minWidth: 140,fixed:'left'},
        {prop: "monitor_time", label: "监测时间", minWidth: 140},
        {prop: "origin_monitor_time", label: "(原)监测时间", minWidth: 140},
        {prop: "monitor_value", label: "日降雨(mm)", minWidth: 140},
        {prop: "create_time", label: "创建时间", minWidth: 140},
    ],
    hy_download_water_dj: [
        {prop: "basin_name", label: "流域", minWidth: 140,fixed:'left'},
        {prop: "river_name", label: "河名", minWidth: 140,fixed:'left'},
        {prop: "province_name", label: "行政区划", minWidth: 140,fixed:'left'},
        {prop: "station_name", label: "站名", minWidth: 140,fixed:'left'},
        {prop: "monitor_time", label: "监测时间", minWidth: 140},
        {prop: "origin_monitor_time", label: "(原)监测时间", minWidth: 140},
        {prop: "monitor_value", label: "水位(m)", minWidth: 140},
        {prop: "monitor_value_warn", label: "警戒水位(m)", minWidth: 140},
        {prop: "create_time", label: "创建时间", minWidth: 140},
    ]
}

export default  {columns}
