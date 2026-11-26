<template>
  <div class="bottom-aside-wrapper" :style="{ left: leftWidth + 'px' }">
    <div
        class="toggle-button"
        @click="toggleCollapse"
        :title="collapsed ? '展开底部栏' : '收起底部栏'"
    >
      <span class="arrow">
        {{ collapsed ? '︿' : '﹀' }}
      </span>
    </div>

    <div
        class="bottom-aside"
        :class="{ collapsed }"
        :style="{ height: computedHeight + 'px' }"
    >
      <div v-if="!collapsed" class="content-wrapper">
        <slot name="default"></slot>
      </div>

      <div
          ref="resizeHandleRef"
          v-if="!collapsed"
          class="resize-handle"
          @mousedown="startResize"
      ></div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, onUnmounted } from 'vue'

const emit = defineEmits(['update:height', 'update:collapsed'])
const resizeHandleRef = ref(null)

const props = defineProps({
  leftWidth: { type: Number, default: 240 },
  height: { type: Number, default: 240 },
  collapsed: { type: Boolean, default: false },
  collapsedHeight: { type: Number, default: 6 },
  minHeight: { type: Number, default: 0 },
  maxHeight: { type: Number, default: 800 }
})

const computedHeight = computed(() => {
  return props.collapsed ? props.collapsedHeight : props.height
})

const toggleCollapse = () => {
  emit('update:collapsed', !props.collapsed)
}

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

  e.preventDefault()
  const startY = e.clientY
  const startHeight = props.height

  document.body.style.userSelect = 'none'
  if (resizeHandleRef.value) {
    resizeHandleRef.value.classList.add('dragging')
  }

  const throttledResize = throttle((moveEvent) => {
    let newHeight = startHeight - (moveEvent.clientY - startY)
    newHeight = Math.max(props.minHeight, Math.min(newHeight, props.maxHeight))
    emit('update:height', newHeight)
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
.bottom-aside-wrapper {
  position: fixed;
  left: 240px;
  right: 0;
  bottom: 0;
  z-index: 10;
}

.toggle-button {
  position: absolute;
  left: calc(50% - 24px);
  top: -15px;
  height: 15px;
  width: 45px;
  background-color: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-bottom: none;
  border-radius: 12px 12px 0 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 11;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;

  &:hover {
    border-color: #409eff;
  }

  .arrow {
    font-size: 14px;
    color: #606266;
    transition: transform 0.3s;
  }

  &:hover .arrow {
    color: #409eff;
  }
}

.bottom-aside {
  position: relative;
  background-color: var(--el-bg-color);
  border-top: 1px solid var(--el-border-color-light);
  transition: height 0.3s ease;
  overflow: hidden;
  border-radius: 16px 16px 16px 16px;
}

.resize-handle {
  position: absolute;
  left: 0;
  height: 5px;
  width: 100%;
  background: transparent;
  cursor: row-resize;
  z-index: 12;
  top: 0;
  &:hover,
  &.dragging {
    background: #409eff;
  }
}

.content-wrapper {
  height: 100%;
  overflow: auto;
}

.bottom-aside.collapsed {
  .content-wrapper {
    display: none;
  }
}
</style>
