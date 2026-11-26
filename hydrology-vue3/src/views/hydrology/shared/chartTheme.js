function cloneChartOption(value, seen = new WeakMap()) {
  if (typeof value === 'function' || value == null || typeof value !== 'object') return value
  if (seen.has(value)) return seen.get(value)
  if (Array.isArray(value)) {
    const copy = []
    seen.set(value, copy)
    value.forEach((item, index) => {
      copy[index] = cloneChartOption(item, seen)
    })
    return copy
  }
  if (Object.getPrototypeOf(value) !== Object.prototype) return value
  const copy = {}
  seen.set(value, copy)
  Object.keys(value).forEach((key) => {
    copy[key] = cloneChartOption(value[key], seen)
  })
  return copy
}

/**
 * Homepage chart theme. Do not change business series; only axis / legend / tooltip colors.
 * Clone first so painting never writes back into the caller's reactive option.
 */
export function paintTemChartOption(option, tech) {
  if (!option || typeof option !== 'object') return option
  option = cloneChartOption(option)
  const colors = tech
    ? { text: '#cfe8ff', axis: '#7aa7d6', split: 'rgba(26, 200, 255, 0.14)', axisLine: 'rgba(26, 200, 255, 0.35)', icon: '#7aa7d6', iconActive: '#1ac8ff' }
    : { text: '#303133', axis: '#606266', split: 'rgba(64, 158, 255, 0.18)', axisLine: '#dcdfe6', icon: '#606266', iconActive: '#409EFF' }
  const paintAxis = (axis) => {
    if (!axis) return axis
    ;(Array.isArray(axis) ? axis : [axis]).forEach((item) => {
      item.axisLabel = { ...(item.axisLabel || {}), color: colors.axis }
      item.nameTextStyle = { ...(item.nameTextStyle || {}), color: colors.axis }
      item.axisLine = { ...(item.axisLine || {}), lineStyle: { ...(item.axisLine?.lineStyle || {}), color: colors.axisLine } }
      item.axisTick = { ...(item.axisTick || {}), lineStyle: { ...(item.axisTick?.lineStyle || {}), color: colors.axisLine } }
      item.splitLine = { ...(item.splitLine || {}), lineStyle: { ...(item.splitLine?.lineStyle || {}), color: colors.split } }
    })
    return axis
  }
  const each = (target, fn) => {
    if (!target) return
    ;(Array.isArray(target) ? target : [target]).forEach(fn)
  }
  option.backgroundColor = 'transparent'
  option.textStyle = { ...(option.textStyle || {}), color: colors.text }
  option.xAxis = paintAxis(option.xAxis)
  option.yAxis = paintAxis(option.yAxis)
  each(option.legend, (legend) => {
    legend.textStyle = { ...(legend.textStyle || {}), color: colors.text }
    legend.pageTextStyle = { ...(legend.pageTextStyle || {}), color: colors.text }
    legend.pageIconColor = colors.icon
    legend.pageIconInactiveColor = colors.axis
  })
  each(option.visualMap, (visualMap) => {
    visualMap.textStyle = { ...(visualMap.textStyle || {}), color: colors.text }
  })
  each(option.dataZoom, (zoom) => {
    zoom.textStyle = { ...(zoom.textStyle || {}), color: colors.text }
    zoom.borderColor = colors.axisLine
    zoom.handleStyle = { ...(zoom.handleStyle || {}), borderColor: colors.icon }
  })
  option.toolbox = {
    ...(option.toolbox || {}),
    iconStyle: { borderColor: colors.icon },
    emphasis: { ...(option.toolbox?.emphasis || {}), iconStyle: { borderColor: colors.iconActive } }
  }
  option.tooltip = {
    ...(option.tooltip || {}),
    ...(tech
      ? {
          backgroundColor: 'rgba(9, 44, 118, 0.96)',
          borderColor: 'rgba(26, 200, 255, 0.35)',
          textStyle: { ...(option.tooltip?.textStyle || {}), color: '#eaf7ff' },
          extraCssText: 'color:#eaf7ff;box-shadow:0 8px 22px rgba(4,16,56,0.35);'
        }
      : {
          backgroundColor: '#fff',
          borderColor: '#dcdfe6',
          textStyle: { ...(option.tooltip?.textStyle || {}), color: '#303133' }
        })
  }
  return option
}

export function getEchartsLoadingOption(tech) {
  const loadingText = '\u6b63\u5728\u52a0\u8f7d\u6570\u636e...'
  const fontFamily = 'Microsoft YaHei, PingFang SC, sans-serif'
  if (tech) {
    return {
      text: loadingText,
      color: '#1ac8ff',
      textColor: '#cfe8ff',
      maskColor: 'rgba(6, 26, 74, 0.78)',
      fontSize: 14,
      fontFamily,
      zlevel: 2
    }
  }
  return {
    text: loadingText,
    color: '#409EFF',
    textColor: '#606266',
    maskColor: 'rgba(255, 255, 255, 0.8)',
    fontSize: 14,
    fontFamily,
    zlevel: 2
  }
}
