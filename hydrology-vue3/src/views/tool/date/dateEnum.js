export function shortcuts() {
    return [
        {
            text: '最近一天',
            value: () => {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24)
                return [start, end]
            },
        },
        {
            text: '最近一周',
            value: () => {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)

                return [start, end]
            },
        },
        {
            text: '最近一月',
            value: () => {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
                return [start, end]
            },
        },
        {
            text: '最近三月',
            value: () => {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 30 * 3)
                return [start, end]
            },
        }, {
            text: '最近一年',
            value: () => {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 30 * 12)
                return [start, end]
            },
        },
    ]
}


export function getEChartFormat(timeInterval ) {
    switch (timeInterval) {
        case "datetimerange":
        case "datetime":
            return  "{yyyy}-{MM}-{dd} {HH}:{mm}:{ss}";
        case "daterange":
        case "date":
            return "{yyyy}-{MM}-{dd} {HH}:{mm}";
        case "monthrange":
        case "month":
            return "{yyyy}-{MM}-{dd}";
        case "yearrange":
        case "year":
            return "{yyyy}-{MM}";
    }

}


export default {shortcuts,getEChartFormat}
