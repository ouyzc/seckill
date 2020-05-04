-- 数据库初始化脚本
-- 创建数据库
CREATE DATABASE seckill;
-- 使用数据库
USE seckill;
-- 创建秒杀库存表
CREATE TABLE seckill
(
    `seckill_id`  BIGINT       NOT NULL AUTO_INCREMENT COMMENT '商品库存ID',
    `name`        VARCHAR(120) NOT NULL COMMENT '商品名称',
    `number`      INT          NOT NULL COMMENT '库存数量',
    `start_time`  TIMESTAMP    NOT NULL COMMENT '秒杀开启时间',
    `end_time`    TIMESTAMP    NOT NULL COMMENT '秒杀结束时间',
    `create_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (seckill_id),
    KEY idx_start_time (start_time),
    KEY idx_end_time (end_time),
    KEY idx_create_time (create_time)
) ENGINE = INNODB
  AUTO_INCREMENT = 1000
  DEFAULT CHARSET = utf8 COMMENT ='秒杀库存表';
-- 初始化数据
INSERT INTO seckill(name, number, start_time, end_time)
VALUES ('1000元秒杀iphone 11', 100, '2020-04-25 00:00:00', '2020-04-26 00:00:00'),
       ('500元秒杀ipad pro', 200, '2020-04-25 00:00:00', '2020-04-26 00:00:00'),
       ('200元秒杀ps4', 300, '2020-04-25 00:00:00', '2020-04-26 00:00:00'),
       ('100元秒杀readmi note8 pro', 500, '2020-04-25 00:00:00', '2020-04-26 00:00:00');
-- 创建秒杀成功明细表
CREATE TABLE success_killed
(
    `seckill_id`  BIGINT    NOT NULL COMMENT '秒杀商品ID',
    `user_phone`  BIGINT    NOT NULL COMMENT '用户手机号',
    `state`       TINYINT   NOT NULL DEFAULT 0 COMMENT '状态标识：-1:无效 0:成功 1:已付款',
    `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (seckill_id, user_phone),/* 联合主键 */
    KEY idx_create_time (create_time)
) ENGINE = INNODB
  AUTO_INCREMENT = 1000
  DEFAULT CHARSET = utf8 COMMENT ='秒杀成功明细表';