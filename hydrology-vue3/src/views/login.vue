<template>
  <div class="login">
    <div class="login-decor">
      <span class="ring ring-1"></span>
      <span class="ring ring-2"></span>
      <span class="dots dots-1"></span>
      <span class="dots dots-2"></span>
      <span class="bubble b1"></span>
      <span class="bubble b2"></span>
      <span class="bubble b3"></span>
      <span class="bubble b4"></span>
      <span class="bubble b5"></span>
      <span class="bubble b6"></span>
      <svg class="wave wave-1" preserveAspectRatio="none" viewBox="0 0 1440 220">
        <path d="M0 120 C 240 60 480 180 720 120 C 960 60 1200 180 1440 120 L1440 220 L0 220 Z" fill="#ffffff"/>
      </svg>
      <svg class="wave wave-2" preserveAspectRatio="none" viewBox="0 0 1440 220">
        <path d="M0 150 C 260 90 520 200 780 140 C 1040 80 1240 190 1440 140 L1440 220 L0 220 Z" fill="#ffffff"/>
      </svg>
      <svg class="wave wave-3" preserveAspectRatio="none" viewBox="0 0 1440 220">
        <path d="M0 180 C 240 130 480 210 720 170 C 960 130 1200 210 1440 170 L1440 220 L0 220 Z" fill="#ffffff"/>
      </svg>
    </div>
    <div class="login-card">
      <div class="login-banner"></div>
      <svg aria-hidden="true" class="login-curve" preserveAspectRatio="none" viewBox="0 0 60 540">
        <path d="M60 0 Q -20 270 60 540 L60 540 L60 0 Z" fill="#ffffff"/>
      </svg>
      <div class="login-panel">
        <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
      <img :src="logo" class="login-logo" alt=""/>
      <h3 class="title">{{ title }}</h3>

      <!-- SSO 验证失败提示 -->
      <el-alert
          v-if="errorMsg"
          :closable="false"
          :title="errorMsg"
          show-icon
          style="margin-bottom: 20px;"
          type="error"
      />

      <el-form-item prop="username">
        <el-input
            v-model="loginForm.username"
            auto-complete="off"
            placeholder="账号"
            size="large"
            type="text"
        >
          <template #prefix>
            <svg-icon class="el-input__icon input-icon" icon-class="user"/>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
            v-model="loginForm.password"
            auto-complete="off"
            placeholder="密码"
            size="large"
            type="password"
            @keyup.enter="handleLogin"
        >
          <template #prefix>
            <svg-icon class="el-input__icon input-icon" icon-class="password"/>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item v-if="captchaEnabled && captchaType === 'image'" prop="code">
        <el-input
            v-model="loginForm.code"
            auto-complete="off"
            placeholder="验证码"
            size="large"
            style="width: 63%"
            @keyup.enter="handleLogin"
        >
          <template #prefix>
            <svg-icon class="el-input__icon input-icon" icon-class="validCode"/>
          </template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" class="login-code-img" @click="getCode"/>
        </div>
      </el-form-item>
      <el-form-item v-if="captchaEnabled && captchaType === 'slider'" prop="code">
        <SliderCaptcha ref="sliderRef" @verify="onSliderVerify" @refresh="getCode"/>
      </el-form-item>
      <el-checkbox v-if="false" v-model="loginForm.rememberMe" style="margin:0px 0px 25px 0px;">记住密码</el-checkbox>
      <el-form-item style="width:100%;">
        <el-button
            :loading="loading"
            size="large"
            style="width:100%;"
            type="primary"
            @click.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div v-if="register" style="float: right;">
          <router-link :to="'/register'" class="link-type">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
      </div>
    </div>
    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script setup>
import {getCodeImg, getSSOConfig, ssoLogin} from "@/api/login"
import SliderCaptcha from "@/components/SliderCaptcha/index.vue"
import logo from "@/assets/logo/logo.png"
import Cookies from "js-cookie"
import {encrypt, decrypt} from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'
import defaultSettings from '@/settings'
import {getToken, setToken} from '@/utils/auth'
import {isHttp, isEmpty} from "@/utils/validate"
import {ElMessage} from 'element-plus'
import usePermissionStore from "@/store/modules/permission.js";

const title = import.meta.env.VITE_APP_TITLE
const footerContent = defaultSettings.footerContent
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const {proxy} = getCurrentInstance()

const loginForm = ref({
  username: "",
  password: "",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{required: true, trigger: "blur", message: "请输入您的账号"}],
  password: [{required: true, trigger: "blur", message: "请输入您的密码"}],
  code: [{required: true, trigger: "change", message: "请输入验证码"}]
}

const codeUrl = ref("")
const loading = ref(false)
const captchaEnabled = ref(true)
const captchaType = ref("image")
const sliderRef = ref(null)
const register = ref(false)
const redirect = ref(undefined)

// SSO 状态
const ssoEnabled = ref(false)
const ssoConfig = ref({ssoUrl: '', localStoreKey: '', localLoginUrl: '', redirectUrl: '',logoutUrl:''})
const errorMsg = ref('')
const SSO_CONFIG_KEY = 'SSO_CONFIG'

watch(route, (newRoute) => {
  redirect.value = newRoute.query && newRoute.query.redirect
}, {immediate: true})

// 加载 SSO 配置
async function loadSSOConfig() {
  // 先读缓存作为兜底
  const cached = localStorage.getItem(SSO_CONFIG_KEY)
  if (cached) {
    try {
      ssoConfig.value = JSON.parse(cached)
      ssoEnabled.value = ssoConfig.value.enabled
    } catch (e) { /* ignore */ }
  }

  // 异步获取最新配置（失败则保持缓存值）
  try {
    const res = await getSSOConfig()
    if (res.code === 200 && res.data) {
      ssoConfig.value = res.data
      ssoEnabled.value = res.data.enabled
      localStorage.setItem(SSO_CONFIG_KEY, JSON.stringify(res.data))
    }
  } catch (e) {
    // API 失败，使用缓存的值继续
  }
}

// 验证 SSO token（URL 参数或 localStorage key）
function verifySSOToken(token) {
  loading.value = true
  errorMsg.value = ''
  return ssoLogin(token, ssoConfig.value.localLoginUrl).then(async res => {
    debugger
    if (res.code === 200 && res.data) {
      setToken(res.data.data)
       await userStore.getInfo()
      const accessRoutes = await usePermissionStore().generateRoutes()
      accessRoutes.forEach(route => {
        if (!isHttp(route.path)) {
          router.addRoute(route)
        }
      })
      return accessRoutes

    } else {
      errorMsg.value = res.msg || 'SSO 验证失败'
      throw new Error(res.msg || 'SSO 验证失败')
    }
  }).then(() => {
    router.replace('/')
  }).catch(err => {
    errorMsg.value = err.msg || 'SSO 验证失败'
    loading.value = false
    // 验证失败 → 跳回 SSO，让用户重新登录
    window.location.href = ssoConfig.value.redirectUrl
  })
}

// 跳转 SSO，带上当前页 URL
function redirectSSO() {
  const frontendUrl = window.location.origin + window.location.pathname
  // const separator = ssoConfig.value.ssoUrl.includes('?') ? '&' : '?'
  window.location.href = `${ssoConfig.value.redirectUrl}=${encodeURIComponent(frontendUrl)}`
}

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      submitLogin()
    } else if (captchaType.value === 'slider') {
      // 表单校验未过（如账号密码为空）：复位滑块避免卡在 verifying
      sliderRef.value && sliderRef.value.reset()
    }
  })
}

function submitLogin() {
  loading.value = true
  if (loginForm.value.rememberMe) {
    Cookies.set("username", loginForm.value.username, {expires: 30})
    Cookies.set("password", encrypt(loginForm.value.password), {expires: 30})
    Cookies.set("rememberMe", loginForm.value.rememberMe, {expires: 30})
  } else {
    Cookies.remove("username")
    Cookies.remove("password")
    Cookies.remove("rememberMe")
  }
  userStore.login(loginForm.value).then(() => {
    if (captchaType.value === 'slider') sliderRef.value && sliderRef.value.success()
    const query = route.query
    const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
      if (cur !== "redirect") acc[cur] = query[cur]
      return acc
    }, {})
    // 留出毛玻璃闪现时间再跳转
    setTimeout(() => {
      router.push({path: redirect.value || '/', query: otherQueryParams})
    }, captchaType.value === 'slider' ? 650 : 0)
  }).catch(err => {
    loading.value = false
    refreshCaptcha(err)
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    captchaType.value = res.captchaType === "slider" ? "slider" : "image"
    if (captchaEnabled.value) {
      loginForm.value.uuid = res.uuid
      if (captchaType.value === "slider") {
        nextTick(() => sliderRef.value && sliderRef.value.load(res))
      } else {
        codeUrl.value = "data:image/gif;base64," + res.img
      }
    }
  })
}

// 滑块松手：回填 x 坐标后提交登录，校验结果由 refreshCaptcha 路由
function onSliderVerify(x) {
  loginForm.value.code = String(x)
  handleLogin()
}

// 登录失败后按错误类型路由滑块状态并刷新验证码
function refreshCaptcha(err) {
  if (!captchaEnabled.value) return
  if (captchaType.value === 'slider') {
    const msg = (err && err.message) || ''
    // 账号密码类错误说明验证码已通过：毛玻璃闪现后换新拼图
    if (/密码|用户不存在/.test(msg)) {
      sliderRef.value && sliderRef.value.success()
      setTimeout(getCode, 950)
    } else {
      sliderRef.value && sliderRef.value.fail()
      setTimeout(getCode, 800)
    }
  } else {
    getCode()
  }
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

// 核心流程
function initLoginFlow() {
  loadSSOConfig().then(() => {
    if (ssoConfig.value.enabled) {
      const urlParams = new URLSearchParams(window.location.search)
      let urlToken = urlParams.get('token')

      // 如果没拿到，试试从 redirect 参数里提取
      if (!urlToken) {
        const redirectRaw = urlParams.get('redirect')
        if (redirectRaw) {
          // 从 /index?token=111 这种字符串里提取 token
          const match = redirectRaw.match(/token=([^&]+)/)
          if (match) urlToken = match[1]
        }
      }
      if (urlToken) {
        verifySSOToken(urlToken).then(() => {
          window.history.replaceState({}, '', '/login')
        })
        return
      }

      // 2. URL 没 token → 查 localStorage
      const storageKey = ssoConfig.value.localStoreKey
      if (storageKey) {
        const ssoToken = localStorage.getItem(storageKey)
        if (ssoToken) {
          verifySSOToken(ssoToken.replace('"','').replace('"',''))
          return
        }
      }

      // 3. 都没有 → 跳 SSO，带上当前页 URL
      redirectSSO()
    } else {
      // SSO 没开启 → 保持原样
      getCode()
      getCookie()
    }
  })
}

initLoginFlow()
</script>

<style lang='scss' scoped>
.login {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  overflow: hidden;
  background:
    radial-gradient(1200px 600px at 85% -10%, rgba(255, 255, 255, 0.16), transparent 60%),
    radial-gradient(900px 500px at -10% 110%, rgba(0, 229, 255, 0.22), transparent 60%),
    linear-gradient(135deg, #35b6f9 0%, #1667d9 60%, #0451be 100%);
}

.login-decor {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.ring {
  position: absolute;
  border: 1.5px solid rgba(255, 255, 255, 0.16);
  border-radius: 50%;
}

.ring-1 {
  width: 380px;
  height: 380px;
  top: -120px;
  right: -100px;
}

.ring-2 {
  width: 260px;
  height: 260px;
  bottom: -80px;
  left: -60px;
}

.dots {
  position: absolute;
  width: 220px;
  height: 160px;
  background-image: radial-gradient(rgba(255, 255, 255, 0.4) 1.5px, transparent 1.5px);
  background-size: 18px 18px;
  opacity: 0.35;
}

.dots-1 {
  top: 12%;
  left: 5%;
}

.dots-2 {
  bottom: 24%;
  right: 4%;
}

.bubble {
  position: absolute;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.35);
  background: radial-gradient(circle at 32% 30%, rgba(255, 255, 255, 0.35), rgba(255, 255, 255, 0.06) 65%);
}

.b1 { width: 26px; height: 26px; top: 20%; left: 12%; }
.b2 { width: 12px; height: 12px; top: 34%; left: 7%; }
.b3 { width: 34px; height: 34px; top: 14%; right: 10%; }
.b4 { width: 16px; height: 16px; top: 42%; right: 6%; }
.b5 { width: 18px; height: 18px; bottom: 28%; left: 16%; }
.b6 { width: 22px; height: 22px; bottom: 32%; right: 18%; }

.wave {
  position: absolute;
  left: -5%;
  bottom: 0;
  width: 110%;
  height: 220px;
}

.wave-1 {
  opacity: 0.08;
}

.wave-2 {
  opacity: 0.1;
  height: 180px;
}

.wave-3 {
  opacity: 0.14;
  height: 140px;
}

.login-card {
  position: relative;
  display: flex;
  width: 960px;
  max-width: 94vw;
  height: 540px;
  max-height: 86vh;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.25);
  z-index: 1;
  // 登录卡片固定浅色观感，避免系统暗黑模式把输入框染黑
  --el-fill-color-blank: #ffffff;
  --el-bg-color: #ffffff;
  --el-bg-color-overlay: #ffffff;
  --el-text-color-regular: #606266;
  --el-text-color-primary: #303133;
  --el-text-color-placeholder: #a8abb2;
  --el-border-color: #dcdfe6;
  --el-border-color-light: #e4e7ed;
  --el-border-color-lighter: #ebeef5;
  --el-input-bg-color: #ffffff;
  --el-input-border-color: #dcdfe6;
  --el-input-text-color: #606266;
  --el-input-placeholder-color: #a8abb2;
  --el-input-icon-color: #a8abb2;
}

.login-banner {
  flex: 1;
  background: #6f86f2 url("../assets/images/login-banner.jpg") center / cover no-repeat;
}

.login-panel {
  position: relative;
  display: flex;
  flex-direction: column;
  width: 400px;
  padding: 20px 30px 10px 30px;
  background: #ffffff;
  overflow: hidden;
}

.login-curve {
  position: absolute;
  top: 0;
  right: 400px;
  width: 60px;
  height: 100%;
  pointer-events: none;
}

.title {
  margin: 0px auto 14px auto;
  text-align: center;
  color: #333333;
  font-size: 20px;
}

.login-logo {
  display: block;
  width: 44px;
  height: 44px;
  margin: 0 auto 6px auto;
}

.login-form {
  width: 100%;
  margin: auto 0;

  .el-form-item {
    margin-bottom: 14px;
  }

  .el-input {
    height: 40px;

    input {
      height: 40px;
    }
  }

  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
  }
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 33%;
  height: 40px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: rgba(255, 255, 255, 0.85);
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}

.login-code-img {
  height: 40px;
  padding-left: 12px;
}

@media (max-width: 900px) {
  .login-banner,
  .login-curve {
    display: none;
  }

  .login-card {
    width: 400px;
  }

  .login-panel {
    width: 100%;
  }
}
</style>
