package com.hydrology.controller;

import com.hydrology.common.annotation.Log;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.service.SSOLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("sso")
public class SSOLoginController {


    @Autowired
    SSOLoginService ssoLoginService;

    @Log(title = "获取sso配置")
    @PostMapping("getConfig")
    public AjaxResult getConfig() {
        return AjaxResult.success(this.ssoLoginService.getConfig());
    }
}