<template>
  <div class="app-container">
    <table-component ref="table" :table-config="tableConfig" >

    </table-component>
  </div>
</template>


<script setup>
import TableComponent from '@/components/TableComponent/TableComponent.vue'
let {proxy} = getCurrentInstance()

// 路由 query 缺失时从路径末段推导映射表名
const routePath = proxy.$route.path.split('/').pop()
let metaName = proxy.$route.query.meta
let mappingName = proxy.$route.query.mapping || routePath

const tableConfig = {
  tableName: mappingName,
  exportName: "映射信息",
  toolbar: {
    header: true,
    show: true,
    add: true,
    width: 160,
    update: true,
    delete: true,
    export: true,
  }
}

</script>


<style lang="scss" scoped>

</style>
