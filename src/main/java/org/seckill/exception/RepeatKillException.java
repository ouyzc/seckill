package org.seckill.exception;

/**
 * @ClassName RepeatKillException
 * @Description 重复秒杀异常（运行期异常）
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:49
 * @Version 1.0
 */
public class RepeatKillException extends SeckillException {

    // 使用快捷键生成两个构造方法
    public RepeatKillException(String message) {
        super(message);
    }

    public RepeatKillException(String message, Throwable cause) {
        super(message, cause);
    }
}
