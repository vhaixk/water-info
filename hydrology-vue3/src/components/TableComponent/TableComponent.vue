<template>
  <el-container class="page">
    <el-header v-if="tableConfig.toolbar.header">
      <el-form
          :inline="true"
          :model="whereFrom"
          label-position="left"
      >
        <el-form-item v-for="item in searchColumnConfig"
                      :key="item.column_name"
                      :label="item.column_comment"
                      class="form-inline">

          <el-input v-if="item.html_type ==='input' || item.html_type ==='textarea'"
                    v-model="whereFrom.columns[item.column_name].columnValue"
                    :placeholder="`请输入${item.column_comment}`"
                    clearable
                    suffix-icon="Edit"
                    @keyup.enter="getColumnData"/>

          <el-date-picker v-if="item.html_type ==='datetime' "
                          v-model="whereFrom.columns[item.column_name].columnValue"
                          :placeholder="`请输入${item.column_comment}`"
                          :type="getDateType(item)"
                          clearable
                          style="width: 370px"
                          @keyup.enter="getColumnData"/>

          <el-select v-if="item.html_type ==='select'"
                     v-model="whereFrom.columns[item.column_name].columnValue"
                     :placeholder="`请输入${item.column_comment}`"
                     clearable
                     collapse-tags
                     collapse-tags-tooltip
                     filterable
                     multiple
                     suffix-icon="Switch"
                     @keyup.enter="getColumnData"
          >
            <el-option
                v-for="item in Object.values(dicColumnConfig[item.column_name])"
                :key="item.value"
                :label="item.label"
                :value="item.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item class="table-search-actions">
          <el-button :loading="loading" icon="Search" type="primary" @click="getColumnData">查询</el-button>
          <el-button :loading="loading" icon="Refresh" type="info" @click="resetTableData">重置</el-button>
          <el-button v-if="tableConfig.toolbar.add" icon="Plus" type="success" @click="handleEdit">新增</el-button>
          <el-button v-if="tableConfig.toolbar.delete" icon="Delete" type="danger" @click="handleDelete">删除
          </el-button>
          <el-button v-if="tableConfig.toolbar.export" :loading="exportLoading" icon="Document" type="success"
                     @click="handleExport">导出
          </el-button>
          <slot name="toolbar"></slot>
        </el-form-item>
      </el-form>

    </el-header>


    <el-main class="table_wrap">
      <el-table
          ref="table"
          v-loading="loading"
          :data="tableData"
          :height="tableConfig.maxHeight || '100%'"
          :max-height="tableConfig.maxHeight || '100%'"
          border
          class="table"
          highlight-current-row
          scrollbar-always-on
          show-overflow-tooltip
          stripe
      >
        <el-table-column v-if="setVisible({is_list:'1',column_name:'checkbox'})" column-key="checkbox" type="selection"
                         width="50"/>
        <el-table-column v-if="setVisible({is_list:'1',column_name:'index'})" align="center" column-key="index"
                         fixed="left" label="序号" type="index" width="55"/>

        <slot name="columns"></slot>
        <template v-for="item in sortColumnConfig" :key="item.column_name">
          <el-table-column
              v-if="setVisible(item)"
              :align="item.align_type"
              :column-key="item.column_name"
              :fixed="item.fixed_type || null"
              :label="item.column_comment"
              :min-width="item.min_width"
              :prop="item.column_name"
              :width="item.bast_width"
              show-overflow-tooltip
          >
            <template #default="scope">
              <div
                  v-if="item.html_type ==='select' || item.html_type ==='selectMore'|| item.html_type ==='radio'||item.html_type ==='checkBox'">
                <el-tag v-if=" getDictValue(item,scope.row,'elTagType') || getDictValue(item,scope.row,'elTagClass')"
                        :class="getDictValue(item,scope.row,'elTagClass')"
                        :type="getDictValue(item,scope.row,'elTagType')"
                >
                  {{ formatter(scope.row, item) }}
                </el-tag>
                <span v-else>
                    {{ formatter(scope.row, item) }}
                  </span>
              </div>
              <div v-else-if="item.html_type ==='fileUpload'">
                <el-button
                    v-if="scope.row[item.column_name]"
                    icon="download"
                    type="primary"
                    @click="downloadFile(item,scope.row)">
                  {{ CommonUtils.getFullName(scope.row[item.column_name]) }}
                </el-button>
              </div>
              <div v-else-if="item.html_type ==='imageUpload' && scope.row[item.column_name]">
                <el-image
                    v-if="scope.row[item.column_name]"
                    :preview-src-list="formatImagePreview(scope.row[item.column_name])"
                    :src="formatImagePreview(scope.row[item.column_name])[0]"
                    fit="cover"
                    preview-teleported
                    show-progress
                    style="width: 50px; height: 50px;"
                >
                  <template
                      #toolbar="{ actions, prev, next, reset, activeIndex, setActiveItem }"
                  >
                    <el-icon @click="prev">
                      <Back/>
                    </el-icon>
                    <el-icon @click="next">
                      <Right/>
                    </el-icon>
                    <el-icon @click="setActiveItem(srcList.length - 1)">
                      <DArrowRight/>
                    </el-icon>
                    <el-icon @click="actions('zoomOut')">
                      <ZoomOut/>
                    </el-icon>
                    <el-icon
                        @click="actions('zoomIn', { enableTransition: false, zoomRate: 2 })"
                    >
                      <ZoomIn/>
                    </el-icon>
                    <el-icon @click="actions('clockwise', { rotateDeg: 180, enableTransition: false })">
                      <RefreshRight/>
                    </el-icon>
                    <el-icon @click="actions('anticlockwise')">
                      <RefreshLeft/>
                    </el-icon>
                    <el-icon @click="reset">
                      <Refresh/>
                    </el-icon>
                    <el-icon @click="download(formatImagePreview(scope.row[item.column_name]),activeIndex)">
                      <Download/>
                    </el-icon>
                  </template>
                </el-image>
              </div>
              <span v-else>
                      {{ formatter(scope.row, item) }}
              </span>
            </template>
          </el-table-column>
        </template>

        <el-table-column
            v-if="tableConfig.toolbar.show"
            :width="tableConfig.toolbar.width"
            align="center"
            column-key="handle"
            fixed="right"
            label="操作">
          <template #default="scope">
            <slot name="operate" v-bind="{ row: scope.row, index: scope.$index }"></slot>
            <el-button
                v-if="tableConfig.toolbar.update"
                size="small"
                @click="handleEdit(scope.$index, scope.row)"
            >
              <el-icon>
                <Edit/>
              </el-icon>
            </el-button>
            <el-button
                v-if="tableConfig.toolbar.delete"
                size="small"
                type="danger"
                @click="handleDelete(scope.row)"
            >
              <el-icon>
                <Delete/>
              </el-icon>
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-footer>
        <el-pagination
            v-model:current-page="whereFrom.page"
            v-model:page-size="whereFrom.pageSize"
            :disabled="false"
            :layout="tableConfig.pageLayout || 'prev, pager, sizes,next, jumper, total'"
            :page-sizes="[10, 20, 50, 100]"
            :total="whereFrom.total"
            background
            class="pagination-container"
            size="small"
            @change="getColumnData"
        />
      </el-footer>
    </el-main>
    <insert-or-update
        ref="insertOrUpdate"
        :columnConfig="sortColumnConfig"
        :dicColumnConfig="dicColumnConfig"
        :tableConfig="tableConfig"
        @refresh="getColumnData"
        @saveOver="(rowData)=>$emit('saveOver',rowData)"
    ></insert-or-update>
  </el-container>
</template>


<script setup>

import commonApi from "@/api/common/commonApi.js";
import dayjs from 'dayjs';
import {watch} from "vue";
import InsertOrUpdate from "@/components/TableComponent/InsertOrUpdate.vue";
import {ElMessage, ElMessageBox} from "element-plus";
import CommonApi from "@/api/common/commonApi.js";
import CommonUtils from "@/api/common/commonUtils.js";

const {proxy} = getCurrentInstance()

const insertOrUpdate = ref({})
const table = ref({})

const loading = ref(false);
const exportLoading = ref(false);
const emit = defineEmits(['removeOver'])

const props = defineProps({
  tableConfig: {
    type: Object,
    default: {
      tableName: "",
      exportName: "",
      maxHeight: "",
      showColumns: [],
      pageLayout: "prev, pager, sizes,next, jumper, total",
      toolbar: {
        header: true,
        show: true,
        width: 120,
        add: true,
        update: true,
        delete: true,
      },
    }
  },
})

onMounted(async () => {
  await refreshAll();
})

watch(() => props.tableConfig, async () => await refreshAll(), {deep: true})
const refreshAll = (async () => {
  await getColumnConfig()
  await refreshDicCache()
  await getColumnData()
})
const calculatedMaxHeight = () => {
  // 获取窗口内部高度
  const windowHeight = window.innerHeight;
  // 计算可用高度（减去头部和底部高度）
  const availableHeight = windowHeight - this.headerHeight - this.footerHeight;
  // 设置一个最小值或最大值，防止极端情况
  return Math.max(availableHeight, 400); // 至少显示 400px 高度
}
const formatImagePreview = (value) => {
  return value.split(',').map(v => import.meta.env.VITE_APP_BASE_API + v)
}
const downloadFile = (item, row) => {
  const path = row[item.column_name]

  CommonUtils.downloadFile(path, CommonUtils.getFullName(path))
}
const setVisible = (item) => {
  if (!props.tableConfig.showColumns) {
    if (item.column_name === "index" || item.column_name === "checkbox") return true
    return item.is_list === '1'
  }
  return (props.tableConfig.showColumns.length === 0 || props.tableConfig.showColumns.includes(item.column_name))
}
const formatter = (row, item) => {
  const value = row[item.column_name]
  if (!value) return null
  if (item.date_type) {
    return dayjs(value).format(item.date_type)
  }

  if (item.dict_type) {
    const dicMap = dicColumnConfig.value[item.column_name]
    if (!dicMap || dicMap.length === 0) return value
    return String(value)
        .split(',')
        .map(d => {
          return dicMap[d]?.label
        })
        .join(',')
  }
  return value
}
const getDateType = (item) => {
  const date_type = item.date_type
  const suffix = item.query_type === 'BETWEEN' ? 'range' : ''
  if (!date_type) return "datetime" + suffix
  if (date_type === 'YYYY-MM-DD') {
    return 'date' + suffix
  }
  return "datetime" + suffix

}

const handleEdit = (index, row) => {
  insertOrUpdate.value.openDialog(row)
  // console.log(index, row)
}


const tableData = ref([])
const columnMapConfig = ref({})
const idColumnConfig = ref([])
const sortColumnConfig = ref([])
const searchColumnConfig = ref([])
const dicColumnConfig = ref({})


const getDictValue = (item, row, fieldName) => {
  const rowValue = row[item.column_name]

  if (!rowValue) return
  const dicMap = dicColumnConfig.value[item.column_name]


  if (!dicMap) return
  const dic = dicMap[String(rowValue)]
  if (!dic) return

  return dic[fieldName]
}
const getColumnConfig = async () => {
  const {data} = await commonApi.getColumnConfig(props.tableConfig.tableName)
  columnMapConfig.value = data
  const columnArray = Object.values(data)
  await refreshDicCache()
  sortColumnConfig.value = columnArray.sort((item1, item2) => item1.sort - item2.sort)
  searchColumnConfig.value = sortColumnConfig.value.filter(item => item.is_query === '1')
  idColumnConfig.value = sortColumnConfig.value.filter(item => item.is_pk === '1')
  for (let column of searchColumnConfig.value) {
    whereFrom.value.columns[column.column_name] = {
      columnName: column.column_name,
      columnValue: null,
      whereType: column.query_type,
      groupId: column.column_name,
    }
  }
  Object.values(data)
      .filter(item => item.sort_sort === 1)
      .sort((item1, item2) => item1.sort_sort - item2.sort_sort)
      .forEach((column) => {
        whereFrom.value.orders[column.column_name] = {
          columnName: column.column_name,
          sortType: column.sort_type,
          sort: column.sort_sort,
        }
      })


  assignWhereFrom.value = JSON.stringify(whereFrom.value)
}

// 刷新字典
const refreshDicCache = async () => {
  const columnArray = Object.values(columnMapConfig.value)
  for (let columnItem of columnArray) {
    if (!columnItem.dict_type) continue
    dicColumnConfig.value[columnItem.column_name] = []
    const data = await proxy.useDict(columnItem.dict_type)[columnItem.dict_type]
    if (data.value.length > 0) {
      const dicMap = {}
      for (let dicDatum of data.value) {
        dicMap[dicDatum.value] = dicDatum
      }
      dicColumnConfig.value[columnItem.column_name] = dicMap
    } else {
      watch(data, dicData => {
        const dicMap = {}
        for (let dicDatum of data.value) {
          dicMap[dicDatum.value] = dicDatum
        }
        dicColumnConfig.value[columnItem.column_name] = dicMap
      }, {deep: true})
    }
  }
}

const whereFrom = ref({
  tableName: "",
  columns: {},
  orders: {},
  page: 1,
  pageSize: 20,
  total: 0,
})

const assignWhereFrom = ref({})

// 获取数据
const getColumnData = async () => {
  loading.value = true
  whereFrom.value.tableName = props.tableConfig.tableName
  whereFrom.value.uid = props.tableConfig.token
  if (props.tableConfig.whereFromColumns) {
    whereFrom.value.columns = Object.assign({}, whereFrom.value.columns, props.tableConfig.whereFromColumns)
  }
  const {data} = await commonApi.getColumnData(props.tableConfig.tableName, whereFrom.value)
  tableData.value = data.dataList
  whereFrom.value.page = data.page
  whereFrom.value.pageSize = data.pageSize
  whereFrom.value.total = data.total
  loading.value = false
}

const resetTableData = async () => {
  whereFrom.value = JSON.parse(assignWhereFrom.value)
  await getColumnData()
}

const handleExport = async () => {
  exportLoading.value = true
  const exportName = props.tableConfig.exportName + '-' + dayjs().format('YYYYMMDDHHmmss')
  const data = await commonApi.exportData(
      props.tableConfig.tableName,
      exportName,
      {
        ...whereFrom.value,
        page: 0,
        pageSize: 100000
      }
  )
  if (data.code === 200) {
    ElMessage({message: `导出成功`, type: 'success', duration: 2 * 1000})
    await CommonUtils.downloadFile(data.data, exportName + '.xlsx')
  } else {
    ElMessage({message: `导出失败`, type: 'error', duration: 2 * 1000})
  }
  exportLoading.value = false
}


const handleDelete = (row) => {
  const multipleSelection = table.value.getSelectionRows()

  if (!row && multipleSelection.value.length === 0) {
    ElMessage({message: `请选择数据后进行操作`, type: 'info', duration: 2 * 1000})
    return
  }

  const rows = []
  const params = {}
  if (row && !row.pointerType) {
    rows.push(row);
  } else {
    rows.push(...multipleSelection)
  }
  for (let icColumn of idColumnConfig.value) {
    params[icColumn.column_name] = []
    for (let item of rows) {
      params[icColumn.column_name].push(item[icColumn.column_name])
    }
  }

  ElMessageBox({
    title: '删除',
    message: '是否删除 ' + rows.length + ' 条数据？',
    showCancelButton: true,
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    beforeClose: async (action, instance, done) => {
      if (action === 'confirm') {
        instance.confirmButtonLoading = true
        instance.confirmButtonText = 'Loading...'
        const data = await commonApi.removeData(props.tableConfig.tableName, params)

        if (data.code === 200) {
          ElMessage({message: `成功删除 ${data.data} 条数据！`, type: 'success', duration: 2 * 1000})
        } else {
          ElMessage({message: `删除失败`, type: 'error', duration: 2 * 1000})
        }
        done()
        instance.confirmButtonLoading = false
         emit('removeOver', params)
        await getColumnData()
      } else {
        done()
        ElMessage({message: `已取消删除`, type: 'info', duration: 2 * 1000})
      }
    },
  })
}

const download = (srcList, index) => {
  const url = srcList[index]
  const suffix = url.slice(url.lastIndexOf('.'))
  const filename = Date.now() + suffix

  fetch(url)
      .then((response) => response.blob())
      .then((blob) => {
        const blobUrl = URL.createObjectURL(new Blob([blob]))
        const link = document.createElement('a')
        link.href = blobUrl
        link.download = filename
        document.body.appendChild(link)
        link.click()
        URL.revokeObjectURL(blobUrl)
        link.remove()
      })
}

defineExpose({getColumnData})
</script>

<style lang="scss" scoped>
.page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}

.page > :deep(.el-header) {
  height: auto !important;
  flex-shrink: 0;
  position: relative;
  z-index: 5;
  overflow: visible;
}

.table-search-actions {
  margin-left: auto;
}

.table_wrap {
  flex: 1;
  min-height: 0;
  position: relative;
  z-index: 1;
  overflow: hidden;
  padding-bottom: 0;
  padding-top: 0;
  display: grid;
  grid-template-rows: 1fr auto;

  :deep(.table) {
    height: 100%;
    min-height: 0;
  }

  :deep(.el-footer) {
    height: auto !important;
    flex-shrink: 0;
    padding: 8px 0;
  }
}

/* 其他样式保持不变 */
.form-inline {
  --el-input-width: 180px;
  --el-select-width: 180px;
  --el-date-editor-daterange-width: 220px;
  --el-date-editor-datetimerange-width: 220px;
  --el-date-editor-width: 220px;
  --el-range-editor-width: 220px;

}

.pagination-container {
  float: right;
  margin-top: 20px;
}
</style>
