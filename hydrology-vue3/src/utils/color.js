/**
 * 颜色对比度工具：为自定义背景色挑选可读的文字颜色。
 * 用于字典配色标签等「背景色由数据决定」的场景，
 * 按 WCAG 相对亮度计算白字/深字的对比度，取对比度更高者。
 */

// 解析 #rgb / #rrggbb / rgb() / rgba() 为 [r, g, b]（0-255），失败返回 null
function parseColor(color) {
  if (typeof color !== 'string') return null
  const str = color.trim().toLowerCase()
  if (str.startsWith('#')) {
    let hex = str.slice(1)
    if (hex.length === 3) hex = hex.split('').map((c) => c + c).join('')
    if (hex.length !== 6) return null
    const num = parseInt(hex, 16)
    if (Number.isNaN(num)) return null
    return [(num >> 16) & 255, (num >> 8) & 255, num & 255]
  }
  const m = str.match(/^rgba?\(\s*(\d+)[,\s]+(\d+)[,\s]+(\d+)/)
  if (m) return [Number(m[1]), Number(m[2]), Number(m[3])]
  return null
}

// WCAG 相对亮度
function luminance([r, g, b]) {
  const channel = (v) => {
    const s = v / 255
    return s <= 0.03928 ? s / 12.92 : Math.pow((s + 0.055) / 1.055, 2.4)
  }
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
}

function contrastRatio(l1, l2) {
  const [hi, lo] = l1 >= l2 ? [l1, l2] : [l2, l1]
  return (hi + 0.05) / (lo + 0.05)
}

const WHITE = '#ffffff'
const DARK = '#303133'
const L_WHITE = 1
const L_DARK = luminance([48, 49, 51])

/**
 * 返回在给定背景色上对比度更高的文字颜色（'#ffffff' 或 '#303133'）。
 * 背景色无法解析时返回 null，调用方保持原有样式。
 */
export function readableTextColor(background) {
  const rgb = parseColor(background)
  if (!rgb) return null
  const l = luminance(rgb)
  return contrastRatio(l, L_WHITE) >= contrastRatio(l, L_DARK) ? WHITE : DARK
}