<template>
  <el-image-viewer
      v-if="isImage"
      :url-list="[file.url]"
      show-progress
      @close="$emit('close')"
  />
  <el-dialog
      v-else
      :model-value="true"
      :title="file.name"
      align-center
      class="custom-dragging-style"
      destroy-on-close
      draggable
      style="height: 85vh"
      width="70%"
      @close="$emit('close')"
  >
    <div v-loading="loading" style="flex: 1;overflow: auto;height: 80vh;width: 100%">
      <vue-office-pdf v-if="suffix === 'pdf'" :src="file.url" @rendered="loading = false"/>
      <vue-office-docx v-if="suffix === 'doc' || suffix === 'docx'" :src="file.url" @rendered="loading = false"/>
      <vue-office-pptx v-if="suffix === 'ppt' || suffix === 'pptx'" :src="file.url" @rendered="loading = false"/>
      <vue-office-excel v-if="suffix === 'xls' || suffix === 'xlsx'" :src="file.url" @rendered="loading = false"/>
    </div>
  </el-dialog>
</template>

<script setup>
// 文件预览独立组件：vue-office 系列依赖较重，随本组件异步加载，不进入表格主 chunk
import VueOfficePdf from '@vue-office/pdf'
import VueOfficeDocx from '@vue-office/docx'
import VueOfficePptx from '@vue-office/pptx'
import VueOfficeExcel from '@vue-office/excel'
import '@vue-office/docx/lib/index.css'
import '@vue-office/excel/lib/index.css'
import CommonUtils from "@/api/common/commonUtils.js";

const props = defineProps({
  file: {type: Object, required: true}
})
defineEmits(['close'])

const suffix = CommonUtils.getSuffixName(props.file.name).toLowerCase()
const isImage = ["bmp", "gif", "jpg", "jpeg", "png"].includes(suffix)
const loading = ref(!isImage)
</script>