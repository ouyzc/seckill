-- 秒杀执行存储过程
DELIMITER $$ -- console ; 转换为 $$  使用console执行sql时需要转换
-- 定义存储过程
-- 参数：in 输入参数 out 输出参数
-- ROW_COUNT():返回上一条修改类型sql(DELETE,INSERT,UPDATE)的影响行数
-- ROW_COUNT(): 0:未修改数据; >0:表示修改的行数 <0:sql错误/未执行修改sql
CREATE PROCEDURE `seckill`.`execute_seckill`
(IN v_seckill_id BIGINT, IN v_phone BIGINT,IN v_kill_time TIMESTAMP, OUT r_result INT)
BEGIN
    DECLARE insert_count INT DEFAULT 0;
    START TRANSACTION;
    INSERT IGNORE INTO success_killed(seckill_id, user_phone, create_time)
    VALUES (v_seckill_id, v_phone, v_kill_time);
    SELECT ROW_COUNT() INTO insert_count;
    IF(insert_count = 0) THEN
        ROLLBACK;
        SET r_result = -1;
    ELSEIF(insert_count < 0) THEN
        ROLLBACK;
        SET r_result = -2;
    ELSE
        UPDATE seckill SET number = number - 1
        WHERE seckill_id=v_seckill_id
          AND end_time > v_kill_time
          AND start_time < v_kill_time
          AND number > 0;
        SELECT ROW_COUNT() INTO insert_count;
        IF (insert_count = 0) THEN
            ROLLBACK;
            SET r_result = 0;
        ELSEIF (insert_count < 0) THEN
            ROLLBACK;
            SET r_result = -2;
        ELSE
            COMMIT;
            SET r_result = 1;
        END IF;
    END IF;
END;
-- 储存过程定义结束
-- 查询存储过程
show PROCEDURE status where db='seckill'
-- 调用存储过程
set @r_result=-3;
CALL execute_seckill(1000,13567653456,NOW(),@r_result);
SELECT @r_result;
