<template>
  <el-aside
      :width="computedWidth + 'px'"
      class="station-tree-aside"
      :class="{ collapsed }"
  >
    <!-- 可拖拽手柄（仅展开时显示） -->
    <div
        ref="resizeHandleRef"
        v-if="!collapsed"
        class="resize-handle"
        @mousedown="startResize"
    ></div>

    <!-- 收起/展开按钮 - 移到外面 -->
    <div
        class="toggle-button"
        @click="toggleCollapse"
        :title="collapsed ? '展开侧边栏' : '收起侧边栏'"
    >
      <span class="arrow">
        {{ collapsed ? '❯' : '❮' }}
      </span>
    </div>

    <!-- 内容区域 -->
    <div v-if="!collapsed" class="content-wrapper">
      <slot name="default"></slot>
    </div>
  </el-aside>
</template>

<script setup>
import { computed, ref, onUnmounted } from 'vue'

const emit = defineEmits(['update:width', 'update:collapsed'])
const resizeHandleRef = ref(null)

const props = defineProps({
  width: { type: Number, default: 240 },
  collapsed: { type: Boolean, default: false },
  collapsedWidth: { type: Number, default: 1 },   // 收起后更窄，只留一点边
  minWidth: { type: Number, default: 0 },
  maxWidth: { type: Number, default: 1440 }
})

const computedWidth = computed(() => {
  return props.collapsed ? props.collapsedWidth : props.width
})

const toggleCollapse = () => {
  emit('update:collapsed', !props.collapsed)
}

// ... 其余的 throttle、startResize、onUnmounted 逻辑保持不变
const throttle = (func, delay) => {
  let timeoutId;
  let lastExecTime = 0;
  return function (...args) {
    const currentTime = Date.now();
    if (currentTime - lastExecTime > delay) {
      func.apply(this, args);
      lastExecTime = currentTime;
    } else {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => {
        func.apply(this, args);
        lastExecTime = Date.now();
      }, delay - (currentTime - lastExecTime));
    }
  };
};

let currentMouseMoveHandler = null;
let currentMouseUpHandler = null;

const startResize = (e) => {
  if (props.collapsed) return

  const startX = e.clientX
  const startWidth = props.width

  document.body.style.userSelect = 'none'
  if (resizeHandleRef.value) {
    resizeHandleRef.value.classList.add('dragging')
  }

  const throttledResize = throttle((moveEvent) => {
    let newWidth = startWidth + (moveEvent.clientX - startX)
    newWidth = Math.max(props.minWidth, Math.min(newWidth, props.maxWidth))
    emit('update:width', newWidth)
  }, 16)

  const doResize = (moveEvent) => throttledResize(moveEvent)

  const stopResize = () => {
    document.body.style.userSelect = ''
    if (resizeHandleRef.value) {
      resizeHandleRef.value.classList.remove('dragging')
    }
    document.removeEventListener('mousemove', currentMouseMoveHandler)
    document.removeEventListener('mouseup', currentMouseUpHandler)
    currentMouseMoveHandler = null
    currentMouseUpHandler = null
  }

  currentMouseMoveHandler = doResize
  currentMouseUpHandler = stopResize

  document.addEventListener('mousemove', currentMouseMoveHandler)
  document.addEventListener('mouseup', currentMouseUpHandler)
}

onUnmounted(() => {
  if (currentMouseMoveHandler && currentMouseUpHandler) {
    document.removeEventListener('mousemove', currentMouseMoveHandler)
    document.removeEventListener('mouseup', currentMouseUpHandler)
  }
})
</script>

<style lang="scss" scoped>
.station-tree-aside {
  padding: 0;
  position: relative;
  background-color: var(--el-bg-color);
  height: calc(100vh - 120px);
  border-right: 1px solid var(--el-bg-color);
  transition: width 0.3s ease;
  overflow: visible !important;
  z-index: 10;
}

.resize-handle {
  position: absolute;
  right: 0;
  top: 0;
  width: 5px;
  height: 100%;
  background: transparent;
  cursor: col-resize;
  z-index: 15;

  &:hover,
  &.dragging {
    background: #409eff;
  }
}

/* 关键修改：收缩按钮放在外面 */
.toggle-button {
  position: absolute;
  left: 100%;                    /* 关键：放在侧边栏右边外面 */
  top: 50%;
  transform: translateY(-50%);
  width: 15px;
  height: 45px;
  background-color: var(--el-bg-color);
  border: 1px solid #e4e7ed;
  border-left: none;             /* 去掉左边框，使其更像“突出”按钮 */
  border-radius: 0 12px 12px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 20;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.12);
  transition: all 0.3s ease;

  &:hover {
    background-color: var(--el-bg-color);
    border-color: #409eff;
  }

  .arrow {
    font-size: 18px;
    color: #606266;
    transition: transform 0.3s;
  }

  &:hover .arrow {
    color: #409eff;
  }
}

  .content-wrapper {
    overflow: hidden;
    height: 100%;
  }

.station-tree-aside.collapsed {
  .content-wrapper {
    display: none;
  }

  /* 收起时按钮更明显 */
  .toggle-button {
    box-shadow: 3px 0 10px rgba(0, 0, 0, 0.15);
  }
}
</style>
