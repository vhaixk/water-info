package com.hydrology;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 启动程序
 *
 * @author hydrology
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class HydrologyApplication {
    public static void main(String[] args) {
        // System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(HydrologyApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  水温监测系统启动成功   ლ(´ڡ`ლ)ﾞ");
    }
}
