/**
 * 内容区双风格（与首页一致）
 * 'light' = 浅色风格
 * 'tech'  = 深蓝风格
 *
 * 由导航栏主题按钮切换，写入 localStorage，并同步到 <html> class。
 * 不覆盖头部导航 / 标题 / 侧边栏。
 */
import { computed, ref } from 'vue'

const STORAGE_KEY = 'tem-home-theme'
const DEFAULT_THEME = 'tech'

function readStoredTheme() {
  try {
    const stored = localStorage.getItem(STORAGE_KEY)
    if (stored === 'light' || stored === 'tech') return stored
  } catch (e) {
    /* ignore */
  }
  return DEFAULT_THEME
}

function persistTheme(theme) {
  try {
    localStorage.setItem(STORAGE_KEY, theme)
  } catch (e) {
    /* ignore */
  }
}

function applyDocumentTheme(theme) {
  if (typeof document === 'undefined') return
  const root = document.documentElement
  root.classList.remove('tem-app-light', 'tem-app-tech')
  root.classList.add(theme === 'tech' ? 'tem-app-tech' : 'tem-app-light')
}

export const temHomeTheme = ref(readStoredTheme())
applyDocumentTheme(temHomeTheme.value)

/** TEM_HOME_THEME 用于 tem-theme-${name} */
export const TEM_HOME_THEME = temHomeTheme

/** 是否深蓝风。用于 class / 控件 / 图表 */
export const isTemTechTheme = computed(() => temHomeTheme.value === 'tech')

export function setTemHomeTheme(theme) {
  if (theme !== 'light' && theme !== 'tech') return
  if (temHomeTheme.value === theme) return
  temHomeTheme.value = theme
  persistTheme(temHomeTheme.value)
  applyDocumentTheme(temHomeTheme.value)
}

export function toggleTemHomeTheme() {
  setTemHomeTheme(temHomeTheme.value === 'tech' ? 'light' : 'tech')
}
