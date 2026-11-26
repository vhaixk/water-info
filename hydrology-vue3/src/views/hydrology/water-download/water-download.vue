<template>
  <div class="app-container">
    <el-container style="height: 100%">
      <left-aside-component v-model:collapsed="sidebarCollapsed"
                       v-model:width="sidebarWidth"
                       :max-width="380"
                       :min-width="0">
        <template #default>
          <tree-component
              :tree-config="{
              loading:treeLoading,
              treeData:treeData,
              defaultExpandedKeys:['ROOT']
              }"
              style="height: 100%"
              @check-change="handleCheckChange"
          >
            <!--            <template #toolbar="{ node, data }">-->
            <!--              <el-button :icon="View" size="default" text type="primary" @click="treeNodeClick(node,data)"></el-button>-->
            <!--            </template>-->
          </tree-component>
        </template>
      </left-aside-component>
      <el-container class="table-container">
        <el-header>
          <el-form :model="form" inline>
            <el-form-item label="时间排序">
              <el-select v-model="form.dataOrder" placeholder="时间排序" style="width: 160px" suffix-icon="Switch">
                <el-option label="正序" value="asc"/>
                <el-option label="倒序" value="desc"/>
              </el-select>
            </el-form-item>
            <el-form-item label="监测时间">
              <el-date-picker
                  v-model="form.dates"
                  :clearable="false"
                  :shortcuts="DateEnum.shortcuts()"
                  end-placeholder="结束时间"
                  range-separator="至"
                  start-placeholder="开始时间"
                  style="width: 240px"
                  type="daterange"
                  :disabled="Object.keys(form.treeCheckList).length === 0"
                  unlink-panels
              />
            </el-form-item>

            <div style="float: right">
              <el-button :loading="loading" icon="Search" type="primary" @click="getData">查询</el-button>
              <el-button :loading="exportLoading" icon="Document" type="success" @click="handleExport">导出</el-button>
              <el-button :loading="exportLoading" icon="Document" type="success" @click="handleExportOrigin">
                导出原始数据
              </el-button>
            </div>
          </el-form>
        </el-header>

        <el-main style="height: 100%;padding-top:0;overflow: hidden">
          <el-table
              v-if="spanRules.length>0"
              id='myTable'
              ref="tableRef"
              v-loading="loading"
              :data="tableData"
              :span-method="objectSpanMethod"
              border
              height="100%"
              highlight-current-row
              maxHeight="100%"
              scrollbar-always-on
              show-overflow-tooltip
              stripe
              style="flex:1;overflow: auto"
          >
            <el-table-column align="center" column-key="index" fixed="left" label="序号" type="index" width="55"/>
            <template v-for="(item,index) in waterDownloadColumn.columns[metaName]">
              <el-table-column :column-key="item.prop" :fixed="item.fixed" :formatter="formatter" :label="item.label"
                               :min-width="item.minWidth" :prop="item.prop" align="center"/>
            </template>

            <el-table-column

                :width="80"
                align="center"
                column-key="handle"
                fixed="right"
                label="操作">
              <template #default="scope">
                <el-button
                    size="small"
                    @click="handleViewPicture(scope.$index, scope.row)"
                >
                  <el-icon>
                    <View/>
                  </el-icon>
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-main>

        <el-image-viewer
            v-if="pictureShow"
            :url-list="[pictureData]"
            @close="pictureShow = false"
        />

      </el-container>
    </el-container>


  </div>
</template>


<script setup>


import TreeComponent from "@/views/tool/tree/tree-component.vue";
import dayjs from 'dayjs';
import {ElMessage} from "element-plus";
import {nextTick, watch} from "vue";
import {debounce} from 'lodash-es'
import LeftAsideComponent from "@/views/tool/aside/leftAsideComponent.vue";
import {deepClone} from "@/utils/index.js";
import {View} from "@element-plus/icons-vue";
import {useRoute} from "vue-router";
import waterDownload from "@/api/water-download/water-download.js";
import DateEnum from "@/views/tool/date/dateEnum.js";
import {exportTable} from "@/utils/exportTable.js";
import waterDownloadColumn, {columns} from './water-download-column.js'
import {downloadFile} from "@/api/common/commonUtils.js";

const pictureData = ref()
const pictureShow = ref(false)
const treeData = ref([])
const treeLoading = ref(false)
const tableRef = ref({})
const loading = ref(false)
const exportLoading = ref(false)
const tableData = ref([])
const monitorDataDialog = ref([])
const sidebarWidth = ref(360)
const sidebarCollapsed = ref(false)
let {proxy} = getCurrentInstance()

// 路由 query 缺失时（如默认落地/直接 URL 进入）从路径末段推导表名
const routePath = proxy.$route.path.split('/').pop()
let metaName = proxy.$route.query.meta || routePath
let mappingName = proxy.$route.query.mapping || metaName.replace('hy_download_water_', 'hy_download_water_mapping_')
let dicMapping

const form = ref({
  dates: [dayjs().format('YYYY-MM-DD'),dayjs().add(1,'day').format('YYYY-MM-DD')],
  dataOrder: 'desc',
  treeCheckList: {},
  metaName: metaName,
  mappingName: mappingName,
})

onMounted(async () => {
      treeLoading.value = true
      const getTreeData = await waterDownload.getTreeData(mappingName)
      const getDicMapping = await waterDownload.getDicMapping(mappingName)
      await getData()
      treeData.value = getTreeData.data
      dicMapping = getDicMapping.data

      treeLoading.value = false
    }
)

watch(() => form.value.treeCheckList, debounce(async () => {
  loading.value = true
  await getData()
  loading.value = false
}, 500), {deep: true})


const formatter = (row, column) => {
  const columnName = column.columnKey
  const label = column.label
  if (label === '监测时间') {
    return dayjs(row[columnName]).format('YYYY-MM-DD HH')
  }
  if (label === '创建时间') {
    return dayjs(row[columnName]).format('YYYY-MM-DD HH:mm:ss')
  }
  return row[columnName]

}
const handleCheckChange = ({data, checked, indeterminate}) => {
  if (!indeterminate) {
    if (checked === undefined) return
    if (checked) {
      form.value.treeCheckList[data.id] = true
    } else {
      delete form.value.treeCheckList[data.id]
    }
  }
}


const getData = async () => {
  loading.value = true
  const {data} = await waterDownload.getData(form.value)
  tableData.value = data
  const fieldsToMerge = ['basin_name', 'river_name', 'province_name']
  spanRules.value = await getSpanRules(tableData.value, fieldsToMerge)
  loading.value = false
}
const handleViewPicture = async (index, row) => {
  const path = row.monitor_png_path
  const blob = new Blob([await waterDownload.getProfileData(path)], {type: 'image/png'})
  pictureData.value = URL.createObjectURL(blob)
  pictureShow.value = true
}
const handleExport = async () => {
  exportLoading.value = true
  try {
    ElMessage({message: `导出成功`, type: 'success', duration: 2 * 1000})
    await exportTable(
        "myTable",
        `监测数据 ${dayjs(form.value.dates[0]).format("YYYYMMDDHHmmss")}-${dayjs(form.value.dates[1]).format("YYYYMMDDHHmmss")}`,
        1)
  } catch (e) {
    ElMessage({message: `导出失败`, type: 'error', duration: 2 * 1000})
  }
  exportLoading.value = false
}

const handleExportOrigin = async () => {

  const data = await waterDownload.handleExportOrigin(form.value)
  await downloadFile(data.data)
}

// 存放合并规则
const spanRules = ref([])

// 通用方法：提前计算合并规则
const getSpanRules = (data, fields) => {
  const rules = fields.map(() => [])

  fields.forEach((field, fieldIndex) => {
    let pos = 0
    data.forEach((item, index) => {
      if (index === 0) {
        rules[fieldIndex].push(1)
      } else {
        const isSame = item[field] === data[index - 1][field]
        if (isSame) {
          rules[fieldIndex][pos] += 1
          rules[fieldIndex].push(0)
        } else {
          rules[fieldIndex].push(1)
          pos = index
        }
      }
    })
  })
  return rules
}

// 表格合并方法
const objectSpanMethod = ({rowIndex, columnIndex}) => {
  // 1. 【进阶建议】处理序号列（第0列），让它跟随第一列（basin_name）的合并状态
  if (columnIndex === 0) {
    // spanRules[0] 存的是第一个字段（basin_name）的合并规则
    const values = spanRules.value[0]
    const _row = values[rowIndex]
    return {rowspan: _row, colspan: 1}
  }

  // 2. 处理第1、2、3列的合并
  if (columnIndex >= 1 && columnIndex <= 3) {
    // 因为跳过了0列，取规则时数组索引需要减 1
    const ruleIndex = columnIndex - 1
    const _row = spanRules.value[ruleIndex][rowIndex]
    const _col = _row > 0 ? 1 : 0
    return {rowspan: _row, colspan: _col}
  }

  // 3. 其他列不合并
  return {rowspan: 1, colspan: 1}
}

</script>
<style lang="scss" scoped>


</style>
