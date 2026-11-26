package com.hydrology.web.controller.common;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Area;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FastByteArrayOutputStream;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.google.code.kaptcha.Producer;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.CacheConstants;
import com.hydrology.common.constant.Constants;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.sign.Base64;
import com.hydrology.common.utils.uuid.IdUtils;
import com.hydrology.system.service.ISysConfigService;

/**
 * 验证码操作处理
 * 
 * @author hydrology
 */
@RestController
public class CaptchaController
{
    /** 滑块底图宽 */
    private static final int SLIDER_WIDTH = 320;

    /** 滑块底图高 */
    private static final int SLIDER_HEIGHT = 160;

    /** 拼图块边长 */
    private static final int SLIDER_PIECE = 50;

    /** 拼图块凸起半径 */
    private static final int SLIDER_KNOB = 8;

    /** 滑块底图资源（随机轮换） */
    private static final String[] SLIDER_BACKGROUNDS = {"captcha/bg1.jpg", "captcha/bg2.jpg", "captcha/bg3.jpg", "captcha/bg4.jpg"};

    @Resource(name = "captchaProducer")
    private Producer captchaProducer;

    @Resource(name = "captchaProducerMath")
    private Producer captchaProducerMath;

    @Autowired
    private RedisCache redisCache;
    
    @Autowired
    private ISysConfigService configService;
    /**
     * 生成验证码
     */
    @GetMapping("/captchaImage")
    public AjaxResult getCode(HttpServletResponse response) throws IOException
    {
        AjaxResult ajax = AjaxResult.success();
        boolean captchaEnabled = configService.selectCaptchaEnabled();
        ajax.put("captchaEnabled", captchaEnabled);
        String captchaMode = SystemConfig.getCaptchaMode();
        ajax.put("captchaType", "slider".equals(captchaMode) ? "slider" : "image");
        if (!captchaEnabled)
        {
            return ajax;
        }

        // 保存验证码信息
        String uuid = IdUtils.simpleUUID();
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + uuid;

        // 滑块验证码模式
        if ("slider".equals(captchaMode))
        {
            return getSliderCode(ajax, uuid, verifyKey);
        }

        String capStr = null, code = null;
        BufferedImage image = null;

        // 生成验证码
        String captchaType = SystemConfig.getCaptchaType();
        if ("math".equals(captchaType))
        {
            String capText = captchaProducerMath.createText();
            capStr = capText.substring(0, capText.lastIndexOf("@"));
            code = capText.substring(capText.lastIndexOf("@") + 1);
            image = captchaProducerMath.createImage(capStr);
        }
        else if ("char".equals(captchaType))
        {
            capStr = code = captchaProducer.createText();
            image = captchaProducer.createImage(capStr);
        }

        redisCache.setCacheObject(verifyKey, code, Constants.CAPTCHA_EXPIRATION, TimeUnit.MINUTES);
        // 转换流信息写出
        FastByteArrayOutputStream os = new FastByteArrayOutputStream();
        try
        {
            ImageIO.write(image, "jpg", os);
        }
        catch (IOException e)
        {
            return AjaxResult.error(e.getMessage());
        }

        ajax.put("uuid", uuid);
        ajax.put("img", Base64.encode(os.toByteArray()));
        return ajax;
    }

    /**
     * 生成滑块验证码：底图抠出拼图缺口，返回底图/滑块块 base64 与 y 坐标，目标 x 存 Redis
     */
    private AjaxResult getSliderCode(AjaxResult ajax, String uuid, String verifyKey) throws IOException
    {
        BufferedImage bg;
        String bgPath = SLIDER_BACKGROUNDS[ThreadLocalRandom.current().nextInt(SLIDER_BACKGROUNDS.length)];
        try (InputStream in = new ClassPathResource(bgPath).getInputStream())
        {
            bg = ImageIO.read(in);
        }
        int pieceSize = SLIDER_PIECE + SLIDER_KNOB;
        int x = ThreadLocalRandom.current().nextInt(SLIDER_PIECE, SLIDER_WIDTH - pieceSize - 5);
        int y = ThreadLocalRandom.current().nextInt(SLIDER_KNOB + 2, SLIDER_HEIGHT - SLIDER_PIECE - 2);
        Area area = buildPieceArea(x, y);

        // 底图：缩放背景 + 白色半透明缺口
        BufferedImage original = new BufferedImage(SLIDER_WIDTH, SLIDER_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = original.createGraphics();
        g.drawImage(bg, 0, 0, SLIDER_WIDTH, SLIDER_HEIGHT, null);
        g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.75f));
        g.setColor(Color.WHITE);
        g.fill(area);
        g.setComposite(AlphaComposite.SrcOver);
        g.setStroke(new BasicStroke(1.5f));
        g.draw(area);
        g.dispose();

        // 滑块块：透明底 + 拼图形状裁剪背景
        BufferedImage slider = new BufferedImage(pieceSize, pieceSize, BufferedImage.TYPE_INT_ARGB);
        Graphics2D sg = slider.createGraphics();
        sg.translate(-x, -(y - SLIDER_KNOB));
        sg.setClip(area);
        sg.drawImage(bg, 0, 0, SLIDER_WIDTH, SLIDER_HEIGHT, null);
        sg.setClip(null);
        sg.setColor(Color.WHITE);
        sg.setStroke(new BasicStroke(1.5f));
        sg.draw(area);
        sg.dispose();

        redisCache.setCacheObject(verifyKey, String.valueOf(x), Constants.CAPTCHA_EXPIRATION, TimeUnit.MINUTES);
        ajax.put("uuid", uuid);
        ajax.put("y", y - SLIDER_KNOB);
        ajax.put("originalImageBase64", Base64.encode(toBytes(original, "jpg")));
        ajax.put("sliderImageBase64", Base64.encode(toBytes(slider, "png")));
        return ajax;
    }

    /**
     * 拼图形状：方块 + 上/右两个凸起
     */
    private Area buildPieceArea(int x, int y)
    {
        Area area = new Area(new Rectangle2D.Double(x, y, SLIDER_PIECE, SLIDER_PIECE));
        area.add(new Area(new Ellipse2D.Double(x + SLIDER_PIECE / 2.0 - SLIDER_KNOB, y - SLIDER_KNOB, SLIDER_KNOB * 2, SLIDER_KNOB * 2)));
        area.add(new Area(new Ellipse2D.Double(x + SLIDER_PIECE - SLIDER_KNOB, y + SLIDER_PIECE / 2.0 - SLIDER_KNOB, SLIDER_KNOB * 2, SLIDER_KNOB * 2)));
        return area;
    }

    private byte[] toBytes(BufferedImage image, String format) throws IOException
    {
        FastByteArrayOutputStream os = new FastByteArrayOutputStream();
        ImageIO.write(image, format, os);
        return os.toByteArray();
    }
}
