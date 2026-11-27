<template>
    <el-tabs v-model="activeName">
      <el-tab-pane label="基本信息" name="basic">
        <basic-info-form ref="basicInfo" :info="info"/>
      </el-tab-pane>
      <el-tab-pane label="字段信息" name="columnInfo">
        <el-table ref="dragTable" v-loading="loading" :data="columns" border style="height: 70vh"
                  highlight-current-row row-key="columnId" scrollbar-always-on show-overflow-tooltip stripe>
          <el-table-column class-name="allowDrag" fixed="left" label="序号" min-width="50" type="index"/>
          <el-table-column :show-overflow-tooltip="true" class-name="allowDrag" fixed="left" label="字段列名"
                           min-width="140" prop="columnName"/>
          <el-table-column fixed="left" label="字段描述" min-width="120">
            <template #default="scope">
              <el-input v-model="scope.row.columnComment"></el-input>
            </template>
          </el-table-column>
          <el-table-column
              :show-overflow-tooltip="true"
              label="物理类型"
              min-width="120"
              prop="columnType"
          />
          <el-table-column label="Java类型" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.javaType">
                <el-option label="Long" value="Long"/>
                <el-option label="String" value="String"/>
                <el-option label="Integer" value="Integer"/>
                <el-option label="Double" value="Double"/>
                <el-option label="BigDecimal" value="BigDecimal"/>
                <el-option label="Date" value="Date"/>
                <el-option label="Boolean" value="Boolean"/>
                <el-option label="Geometry" value="Geometry"/>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="java属性" min-width="120">
            <template #default="scope">
              <el-input v-model="scope.row.javaField"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="最佳宽度" min-width="80">
            <template #default="scope">
              <el-input v-model="scope.row.bestWidth"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="最小宽度" min-width="80">
            <template #default="scope">
              <el-input v-model="scope.row.minWidth"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="对齐方式" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.alignType">
                <el-option label="center" value="center"/>
                <el-option label="left" value="left"/>
                <el-option label="right" value="right"/>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="字段顺序" min-width="80">
            <template #default="scope">
              <el-input v-model="scope.row.sort"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="order顺序" min-width="80">
            <template #default="scope">
              <el-input v-model="scope.row.sortSort"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="排序方式" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.sortType" clearable>
                <el-option label="asc" value="asc"/>
                <el-option label="desc" value="desc"/>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="固定列" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.fixedType" clearable>
                <el-option label="left" value="left"/>
                <el-option label="right" value="right"/>
              </el-select>
            </template>
          </el-table-column>

          <el-table-column label="插入" min-width="55">
            <template #default="scope">
              <el-checkbox v-model="scope.row.isInsert" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="可编辑" min-width="60">
            <template #default="scope">
              <el-checkbox v-model="scope.row.isEdit" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="列表" min-width="55">
            <template #default="scope">
              <el-checkbox v-model="scope.row.isList" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="编辑显示" min-width="55">
            <template #default="scope">
              <el-checkbox v-model="scope.row.editList" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>


          <el-table-column label="查询" min-width="55">
            <template #default="scope">
              <el-checkbox v-model="scope.row.isQuery" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="必填" min-width="55">
            <template #default="scope">
              <el-checkbox v-model="scope.row.isRequired" false-value="0" true-value="1"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="查询方式" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.queryType">
                <el-option label="=" value="EQ"/>
                <el-option label="!=" value="NE"/>
                <el-option label=">" value="GT"/>
                <el-option label=">=" value="GTE"/>
                <el-option label="<" value="LT"/>
                <el-option label="<=" value="LTE"/>
                <el-option label="LIKE" value="LIKE"/>
                <el-option label="RLIKE" value="RLIKE"/>
                <el-option label="IN" value="IN"/>
                <el-option label="LLIKE" value="LLIKE"/>
                <el-option label="BETWEEN" value="BETWEEN"/>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="显示类型" min-width="140">
            <template #default="scope">
              <el-select v-model="scope.row.htmlType">
                <el-option label="文本框" value="input"/>
                <el-option label="文本域" value="textarea"/>
                <el-option label="下拉框" value="select"/>
                <el-option label="单选框" value="radio"/>
                <el-option label="复选框" value="checkbox"/>
                <el-option label="日期控件" value="datetime"/>
                <el-option label="图片上传" value="imageUpload"/>
                <el-option label="文件上传" value="fileUpload"/>
                <el-option label="富文本控件" value="editor"/>
                <el-option label="矢量类型" value="Geometry"/>
              </el-select>
            </template>
          </el-table-column>


          <el-table-column label="编辑类型" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.editType">
                <el-option label="文本框" value="input"/>
                <el-option label="文本域" value="textarea"/>
                <el-option label="下拉框" value="select"/>
                <el-option label="多选下拉框" value="selectMore"/>
                <el-option label="单选框" value="radio"/>
                <el-option label="复选框" value="checkbox"/>
                <el-option label="日期控件" value="datetime"/>
                <el-option label="图片上传" value="imageUpload"/>
                <el-option label="文件上传" value="fileUpload"/>
                <el-option label="多图片上传" value="imageUploadMore"/>
                <el-option label="多文件文件上传" value="fileUploadMore"/>
                <el-option label="富文本控件" value="editor"/>
                <el-option label="矢量类型" value="Geometry"/>
              </el-select>
            </template>
          </el-table-column>

          <el-table-column label="字典类型" min-width="120">
            <template #default="scope">
              <el-select v-model="scope.row.dictType"
                         :disabled="scope.row.editType.indexOf('select') === -1 && scope.row.editType.indexOf('radio') === -1 && scope.row.editType.indexOf('checkbox') === -1"
                         clearable filterable
                         placeholder="请选择">
                <el-option
                    v-for="dict in dictOptions"
                    :key="dict.dictType"
                    :label="dict.dictName"
                    :value="dict.dictType">
                  <span style="float: left">{{ dict.dictName }}</span>
                  <span style="float: right; color: #8492a6; font-size: 13px">{{ dict.dictType }}</span>
                </el-option>
              </el-select>
            </template>
          </el-table-column>

          <el-table-column label="字段说明" min-width="150">
            <template #default="scope">
              <el-input clearable v-model="scope.row.columnRemark"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="多选或上传数量" min-width="80">
            <template #default="scope">
              <el-input v-model="scope.row.uploadNumber"
                        :disabled="scope.row.editType.indexOf('More') === -1"></el-input>
            </template>
          </el-table-column>

          <el-table-column label="日期显示类型" min-width="220">
            <template #default="scope">
              <el-select v-model="scope.row.dateType" :disabled="scope.row.editType !== 'datetime'" clearable>
                <el-option label="YYYY-MM-DD HH:mm:ss" value="YYYY-MM-DD HH:mm:ss"/>
                <el-option label="YYYY-MM-DD HH:mm" value="YYYY-MM-DD HH:mm"/>
                <el-option label="YYYY-MM-DD HH" value="YYYY-MM-DD HH"/>
                <el-option label="YYYY-MM-DD" value="YYYY-MM-DD"/>
                <el-option label="YYYY-MM" value="YYYY-MM"/>
                <el-option label="YYYY" value="YYYY"/>
              </el-select>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
    <el-form label-width="100px">
      <div style="text-align: center;margin-left:-100px;margin-top:10px;">
        <el-button type="primary" @click="submitForm()">提交</el-button>
        <!--        <el-button @click="close()">返回</el-button>-->
      </div>
    </el-form>

</template>

<script name="GenEdit" setup>
import {getGenTable, updateGenTable} from "@/api/tool/gen"
import {optionselect as getDictOptionselect} from "@/api/system/dict/type"
import basicInfoForm from "./basicInfoForm"
import Sortable from 'sortablejs'

const route = useRoute()
const {proxy} = getCurrentInstance()

const activeName = ref("columnInfo")
const tables = ref([])
const columns = ref([])
const dictOptions = ref([])
const info = ref({})
const loading = ref(false)
const props = defineProps({
  tableId: {
    type: String,
    default: ""
  }
})
const emit = defineEmits(['resetQuery'])

/** 提交按钮 */
function submitForm() {
  const basicForm = proxy.$refs.basicInfo.$refs.basicInfoForm
  Promise.all([basicForm].map(getFormPromise)).then(res => {
    const validateResult = res.every(item => !!item)
    if (validateResult) {
      const genTable = Object.assign({}, info.value)
      genTable.columns = columns.value
      genTable.params = {
        treeCode: info.value.treeCode,
        treeName: info.value.treeName,
        treeParentCode: info.value.treeParentCode,
        parentMenuId: info.value.parentMenuId
      }
      updateGenTable(genTable).then(res => {
        proxy.$modal.msgSuccess(res.msg)
        // if (res.code === 200) {
        //   close()
        // }
      })
    //    setTimeout(()=>emit('resetQuery'),800)

    } else {
      proxy.$modal.msgError("表单校验未通过，请重新检查提交内容")
    }
  })
}

function getFormPromise(form) {
  return new Promise(resolve => {
    form.validate(res => {
      resolve(res)
    })
  })
}

function close() {
  const obj = {path: "/tool/gen", query: {t: Date.now(), pageNum: route.query.pageNum}}
  proxy.$tab.closeOpenPage(obj)
}

watch(() => props.tableId, () => init())

async function init() {

  const tableId = props.tableId
  if (tableId) {
    // 获取表详细信息
    loading.value = true

    await getGenTable(tableId).then(res => {
      columns.value = res.data.rows
      info.value = res.data.info
      tables.value = res.data.tables
    })
    /** 查询字典下拉列表 */
    await getDictOptionselect().then(response => {
      dictOptions.value = response.data
    })
    loading.value = false
  }
}

// 拖动排序
onMounted(() => {
  const element = document.querySelector('.el-table__body > tbody')
  Sortable.create(element, {
    handle: ".allowDrag",
    onEnd: (evt) => {
      const targetRow = columns.value.splice(evt.oldIndex, 1)[0]
      columns.value.splice(evt.newIndex, 0, targetRow)
      for (const index in columns.value) {
        columns.value[index].sort = parseInt(index) + 1
      }
    }
  })
})
</script>
