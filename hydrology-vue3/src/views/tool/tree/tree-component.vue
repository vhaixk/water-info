<template>
  <div class="tree-wrapper" style="overflow: auto" v-loading.fullscreen.lock="treeConfig.loading">
    <!-- 修复点 1: 绑定 compositionstart 和 compositionend -->
    <el-input
        v-model="filterText"
        class="w-60 mb-4"
        style="width: 95%;"
        clearable
        placeholder="请输入关键字"
        @compositionend="handleCompositionEnd"
        @compositionstart="handleCompositionStart"
        @input="handleInput"
        suffix-icon="Edit"
    />

    <el-tree
        ref="treeRef"
        :check-on-click-leaf="false"
        :data="props.treeConfig.treeData"
        :expand-on-click-node="false"
        :filter-node-method="filterNode"
        :indent="16"
        :props="defaultProps"
        :render-after-expand="false"
        :default-expanded-keys="props.treeConfig.defaultExpandedKeys"
        :default-expand-all="props.treeConfig.defaultExpandedAll"
        class="custom-tree with-lines custom-tree-style"
        highlight-current
        node-key="id"
        show-checkbox
        @node-click="handleNodeClick"
        @check-change="handleCheckChange"
        @check="handleCheck"
    >
      <template #default="{ node, data }">
        <div class="custom-tree-node">
          <span>
            <el-icon v-if="data.children && !node.expanded"><Folder /></el-icon>
            <el-icon v-if="data.children && node.expanded"><FolderOpened /></el-icon>
            {{ node.label }}
          </span>
          <div>
            <slot name="toolbar"  :node="node" :data="data"></slot>
          </div>
        </div>
      </template>
    </el-tree>
  </div>
</template>

<script setup>
import {ref, watch} from "vue";

const props = defineProps({
  treeConfig: {
    type: Object,
    default: {}
  }
});

const emit = defineEmits(['node-click', 'check-change']);

const filterText = ref('');
const treeRef = ref({});
const visibleNodeIds = new Set();
const isComposing = ref(false);

const defaultProps = {
  children: 'children',
  label: 'label',
  id: 'id',
  disabled: 'disabled',
};

/**
 * 辅助函数：将某个节点下的所有子孙节点 ID 加入白名单
 * 当父节点匹配时，需要强制显示其所有子节点
 */
const markAllDescendantsAsVisible = (node) => {
  if (!node.children) return;
  node.children.forEach(child => {
    visibleNodeIds.add(child.id);
    markAllDescendantsAsVisible(child);
  });
};

/**
 * 修复点 2: 重写递归逻辑
 * 正确返回当前层级是否有匹配项，解决 forEach return 无效的问题
 */
const updateVisibleNodes = (nodes, value) => {
  let hasAnyMatchInThisLevel = false;

  if (!value) {
    return false;
  }

  nodes.forEach(node => {
    const label = node.label || '';
    const isSelfMatch = label.includes(value);

    let hasMatchedDescendant = false;
    if (node.children && node.children.length > 0) {
      // 递归检查子节点，获取子树是否有匹配
      hasMatchedDescendant = updateVisibleNodes(node.children, value);
    }

    // 如果自身匹配 或 子节点有匹配
    if (isSelfMatch || hasMatchedDescendant) {
      visibleNodeIds.add(node.id);
      hasAnyMatchInThisLevel = true;

      // 如果是自身匹配，必须展开并显示所有子节点
      if (isSelfMatch) {
        markAllDescendantsAsVisible(node);
      }
    }
  });

  return hasAnyMatchInThisLevel;
};

// 核心过滤执行函数
// 改成这样：
const performFilter = (val) => {
  visibleNodeIds.clear();

  const treeData = props.treeConfig?.treeData;

  if (val && treeData && Array.isArray(treeData)) {
    updateVisibleNodes(treeData, val);
  }

  treeRef.value?.filter(val);
};
// 防抖定时器
let debounceTimer = null;

// 立即执行过滤（用于中文输入结束）
const runFilterImmediately = (val) => {
  if (debounceTimer) clearTimeout(debounceTimer);
  performFilter(val);
};

// 防抖执行过滤（用于英文输入）
const runFilterDebounced = (val) => {
  if (debounceTimer) clearTimeout(debounceTimer);
  debounceTimer = setTimeout(() => {
    performFilter(val);
  }, 300);
};

// 处理输入法开始
const handleCompositionStart = () => {
  isComposing.value = true;
  // 输入过程中清除之前的定时器，防止拼音阶段误触发
  if (debounceTimer) clearTimeout(debounceTimer);
};

// 处理输入法结束
const handleCompositionEnd = () => {
  isComposing.value = false;
  // 中文上屏后，立即执行过滤，不等待防抖
  runFilterImmediately(filterText.value);
};

// 兼容处理普通输入事件（可选，主要依赖 watch）
const handleInput = () => {
  // 如果需要更激进的清理逻辑可以在这里添加
};

// 监听输入框变化
watch(filterText, (val) => {
  // 如果正在中文输入过程中，忽略 watch 触发，等待 compositionend
  if (isComposing.value) {
    return;
  }
  // 非中文输入（如英文、退格），使用防抖
  runFilterDebounced(val);
});

// 自定义过滤方法：只判断 ID 是否在白名单中
const filterNode = (value, data) => {
  if (!value) return true;
  return visibleNodeIds.has(data.id);
};

const handleNodeClick = (data, node, instance) => {
  emit('node-click', {data, node, instance});
};

const handleCheckChange = (data, checked, indeterminate) => {
  emit('check-change', {data, checked, indeterminate});
};
const handleCheck = (data, checkedInfo) => {
  // 当复选框状态改变时，也设置为当前选中节点
  treeRef.value.setCurrentKey(data.id);
  emit('check-change', {data, checked: checkedInfo.checked, indeterminate: checkedInfo.indeterminate});
};

const setChecked = (nodeKey, checked) => {
  treeRef.value.setChecked(nodeKey, checked, true);
}
defineExpose({setChecked})
</script>
<style scoped>
.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 8px;
}


/* 悬浮样式 - 浅蓝色 */
:deep(.custom-tree-style) .el-tree-node__content:hover {
  background-color: #82c4e3 !important;
  border-radius: 6px;
}

/* 点击高亮样式 - 橙色 */
:deep(.custom-tree-style) .el-tree-node.is-current > .el-tree-node__content {
  background-color: #ffe8cc !important;
  border-radius: 6px;
  border-left: 3px solid #fa8c16 !important;
  color: #fa8c16 !important;
  font-weight: 500;
}

/* 确保节点内容有圆角 */
:deep(.custom-tree-style) .el-tree-node__content {
  border-radius: 6px;
  transition: all 0.2s ease;
  margin: 2px 4px;
}
</style>
