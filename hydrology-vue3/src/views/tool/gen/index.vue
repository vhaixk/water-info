<template>
  <div class="app-container">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="单表注册" name="table">
        <div class="gen-pane-scroll">
        <el-form v-show="showSearch" ref="queryRef" :inline="true" :model="queryParams">
          <el-form-item label="表名称" prop="tableName">
            <el-input
                v-model="queryParams.tableName"
                clearable
                placeholder="请输入表名称"
                style="width: 200px"
                @keyup.enter="handleQuery"
            />
          </el-form-item>
          <el-form-item label="表描述" prop="tableComment">
            <el-input
                v-model="queryParams.tableComment"
                clearable
                placeholder="请输入表描述"
                style="width: 200px"
                @keyup.enter="handleQuery"
            />
          </el-form-item>
          <el-form-item label="创建时间" style="width: 308px">
            <el-date-picker
                v-model="dateRange"
                end-placeholder="结束日期"
                range-separator="-"
                start-placeholder="开始日期"
                type="daterange"
                value-format="YYYY-MM-DD"
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button icon="Search" type="primary" @click="handleQuery">搜索</el-button>
            <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button
                v-hasPermi="['tool:gen:import']"
                icon="Upload"
                plain
                type="info"
                @click="openImportTable"
            >导入
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
                v-hasPermi="['tool:gen:remove']"
                :disabled="multiple"
                icon="Delete"
                plain
                type="danger"
                @click="handleDelete"
            >删除
            </el-button>
          </el-col>
          <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>

        <div class="gen-table-wrap">
        <el-table ref="genRef" v-loading="loading" :data="tableList" :default-sort="defaultSort" border
                  highlight-current-row scrollbar-always-on show-overflow-tooltip stripe
                  @selection-change="handleSelectionChange"
                  @sort-change="handleSortChange"
        height="100%">
          <el-table-column align="center" type="selection" width="55"></el-table-column>
          <el-table-column align="center" fixed="left" label="序号" type="index" width="50">
            <template #default="scope">
              <span>{{ (queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1 }}</span>
            </template>
          </el-table-column>
          <el-table-column :show-overflow-tooltip="true" align="center" label="表名称" prop="tableName">
            <template #default="scope">
              <el-button
                  link type="primary"
                  @click="handleEditTable(scope.row)">
                {{ scope.row.tableName }}
              </el-button>

              <el-button
                  link type="primary"
                  @click="handlePreview(scope.row)">
                预览
              </el-button>
            </template>

          </el-table-column>
          <el-table-column :show-overflow-tooltip="true" align="center" label="表描述" prop="tableComment"/>
          <el-table-column :show-overflow-tooltip="true" align="center" label="实体" prop="className"/>
          <el-table-column :show-overflow-tooltip="true" align="center" label="删改刷新缓存" prop="refreshCache" :formatter="(row,column) => row[column.property]==='1' ? '是' : '否' "/>

          <el-table-column :sort-orders="['descending', 'ascending']" align="center" label="创建时间" prop="createTime"
                           sortable="custom"
                           width="160"/>
          <el-table-column :sort-orders="['descending', 'ascending']" align="center" label="更新时间" prop="updateTime"
                           sortable="custom"
                           width="160"/>
          <el-table-column align="center" class-name="small-padding fixed-width" fixed="right" label="操作" width="200">
            <template #default="scope">
              <el-tooltip content="预览" placement="top">
                <el-button v-hasPermi="['tool:gen:preview']" icon="View" link type="primary"
                           @click="handlePreview(scope.row)"></el-button>
              </el-tooltip>
              <el-tooltip content="编辑" placement="top">
                <el-button v-hasPermi="['tool:gen:edit']" icon="Edit" link type="primary"
                           @click="handleEditTable(scope.row)"></el-button>
              </el-tooltip>
              <el-tooltip content="删除" placement="top">
                <el-button v-hasPermi="['tool:gen:remove']" icon="Delete" link type="primary"
                           @click="handleDelete(scope.row)"></el-button>
              </el-tooltip>
              <el-tooltip content="同步" placement="top">
                <el-button v-hasPermi="['tool:gen:edit']" icon="Refresh" link type="primary"
                           @click="handleSynchDb(scope.row)"></el-button>
              </el-tooltip>
            </template>
          </el-table-column>
        </el-table>
        </div>
        <pagination
            v-show="total>0"
            v-model:limit="queryParams.pageSize"
            v-model:page="queryParams.pageNum"
            :total="total"
            @pagination="getList"
        />
        </div>
      </el-tab-pane>
      <el-tab-pane label="关联数据集" name="dataset">
        <dataset-panel @preview="(name, comment) => tableInfo.openDialog(name, comment)"/>
      </el-tab-pane>
    </el-tabs>

    <import-table ref="importRef" @ok="handleQuery"/>
    <table-info ref="tableInfo"></table-info>

    <el-dialog v-model="editInfo.editDialogVisible" :title="editInfo.title" align-center
               draggable width="92%">
      <edit-table :tableId="editInfo.tableId" @reset-query="resetQuery"></edit-table>
    </el-dialog>
  </div>
</template>

<script name="Gen" setup>
import {listTable, delTable, synchDb} from "@/api/tool/gen"
import importTable from "./importTable"
import TableInfo from "@/views/tool/gen/tableInfo.vue";
import EditTable from "@/views/tool/gen/editTable.vue";
import DatasetPanel from "@/views/tool/gen/datasetPanel.vue";

const route = useRoute()
const {proxy} = getCurrentInstance()

const activeTab = ref("table")
const tableList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const multiple = ref(true)
const total = ref(0)
const tableNames = ref([])
const dateRange = ref([])
const uniqueId = ref("")
const tableInfo = ref({})
const defaultSort = ref({prop: "createTime", order: "descending"})
const editInfo = ref({editDialogVisible: false, title: '', tableId: null})

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 20,
    tableName: undefined,
    tableComment: undefined,
    orderByColumn: defaultSort.value.prop,
    isAsc: defaultSort.value.order
  }
})

const {queryParams} = toRefs(data)

onActivated(() => {
  const time = route.query.t
  if (time != null && time != uniqueId.value) {
    uniqueId.value = time
    queryParams.value.pageNum = Number(route.query.pageNum)
    dateRange.value = []
    proxy.resetForm("queryForm")
    getList()
  }
})

/** 查询表集合 */
function getList() {
  loading.value = true
  listTable(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    tableList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 同步数据库操作 */
function handleSynchDb(row) {
  const tableName = row.tableName
  proxy.$modal.confirm('确认要强制同步"' + tableName + '"表结构吗？').then(function () {
    return synchDb(tableName)
  }).then(() => {
    proxy.$modal.msgSuccess("同步成功")
  }).catch(() => {
  })
}

/** 打开导入表弹窗 */
function openImportTable() {
  proxy.$refs["importRef"].show()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  proxy.resetForm("queryRef")
  queryParams.value.pageNum = 1
  proxy.$refs["genRef"].sort(defaultSort.value.prop, defaultSort.value.order)
}

/** 预览按钮（数据预览） */
function handlePreview(row) {
  tableInfo.value.openDialog(row.tableName, row.tableComment)
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.tableId)
  tableNames.value = selection.map(item => item.tableName)
  multiple.value = !selection.length
}

/** 排序触发事件 */
function handleSortChange(column, prop, order) {
  queryParams.value.orderByColumn = column.prop
  queryParams.value.isAsc = column.order
  getList()
}

/** 修改按钮操作 */
function handleEditTable(row) {
  const tableId = row.tableId || ids.value[0]
  const tableName = row.tableName || tableNames.value[0]
  const params = {pageNum: queryParams.value.pageNum}
  editInfo.value.editDialogVisible = true
  editInfo.value.params = params
  editInfo.value.title = "列配置[" + tableName + "]"
  setTimeout(() => editInfo.value.tableId = String(tableId), 200)
}

/** 删除按钮操作 */
function handleDelete(row) {
  const tableIds = row.tableId || ids.value
  proxy.$modal.confirm('是否确认删除表编号为"' + tableIds + '"的数据项？').then(function () {
    return delTable(tableIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {
  })
}

getList()
</script>

<style lang="scss" scoped>
/* 全局主题对 .el-tab-pane 直接 div 子元素强制 height:100%，
   用单一容器承接：flex 满高布局，表格内部滚行，页面无滚动轴 */
.gen-pane-scroll {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  > .el-form,
  > .el-row,
  > .pagination-container {
    flex: none;
  }
}
.gen-table-wrap {
  flex: 1;
  min-height: 0;
}
</style>