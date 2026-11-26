<template>
  <div class="app-container">
    <div v-if="loading" style="display: flex; justify-content: center; align-items: center; height: 100vh;">
      加载中...
    </div>
  </div>
</template>

<script name="Index" setup>
import {useRoute, useRouter} from 'vue-router'
import useUserStore from '@/store/modules/user'
// 引入 tagsView store 用于关闭当前标签页
import useTagsViewStore from '@/store/modules/tagsView'
import {onMounted, ref} from 'vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const tagsViewStore = useTagsViewStore() // 初始化 tagsView store
const loading = ref(true)

const getFirstMenu = () => {
  const asyncRoutes = router.getRoutes()
  const validRoutes = asyncRoutes.filter(item => {
    return item.meta &&
        item.meta.title &&
        item.path !== '/index' &&
        item.path !== '/login' &&
        item.path !== '/404' &&
        item.path !== '/' &&
        !item.meta.link &&
        !item.path.includes('/user') &&
        !item.path.includes('/system') &&
        !item.path.includes('/tool') &&
        !item.path.includes('/monitor') &&
        !item.path.includes('/water-mapping') &&
        !item.path.includes('/gen')

  })
  if (validRoutes.length > 0) {
    // 按添加顺序返回第一个，若需排序可在此处处理
    return validRoutes[0].path
  }
  return null
}

onMounted(async () => {
  // 确保用户信息已加载
  if (!userStore.name) {
    await userStore.getInfo()
  }
  // 仅当访问首页或根路径时执行跳转逻辑
  if (route.path === '/index' || route.path === '/') {
    const firstPath = getFirstMenu()
    if (firstPath) {
      tagsViewStore.delView(route)
      router.replace(firstPath)
    } else {
      console.warn('未找到任何可用路由，跳转至404')
      tagsViewStore.delView(route)
      router.replace('/404')
    }
  } else {
    loading.value = false
  }
})
</script>

<style lang="scss" scoped>
.app-container {
  height: 100%;
}
</style>
