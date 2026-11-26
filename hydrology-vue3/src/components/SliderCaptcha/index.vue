<template>
  <div class="slider-captcha">
    <div ref="panelRef" class="slider-panel">
      <img :src="bgSrc" class="slider-bg" draggable="false" alt="" />
      <img
          v-if="pieceSrc"
          :src="pieceSrc"
          class="slider-piece"
          :style="{ top: pieceTop + 'px', left: pieceLeft + 'px' }"
          draggable="false"
          alt=""
      />
      <div class="slider-refresh" title="刷新验证码" @click="emit('refresh')">
        <el-icon><RefreshRight/></el-icon>
      </div>
      <div v-if="state === 'success'" class="slider-mask slider-mask-success">验证成功</div>
      <div v-if="state === 'fail'" class="slider-mask slider-mask-fail">验证失败，请重试</div>
    </div>
    <div ref="trackRef" class="slider-track" :class="'is-' + state">
      <div class="slider-track-fill" :style="{ width: handleLeft + handleSize / 2 + 'px' }"></div>
      <span v-show="handleLeft === 0 && state === 'idle'" class="slider-tip">拖动滑块完成拼图</span>
      <div
          class="slider-handle"
          :style="{ left: handleLeft + 'px', width: handleSize + 'px' }"
          @pointerdown="onPointerDown"
      >
        <el-icon v-if="state === 'success'"><Check/></el-icon>
        <el-icon v-else-if="state === 'fail'"><Close/></el-icon>
        <el-icon v-else><DArrowRight/></el-icon>
      </div>
    </div>
  </div>
</template>

<script setup>
import {Check, Close, DArrowRight, RefreshRight} from '@element-plus/icons-vue'

const emit = defineEmits(['verify', 'refresh'])

// 后端底图自然尺寸
const NATURAL_WIDTH = 320
const PIECE_SIZE = 58
const HANDLE_SIZE = 40

const panelRef = ref(null)
const trackRef = ref(null)
const bgSrc = ref('')
const pieceSrc = ref('')
const pieceY = ref(0)
const handleLeft = ref(0)
const state = ref('idle') // idle dragging verifying success fail
const handleSize = HANDLE_SIZE

let startX = 0
let startLeft = 0
let maxLeft = 0
let scale = 1

const pieceLeft = computed(() => handleLeft.value / maxTravel() * (NATURAL_WIDTH - PIECE_SIZE) * scale)
const pieceTop = computed(() => pieceY.value * scale)

function maxTravel() {
  const track = trackRef.value
  return track ? track.clientWidth - handleSize : 1
}

// 父组件获取验证码后注入滑块数据
function load(data) {
  bgSrc.value = 'data:image/jpg;base64,' + data.originalImageBase64
  pieceSrc.value = 'data:image/png;base64,' + data.sliderImageBase64
  pieceY.value = data.y || 0
  reset()
  nextTick(() => {
    const panel = panelRef.value
    scale = panel ? panel.clientWidth / NATURAL_WIDTH : 1
  })
}

function reset() {
  handleLeft.value = 0
  state.value = 'idle'
}

function onPointerDown(e) {
  if (state.value === 'success') return
  state.value = 'dragging'
  startX = e.clientX
  startLeft = handleLeft.value
  maxLeft = maxTravel()
  window.addEventListener('pointermove', onPointerMove)
  window.addEventListener('pointerup', onPointerUp)
}

function onPointerMove(e) {
  const left = startLeft + (e.clientX - startX)
  handleLeft.value = Math.min(Math.max(left, 0), maxLeft)
}

function onPointerUp() {
  window.removeEventListener('pointermove', onPointerMove)
  window.removeEventListener('pointerup', onPointerUp)
  if (state.value !== 'dragging') return
  if (handleLeft.value <= 0) {
    state.value = 'idle'
    return
  }
  // 换算为底图自然坐标 x 提交服务端校验，校验结果由父组件回调 success/fail
  const x = Math.round(handleLeft.value / maxTravel() * (NATURAL_WIDTH - PIECE_SIZE))
  state.value = 'verifying'
  emit('verify', x)
}

// 服务端确认验证码通过后由父组件调用：毛玻璃闪现
function success() {
  state.value = 'success'
}

// 服务端校验失败由父组件调用
function fail() {
  state.value = 'fail'
}

defineExpose({load, reset, success, fail})
</script>

<style lang="scss" scoped>
.slider-captcha {
  width: 100%;
  user-select: none;
}

.slider-panel {
  position: relative;
  width: 100%;
  overflow: hidden;
  border-radius: 4px;
  background: #e8eef5;

  .slider-bg {
    display: block;
    width: 100%;
    pointer-events: none;
  }

  .slider-piece {
    position: absolute;
    width: 18.125%; /* 58 / 320 */
    pointer-events: none;
  }

  .slider-refresh {
    position: absolute;
    top: 4px;
    right: 4px;
    width: 24px;
    height: 24px;
    line-height: 24px;
    text-align: center;
    color: #fff;
    background: rgba(0, 0, 0, 0.35);
    border-radius: 4px;
    cursor: pointer;
  }

  .slider-mask {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    color: #fff;
    pointer-events: none;
  }

  .slider-mask-success {
    // 毛玻璃闪现：模糊掩盖容差残差，闪一下后自动隐去
    background: rgba(255, 255, 255, 0.22);
    backdrop-filter: blur(8px) saturate(1.3);
    -webkit-backdrop-filter: blur(8px) saturate(1.3);
    text-shadow: 0 1px 4px rgba(0, 0, 0, 0.35);
    animation: mask-flash 0.9s ease forwards;
  }

  .slider-mask-fail {
    background: rgba(245, 108, 108, 0.45);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
  }
}

@keyframes mask-flash {
  0% { opacity: 0; }
  12% { opacity: 1; }
  65% { opacity: 1; }
  100% { opacity: 0; }
}

.slider-track {
  position: relative;
  height: 40px;
  margin-top: 8px;
  background: #f0f2f5;
  border: 1px solid #e4e7ed;
  border-radius: 4px;

  .slider-tip {
    position: absolute;
    inset: 0;
    line-height: 38px;
    text-align: center;
    font-size: 13px;
    color: #909399;
    pointer-events: none;
  }

  .slider-track-fill {
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    background: #d9ecff;
    border-radius: 4px 0 0 4px;
  }

  .slider-handle {
    position: absolute;
    top: -1px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border: 1px solid #e4e7ed;
    border-radius: 4px;
    color: #606266;
    cursor: grab;
    box-shadow: 0 0 4px rgba(0, 0, 0, 0.12);
    touch-action: none;
  }

  &.is-success {
    .slider-track-fill {
      background: #e1f3d8;
    }

    .slider-handle {
      color: #52c41a;
      border-color: #52c41a;
    }
  }

  &.is-fail {
    .slider-track-fill {
      background: #fde2e2;
    }

    .slider-handle {
      color: #f56c6c;
      border-color: #f56c6c;
    }
  }
}
</style>