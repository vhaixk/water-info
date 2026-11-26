<template>
  <div ref="chartRef" class="echarts-container"></div>
</template>

<script setup>
import {computed, onBeforeUnmount, onDeactivated, onMounted, ref, watch} from 'vue'
import * as echarts from 'echarts'
import {debounce} from "lodash-es";
import { isTemTechTheme } from '@/views/hydrology/shared/theme.js'
import { getEchartsLoadingOption, paintTemChartOption } from '@/views/hydrology/shared/chartTheme.js'

const props = defineProps({
  options: {
    type: Object,
    required: true,
  },

  // 可选：是否启用默认的 toolbox 配置，默认为 true
  enableToolbox: {
    type: Boolean,
    default: true
  }
})

const chartRef = ref(null)
let chartInstance = null
let resizeObserver = null

// 合并用户传入的 options 和默认的 toolbox 配置
const mergedOptions = computed(() => {
  if (!props.options) return {}

  const baseOption = clonePlain(props.options)
  if (props.enableToolbox) {
    const userToolbox = baseOption.toolbox || {}
    baseOption.toolbox = {
      show: true,
      right: 20,
      top: 10,
      ...userToolbox,
      feature: {
        dataZoom: {
          yAxisIndex: 'none'
        },
        dataView: {readOnly: false},
        saveAsImage: {},
        ...(userToolbox.feature || {})
      }
    }
  }

  return paintTemChartOption(baseOption, isTemTechTheme.value)
})

function clonePlain(value) {
  if (!value || typeof value !== 'object') return {}
  return {...value}
}

// 初始化图表
const initChart = () => {
  if (!chartRef.value) return

  if (chartInstance) {
    chartInstance.dispose()
  }
  chartInstance = echarts.init(chartRef.value, null, {
    renderer: 'canvas',
    width: 'auto',
    height: 'auto'
  })

  chartInstance.setOption(mergedOptions.value)
  window.addEventListener('resize', handleResize)

  if (typeof ResizeObserver !== 'undefined') {
    resizeObserver = new ResizeObserver(() => {
      chartInstance?.resize()
    })
    resizeObserver.observe(chartRef.value)
  }
}

const handleResize = () => {
  if (chartInstance) {
    chartInstance.resize()
  }
}
let loadingVisible = false
const showLoading = (bool) => {
  loadingVisible = !!bool
  if (!chartInstance) return
  if (bool) {
    chartInstance.showLoading(getEchartsLoadingOption(isTemTechTheme.value))
  } else {
    chartInstance.hideLoading()
  }
}

watch(mergedOptions, debounce((option) => {
  if (!chartInstance || !option) return
  chartInstance.setOption(option, {notMerge: true})
}, 200))

watch(isTemTechTheme, () => {
  if (loadingVisible) showLoading(true)
})

onMounted(() => {
  setTimeout(() => {
    initChart()
  }, 0)
})

onBeforeUnmount(() => {
  if (chartInstance) {
    chartInstance.dispose()
    chartInstance = null
  }
  window.removeEventListener('resize', handleResize)
  if (resizeObserver && chartRef.value) {
    resizeObserver.unobserve(chartRef.value)
    resizeObserver = null
  }
})

defineExpose({
  showLoading
})
onDeactivated(() => {
  if (chartInstance) {
  }
})
</script>

<style scoped>
.echarts-container {
  width: 100%;
  height: 100%;
}
</style>
