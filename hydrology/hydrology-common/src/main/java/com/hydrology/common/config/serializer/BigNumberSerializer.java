package com.hydrology.common.config.serializer;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.NumberSerializer;

import java.io.IOException;

public class BigNumberSerializer extends NumberSerializer {

    // JavaScript 的最大安全整数
    private static final long MAX_SAFE_INTEGER = 9007199254740991L;
    private static final long MIN_SAFE_INTEGER = -9007199254740991L;

    public static final BigNumberSerializer INSTANCE = new BigNumberSerializer(Number.class);

    public BigNumberSerializer(Class<? extends Number> rawType) {
        super(rawType);
    }

    @Override
    public void serialize(Number value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        // 核心逻辑：如果超出安全范围，转为字符串；否则保持数字
        if (value.longValue() > MAX_SAFE_INTEGER || value.longValue() < MIN_SAFE_INTEGER) {
            gen.writeString(value.toString());
        } else {
            super.serialize(value, gen, serializers);
        }
    }
}