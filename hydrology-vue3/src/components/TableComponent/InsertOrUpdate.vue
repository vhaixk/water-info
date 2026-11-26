<template>
  <div>
    <el-dialog
        v-model="visible"
        :loading="loading"
        :title="title"
        class="custom-dragging-style"
        destroy-on-close
        align-center
        draggable
        width="60%"
    >
      <el-form
          ref="form"
          :loading="loading"
          :model="rowData"
          label-position="left"
      >
        <el-row
            :gutter="50"
            style="padding-right: 10%; padding-left: 10%"
        >
          <template v-for="item in props.columnConfig" :key="item.column_name">
            <el-col
                v-if="item.edit_list === '1'"
                :span="(item.edit_type.indexOf('Upload') > -1) || item.edit_type === 'textarea' ? 24 : 12"
            >
              <el-form-item
                  :label="item.column_comment"
                  :label-width="120"
                  :prop="item.column_name"
                  :rules="[
            {
              required: item.is_required === '1',
              message: `${item.column_comment} 不能为空！`,
              trigger: ['blur', 'change'],
            },
          ]"
              >
                <!-- 统一用 flex 包住控件 + 提示图标 -->
                <div style="display: flex; align-items: center; width: 100%; gap: 8px;">
                  <!-- 字符串输入 / 文本域 -->
                  <el-input
                      v-if="(item.edit_type === 'input' || item.edit_type === 'textarea') && item.java_type === 'String'"
                      v-model="rowData[item.column_name]"
                      :disabled="(formInsert && item.is_insert === '0') || (!formInsert && item.is_edit === '0')"
                      :placeholder="`请输入${item.column_comment}`"
                      :type="item.edit_type"
                      suffix-icon="Edit"
                      clearable
                      style="flex: 1; min-width: 0;"
                  />

                  <!-- 数字输入 -->
                  <el-input-number
                      v-if="(item.java_type === 'BigDecimal' || item.java_type === 'Long' || item.java_type === 'Integer') && item.edit_type === 'input'"
                      v-model="rowData[item.column_name]"
                      :disabled="(formInsert && item.is_insert === '0') || (!formInsert && item.is_edit === '0')"
                      :placeholder="`请输入${item.column_comment}`"
                      :step="item.java_type === 'BigDecimal' ? 0.1 : 1"
                      clearable
                      style="flex: 1; min-width: 0; width: 100%;"
                  />

                  <!-- 日期时间 -->
                  <el-date-picker
                      v-if="item.edit_type === 'datetime'"
                      v-model="rowData[item.column_name]"
                      :disabled="(formInsert && item.is_insert === '0') || (!formInsert && item.is_edit === '0')"
                      :placeholder="`请输入${item.column_comment}`"
                      :type="item.edit_type"
                      clearable
                      style="flex: 1; min-width: 0; width: 100%;"
                  />

                  <!-- 下拉 / 多选 / 单选 / 复选 -->
                  <el-select
                      v-if="item.edit_type === 'select' || item.edit_type === 'selectMore' || item.edit_type === 'radio' || item.edit_type === 'checkBox'"
                      v-model="rowData[item.column_name]"
                      :collapse-tags="item.edit_type === 'selectMore' || item.edit_type === 'checkBox'"
                      :collapse-tags-tooltip="item.edit_type === 'selectMore' || item.edit_type === 'checkBox'"
                      :disabled="(formInsert && item.is_insert === '0') || (!formInsert && item.is_edit === '0')"
                      :multiple="item.edit_type === 'selectMore' || item.edit_type === 'checkBox'"
                      :placeholder="`请输入${item.column_comment}`"
                      clearable
                      filterable
                      suffix-icon="Switch"
                      style="flex: 1; min-width: 0;"
                      @clear="() => (rowData[item.column_name] = null)"
                  >
                    <el-option
                        v-for="opt in getDic(item.column_name)"
                        :key="opt.value"
                        :label="opt.label"
                        :value="opt.value"
                    >
                      <el-tag v-if="opt.elTagType" :type="opt.elTagType">{{ opt.label }}</el-tag>
                      <span v-else>{{ opt.label }}</span>
                    </el-option>
                  </el-select>

                  <!-- 文件 / 图片上传 -->
                  <el-upload
                      v-if="item.edit_type === 'fileUploadMore' || item.edit_type === 'fileUpload' || item.edit_type === 'imageUpload' || item.edit_type === 'imageUploadMore'"
                      :ref="item.column_name"
                      v-model:file-list="viewFile[item.column_name]"
                      :auto-upload="false"
                      :disabled="(formInsert && item.is_insert === '0') || (!formInsert && item.is_edit === '0')"
                      :limit="item.upload_number || 1"
                      :list-type="item.edit_type.indexOf('image') > -1 ? 'picture-card' : 'text'"
                      :on-change="(uploadFile, uploadFiles) => fileUpload(uploadFile, uploadFiles, item)"
                      :on-exceed="handleExceed"
                      :on-preview="handledPreview"
                      style="flex: 1; min-width: 0; width: 100%;"
                  >
                    <el-button class="el-upload__text" type="primary">
                      <el-icon class="el-icon--upload">
                        <upload-filled />
                      </el-icon>
                      点击上传
                    </el-button>
                    <template #tip>
                      <div class="el-upload__tip text-red">
                        最多上传 {{ item.upload_number || 1 }} 个文件
                      </div>
                    </template>

                    <template v-if="item.edit_type.indexOf('image') === -1" #file="scope">
                      <div>
                        <el-link type="primary" @click="handledPreview(scope.file)">
                          {{ scope.file.name }}
                        </el-link>
                        <div style="float: right">
                          <el-button
                              :icon="View"
                              circle
                              size="small"
                              type="success"
                              @click="handledPreview(scope.file)"
                          />
                          <el-button
                              :icon="Download"
                              circle
                              size="small"
                              type="primary"
                              @click="CommonUtils.downloadFile(scope.file.profilePath, scope.file.name)"
                          />
                          <el-button
                              :icon="DeleteFilled"
                              circle
                              size="small"
                              type="danger"
                              @click="removeFile(scope.file, item.column_name)"
                          />
                        </div>
                      </div>
                    </template>
                  </el-upload>

                  <el-popover
                      v-if="item.column_remark"
                      placement="top-start"
                      trigger="hover"
                      :content="item.column_remark"
                  >
                    <template #reference>
                      <el-icon
                          style="cursor: pointer; flex-shrink: 0; color: var(--el-text-color-secondary);"
                      >
                        <QuestionFilled />
                      </el-icon>
                    </template>
                  </el-popover>
                </div>
              </el-form-item>
            </el-col>
          </template>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="visible = false">取消</el-button>
          <el-button :loading="loading" type="primary" @click="submitForm">
            确定
          </el-button>
        </div>
      </template>


    </el-dialog>

    <el-image-viewer
        v-if="previewFile.imgDialogVisible"
        :url-list="[previewFile.dialogImageUrl]"
        show-progress
        @close="previewFile.imgDialogVisible = false"
    />
    <el-dialog
        v-model="previewFile.officeVisible"
        :loading="previewFile.loading"
        :title="previewFile.title"
        align-center
        class="custom-dragging-style"
        destroy-on-close
        draggable
        style="height: 85vh"
        width="70%"
    >
      <div style="flex: 1;overflow: auto;height: 80vh;width: 100%">
        <vue-office-pdf v-if="previewFile.pdfUrl" :@endered="previewFile.loading = false" :src="previewFile.pdfUrl"/>
        <vue-office-docx v-if="previewFile.docxUrl" :src="previewFile.docxUrl "
                         @rendered="previewFile.loading = false"/>
        <vue-office-pptx v-if="previewFile.pptxUrl" :src="previewFile.pptxUrl "
                         @rendered="previewFile.loading = false"/>
        <vue-office-excel v-if="previewFile.excelUrl" :src="previewFile.excelUrl "
                          @rendered="previewFile.loading = false"/>
      </div>
    </el-dialog>
  </div>
</template>


<script setup>

import CommonApi, {insertOrUpdate} from "@/api/common/commonApi.js";
import VueOfficePdf from '@vue-office/pdf'
import VueOfficeDocx from '@vue-office/docx'
import VueOfficePptx from '@vue-office/pptx'
import VueOfficeExcel from '@vue-office/excel'
import '@vue-office/docx/lib/index.css'
import '@vue-office/excel/lib/index.css'

import {ElMessage} from "element-plus";
import {
  View,
  Download,
  DeleteFilled, QuestionFilled
} from "@element-plus/icons-vue";
import CommonUtils from "@/api/common/commonUtils.js";

const visible = ref(false)
const title = ref('')
const formInsert = ref(true)
const form = ref({})
const rowData = ref({})
const loading = ref(false)
const emit = defineEmits(['saveOver','refresh'])
const viewFile = ref({})
import cloneDeep from "lodash/cloneDeep";

const previewFile = ref({
  dialogImageUrl: '',
  imgDialogVisible: false,
  pdfUrl: '',
  excelUrl: '',
  docxUrl: '',
  pptxUrl: '',
  officeVisible: false,
  title: ''

})

const location = CommonUtils.getLocation()

const props = defineProps({
  columnConfig: {},
  dicColumnConfig: {},
  tableConfig: {},
})
const getDic = (column_name) => {
  const dic = props.dicColumnConfig[column_name]

  if (!dic) {
    console.warn("字段 " + column_name + " 没有对应类型")
    return []
  }
  return Object.values(dic)
}

const openDialog = (row) => {
  loading.value = true
  visible.value = true
  title.value = !row ? '新增' : '修改'
  formInsert.value = !row
  viewFile.value = {}
  rowData.value = row ? cloneDeep(row) : {}
  for (let column of props.columnConfig) {
    if (column.edit_type === 'select' && rowData.value[column.column_name]) {
      rowData.value[column.column_name] = String(rowData.value[column.column_name])
    }
    if (column.edit_type === 'selectMore' || column.edit_type === 'checkbox') {
      if (row) {
        rowData.value[column.column_name] = rowData.value[column.column_name] ? rowData.value[column.column_name].split(',') :[]
      } else {
        rowData.value[column.column_name] = []
      }
    }
    if (!row) {
      rowData.value[column.column_name] = null
    }
    if (column.edit_type.indexOf('Upload') > -1 && rowData.value[column.column_name]) {
      viewFile.value[column.column_name] =
          rowData.value[column.column_name]
              .split(",")
              .map((item) => {
                return {
                  name: CommonUtils.getFullName(item),
                  url: location + import.meta.env.VITE_APP_BASE_API + item,
                  profilePath: item
                }
              })
    }
  }
  loading.value = false
}


const fileUpload = async (uploadFile, uploadFiles, item) => {
  const view = viewFile.value[item.column_name]

  if (item.edit_type.indexOf('image') > -1) {
    if (!["bmp", "gif", "jpg", "jpeg", "png"].includes(CommonUtils.getSuffixName(uploadFile.name).toLowerCase())) {
      viewFile.value[item.column_name] = view.filter(item => item.uid !== uploadFile.uid)
      ElMessage({message: `不允许上传非图片文件`, type: 'error', duration: 2 * 1000})
    }
  }

  if (uploadFile.name.includes('@') || uploadFile.name.includes('/') || uploadFile.name.includes('#')) {
    viewFile.value[item.column_name] = view.filter(item => item.uid !== uploadFile.uid)
    ElMessage({message: `已过滤非法文件名称的文件`, type: 'error', duration: 2 * 1000})
  }

  const formData = new FormData();
  formData.append('file', uploadFile.raw);
  const data = await CommonApi.uploadFile(formData)
  if (data.code !== 200) {
    ElMessage({message: `上传失败`, type: 'error', duration: 2 * 1000})
    return
  }
  for (let viewKey in view) {
    if (view[viewKey].name === data.originalFilename) {
      view[viewKey].name = data.newFileName
      view[viewKey].url = location + import.meta.env.VITE_APP_BASE_API + data.profilePath
      view[viewKey].status = 'success'
      view[viewKey].profilePath = data.profilePath
    }
  }
}

const handleExceed = (files) => {
  ElMessage({message: `数据超出上传最大限制，请删除后再上传`, type: 'warning', duration: 2 * 1000})

}
const removeFile = (file, columnName) => {
  const files = viewFile.value[columnName]
  const fs = files.filter(item => item.uid !== file.uid)
  viewFile.value[columnName] = fs
}
const handledPreview = (uploadFile) => {

  previewFile.value.docxUrl = ''
  previewFile.value.pdfUrl = ''
  previewFile.value.excelUrl = ''
  previewFile.value.pptxUrl = ''
  previewFile.value.title = uploadFile.name

  const suffix = CommonUtils.getSuffixName(uploadFile.name).toLowerCase()
  if (["bmp", "gif", "jpg", "jpeg", "png"].includes(suffix)) {
    previewFile.value.dialogImageUrl = uploadFile.url
    previewFile.value.imgDialogVisible = true
  }

  let flag = false
  if (["doc", "docx"].includes(suffix)) {
    previewFile.value.docxUrl = uploadFile.url
    flag = true
  }
  if (["pdf"].includes(suffix)) {
    previewFile.value.pdfUrl = uploadFile.url
    flag = true
  }
  if (["xls", "xlsx"].includes(suffix)) {
    previewFile.value.excelUrl = uploadFile.url
    flag = true
  }
  if (["pptx", "ppt"].includes(suffix)) {
    previewFile.value.pptxUrl = uploadFile.url
    flag = true
  }

  previewFile.value.loading = flag
  previewFile.value.officeVisible = flag

  if (!flag) CommonUtils.downloadFile(uploadFile.profilePath, uploadFile.name)
}

const submitForm = () => {

  form.value.validate(async (valid) => {
    if (!valid) {
      ElMessage({message: `请按照规则填写数据！`, type: 'warning', duration: 2 * 1000})
      return
    }
    loading.value = true
    const saveRowData = {tableName: props.tableConfig.tableName}
    for (let column of props.columnConfig) {
      if (column.edit_type === 'selectMore' || column.edit_type === 'checkbox') {
        saveRowData[column.column_name] = rowData.value[column.column_name]?.join(',')
      } else {
        saveRowData[column.column_name] = rowData.value[column.column_name]
      }
    }
    for (let columnName of Object.keys(viewFile.value)) {
      const uploadValue = viewFile.value[columnName].map((item) => item.profilePath).join(',')
      saveRowData[columnName] = uploadValue
      rowData.value[columnName] = uploadValue
    }
    const data = await insertOrUpdate(props.tableConfig.tableName, saveRowData)
    if (data.code === 200) {
      ElMessage({message: `已成功${title.value} ${data.data} 条数据！`, type: 'success', duration: 2 * 1000})

      emit('refresh')
      emit('saveOver',saveRowData)
      visible.value = false
    } else {
      ElMessage({message: `${title.value}数据失败`, type: 'error', duration: 2 * 1000})
    }

    loading.value = false
  })
}


defineExpose({openDialog})
</script>

<style lang="scss" scoped>
:global(.custom-dragging-style.is-dragging) {
  border: 2px dashed var(--el-color-primary);
  opacity: 0.65;
}


</style>
