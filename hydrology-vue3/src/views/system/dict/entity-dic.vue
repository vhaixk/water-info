<template>
  <el-dialog
      v-model="dialogVisible"
      :close-on-click-modal="false"
      title="实体表字典"
      width="75%"
      align-center
      draggable
  >
    <el-table  highlight-current-row v-loading="loading" :data="dataList" border stripe scrollbar-always-on show-overflow-tooltip>
      <el-table-column align="center" type="selection" width="55"/>
      <el-table-column align="center" label="字典编码" prop="code"/>
      <el-table-column align="center" label="字典标签" prop="label">
        <template #default="scope">
          <span
              v-if="(scope.row.elTagType === '' || scope.row.elTagType === 'default') && (scope.row.elTagClass === '' || scope.row.elTagClass == null)">{{
              scope.row.dictLabel
            }}</span>
          <el-tag v-else :class="scope.row.elTagClass"
                  :type="scope.row.elTagType === 'primary' ? '' : scope.row.elTagType">{{ scope.row.label }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column align="center" label="字典键值" prop="value"/>
      <el-table-column align="center" label="字典排序" prop="sort"/>
      <el-table-column align="center" label="状态" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column :show-overflow-tooltip="true" align="center" label="备注" prop="remark"/>
      <el-table-column align="center" label="创建时间" prop="sort" width="180">
        <template #default="scope">
          <span>{{ scope.row.createTime }}</span>
        </template>
      </el-table-column>
    </el-table>
  </el-dialog>
</template>

<script setup>
import {ref} from "vue";

const {proxy} = getCurrentInstance()
const {sys_normal_disable} = proxy.useDict("sys_normal_disable")

const dialogVisible = ref(false)
const loading = ref(false)
const dataList = ref([])

const openDialog = async (row) => {
  dialogVisible.value = true
  const data = await proxy.useDict(row.dictType)

  setTimeout(() => {
    console.log(data[row.dictType]);
    dataList.value = data[row.dictType].value
  },200)
}

defineExpose({
  openDialog
})
</script>

<style lang="scss" scoped>

</style>
