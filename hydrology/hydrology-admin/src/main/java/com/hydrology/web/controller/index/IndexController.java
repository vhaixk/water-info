package com.hydrology.web.controller.index;

import cn.hutool.core.io.FileUtil;
import com.hydrology.common.config.SystemConfig;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class IndexController {


    @GetMapping(value = {"/", "/index", "/index/"})
    public String index() {
        return "index";
    }

    @RequestMapping("profile/**")
    public void profile(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String requestURI = request.getRequestURI();
        String decodedURI = URLDecoder.decode(requestURI, StandardCharsets.UTF_8.name());

        String realPath = SystemConfig.getRealPath(decodedURI);
        try {
            if (FileUtil.exist(realPath)) {
                Path path = Paths.get(realPath);

                java.nio.file.attribute.BasicFileAttributes attrs = Files.readAttributes(path, java.nio.file.attribute.BasicFileAttributes.class);
                long lastModified = attrs.lastModifiedTime().toMillis();
                long fileSize = attrs.size();

                String eTag = String.format("\"%x-%x\"", lastModified, fileSize);

                response.setHeader("Cache-Control", "public, max-age=3600, must-revalidate");
                response.setHeader("ETag", eTag);

                String mimeType = Files.probeContentType(path);
                if (mimeType == null) {
                    mimeType = "application/octet-stream"; // 兜底默认值
                }
                response.setContentType(mimeType);
                // 显式 Content-Length：避免 chunked 传输导致前端下载进度无法计算百分比
                response.setContentLengthLong(fileSize);

                // 5. 流式输出文件内容
                Files.copy(path, response.getOutputStream());
                response.flushBuffer();
                return;
            }

            // 文件不存在：返回错误信息
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/plain;charset=UTF-8");
            PrintWriter writer = response.getWriter();
            writer.print("文件不存在");
            writer.flush();

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}
