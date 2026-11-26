<template>
  <div class="sidebar-logo-container" :class="{ 'collapse': collapse }">
    <transition name="sidebarLogoFade">
      <router-link v-if="collapse" key="collapse" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" />
        <h1 v-else class="sidebar-title">{{ title }}</h1>
      </router-link>
      <router-link v-else key="expand" class="sidebar-logo-link" to="/">
        <h1 class="sidebar-title">
          <img v-if="logo" :src="logo" class="sidebar-logo" />
          <span class="title-text">
            <span class="title-main">{{ title.replace('信息系统', '') }}</span>
            <span class="title-sub">信息系统</span>
          </span>
        </h1>
      </router-link>
    </transition>
  </div>
</template>

<script setup>
import logo from '@/assets/logo/logo.png'
import useSettingsStore from '@/store/modules/settings'
import variables from '@/assets/styles/variables.module.scss'

defineProps({
  collapse: {
    type: Boolean,
    required: true
  }
})

const title = import.meta.env.VITE_APP_TITLE
const settingsStore = useSettingsStore()
const sideTheme = computed(() => settingsStore.sideTheme)

// 获取Logo背景色
const getLogoBackground = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-bg)'
  }
  if (settingsStore.navType == 3) {
    return variables.menuLightBg
  }
  return sideTheme.value === 'theme-dark' ? variables.menuBg : variables.menuLightBg
})

// 获取Logo文字颜色
const getLogoTextColor = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-text)'
  }
  if (settingsStore.navType == 3) {
    return variables.menuLightText
  }
  return sideTheme.value === 'theme-dark' ? '#fff' : variables.menuLightText
})
</script>

<style lang="scss" scoped>
.sidebarLogoFade-enter-active {
  transition: opacity 1.5s;
}

.sidebarLogoFade-enter,
.sidebarLogoFade-leave-to {
  opacity: 0;
}

.sidebar-logo-container {
  position: relative;
  height: 100px;
  line-height: 100px;
  text-align: center;
  overflow: hidden;

  & .sidebar-logo-link {
    height: 100%;
    width: 100%;

    & .sidebar-logo {
      width: 46px;
      height: 46px;
      vertical-align: middle;
      margin-left: 24px;
      margin-right: 12px;
      filter: drop-shadow(0 2px 6px rgba(30, 111, 255, 0.25));
    }

    & .sidebar-title {
      display: inline-flex;
      align-items: center;
      margin: 0;
      height: 100%;
      vertical-align: middle;
      font-family: "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", sans-serif;

      .title-text {
        display: inline-flex;
        flex-direction: column;
        align-items: flex-start;
        line-height: 1.25;
      }

      .title-main {
        font-size: 21px;
        font-weight: 700;
        letter-spacing: 3px;
        background: linear-gradient(120deg, #1e6fff 10%, #00a6e8 55%, #00c6c0 95%);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        white-space: nowrap;
      }

      .title-sub {
        margin-top: 3px;
        font-size: 11px;
        font-weight: 500;
        letter-spacing: 7px;
        color: v-bind(getLogoTextColor);
        opacity: 0.72;
        white-space: nowrap;
      }
    }
  }

  &.collapse {
    .sidebar-logo {
      margin-right: 0px;
    }
  }
}
</style>
