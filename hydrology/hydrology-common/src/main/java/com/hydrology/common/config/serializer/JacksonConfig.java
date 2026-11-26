package com.hydrology.common.config.serializer;

import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigInteger;

@Configuration
public class JacksonConfig {
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer customizer() {
        return builder -> {
            // 使用智能序列化器，而不是强制转 String 的 ToStringSerializer
            builder.serializerByType(Long.class, BigNumberSerializer.INSTANCE);
            builder.serializerByType(Long.TYPE, BigNumberSerializer.INSTANCE);
            // 如果有 BigInteger 也建议加上
            builder.serializerByType(BigInteger.class, BigNumberSerializer.INSTANCE);
        };
    }
}