<template>
  <div :class="'nav' + settingsStore.navType" class="navbar">
    <!-- 左侧汉堡按钮 -->
    <hamburger id="hamburger-container" :is-active="appStore.sidebar.opened" class="hamburger-container"
               @toggleClick="toggleSideBar"/>

    <!-- 中间/左侧导航内容 -->
    <breadcrumb v-if="settingsStore.navType == 1" id="breadcrumb-container" class="breadcrumb-container"/>
    <top-nav v-if="settingsStore.navType == 2" id="topmenu-container" class="topmenu-container"/>
    <template v-if="settingsStore.navType == 3">
      <logo v-show="settingsStore.sidebarLogo" :collapse="false"></logo>
      <top-bar id="topbar-container" class="topbar-container"/>
    </template>

    <div class="right-menu-wrapper">
      <div class="right-menu">
        <template v-if="appStore.device !== 'mobile'">
          <header-search id="header-search" class="right-menu-item"/>
          <screenfull id="screenfull" class="right-menu-item hover-effect"/>

          <el-tooltip :content="isTemTechTheme ? '切换浅色' : '切换深色'" effect="dark" placement="bottom">
            <div class="right-menu-item hover-effect theme-switch-wrapper" @click="toggleHomeTheme">
              <svg-icon v-if="isTemTechTheme" icon-class="sunny"/>
              <svg-icon v-else icon-class="moon"/>
            </div>
          </el-tooltip>

          <el-tooltip content="布局大小" effect="dark" placement="bottom">
            <size-select id="size-select" class="right-menu-item hover-effect "/>
          </el-tooltip>
        </template>

        <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="hover" @command="handleCommand">
          <div class="avatar-wrapper">
            <img :src="userStore.avatar" class="user-avatar"/>
            <span class="user-nickname"> {{ userStore.nickName }} </span>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <router-link to="/user/profile">
                <el-dropdown-item>个人中心</el-dropdown-item>
              </router-link>
              <el-dropdown-item v-if="settingsStore.showSettings" command="setLayout">
                <span>布局设置</span>
              </el-dropdown-item>
              <el-dropdown-item command="logout" divided>
                <span>退出登录</span>
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ElMessageBox} from 'element-plus'
import Breadcrumb from '@/components/Breadcrumb'
import TopNav from '@/components/TopNav'
import TopBar from './TopBar'
import Logo from './Sidebar/Logo'
import Hamburger from '@/components/Hamburger'
import Screenfull from '@/components/Screenfull'
import SizeSelect from '@/components/SizeSelect'
import HeaderSearch from '@/components/HeaderSearch'
import useAppStore from '@/store/modules/app'
import useUserStore from '@/store/modules/user'
import useSettingsStore from '@/store/modules/settings'
import { isTemTechTheme, toggleTemHomeTheme } from '@/views/hydrology/shared/theme.js'

const appStore = useAppStore()
const userStore = useUserStore()
const settingsStore = useSettingsStore()

function toggleSideBar() {
  appStore.toggleSideBar()
}

function handleCommand(command) {
  switch (command) {
    case "setLayout":
      setLayout()
      break
    case "logout":
      logout()
      break
    default:
      break
  }
}

function logout() {
  ElMessageBox.confirm('确定注销并退出系统吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    userStore.logOut().then(() => {
      location.href = '/index'
    })
  }).catch(() => {
  })
}

const emits = defineEmits(['setLayout'])

function setLayout() {
  emits('setLayout')
}

function disableLegacyDarkMode() {
  if (settingsStore.isDark) {
    settingsStore.toggleTheme()
  }
  document.documentElement.classList.remove('dark')
}

let themeTransition = null
let themeToggleToken = 0

onMounted(() => {
  disableLegacyDarkMode()
  releaseThemeTransition()
})

function applyHomeTheme() {
  toggleTemHomeTheme()
  disableLegacyDarkMode()
}

function releaseThemeTransition() {
  const root = document.documentElement
  root.classList.remove('tem-vt-to-tech', 'tem-vt-to-light')
  root.style.viewTransitionName = ''
  try {
    themeTransition?.skipTransition()
  } catch (e) {
    /* ignore */
  }
  themeTransition = null
  try {
    document.getAnimations().forEach((animation) => {
      const pseudo = animation.effect?.pseudoElement || ''
      if (pseudo.includes('view-transition')) animation.cancel()
    })
  } catch (e) {
    /* ignore */
  }
}

function themeOrigin(event) {
  const node = event?.currentTarget
  if (node instanceof HTMLElement) {
    const rect = node.getBoundingClientRect()
    return {
      x: rect.left + rect.width / 2,
      y: rect.top + rect.height / 2
    }
  }
  return { x: window.innerWidth, y: 0 }
}

async function toggleHomeTheme(event) {
  const token = ++themeToggleToken
  if (document.activeElement instanceof HTMLElement) {
    document.activeElement.blur()
  }
  releaseThemeTransition()

  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  const canAnimate = typeof document.startViewTransition === 'function' && !reduced
  if (!canAnimate) {
    applyHomeTheme()
    nextTick(() => window.dispatchEvent(new Event('resize')))
    return
  }

  const { x, y } = themeOrigin(event)
  const endRadius = Math.hypot(
    Math.max(x, window.innerWidth - x),
    Math.max(y, window.innerHeight - y)
  )
  const root = document.documentElement
  root.style.setProperty('--tem-vt-x', `${x}px`)
  root.style.setProperty('--tem-vt-y', `${y}px`)
  root.style.setProperty('--tem-vt-r', `${endRadius}px`)
  try {
    const transition = document.startViewTransition(async () => {
      applyHomeTheme()
      await nextTick()
      window.dispatchEvent(new Event('resize'))
    })
    themeTransition = transition
    await transition.finished
  } catch (e) {
    /* 过渡被下一次点击打断，或浏览器不支持，主题已经切过则保持 */
  } finally {
    if (token === themeToggleToken) {
      releaseThemeTransition()
      nextTick(() => window.dispatchEvent(new Event('resize')))
    }
  }
}
</script>

<style lang='scss' scoped>
/* 针对 nav3 布局隐藏汉堡按钮 */
.navbar.nav3 {
  .hamburger-container {
    display: none !important;
  }
}

.navbar {
  height: 100px;
  overflow: hidden;
  position: relative;
  background: var(--navbar-bg);
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  align-items: center;
  box-sizing: border-box;

  background-image: url("../../assets/images/top-header.png");
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;


  .hamburger-container {
    line-height: 46px;
    height: 100%;
    cursor: pointer;

    transition: background 0.3s;
    -webkit-tap-highlight-color: transparent;
    display: flex;
    align-items: center;
    flex-shrink: 0;
    margin-right: 8px;
    color: #fff;
    &:hover {
      background: rgba(0, 0, 0, 0.025);
    }
  }

  .breadcrumb-container {
    flex-shrink: 0;
    font-size: 18px;

  }

  .topmenu-container {
    position: absolute;
    left: 50px;
    background: rgba(0,0,0,0);

  }

  .topbar-container {
    transform: translateY(35px);
    flex: 1;
    min-width: 0;
    display: flex;
    align-items: center;
    padding-bottom: 15px;
    overflow: hidden;
    margin-left: 8px;
    border-top-left-radius: 45px;
    background-image: linear-gradient(0deg,#d5d4ca,#edede9);
  }

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  /* 【核心修改】右侧菜单样式 */
  .right-menu {
    /* 改为绝对定位，脱离文档流，不占用高度和宽度 */
    position: absolute;
    top: 0;
    right: 10px;


    /* 保持原有的 Flex 布局以对齐内部图标 */
    display: flex;
    align-items: center;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 8px;
      height: 100%;
      font-size: 18px;
      color: #fff;
      vertical-align: text-bottom;

      /* 修正：让 item 内部也垂直居中 */
      align-items: center;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        &:hover {
          background: rgba(0, 0, 0, 0.025);
        }
      }

      &.theme-switch-wrapper {
        display: flex;
        align-items: center;

        svg {
          width: 20px;
          height: 20px;
          overflow: visible;
          color: #fff;
          fill: currentColor;
          transition: transform 0.3s;

          &:hover {
            transform: scale(1.15);
          }
        }
      }
    }

    .avatar-container {
      margin-right: 0px;
      padding-right: 0px;
      height: 100%; /* 确保下拉触发区域充满高度 */
      display: flex;
      align-items: center;

      .avatar-wrapper {
        /* 移除多余的 margin/padding/position 调整，利用 flex 居中 */
        display: flex;
        align-items: center;
        cursor: pointer;

        .user-avatar {
          width: 30px;
          height: 30px;
          margin-right: 8px;
          border-radius: 50%;
        }

        .user-nickname {
          font-size: 14px;
          font-weight: bold;
          color: #fff; /* 确保在深色背景下可见 */
        }

        i {
          /* 下拉箭头微调 */
          margin-left: 4px;
          font-size: 12px;
        }
      }
    }
  }
}
</style>
