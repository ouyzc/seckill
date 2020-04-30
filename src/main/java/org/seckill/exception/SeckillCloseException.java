package org.seckill.exception;

/**
 * @ClassName SeckillCloseException
 * @Description 秒杀关闭异常
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:52
 * @Version 1.0
 */
public class SeckillCloseException extends SeckillException {

    public SeckillCloseException(String message) {
        super(message);
    }

    public SeckillCloseException(String message, Throwable cause) {
        super(message, cause);
    }
}
