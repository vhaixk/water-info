package com.hydrology.service;

import cn.hutool.db.Entity;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SSOLoginService {


    @Value("${sso.enabled}")
    private Boolean enabled;
    @Value("${sso.ssoUrl}")
    private String ssoUrl;
    @Value("${sso.localStoreKey}")
    private String localStoreKey;
    @Value("${sso.localLoginUrl}")
    private String localLoginUrl;
    @Value("${sso.redirectUrl}")
    private String redirectUrl;
    @Value("${sso.logoutUrl}")
    private String logoutUrl;

    public Entity getConfig() {
        return Entity.create()
                .set("enabled", this.enabled)
                .set("ssoUrl", this.ssoUrl)
                .set("localStoreKey", this.localStoreKey)
                .set("redirectUrl", this.redirectUrl)
                .set("logoutUrl", this.logoutUrl)
                .set("localLoginUrl", this.localLoginUrl);
    }

}