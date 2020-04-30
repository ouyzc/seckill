package org.seckill.exception;

/**
 * @ClassName SeckillException
 * @Description 秒杀相关业务异常
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:54
 * @Version 1.0
 */
public class SeckillException extends RuntimeException {

    public SeckillException(String message) {
        super(message);
    }

    public SeckillException(String message, Throwable cause) {
        super(message, cause);
    }
}
