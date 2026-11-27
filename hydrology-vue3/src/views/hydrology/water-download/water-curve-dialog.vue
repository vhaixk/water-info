<template>
  <el-dialog
      v-model="visible"
      :title="config.title"
      align-center
      append-to-body
      destroy-on-close
      width="80%"
  >
    <div class="curve-toolbar">
      <el-date-picker
          v-model="dates"
          :clearable="false"
          :shortcuts="DateEnum.shortcuts()"
          end-placeholder="结束时间"
          range-separator="至"
          start-placeholder="开始时间"
          style="width: 240px"
          type="daterange"
          unlink-panels
      />
      <el-select v-if="config.metrics.length > 1" v-model="activeMetric" style="width: 200px">
        <el-option v-for="m in config.metrics" :key="m.prop" :label="m.label" :value="m.prop"/>
      </el-select>
      <el-button :loading="loading" icon="Search" type="primary" @click="loadData">查询</el-button>
      <el-button :disabled="rows.length === 0" icon="Download" style="margin-left: auto" type="success"
                 @click="handleExport">导出</el-button>
    </div>
    <!-- 左表格右图：表格行分页限制 DOM，图表仍用全量数据 -->
    <el-container style="height: 60vh; overflow: hidden">
      <el-aside style="display: flex; flex-direction: column; overflow: hidden" width="40%">
        <el-table
            v-loading="loading"
            :data="pagedRows"
            border
            height="100%"
            scrollbar-always-on
            stripe
            style="width: 100%; flex: 1; min-height: 0"
        >
          <el-table-column align="center" label="监测时间" min-width="140">
            <template #default="{row}">{{ formatTime(row[config.timeProp]) }}</template>
          </el-table-column>
          <el-table-column v-for="m in config.metrics" :key="m.prop" :label="m.label" :prop="m.prop"
                           align="center" min-width="100"/>
          <el-table-column v-for="l in config.referenceLines" :key="l.prop" :label="l.label" :prop="l.prop"
                           align="center" min-width="100"/>
        </el-table>
        <el-pagination
            v-model:current-page="page"
            v-model:page-size="pageSize"
            :page-sizes="[50, 100, 200]"
            :total="rows.length"
            background
            layout="total, prev, pager, next"
            size="small"
            style="flex-shrink: 0; padding: 6px 0; justify-content: flex-end"
        />
      </el-aside>
      <el-divider direction="vertical" style="height: 100%; margin: 0 10px"/>
      <el-main style="padding: 0; overflow: hidden">
        <e-chart-component v-if="rows.length > 0" :options="chartOptions" style="height: 100%; width: 100%"/>
        <el-empty v-else-if="!loading" description="所选时间段内暂无数据"/>
      </el-main>
    </el-container>
  </el-dialog>
</template>

<script setup>
import dayjs from 'dayjs';
import {computed, ref, shallowRef} from 'vue';
import EChartComponent from '@/views/tool/echart/eChartComponent.vue';
import DateEnum from '@/views/tool/date/dateEnum.js';
import {exportData} from '@/utils/exportTable.js';

const visible = ref(false)
const loading = ref(false)
const config = ref({metrics: [], referenceLines: []})
// 浅层响应 + 行分页：长时间序列下限制 DOM 行数，图表仍用全量数据
const rows = shallowRef([])
const page = ref(1)
const pageSize = ref(50)
const pagedRows = computed(() => {
  const start = (page.value - 1) * pageSize.value
  return rows.value.slice(start, start + pageSize.value)
})
const dates = ref([])
const activeMetric = ref('')

const formatTime = (v) => v ? dayjs(v).format('YYYY-MM-DD HH:mm') : ''

// config: {title, timeProp, metrics:[{prop,label}], defaultMetric, referenceLines, fetchRows(dates)}
const open = async (cfg) => {
  config.value = {referenceLines: [], ...cfg}
  // 页面默认只查当天，曲线默认取最近 7 天便于观察趋势
  dates.value = [dayjs().subtract(7, 'day').format('YYYY-MM-DD'), dayjs().add(1, 'day').format('YYYY-MM-DD')]
  activeMetric.value = cfg.defaultMetric || cfg.metrics[0]?.prop
  rows.value = []
  page.value = 1
  visible.value = true
  await loadData()
}

const loadData = async () => {
  loading.value = true
  try {
    const data = await config.value.fetchRows(dates.value)
    const timeProp = config.value.timeProp
    rows.value = (data || []).slice().sort((a, b) => dayjs(a[timeProp]).valueOf() - dayjs(b[timeProp]).valueOf())
    page.value = 1
  } finally {
    loading.value = false
  }
}

const toNumber = (v) => {
  const n = parseFloat(v)
  return Number.isFinite(n) ? n : null
}

// 当前选中指标
const activeMetricItem = computed(() => {
  const {metrics} = config.value
  return metrics.find(m => m.prop === activeMetric.value) || metrics[0]
})

// 按测值分段着色（低→高：紫蓝→红），右侧展示色带图例
const buildVisualMap = (values) => {
  const nums = values.filter(v => v !== null)
  if (nums.length === 0) return null
  const min = Math.min(...nums)
  const max = Math.max(...nums)
  const colors = ['#7e57c2', '#5ab1ef', '#26c0c0', '#fac858', '#fc8452', '#e53935']
  if (min === max) {
    return {type: 'piecewise', seriesIndex: 0, dimension: 1, right: 0, top: 'middle',
      pieces: [{gte: min, lte: max, label: min.toFixed(2), color: colors[0]}]}
  }
  const step = (max - min) / colors.length
  const pieces = colors.map((color, i) => {
    const lo = min + step * i
    const hi = min + step * (i + 1)
    const piece = {gte: lo, color, label: `${lo.toFixed(2)} - ${hi.toFixed(2)}`}
    if (i < colors.length - 1) piece.lt = hi
    else piece.lte = max
    return piece
  })
  return {type: 'piecewise', seriesIndex: 0, dimension: 1, right: 0, top: 'middle', pieces}
}

const chartOptions = computed(() => {
  const {timeProp, referenceLines} = config.value
  const active = activeMetricItem.value
  if (!active) return {}
  const times = rows.value.map(r => dayjs(r[timeProp]).format('MM-DD HH:mm'))
  const values = rows.value.map(r => toNumber(r[active.prop]))
  const series = [{
    name: active.label,
    type: 'line',
    data: values,
    smooth: true,
    showSymbol: false,
    connectNulls: true,
  }]
  // 参考线（如警戒水位）始终绘制，虚线区分
  referenceLines.forEach(line => {
    series.push({
      name: line.label,
      type: 'line',
      data: rows.value.map(r => toNumber(r[line.prop])),
      showSymbol: false,
      connectNulls: true,
      lineStyle: {type: 'dashed'},
      itemStyle: {color: '#F56C6C'},
    })
  })
  return {
    tooltip: {trigger: 'axis'},
    legend: {show: series.length > 1, top: 8},
    grid: {left: 70, right: 130, top: 50, bottom: 60},
    xAxis: {type: 'category', data: times},
    yAxis: {type: 'value', scale: true, name: active.label},
    visualMap: buildVisualMap(values),
    dataZoom: [
      {type: 'inside'},
      {type: 'slider', height: 18, bottom: 10},
    ],
    series,
  }
})

const handleExport = () => {
  const {timeProp, referenceLines, title} = config.value
  const active = activeMetricItem.value
  const headers = ['监测时间', active.label, ...referenceLines.map(l => l.label)]
  const data = rows.value.map(r => [
    dayjs(r[timeProp]).format('YYYY-MM-DD HH:mm'),
    toNumber(r[active.prop]) ?? r[active.prop],
    ...referenceLines.map(l => toNumber(r[l.prop]) ?? r[l.prop]),
  ])
  exportData(headers, data,
      `${title} ${dayjs(dates.value[0]).format('YYYYMMDD')}-${dayjs(dates.value[1]).format('YYYYMMDD')}`)
}

defineExpose({open})
</script>

<style lang="scss" scoped>
.curve-toolbar {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
}
</style>