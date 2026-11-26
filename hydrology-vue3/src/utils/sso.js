import request from '@/utils/request'

const SSO_CONFIG_KEY = 'SSO_CONFIG'

/**
 * 获取 SSO 配置（优先读缓存，失败再请求 API）
 */
export async function getSSOConfig() {
    const cached = localStorage.getItem(SSO_CONFIG_KEY)
    if (cached) {
        try {
            return JSON.parse(cached)
        } catch {
            /* ignore */
        }
    }
    try {
        const res = await request({
            url: '/sso/getConfig',
            method: 'post'
        })
        if (res.code === 200 && res.data) {
            localStorage.setItem(SSO_CONFIG_KEY, JSON.stringify(res.data))
            return res.data
        }
    } catch {
        /* ignore */
    }
    return null
}

/**
 * 执行 SSO 登出（仅当 SSO 开启时）
 * - GET logoutUrl，参数 token=localStoreToken（从 localStorage 读取）
 * - 成功后跳转到 ssoUrl
 * - 返回 true 表示走了 SSO 登出，false 表示 SSO 未开启
 */
export async function ssoLogout() {
    const config = await getSSOConfig()
    if (!config || !config.enabled) {
        return false
    }

    const localStoreKey = config.localStoreKey
    if (localStoreKey) {
        const localToken = localStorage.getItem(localStoreKey)
        if (localToken) {
            try {
                await request({
                    url: config.logoutUrl,
                    method: 'get',
                    params: {token: localToken.replace('"', '').replace('"', '')},
                    headers: {isToken: false}
                })
            } catch {
                /* ignore logout request error */
            }
        }
    }

    if (config.ssoUrl) {
        window.location.href = config.ssoUrl
    }
    return true
}
