<template>
  <el-menu :active-text-color="theme" :default-active="activeMenu" :ellipsis="false" class="topbar-menu"
           mode="horizontal">
    <sidebar-item v-for="(route, index) in topMenus" :key="route.path + index" :base-path="route.path" :item="route"/>

    <el-sub-menu v-if="moreRoutes.length > 0" class="el-sub-menu__hide-arrow" index="more">
      <template #title>
        <span>更多菜单</span>
      </template>
      <sidebar-item v-for="(route, index) in moreRoutes" :key="route.path + index" :base-path="route.path"
                    :item="route"/>
    </el-sub-menu>
  </el-menu>
</template>

<script setup>
import SidebarItem from '../Sidebar/SidebarItem'
import useAppStore from '@/store/modules/app'
import useSettingsStore from '@/store/modules/settings'
import usePermissionStore from '@/store/modules/permission'

const route = useRoute()
const appStore = useAppStore()
const settingsStore = useSettingsStore()
const permissionStore = usePermissionStore()

const sidebarRouters = computed(() => permissionStore.sidebarRouters)
const theme = computed(() => settingsStore.theme)
const device = computed(() => appStore.device)

let oneChildren = false
const activeMenu = computed(() => {
  const {meta, path} = route
  if (meta.activeMenu) {
    return meta.activeMenu
  }
  if (oneChildren) return path.split('/').slice(2).join('/')
  return path
})

const visibleNumber = ref(5)
const topMenus = computed(() => {
  const menu = permissionStore.sidebarRouters.filter((f) => !f.hidden).slice(0, visibleNumber.value)

  if (menu.length === 1) {
    oneChildren = true
    return menu[0].children
  }
  return menu
})
const moreRoutes = computed(() => {
  return permissionStore.sidebarRouters.filter((f) => !f.hidden).slice(visibleNumber.value, sidebarRouters.value.length - visibleNumber.value)
})

function setVisibleNumber() {
  const width = document.body.getBoundingClientRect().width / 3
  visibleNumber.value = parseInt(width / 85)
}

onMounted(() => {
  window.addEventListener('resize', setVisibleNumber)
})
onBeforeUnmount(() => {
  window.removeEventListener('resize', setVisibleNumber)
})

onMounted(() => {
  setVisibleNumber()
})
</script>

<style lang="scss">

.topbar-menu.el-menu--horizontal > .el-menu-item {

  float: left;
  height: 50px !important;
  line-height: 50px !important;
  color: #303133 !important;
  padding: 0 5px !important;
  margin: 0 10px !important;
  padding-top: 30px !important;


}


.el-sub-menu.is-active .svg-icon, .el-menu-item.is-active .svg-icon + span, .el-sub-menu.is-active .svg-icon + span, .el-sub-menu.is-active .el-sub-menu__title span {
  color: v-bind(theme);
}

/* sub-menu item */
.topbar-menu.el-menu--horizontal > .el-sub-menu .el-sub-menu__title {
  float: left;
  line-height: 50px !important;
  color: #303133 !important;
  margin: 0 15px -3px !important;


}

/* topbar more arrow */
.topbar-menu .el-sub-menu .el-sub-menu__icon-arrow {
  position: static;
  margin-left: 8px;
  margin-top: 0px;

  display: block !important;
}


.topbar-menu.el-menu--horizontal .el-menu-item:first-child,
.topbar-menu.el-menu--horizontal .el-sub-menu:first-child {
  width: 208px;
  box-sizing: border-box;
  flex-shrink: 0;
  white-space: nowrap;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 0 10px !important;
  font-size: 20px;
  line-height: 45px;
  color: #272727;
  cursor: pointer;
  border-top-left-radius: 45px;
  border-bottom-left-radius: 0;
  background-clip: padding-box;
  margin-right: -40px;

  &:hover {
    background-color: #f4f3ed;
    box-shadow: inset 2px 2px 6px rgba(0, 0, 0, 0.1);
    transform: translateY(-1px);
    transition: all 0.2s ease;
  }

  &.is-active,
  &:active {
    background-color: #f4f3ed !important;
    box-shadow: inset 2px 2px 6px rgba(0, 0, 0, 0.1) !important;
    transform: translateY(-1px) !important;
  }
}


</style>
