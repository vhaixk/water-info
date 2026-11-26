<template>
  <div class="app-container">
    <el-form v-show="showSearch" ref="queryRef" :inline="true" :model="queryParams" label-width="68px">
      <el-form-item label="字典名称" prop="dictName">
        <el-input
            v-model="queryParams.dictName"
            clearable
            placeholder="请输入字典名称"
            style="width: 240px"
            @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="字典类型" prop="dictType">
        <el-input
            v-model="queryParams.dictType"
            clearable
            placeholder="请输入字典类型"
            style="width: 240px"
            @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select
            v-model="queryParams.status"
            clearable
            placeholder="字典状态"
            style="width: 240px"
        >
          <el-option
              v-for="dict in sys_normal_disable"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
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
            v-hasPermi="['system:dict:add']"
            icon="Plus"
            plain
            type="primary"
            @click="handleAdd"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            v-hasPermi="['system:dict:edit']"
            :disabled="single"
            icon="Edit"
            plain
            type="success"
            @click="handleUpdate"
        >修改
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            v-hasPermi="['system:dict:remove']"
            :disabled="multiple"
            icon="Delete"
            plain
            type="danger"
            @click="handleDelete"
        >删除
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            v-hasPermi="['system:dict:export']"
            icon="Download"
            plain
            type="warning"
            @click="handleExport"
        >导出
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            v-hasPermi="['system:dict:remove']"
            icon="Refresh"
            plain
            type="danger"
            @click="handleRefreshCache"
        >刷新缓存
        </el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table  highlight-current-row scrollbar-always-on show-overflow-tooltip v-loading="loading" :data="typeList" border stripe @selection-change="handleSelectionChange">
      <el-table-column align="center" type="selection" width="55"/>
      <el-table-column align="center" label="字典编号" prop="dictId"/>
      <el-table-column :show-overflow-tooltip="true" align="center" label="字典名称" prop="dictName"/>
      <el-table-column :show-overflow-tooltip="true" align="center" label="字典类型">
        <template #default="scope">
          <el-button
              type="primary" link
              @click="handleDynamicJump(scope.row)">
            {{ scope.row.dictType }}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column align="center" label="状态" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>

      <el-table-column align="center" label="字典类别" prop="dictCategory">
        <template #default="scope">
          <dict-tag :options="sys_dict_category" :value="scope.row.dictCategory"/>
        </template>
      </el-table-column>


      <el-table-column :show-overflow-tooltip="true" align="center" label="备注" prop="remark"/>
      <el-table-column align="center" label="创建时间" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column align="center" class-name="small-padding fixed-width" label="操作" width="160">
        <template #default="scope">
          <el-button v-hasPermi="['system:dict:edit']" icon="Edit" link type="primary" @click="handleUpdate(scope.row)">
            修改
          </el-button>
          <el-button v-hasPermi="['system:dict:remove']" icon="Delete" link type="primary"
                     @click="handleDelete(scope.row)">删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
        v-show="total > 0"
        v-model:limit="queryParams.pageSize"
        v-model:page="queryParams.pageNum"
        :total="total"
        @pagination="getList"
    />

    <!-- 添加或修改参数配置对话框 -->
    <el-dialog v-model="open" :title="title" append-to-body align-center
               draggable width="500px">
      <el-form ref="dictRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="字典名称" prop="dictName">
          <el-input v-model="form.dictName" placeholder="请输入字典名称"/>
        </el-form-item>
        <el-form-item prop="dictType">
          <el-input v-model="form.dictType" placeholder="请输入字典类型"/>
          <template #label>
                 <span>
                   <el-tooltip content='数据存储中的Key值，如：sys_user_sex' placement="top">
                     <el-icon><question-filled/></el-icon>
                   </el-tooltip>
                   字典类型
                 </span>
          </template>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
                v-for="dict in sys_normal_disable"
                :key="dict.value"
                :value="dict.value"
            >{{ dict.label }}
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="字典类别" prop="dictCategory">
          <el-radio-group v-model="form.dictCategory">
            <el-radio
                v-for="dict in sys_dict_category"
                :key="dict.value"
                :value="dict.value"
            >{{ dict.label }}
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item v-if="form.dictCategory === 'entity_dic'" label="实体表字典" prop="dictEntityJson">
          <el-button @click="openEditor()">{{ form.dictEntityJson ? '编辑' : "新增" }}</el-button>
        </el-form-item>


        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" placeholder="请输入内容" type="textarea"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    <entity-dic ref="entityDic"></entity-dic>
    <JsonEditorDialog
        v-model="isDialogVisible"
        :data="jsonData"
        height="600px"
        title="系统配置编辑"
        @save="handleSave"
    />
    <el-dialog v-model="editInfo.editDialogVisible" :title="editInfo.title" align-center
               draggable style="height: 80vh" width="90%">
      <Data :dictId="editInfo.dictId"></Data>
    </el-dialog>

  </div>
</template>

<script name="Dict" setup>
import useDictStore from '@/store/modules/dict'
import {addType, delType, getType, listType, refreshCache, updateType} from "@/api/system/dict/type"
import JsonEditorDialog from "@/views/tool/editor/JsonEditorDialog.vue";
import router from "@/router/index.js";
import EntityDic from "@/views/system/dict/entity-dic.vue";
import Data from "@/views/system/dict/data.vue";

const {proxy} = getCurrentInstance()
const {sys_normal_disable} = proxy.useDict("sys_normal_disable")
const {sys_dict_category} = proxy.useDict("sys_dict_category")

const typeList = ref([])
const entityDic = ref({})
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const dateRange = ref([])
const editInfo = ref({editDialogVisible: false, title: '', dictId: null})

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 20,
    dictName: undefined,
    dictType: undefined,
    status: undefined
  },
  rules: {
    dictName: [{required: true, message: "字典名称不能为空", trigger: "blur"}],
    dictType: [{required: true, message: "字典类型不能为空", trigger: "blur"}]
  },
})

const isDialogVisible = ref(false);

const handleDynamicJump = (row) => {
  if (row.dictCategory === 'entity_dic') {
    entityDic.value.openDialog(row)
  }
  if (row.dictCategory === 'system_dic') {

    const dictId = row.dictId || ids.value[0]
    const tableName = row.dictName
    const params = {pageNum: queryParams.value.pageNum}
    editInfo.value.editDialogVisible = true
    editInfo.value.params = params
    editInfo.value.title = "修改[" + tableName + "]生成配置"
    setTimeout(()=>  editInfo.value.dictId = String(dictId),200)


    // 动态跳转
    // router.push({
    //   path: '/system/dict-data/index/' + row.dictId,
    // });
  }
};
const openEditor = () => {
  if (form.value.dictEntityJson) {
    jsonData.value = JSON.parse(form.value.dictEntityJson)
  } else {
    jsonData.value = {
      "tableName": "",
      "dictType": "",
      "dictCode": "",
      "dictLabel": "",
      "dictValue": "",
      "dictSort": "",
      "dictRemark": "",
      "cssClass": null,
      "listClass": null,
      "isDefault": null,
      "status": null,
      "whereSql": " where 1=1 ",
      "orderSql": " order by  ",
      "remark": "as 前面可以写 case when,如果dictType为空tableName为缓存key,dictCode为空dictValue为dictCode"
    }
  }
  isDialogVisible.value = true;
};

const jsonData = ref({})
const handleSave = (newData) => {
  if (newData) {
    form.value.dictEntityJson = JSON.stringify(newData);
  } else {
    form.value.dictEntityJson = null
  }
};


const {queryParams, form, rules} = toRefs(data)

/** 查询字典类型列表 */
function getList() {
  loading.value = true
  listType(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    typeList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 表单重置 */
function reset() {
  form.value = {
    dictId: undefined,
    dictName: undefined,
    dictType: undefined,
    status: "0",
    remark: undefined,
    dictCategory: 'system_dic',
    dictEntityJson: undefined
  }
  proxy.resetForm("dictRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加字典类型"
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.dictId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const dictId = row.dictId || ids.value
  getType(dictId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改字典类型"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["dictRef"].validate(valid => {
    if (valid) {
      if (form.value.dictId != undefined) {
        updateType(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addType(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const dictIds = row.dictId || ids.value
  proxy.$modal.confirm('是否确认删除字典编号为"' + dictIds + '"的数据项？').then(function () {
    return delType(dictIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {
  })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download("system/dict/type/export", {
    ...queryParams.value
  }, `dict_${new Date().getTime()}.xlsx`)
}

/** 刷新缓存按钮操作 */
function handleRefreshCache() {
  refreshCache().then(() => {
    proxy.$modal.msgSuccess("刷新成功")
    useDictStore().cleanDict()
  })
}

getList()
</script>
