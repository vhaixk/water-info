<template>
  <div>

    <el-dialog
        v-model="dialogVisible"
        :close-on-click-modal="false"
        :title="tableConfig.exportName"
        class="monitor-dialog"
        align-center
        draggable
        width="75%"
    >
      <table-component ref="table" :table-config="tableConfig"></table-component>
    </el-dialog>
  </div>
</template>


<script setup>
import TableComponent from '@/components/TableComponent/TableComponent.vue'

const dialogVisible = ref(false)

const tableConfig =ref( {
  tableName: "",
  exportName: "",
  toolbar: {
    header: true,
    show: true,
    add: true,
    width: 160,
    update: true,
    delete: true,
    export: true,
  }
})
const openDialog = (tableName,exportName) => {
  tableConfig.value.tableName =tableName
  tableConfig.value.exportName =exportName
  // 关联数据集只读：隐藏增/改/删按钮
  const readonly = String(tableName).startsWith('ds_')
  tableConfig.value.toolbar.add = !readonly
  tableConfig.value.toolbar.update = !readonly
  tableConfig.value.toolbar.delete = !readonly
  setTimeout(()=>  dialogVisible.value = true,0)

}

defineExpose({openDialog})
</script>


<style lang="scss" scoped>

</style>
