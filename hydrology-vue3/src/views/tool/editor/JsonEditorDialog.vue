<template>
  <el-dialog
      v-model="dialogVisible"
      :close-on-click-modal="false"
      :title="title"
      destroy-on-
      align-center
      draggable
      width="60%"
      @close="handleClose"
      @open="handleOpen"
  >
    <!-- 顶部工具栏 -->
    <div class="editor-toolbar">
      <div class="toolbar-left">
        <el-radio-group v-model="editMode" size="small">
          <el-radio-button label="tree">可视化 (Tree)</el-radio-button>
          <el-radio-button label="code">代码 (Code)</el-radio-button>
        </el-radio-group>
      </div>
      <div class="toolbar-right">
        <el-button
            v-if="editMode === 'code'"
            :disabled="!!errorMsg"
            size="small"
            @click="formatCode"
        >
          格式化
        </el-button>
        <el-button size="small" @click="copyToClipboard">
          复制
        </el-button>
      </div>
    </div>

    <!-- 错误提示 -->
    <el-alert
        v-if="errorMsg"
        :closable="false"
        :title="errorMsg"
        show-icon
        style="margin-bottom: 10px;"
        type="error"
    />

    <!-- 内容区域 -->
    <div :style="{ height: contentHeight }" class="editor-content">
      <!-- 模式 1: 可视化树形编辑 -->
      <vue-json-pretty
          v-if="editMode === 'tree'"
          v-model:data="internalData"
          :editable="true"
          :show-icon="true"
          :show-length="true"
          path="root"
          style="height: 100%; overflow: auto;"
          @change="handleTreeChange"
      />

      <!-- 模式 2: 纯文本代码编辑 -->
      <el-input
          v-else
          v-model="codeString"
          :rows="20"
          class="code-editor"
          placeholder="请输入 JSON 字符串..."
          type="textarea"
          @input="validateCode"
      />
    </div>

    <!-- 底部按钮 -->
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button :disabled="!!errorMsg" type="primary" @click="confirmSave">
          确定保存
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import {computed, ref} from 'vue';
import {ElMessage} from 'element-plus';

// --- Props & Emits ---
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false,
  },
  data: {
    type: [Object, Array],
    default: () => ({}),
  },
  title: {
    type: String,
    default: 'JSON 编辑器',
  },
  height: {
    type: String,
    default: '500px', // 内容区域高度
  },
});

const emit = defineEmits(['update:modelValue', 'save']);

// --- State ---
const dialogVisible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
});

const editMode = ref('tree'); // 'tree' | 'code'
const internalData = ref(props.data);
const codeString = ref('');
const errorMsg = ref('');
const contentHeight = ref(props.height);

// --- Methods ---

// 打开对话框时初始化
const handleOpen = () => {
  // 深拷贝防止直接修改原数据
  internalData.value = JSON.parse(JSON.stringify(props.data));
  codeString.value = JSON.stringify(internalData.value, null, 2);
  errorMsg.value = '';
  editMode.value = 'tree'; // 默认树形模式
};

// 关闭对话框
const handleClose = () => {
  errorMsg.value = '';
};

// 监听树形模式的变化
const handleTreeChange = (newVal) => {
  // internalData.value = newVal;
  codeString.value = JSON.stringify(internalData.value, null, 2);
  errorMsg.value = '';
};

// 验证代码模式的 JSON 合法性
const validateCode = () => {
  if (!codeString.value.trim()) {
    errorMsg.value = '';
    return;
  }
  try {
    const parsed = JSON.parse(codeString.value);
    internalData.value = parsed;
    errorMsg.value = '';
  } catch (e) {
    errorMsg.value = `JSON 格式错误: ${e.message}`;
  }
};

// 格式化代码
const formatCode = () => {
  try {
    const parsed = JSON.parse(codeString.value);
    codeString.value = JSON.stringify(parsed, null, 2);
    errorMsg.value = '';
    ElMessage.success('格式化成功');
  } catch (e) {
    errorMsg.value = `无法格式化: ${e.message}`;
  }
};

// 复制到剪贴板
const copyToClipboard = async () => {
  const text = editMode.value === 'tree'
      ? JSON.stringify(internalData.value, null, 2)
      : codeString.value;

  try {
    await navigator.clipboard.writeText(text);
    ElMessage.success('已复制到剪贴板');
  } catch (err) {
    ElMessage.error('复制失败');
  }
};

// 确认保存
const confirmSave = () => {
  if (errorMsg.value) {
    ElMessage.warning('请先修复 JSON 格式错误');
    return;
  }

  // 确保最终数据是解析后的对象
  const finalData = editMode.value === 'tree'
      ? internalData.value
      : (codeString.value ? JSON.parse(codeString.value) : null);

  emit('save', finalData);
  dialogVisible.value = false;
  ElMessage.success('保存成功');
};
</script>

<style scoped>
.editor-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
}

.editor-content {
  position: relative;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 10px;
  background-color: #f9fafc;
}

/* 优化 textarea 样式，使其看起来像代码编辑器 */
:deep(.code-editor .el-textarea__inner) {
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 13px;
  line-height: 1.5;
  background-color: #282c34; /* 深色背景 */
  color: #abb2bf;
  border: none;
  resize: none;
  height: 100% !important; /* 强制填满容器 */
  min-height: unset;
}

/* 树形编辑器的深度限制样式微调 */
:deep(.vjs-tree) {
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 13px;
}
</style>
