#### 1. 创建一个maven web项目

创建项目目录，结构如下

![Java项目目录结构](/Volumes/D/Java/seckill/image/Java项目目录结构.png)

将web.xml版本更改为3.1

```xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1"
         metadata-complete="true">
  <!--修改servlet版本为3.1-->

</web-app>
```

#### 2. 导入坐标

```xml
<dependencies>
    <!--使用junit4 测试依赖-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>

    <!--日志 Java日志：slf4j,log4j,logback,common-logging
        slf4j是规范/接口
        日志实现：log4j,logback,common-logging
        使用：slf4j+logback
    -->
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>1.7.12</version>
    </dependency>
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-core</artifactId>
      <version>1.1.1</version>
    </dependency>
    <!--实现slf4j接口并整合-->
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>1.1.1</version>
    </dependency>

    <!--数据库相关依赖-->
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.15</version>
    </dependency>
    <dependency>
      <groupId>c3p0</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.1.2</version>
    </dependency>

    <!--DAO框架：Mybatis依赖-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.5.4</version>
    </dependency>
    <!--mybatis自身实现的Spring依赖整合-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>2.0.4</version>
    </dependency>

    <!--Servlet web相关依赖-->
    <dependency>
      <groupId>taglibs</groupId>
      <artifactId>standard</artifactId>
      <version>1.1.2</version>
    </dependency>
    <dependency>
      <groupId>jstl</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.9.5</version>
    </dependency>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>3.1.0</version>
    </dependency>

    <!--spring依赖-->
    <!--1.spring核心依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-beans</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <!--2.spring dao层依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-tx</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <!--3.spring web相关依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>

    <!--spring test相关依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-test</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>

  </dependencies>
```

#### 3. 设计数据库

```sql
-- 数据库初始化脚本
-- 创建数据库
CREATE DATABASE seckill;
-- 使用数据库
USE seckill;
-- 创建秒杀库存表
CREATE TABLE seckill(
`seckill_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品库存ID',
`name` VARCHAR(120) NOT NULL COMMENT '商品名称',
`number` INT NOT NULL COMMENT '库存数量',
`start_time` TIMESTAMP NOT NULL COMMENT '秒杀开启时间',
`end_time` TIMESTAMP NOT NULL COMMENT '秒杀结束时间',
`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
PRIMARY KEY (seckill_id),
KEY idx_start_time(start_time),
KEY idx_end_time(end_time),
KEY idx_create_time(create_time)
)ENGINE=INNODB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8 COMMENT='秒杀库存表';
-- 初始化数据
INSERT INTO seckill(name,number,start_time,end_time)
VALUES('1000元秒杀iphone 11',100,'2020-04-25 00:00:00','2020-04-26 00:00:00'),
			('500元秒杀ipad pro',200,'2020-04-25 00:00:00','2020-04-26 00:00:00'),
			('200元秒杀ps4',300,'2020-04-25 00:00:00','2020-04-26 00:00:00'),
			('100元秒杀readmi note8 pro',500,'2020-04-25 00:00:00','2020-04-26 00:00:00');
-- 创建秒杀成功明细表
CREATE TABLE success_killed(
`seckill_id` BIGINT NOT NULL COMMENT '秒杀商品ID',
`user_phone` BIGINT NOT NULL COMMENT '用户手机号',
`state` TINYINT NOT NULL DEFAULT 0 COMMENT '状态标识：-1:无效 0:成功 1:已付款',
`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
PRIMARY KEY(seckill_id,user_phone),/* 联合主键 */
KEY idx_create_time(create_time)
)ENGINE=INNODB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8 COMMENT='秒杀成功明细表';
```

#### idea类模版注释设置

File-->settings-->Editor-->File and Code Templates-->Includes

选择File Header，输入

```java
/**
    *@ClassName ${NAME}
    *@Description TODO
    *@Author ${USER}
    *@Date ${DATE} ${TIME}
    *@Version 1.0
    */
```

#### 4. 创建实体类

```java
package org.seckill.entity;

import java.util.Date;

/**
 * @ClassName Seckill
 * @Description 秒杀库存
 * @Author ouyangzicheng
 * @Date 2020/4/25 下午3:45
 * @Version 1.0
 */
public class Seckill {

    private long seckillId;

    private String name;

    private int number;

    private Date startTime;

    private Date endTime;

    private Date createTime;

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Seckill{" +
                "seckillId=" + seckillId +
                ", name='" + name + '\'' +
                ", number=" + number +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", createTime=" + createTime +
                '}';
    }
}
```

``` java
package org.seckill.entity;

import java.util.Date;

/**
 * @ClassName SuccessKilled
 * @Description 秒杀成功明细
 * @Author ouyangzicheng
 * @Date 2020/4/25 下午3:58
 * @Version 1.0
 */
public class SuccessKilled {

    private long seckillId;

    private long userPhone;

    private short state;

    private Date createTime;

    // 多对一
    private Seckill seckill;

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public long getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(long userPhone) {
        this.userPhone = userPhone;
    }

    public short getState() {
        return state;
    }

    public void setState(short state) {
        this.state = state;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Seckill getSeckill() {
        return seckill;
    }

    public void setSeckill(Seckill seckill) {
        this.seckill = seckill;
    }

    @Override
    public String toString() {
        return "SuccessKilled{" +
                "seckillId=" + seckillId +
                ", userPhone=" + userPhone +
                ", state=" + state +
                ", createTime=" + createTime +
                '}';
    }
}
```

#### 5. 创建DAO接口

```java
package org.seckill.dao;

import org.seckill.entity.Seckill;

import java.util.Date;
import java.util.List;

/**
 * @ClassName SeckillDao
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/25 下午4:02
 * @Version 1.0
 */
public interface SeckillDao {

    /**
     * 减库存
     * @param seckillId
     * @param killTime
     * @return 如果影响行数>1，表示更新的记录行数
     */
    int reduceNumber(@Param("seckillId") long seckillId, @Param("killTime") Date killTime);

    /**
     * 根据ID查询秒杀对象
     * @param seckillId
     * @return
     */
    Seckill queryById(long seckillId);

    /**
     * 根据偏移量查询秒杀商品列表
     * @param offet
     * @param limit
     * @return
     */
    List<Seckill> queryAll(@Param("offset") int offset, @Param("limit") int limit);

}
```

```java
package org.seckill.dao;

import org.seckill.entity.SuccessKilled;

/**
 * @ClassName SuccessKilledDao
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/25 下午4:05
 * @Version 1.0
 */
public interface SuccessKilledDao {

    /**
     * 插入购买明细，可过滤重复
     * @param seckillId
     * @param userPhone
     * @return 插入的行数
     */
    int insertSuccessKilled(@Param("seckillId") long seckillId, @Param("userPhone") long userPhone);

        /**
     * 根据ID和用户手机号查询SuccessKilled并携带秒杀产品对象实体
     * @param seckillId
     * @param userPhone
     * @return
     */
    SuccessKilled queryByIdWithSeckill(@Param("seckillId") long seckillId, @Param("userPhone") long userPhone);

}
```

#### 6. 配置mybatis

在resources中创建mybatis-config.xml，再创建一个mapper包用来存放sql映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--配置全局属性-->
    <settings>
        <!--使用jdbc的getGeneratedKeys 获取数据库自增主键值
        在插入数据时不插入ID，通过自增赋值
        查询时就可以通过jdbc的getGeneratedKeys方法获取自增的主键值-->
        <setting name="useGeneratedKeys" value="true"/>
        <!--使用类别名替换列名 默认：True
        当实体当属性名跟数据库当列名不一致时，需要用别名来匹配-->
        <setting name="useColumnLabel" value="true"/>
        <!--开启驼峰命名转换：Table(create_time) -> Entity(createTime)-->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
</configuration>
```

创建SeckillDao接口的sql映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.seckill.dao.SeckillDao">
    <!--目的：为DAO接口方法提供sql语句配置
    xml中<=号有冲突 需要用<![CDATA[ <= ]]>包括起来
    -->
    <update id="reduceNumber">
        update
         seckill
        set
         number = number - 1
        where seckill_id = #{seckillId}
        and start_time <![CDATA[ <= ]]> #{killTime}
        and end_time >= #{killTime}
        and number > 0;
    </update>

    <select id="queryById" resultType="Seckill" parameterType="long">
        select * from where seckill_id = #{seckillId}
    </select>

    <select id="queryAll" resultType="Seckill">
        select * from seckill order by create_time desc
        limit #{offset},#{limit}
    </select>

</mapper>
```

创建SuccessKilledDao接口的sql映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.seckill.dao.SuccessKilledDao">
    <!--主键冲突，报错 添加ignore后，当主键有冲突不会报错而是返回0-->
    <insert id="insertSuccessKilled">
        insert ignore into success_killed(seckill_id,user_phone)
        values(#{seckillId},#{userPhone})
    </insert>

    <!--根据ID查询SuccessKilled并携带秒杀产品对象实体-->
    <!--如何告诉mybatis把结果映射到SuccessKilled同时映射seckill属性
    使用别名告诉mybatis对应数据库哪个字段 as可以省略
    -->
    <select id="queryByIdWithSeckill" resultType="SuccessKilled">
        select
            sk.seckill_id,
            sk.user_phone,
            sk.create_time,
            sk.state,
            s.seckill_id "seckill.seckill_id",
            s.name "seckill.name",
            s.number "seckill.number",
            s.start_time "seckill.start_time",
            s.end_time "seckill.end_time",
            s.create_time "seckill.create_time"
        from success_killed sk
        inner join seckill s on sk.seckill_id = s.seckill_id
        where sk.seckill_id = #{seckillId} and sk.user_phone=#{userPhone}
    </select>
</mapper>
```

#### 7. mybatis整合spring

打开[网址](https://docs.spring.io/spring/docs/5.2.1.RELEASE/spring-framework-reference/index.html)可以查看你使用的Spring版本的官方文档,我这是5.2.1版本

##### 创建jdbc.properties

```xml
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/seckill?serverTimezone=GMT&characterEncoding=utf-8&useSSL=false
username=root
password=12345678
```

创建spring包，包下创建spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">
    <!--配置整合mybatis过程-->
    <!--1：配置数据库相关参数properties的属性：${url}-->
    <context:property-placeholder location="classpath:jdbc.properties"/>
    <!--2：数据库连接池-->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <!--配置连接池属性-->
        <property name="driverClass" value="${driver}"/>
        <property name="jdbcUrl" value="${url}"/>
        <property name="user" value="${username}"/>
        <property name="password" value="${password}"/>

        <!--c3p0连接池的私有属性-->
        <!--连接池保留的最大连接数，默认15-->
        <property name="maxPoolSize" value="30"/>
        <!--连接池保留的最小连接数，默认3-->
        <property name="minPoolSize" value="10"/>
        <!--关闭连接时，是否提交未提交的事务，默认为false，即关闭连接，回滚为提交事务-->
        <property name="autoCommitOnClose" value="false"/>
        <!-- 当连接池连接耗尽时，客户端调用getConnection()后等待获取新连接的时间，
            超时后将抛出SQLException，如设为0则无限期等待。单位毫秒。默认: 0 -->
        <property name="checkoutTimeout" value="3000"/>
        <!--定义在从数据库获取新连接失败后重复尝试的次数。默认值: 30 ；小于等于0表示无限次-->
        <property name="acquireRetryAttempts" value="0"/>
    </bean>

    <!--3：配置SqlSessionFactory对象-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--注入数据库连接池-->
        <property name="dataSource" ref="dataSource"/>
        <!--配置mybatis全局配置文件-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <!--扫描entity包 使用别名 有多个包时用;分割开-->
        <property name="typeAliasesPackage" value="org.seckill.entity"/>
        <!--扫描sql配置文件：mapper需要的xml文件-->
        <property name="mapperLocations" value="classpath:mapper/*.xml"/>
    </bean>

    <!--4：配置扫描Dao接口包，动态实现Dao接口，注入到Spring容器中-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!--注入sqlSessionFactory-->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        <!--扫描Dao接口包-->
        <property name="basePackage" value="org.seckill.dao"/>
    </bean>
</beans>
```

##### 使用junit4进行测试

选中需要测试接口类名，按<kbd>Ctrl</kbd>+<kbd>enter</kbd>快捷键 -> Test -> junit4 -> 勾选需要测试的方法

会在test包下自动生成测试类

###### 对SeckillDao接口的方法进行测试

```java
package org.seckill.dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.entity.Seckill;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import java.util.Date;
import java.util.List;

import static org.junit.Assert.*;

/**
 * 配置spring和junit整合，junit启动时加载springIOC容器
 *  spring-test，junit
 */
@RunWith(SpringJUnit4ClassRunner.class)
// 告诉junit spring配置文件
@ContextConfiguration({"classpath:spring/spring-dao.xml"})
public class SeckillDaoTest {

    // 注入Dao实现类依赖
    @Resource
    private SeckillDao seckillDao;

    @Test
    public void reduceNumber() {
        Date killTime = new Date();
        // 数字为什么要加L，因为java默认是int类型，如果你想要一个长整型（long）就要在后面加L区分
        int updateCount = seckillDao.reduceNumber(1000L, killTime);
        System.out.println(updateCount);
    }

    @Test
    public void queryById() {
        long id = 1000;
        Seckill seckill = seckillDao.queryById(id);
        System.out.println(seckill.getName());
        System.out.println(seckill);
    }

    @Test
    public void queryAll() {
        // java没有保存行参的记录，当有多个参数当时候需要使用 @Param 来指定值
        // select * from seckill order by create_time desc limit #{offset},#{limit}
        // List<Seckill> queryAll(@Param("offset") int offset, @Param("limit") int limit);
        List<Seckill> seckills = seckillDao.queryAll(0, 100);
        for(Seckill seckill : seckills){
            System.out.println(seckill);
        }
    }
}
```

###### 对SuccessKilledDao接口的方法进行测试

```java
package org.seckill.dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.entity.SuccessKilled;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import static org.junit.Assert.*;

/**
 * @ClassName SuccessKilledDaoTest
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/25 下午10:48
 * @Version 1.0
 */
@RunWith(SpringJUnit4ClassRunner.class)
// 告诉junit spring配置文件
@ContextConfiguration({"classpath:spring/spring-dao.xml"})
public class SuccessKilledDaoTest {

    @Resource
    private SuccessKilledDao successKilledDao;

    @Test
    public void insertSuccessKilled() {
        // 第一次执行结果为1
        // 第二次执行结果为0 原因是因为同一个用户只能抢购一件商品
        long id = 1000L;
        long phone = 12767876548L;
        int insertCount = successKilledDao.insertSuccessKilled(id, phone);
        System.out.println(insertCount);
    }

    @Test
    public void queryByIdWithSeckill() {
        long id = 1000L;
        long phone = 12767876548L;
        SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(id, phone);
        System.out.println(successKilled);
        System.out.println(successKilled.getSeckill());
    }
}
```

#### 8. 编写Service层代码

##### [java的几种对象(PO,VO,DAO,BO,POJO,DTO)解释](https://www.cnblogs.com/firstdream/archive/2012/04/13/2445582.html)

PO：
persistant object持久对象
最形象的理解就是一个PO就是数据库中的一条记录。
好处是可以把一条记录作为一个对象处理，可以方便的转为其它对象。

BO：
business object业务对象
主要作用是把业务逻辑封装为一个对象。这个对象可以包括一个或多个其它的对象。
比如一个简历，有教育经历、工作经历、 关系等等。
我们可以把教育经历对应一个PO，工作经历对应一个PO， 关系对应一个PO。
建立一个对应简历的BO对象处理简历，每个BO包含这些PO。
这样处理业务逻辑时，我们就可以针对BO去处理。

VO ：
value object值对象
ViewObject表现层对象
主要对应界面显示的数据对象。对于一个WEB页面，或者SWT、SWING的一个界面，用一个VO对象对应整个界面的值。

DTO ：
Data Transfer Object数据传输对象
主要用于远程调用等需要大量传输对象的地方。
比如我们一张表有100个字段，那么对应的PO就有100个属性。
但是我们界面上只要显示10个字段，
客户端用WEB service来获取数据，没有必要把整个PO对象传递到客户端，
这时我们就可以用只有这10个属性的DTO来传递结果到客户端，这样也不会暴露服务端表结构.到达客户端以后，如果用这个对象来对应界面显示，那此时它的身份就转为VO

POJO ：
plain ordinary java object 简单java对象
个人感觉POJO是最常见最多变的对象，是一个中间对象，也是我们最常打交道的对象。
一个POJO持久化以后就是PO
直接用它传递、传递过程中就是DTO
直接用来对应表示层就是VO

##### 创建Service接口

```java
package org.seckill.service;

import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.seckill.exception.SeckillException;

import java.util.List;

/**
 * @ClassName SeckillService
 * @Description 业务接口：站在"使用者"的角度设计接口
 * 三个方面：方法定义粒度，参数，返回类型（return 类型/异常）
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:32
 * @Version 1.0
 */
public interface SeckillService {

    /**
     * 查询所有秒杀记录
     * @return
     */
    List<Seckill> getSeckillList();

    /**
     * 查询单个秒杀记录
     * @param seckillId
     * @return
     */
    Seckill getById(long seckillId);

    /**
     * 秒杀开启时输出秒杀接口地址，否则输出系统时间和秒杀时间
     * @param seckillId
     */
    Exposer exportSeckillUrl(long seckillId);

    /**
     * 执行秒杀操作
     * @param seckillId
     * @param userPhone
     * @param md5
     * @return
     * @throws SeckillException
     * @throws RepeatKillException
     * @throws SeckillCloseException
     */
    SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException;
}
```

##### 实现Service接口

在实现之前需要创建好异常类、数据传输对象、枚举类

枚举类

```java
package org.seckill.enums;

/**
 * @ClassName SeckillStatEnum
 * @Description 使用枚举表述常量数据字段
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午10:27
 * @Version 1.0
 */
public enum SeckillStatEnum {
    SUCCESS(1, "秒杀成功"),
    END(0, "秒杀结束"),
    REPEAT_KILL(-1, "重复秒杀"),
    INNER_ERROR(-2, "系统异常"),
    DATE_REWRITE(-3, "数据篡改");

    private int state;

    private String stateInfo;

    SeckillStatEnum(int state, String stateInfo) {
        this.state = state;
        this.stateInfo = stateInfo;
    }

    public int getState() {
        return state;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public static SeckillStatEnum stateOf(int index) {
        for (SeckillStatEnum state : values()) {
            if (state.getState() == index){
                return state;
            }
        }
        return null;
    }
}
```

异常类

```java
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
```

```java
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
```

```java
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
```

dto数据传输类

```java
package org.seckill.dto;

/**
 * @ClassName Exposer
 * @Description 暴露秒杀接口DTO
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:38
 * @Version 1.0
 */
public class Exposer {

    // 是否开启秒杀
    private boolean exposed;

    // 一种加密措施
    private String md5;

    // ID
    private long seckillId;

    // 系统当前时间（毫秒）
    private long now;

    // 开启时间
    private long start;

    // 结束时间
    private long end;

    public Exposer(boolean exposed, String md5, long seckillId) {
        this.exposed = exposed;
        this.md5 = md5;
        this.seckillId = seckillId;
    }

    public Exposer(boolean exposed, long seckillId, long now, long start, long end) {
        this.exposed = exposed;
        this.seckillId = seckillId;
        this.now = now;
        this.start = start;
        this.end = end;
    }

    public Exposer(boolean exposed, long seckillId) {
        this.exposed = exposed;
        this.seckillId = seckillId;
    }

    public boolean isExposed() {
        return exposed;
    }

    public void setExposed(boolean exposed) {
        this.exposed = exposed;
    }

    public String getMd5() {
        return md5;
    }

    public void setMd5(String md5) {
        this.md5 = md5;
    }

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public long getNow() {
        return now;
    }

    public void setNow(long now) {
        this.now = now;
    }

    public long getStart() {
        return start;
    }

    public void setStart(long start) {
        this.start = start;
    }

    public long getEnd() {
        return end;
    }

    public void setEnd(long end) {
        this.end = end;
    }
  
  	@Override
    public String toString() {
        return "Exposer{" +
                "exposed=" + exposed +
                ", md5='" + md5 + '\'' +
                ", seckillId=" + seckillId +
                ", now=" + now +
                ", start=" + start +
                ", end=" + end +
                '}';
    }
}
```

```java
package org.seckill.dto;

import org.seckill.entity.SuccessKilled;
import org.seckill.enums.SeckillStatEnum;

/**
 * @ClassName SeckillExecution
 * @Description 封装秒杀执行后结果
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:45
 * @Version 1.0
 */
public class SeckillExecution {

    private long seckillId;

    // 秒杀执行结果状态
    private int state;

    // 状态表示
    private String stateInfo;

    // 秒杀成功对象
    private SuccessKilled successKilled;

    // 使用枚举表示状态
    public SeckillExecution(long seckillId, SeckillStatEnum statEnum, SuccessKilled successKilled) {
        this.seckillId = seckillId;
        this.state = statEnum.getState();
        this.stateInfo = statEnum.getStateInfo();
        this.successKilled = successKilled;
    }

    public SeckillExecution(long seckillId, SeckillStatEnum statEnum) {
        this.seckillId = seckillId;
        this.state = statEnum.getState();
        this.stateInfo = statEnum.getStateInfo();
    }

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public void setStateInfo(String stateInfo) {
        this.stateInfo = stateInfo;
    }

    public SuccessKilled getSuccessKilled() {
        return successKilled;
    }

    public void setSuccessKilled(SuccessKilled successKilled) {
        this.successKilled = successKilled;
    }
  
  	@Override
    public String toString() {
        return "SeckillExecution{" +
                "seckillId=" + seckillId +
                ", state=" + state +
                ", stateInfo='" + stateInfo + '\'' +
                ", successKilled=" + successKilled +
                '}';
    }
}
```

###### 编写Service接口实现类

```java
package org.seckill.service.impl;

import org.seckill.dao.SeckillDao;
import org.seckill.dao.SuccessKilledDao;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.entity.SuccessKilled;
import org.seckill.enums.SeckillStatEnum;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.seckill.exception.SeckillException;
import org.seckill.service.SeckillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.DigestUtils;

import java.util.Date;
import java.util.List;

/**
 * @ClassName SeckillServiceImpl
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/26 下午8:58
 * @Version 1.0
 */
public class SeckillServiceImpl implements SeckillService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private SeckillDao seckillDao;

    private SuccessKilledDao successKilledDao;

  	// md5盐值字符串，用于混淆MD5
    private final String slat = "cnsajcnasmkm74nvlkcn%Ncck&cdksc;acmknvdsj";

    @Override
    public List<Seckill> getSeckillList() {
        return seckillDao.queryAll(0, 4);
    }

    @Override
    public Seckill getById(long seckillId) {
        return seckillDao.queryById(seckillId);
    }

    @Override
    public Exposer exportSeckillUrl(long seckillId) {
        Seckill seckill = seckillDao.queryById(seckillId);
        if (seckill == null) {
            return new Exposer(false, seckillId);
        }
        Date startTime = seckill.getStartTime();
        Date endTime = seckill.getEndTime();
        // 系统当前时间
        Date nowTime = new Date();
        if (nowTime.getTime() < startTime.getTime() || nowTime.getTime() > endTime.getTime()) {
            return new Exposer(false, seckillId, nowTime.getTime(), startTime.getTime(),
                    endTime.getTime());
        }
        // 转化特定字符串的过程，不可逆
        String md5 = getMD5(seckillId);
        return new Exposer(true, md5, seckillId);
    }

    private String getMD5(long seckillId) {
        String base = seckillId + "/" + slat;
        String md5 = DigestUtils.md5DigestAsHex(base.getBytes());
        return md5;
    }

    @Override
    public SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException {
        if (md5 == null || !md5.equals(getMD5(seckillId))) {
            throw new SeckillException("seckill data rewrite");
        }
        // 执行秒杀逻辑：减库存 + 记录购买行为
        Date nowTime = new Date();
        try {
            // 减库存
            int updateCount = seckillDao.reduceNumber(seckillId, nowTime);
            if (updateCount <= 0) {
                // 没有更新记录，秒杀结束
                throw new SeckillCloseException("seckill is closed");
            } else {
                // 记录购买行为
                int insertCount = successKilledDao.insertSuccessKilled(seckillId, userPhone);
                // 唯一：seckillId,userPhone
                if (insertCount <= 0) {
                    // 重复秒杀
                    throw new RepeatKillException("seckill repeated");
                } else {
                    // 秒杀成功
                    SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
                    return new SeckillExecution(seckillId, SeckillStatEnum.SUCCESS, successKilled);
                }
            }
        } catch (SeckillCloseException e1) {
            throw e1;
        } catch (RepeatKillException e2) {
            throw e2;
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            // 所有编译器异常转化为运行期异常
            throw new SeckillException("seckill inner error:" + e.getMessage());
        }
    }
}
```

#### 9. 通过spring来管理Service依赖

本质上就是通过Spring IOC来管理

为什么要用IOC

* 对象创建统一托管

* 规范的正面周期管理

* 灵活的依赖注入
* 一致的获取对象

Spring-IOC注入方式和场景

* XML
  * Bean实现类来自第三方库，如：DataSource等
  * 需要命名空间配置，如：context，aop，mvc等
* 注解
  * 项目中自身开发使用的类，可直接在代码中使用注解，如：@Service，@Controller等
* Java配置类
  * 需要通过代码控制对象创建逻辑的场景，如：自定义修改依赖类库

在spring包下创建spring-service.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">
    <!--扫描service包下所有使用注解的类型-->
    <context:component-scan base-package="org.seckill.service"/>
</beans>
```

在service实现类上加上注解<kbd>@Service</kbd>

使用注解<kbd>@Autowired</kbd>注入Service依赖，也就是Dao层接口

在使用spring框架中的依赖注入注解@Autowired时，idea报了一个警告

> Field injection is not recommended

解决方法参考[使用@Autowired注解警告](https://blog.csdn.net/zhangjingao/article/details/81094529)

##### 什么是Spring声明式事物

声明式事务管理使用了 `AOP` 实现的，本质就是**在目标方法执行前后进行拦截**。在目标方法执行前加入或创建一个事务，在执行方法执行后，根据实际情况选择提交或是回滚事务。[参考文章](https://blog.csdn.net/yuanlaijike/article/details/91909069)

什么时候会滚事物

* 抛出运行期异常(RuntimeException)

* 小心不当的try/catch

##### 配置声明式事物

在spring-service.xml中增加配置如下

```xml
		<!--配置事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--注入数据库的连接池-->
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--配置基于注解的声明式事务 默认使用注解来管理事务行为-->
    <tx:annotation-driven transaction-manager="transactionManager"/>
```

在Service实现类的方法上添加<kbd>@Transactional</kbd>注解

##### 测试Service方法

选中Service接口类名，按<kbd>Ctrl</kbd>+<kbd>enter</kbd>快捷键 -> Test -> junit4 -> 勾选需要测试的方法

```java
package org.seckill.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;


/**
 * @ClassName SeckillServiceTest
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/27 下午10:21
 * @Version 1.0
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring/spring-dao.xml",
        "classpath:spring/spring-service.xml"})
public class SeckillServiceTest {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private SeckillService seckillService;

    @Test
    public void getSeckillList() {
        List<Seckill> list = seckillService.getSeckillList();
        logger.info("list={}", list);
    }

    @Test
    public void getById() {
        long id = 1000L;
        Seckill seckill = seckillService.getById(id);
        logger.info("seckill={}", seckill);
    }

  	// 集成测试代码完整逻辑，注意可重复执行
    @Test
    public void exportSeckillUrl() {
        long id = 1000L;
        Exposer exposer = seckillService.exportSeckillUrl(id);
        if (exposer.isExposed()) {
            logger.info("exposer={}", exposer);
            long phone = 13578563472L;
            String md5 = "a4ae165edd248e561ad47969dee8819c";
            try {
                SeckillExecution execution = seckillService.executeSeckill(id, phone, md5);
                logger.info("execution={}", execution);
            } catch (RepeatKillException | SeckillCloseException e) {
                logger.error(e.getMessage());
            }
        } else {
            // 秒杀未开启
            logger.warn("exposer={}", exposer);
        }
    }

    @Test
    public void executeSeckill() {
        long id = 1000L;
        long phone = 13578563472L;
        String md5 = "a4ae165edd248e561ad47969dee8819c";
        try {
            SeckillExecution execution = seckillService.executeSeckill(id, phone, md5);
            logger.info("execution={}", execution);
        } catch (RepeatKillException | SeckillCloseException e) {
            logger.error(e.getMessage());
        }
    }
}
```

#### 10. SpringMVC配置

[SpringMVC的运行流程](https://juejin.im/post/5c0f6a60518825080825aae7)

##### 配置web.xml

```xml
<!--配置DispatcherServlet-->
  <servlet>
    <servlet-name>seckill-dispatcher</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!--配置springMVC需要加载的配置文件
    spring-dao.xml,spring-service.xml,spring-web.xml-->
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring/spring-*.xml</param-value>
    </init-param>
  </servlet>
  <servlet-mapping>
    <servlet-name>seckill-dispatcher</servlet-name>
    <!--默认匹配所有请求-->
    <url-pattern>/</url-pattern>
  </servlet-mapping>
```

##### 在spring下创建spring-web.xml配置SpringMVC

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
    <!--配置SpringMVC-->
    <!--1:开启SpringMVC注解模式-->
    <mvc:annotation-driven/>
    <!--2:静态资源默认servlet配置-->
    <mvc:default-servlet-handler/>
    <!--3:配置jsp 显示ViewResolver-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
        <property name="prefix" value="/WEB-INF/jsp"/>
        <property name="suffix" value=".jsp"/>
    </bean>
    <!--扫描web相关的bean-->
    <context:component-scan base-package="org.seckill.web"/>
</beans>
```

##### 在dto包下创建SeckillRequest.java，用于封装json数据的返回结果

```jav
package org.seckill.dto;

/**
 * @ClassName SeckillResult
 * @Description 所有的ajax请求的返回类型，封装json结果
 * @Author ouyangzicheng
 * @Date 2020/4/28 下午10:46
 * @Version 1.0
 */
public class SeckillResult<T> {

    private boolean success;

    private T data;

    private String error;

    public SeckillResult(boolean success, T data) {
        this.success = success;
        this.data = data;
    }

    public SeckillResult(boolean success, String error) {
        this.success = success;
        this.error = error;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
```

##### 在java目录下创建web包，编写Controller类

```java
package org.seckill.web;

import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.dto.SeckillResult;
import org.seckill.entity.Seckill;
import org.seckill.enums.SeckillStatEnum;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.seckill.exception.SeckillException;
import org.seckill.service.SeckillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * @ClassName SeckillController
 * @Description TODO
 * @Author ouyangzicheng
 * @Date 2020/4/28 下午10:32
 * @Version 1.0
 */
@Controller
@RequestMapping("/seckill")// url:/模块/资源/{id}/细分
public class SeckillController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private SeckillService seckillService;

    @Autowired
    public void setSeckillService(SeckillService seckillService) {
        this.seckillService = seckillService;
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(Model model) {
        List<Seckill> list = seckillService.getSeckillList();
        model.addAttribute("list", list);
        return "list";
    }

    @RequestMapping(value = "/{seckillId}/detail", method = RequestMethod.GET)
    public String detail(@PathVariable("seckillId") Long seckillId, Model model) {
        if (seckillId == null) {
            return "redirect:/seckill/list";
        }
        Seckill seckill = seckillService.getById(seckillId);
        if (seckill == null) {
            return "forward:/seckill/list";// 重定向
        }
        model.addAttribute("seckill", seckill);// 转发
        return "detail";
    }

    @RequestMapping(value = "/{seckillId}/exposer",
            method = RequestMethod.POST, produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public SeckillResult<Exposer> exposer(Long seckillId) {
        SeckillResult<Exposer> result;
        try {
            Exposer exposer = seckillService.exportSeckillUrl(seckillId);
            result = new SeckillResult<Exposer>(true, exposer);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result = new SeckillResult<Exposer>(false, e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/{seckillId}/{md5}/execution",
            method = RequestMethod.POST, produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public SeckillResult<SeckillExecution> execute(@PathVariable("seckillId") Long seckillId,
                                                   @PathVariable("md5") String md5,
                                                   @CookieValue(value = "killPhone", required = false) Long phone) {
        // 当用户传入很多参数需要验证时，使用SpringMVC valid
        if (phone == null) {
            return new SeckillResult<SeckillExecution>(false, "未注册");
        }
        SeckillResult<SeckillException> result;
        try {
            SeckillExecution execution = seckillService.executeSeckill(seckillId, phone, md5);
            return new SeckillResult<SeckillExecution>(true, execution);
        } catch (RepeatKillException e) {
            // 重复秒杀
            SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.REPEAT_KILL);
            return new SeckillResult<SeckillExecution>(false, execution);
        } catch (SeckillCloseException e) {
            // 秒杀结束
            SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.END);
            return new SeckillResult<SeckillExecution>(false, execution);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            // 系统异常
            SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.INNER_ERROR);
            return new SeckillResult<SeckillExecution>(false, execution);
        }
    }

    @RequestMapping(value = "/time/now", method = RequestMethod.GET)
    public SeckillResult<Long> time() {
        Date now =new Date();
        return new SeckillResult(true, now.getTime());
    }
}
```

### 编写展示界面

#### 秒杀列表页

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="common/tag.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀列表页</title>
    <%@include file="common/head.jsp"%>
</head>
<body>
<!--页面显示部分-->
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading text-center">
            <h2>秒杀列表</h2>
        </div>
        <div class="panel-body">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>名称</th>
                    <th>库存</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>创建时间</th>
                    <th>详情页</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sk" items="${list}">
                    <tr>
                        <td>${sk.name}</td>
                        <td>${sk.number}</td>
                        <td>
                            <fmt:formatDate value="${sk.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>
                            <fmt:formatDate value="${sk.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>
                            <fmt:formatDate value="${sk.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>
                            <a class="btn btn-info" href="/seckill/${sk.seckillId}/detail" target="_blank">link</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</html>
```

将头部通用的代码单独存法，使用`include`导入

head.jsp

```jsp
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- 引入 Bootstrap -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

<!-- HTML5 Shiv 和 Respond.js 用于让 IE8 支持 HTML5元素和媒体查询 -->
<!-- 注意： 如果通过 file://  引入 Respond.js 文件，则该文件无法起效果 -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
```

tag.jsp

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

#### 秒杀详情页

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀详情页</title>
    <%@include file="common/head.jsp"%>
</head>
<body>
<div class="container">
    <div class="panel panel-default text-center">
        <div class="panel-heading">
            <h1>${seckill.name}</h1>
        </div>
        <div class="panel-body">
            <h2 class="text-danger">
                <!--显示time图标-->
                <span class="glyphicon glyphicon-time"></span>
                <!--展示倒计时-->
                <span class="glyphicon" id="seckill-box"></span>
            </h2>
        </div>
    </div>
</div>
<!--登陆弹出层，输入电话-->
<div id="killPhoneModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title text-center">
                    <span class="glyphicon glyphicon-phone"></span>
                    秒杀电话:
                </h3>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                        <input type="text" name="killPhone" id="killPhoneKey"
                               placeholder="填写手机号" class="form-control"/>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <!--验证信息-->
                <span id="killPhoneMessage" class="glyphicon"></span>
                <button type="button" id="killPhoneBtn" class="btn btn-success">
                    <span class="glyphicon glyphicon-phone"></span>
                    Submit
                </button>
            </div>
        </div>
    </div>
</div>
</body>
<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- 使用CDN获取公共js http://www.bootcdn.cn/ -->
<!-- jQuery cookie操作插件 -->
<script src="https://cdn.bootcdn.net/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<!-- jQuery countDown倒计时插件 -->
<script src="https://cdn.bootcdn.net/ajax/libs/jquery.countdown/2.2.0/jquery.countdown.min.js"></script>
<!-- 开始写交互逻辑 -->
<script src="/resources/script/seckill.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        // 使用EL表达式传入参数
        seckill.detail.init({
            seckillId: ${seckill.seckillId},
            startTime: ${seckill.startTime.time},// 毫秒
            endTime: ${seckill.endTime.time}
        });
    });
</script>
</html>
```

#### 交互逻辑

```js
// 存放主要交互逻辑js代码
// javascript 模块化
let seckill = {
    // 封装秒杀相关ajax的url
    URL: {
        now: function () {
            return '/seckill/time/now';
        },
        exposer: function (seckillId) {
            return '/seckill/' + seckillId + '/exposer';
        },
        execution: function (seckillId, md5) {
            return '/seckill/' + seckillId + '/' + md5 + '/execution';
        }
    },
    handleSeckill: function (seckillId, node) {
        // 获取秒杀地址，控制显示逻辑，执行秒杀
        node.hide().html('<button class="btn btn-primary btn-lg" id="killBtn">开始秒杀</button>');
        $.post(seckill.URL.exposer(seckillId), {}, function (result) {
            // 在回调函数中，执行交互流程
            if (result && result['success']) {
                let exposer = result['data'];
                if (exposer['exposed']) {
                    // 开启秒杀
                    // 获取秒杀地址
                    let md5 = exposer['md5'];
                    let killUrl = seckill.URL.execution(seckillId, md5);
                    // 绑定一次点击事件，用户多次点击，防止发起多个同样的请求
                    $('#killBtn').one('click', function () {
                        // 执行秒杀请求
                        // 1.先禁用按钮
                        $(this).addClass('disabled');
                        // 2.发送秒杀请求
                        $.post(killUrl, {}, function (result) {
                            if (result && result['success']) {
                                let killResult = result['data'];
                                let state = killResult['state'];
                                let stateInfo = killResult['stateInfo'];
                                // 3.显示秒杀结果
                                node.html('<span class="label label-success">' + stateInfo + '</span>');
                            }
                        });
                    });
                    node.show();
                } else {
                    // 未开启秒杀，客户端与服务器端时间可能存在偏差
                    let now = exposer['now'];
                    let start = exposer['start'];
                    let end = exposer['end'];
                    // 重新计算计时逻辑
                    seckill.countdown(seckillId, now, start, end);
                }
            } else {
                console.log('result:' + result);
            }
        });
    },
    // 验证手机号
    validatePhone: function (phone) {
        if (phone && phone.length === 11 && !isNaN(phone)) {
            return true;
        } else {
            return false;
        }
    },
    countdown: function (seckillId, nowTime, startTime, endTime) {
        let seckillBox = $('#seckill-box');
        // 时间判断
        if (nowTime > endTime) {
            // 秒杀结束
            seckillBox.html('秒杀结束!')
        } else if (nowTime < startTime) {
            // 秒杀未开始，计时事件
            let killTime = new Date(startTime + 1000);
            seckillBox.countdown(killTime, function (event) {
                // 事件格式
                let format = event.strftime('秒杀倒计时：%D天 %H时 %M分 %S秒');
                seckillBox.html(format);
                // 时间完成后回调事件
            }).on('finish.countdown', function () {
                seckill.handleSeckill(seckillId, seckillBox);
            });
        } else {
            // 秒杀开始
            seckill.handleSeckill(seckillId, seckillBox);
        }
    },
    // 详情页秒杀逻辑
    detail: {
        // 详情页初始化
        init: function (params) {
            // 手机验证和登陆，计时交互
            // 规划交互流程
            // 在cookie中查找手机号
            let killPhone = $.cookie('killPhone');
            // 验证手机号
            if (!seckill.validatePhone(killPhone)) {
                // 控制输出
                let killPhoneModal = $('#killPhoneModal');
                killPhoneModal.modal({
                    show: true,// 显示弹出层
                    backdrop: 'static',// 禁止位置关闭
                    keyboard: false// 关闭键盘事件
                });
                $('#killPhoneBtn').click(function () {
                    let inputPhone = $('#killPhoneKey').val();
                    if (seckill.validatePhone(inputPhone)) {
                        // 电话写入cookie
                        $.cookie('killPhone', inputPhone, {expires: 7, path: '/seckill'});
                        // 刷新页面
                        window.location.reload();
                    } else {
                        $('#killPhoneMessage').hide().html('<label class="label label-danger">手机号错误!</label>').show(300);
                    }
                });
            }
            // 已经登陆
            // 计时交互
            let seckillId = params['seckillId'];
            let startTime = params['startTime'];
            let endTime = params['endTime'];
            $.get(seckill.URL.now(), {}, function (result) {
                if (result && result['success']) {
                    let nowTime = result['data'];
                    // 时间判断
                    seckill.countdown(seckillId, nowTime, startTime, endTime);
                } else {
                    console.log('result:' + result);
                }
            });
        }
    }
}
```

## 使用redis缓存优化查询接口

### 安装并启动redis服务

下载redis解压

使用命令，进入redis根目录，输入命令启动redis服务`redis-server`

```sheel
$ redis-server
628:C 11 May 2020 19:41:42.459 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
628:C 11 May 2020 19:41:42.460 # Redis version=6.0.1, bits=64, commit=00000000, modified=0, pid=628, just started
628:C 11 May 2020 19:41:42.460 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
628:M 11 May 2020 19:41:42.461 * Increased maximum number of open files to 10032 (it was originally set to 256).
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 6.0.1 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 628
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

628:M 11 May 2020 19:41:42.467 # Server initialized
628:M 11 May 2020 19:41:42.468 * Loading RDB produced by version 6.0.1
628:M 11 May 2020 19:41:42.468 * RDB age 595767 seconds
628:M 11 May 2020 19:41:42.468 * RDB memory usage when created 0.95 Mb
628:M 11 May 2020 19:41:42.468 * DB loaded from disk: 0.001 seconds
628:M 11 May 2020 19:41:42.468 * Ready to accept connections
```

### 自定义序列化类

```java
package org.seckill.dao.cache;

import com.dyuproject.protostuff.LinkedBuffer;
import com.dyuproject.protostuff.ProtostuffIOUtil;
import com.dyuproject.protostuff.runtime.RuntimeSchema;
import org.seckill.entity.Seckill;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisDao {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private JedisPool jedisPool;


    public RedisDao(String ip, int port) {
        jedisPool = new JedisPool(ip, port);
    }

    private RuntimeSchema<Seckill> schema = RuntimeSchema.createFrom(Seckill.class);

    public Seckill getSeckill(long seckillId) {
        // redis操作逻辑
        try {
            Jedis jedis = jedisPool.getResource();
            try {
                String key = "seckill:" + seckillId;
                // get -> byte[] -> 反序列化 -> Object(Seckill)
                // 自定义序列化 转换的类必须是有get set方法的pojo
                byte[] bytes = jedis.get(key.getBytes());
                // 从缓存中获取数据
                if (bytes != null) {
                    // 创建一个空对象
                    Seckill seckill = schema.newMessage();
                    // 反序列化
                    ProtostuffIOUtil.mergeFrom(bytes, seckill, schema);
                    return seckill;
                }

            } finally {
                jedis.close();
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return null;
    }

    public String putSeckill(Seckill seckill) {
        // set Object(Seckill) -> 序列化 -> byte[]
        try {
            Jedis jedis = jedisPool.getResource();
            try {
                String key = "seckill:" + seckill.getSeckillId();
                byte[] bytes = ProtostuffIOUtil.toByteArray(seckill, schema,
                        LinkedBuffer.allocate(LinkedBuffer.DEFAULT_BUFFER_SIZE));
                // 超时缓存
                int timeout = 60 * 60;
                String result = jedis.setex(key.getBytes(), timeout, bytes);
                return result;
            } finally {
                jedis.close();
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return null;
    }
}
```

### 测试redis

```java
package org.seckill.dao.cache;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dao.SeckillDao;
import org.seckill.entity.Seckill;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring/spring-dao.xml"})
public class RedisDaoTest {
    private long id = 1001;

    @Autowired
    private RedisDao redisDao;

    @Autowired
    private SeckillDao seckillDao;

    @Test
    public void testSeckill() {
        // 测试序列化和反序列化
        Seckill seckill = redisDao.getSeckill(id);
        if (seckill == null) {
            seckill = seckillDao.queryById(id);
            if (seckill != null) {
                String result = redisDao.putSeckill(seckill);
                System.out.println(result);
                seckill = redisDao.getSeckill(id);
                System.out.println("结果"+seckill);
            }
        }
        System.out.println("结果"+seckill);
    }

}
```

### 优化接口SeckillService查询接口

```java
@Override
public Exposer exportSeckillUrl(long seckillId) {
  // 优化点:缓存优化
  // 1.访问redis
  Seckill seckill = redisDao.getSeckill(seckillId);
  if (seckill == null) {
    // 2.如果缓存中没有查询到数据则访问数据库
    seckill = seckillDao.queryById(seckillId);
    if (seckill == null) {
      return new Exposer(false, seckillId);
    } else {
      // 3.放入redis
      redisDao.putSeckill(seckill);
    }
  }

  Date startTime = seckill.getStartTime();
  Date endTime = seckill.getEndTime();
  // 系统当前时间
  Date nowTime = new Date();
  if (nowTime.getTime() < startTime.getTime() || nowTime.getTime() > endTime.getTime()) {
    return new Exposer(false, seckillId, nowTime.getTime(), startTime.getTime(),
                       endTime.getTime());
  }
  // 转化特定字符串的过程，不可逆
  String md5 = getMD5(seckillId);
  return new Exposer(true, md5, seckillId);
}
```

## 优化秒杀业务

为了减少GC和网络延迟带来的影响，提高并发

简单优化，先执行插入秒杀记录，如果有重复秒杀的则rollback，不做修改操作，可以阻拦一部分重复秒杀的并发

### 业务逻辑简单优化

实现方法如下

```java
@Override
@Transactional
public SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
  throws SeckillException, RepeatKillException, SeckillCloseException {
  if (md5 == null || !md5.equals(getMD5(seckillId))) {
    throw new SeckillException("seckill data rewrite");
  }
  // 执行秒杀逻辑：减库存 + 记录购买行为
  Date nowTime = new Date();
  try {
    // 记录购买行为
    int insertCount = successKilledDao.insertSuccessKilled(seckillId, userPhone);
    // 唯一：seckillId,userPhone
    if (insertCount <= 0) {
      // 重复秒杀
      throw new RepeatKillException("seckill repeated");
    } else {
      // 减库存,热点商品竞争
      int updateCount = seckillDao.reduceNumber(seckillId, nowTime);
      if (updateCount <= 0) {
        // 没有更新记录，秒杀结束，rollback
        throw new SeckillCloseException("seckill is closed");
      } else {
        // 秒杀成功，commit
        SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
        return new SeckillExecution(seckillId, SeckillStatEnum.SUCCESS, successKilled);
      }
    }
  } catch (SeckillCloseException | RepeatKillException e) {
    throw e;
  } catch (Exception e) {
    logger.error(e.getMessage(), e);
    // 所有编译器异常转化为运行期异常
    throw new SeckillException("seckill inner error:" + e.getMessage());
  }
}
```

### 使用存储过程优化

#### 存储过程

```sql
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
```

### mybatis调用存储过程

SeckillDao增加一个接口

```java
/**
  * 使用存储过程执行秒杀
  * @param paramMap
  */
void killByProcedure(Map<String,Object> paramMap);
```

SeckillDao.xml实现

```xml
<!--mybatis调用存储过程-->
<select id="killByProcedure" statementType="CALLABLE">
  call execute_seckill(
  #{seckillId,jdbcType=BIGINT,mode=IN},
  #{phone,jdbcType=BIGINT,mode=IN},
  #{killTime,jdbcType=TIMESTAMP,mode=IN},
  #{result,jdbcType=INTEGER,mode=OUT}
  )
</select>
```

SeckillService增加接口

```java
/**
  * 执行秒杀操作By存储过程
  */
SeckillExecution executeSeckillProcedure(long seckillId, long userPhone, String md5);
```

SeckillServiceImpl实现

```java
@Override
public SeckillExecution executeSeckillProcedure(long seckillId, long userPhone, String md5) {
  if (md5 == null || !md5.equals(getMD5(seckillId))) {
    return new SeckillExecution(seckillId, SeckillStatEnum.DATE_REWRITE);
  }
  Date killTime = new Date();
  Map<String, Object> map = new HashMap<String, Object>();
  map.put("seckillId", seckillId);
  map.put("phone", userPhone);
  map.put("killTime", killTime);
  map.put("result", null);
  // 执行存储过程，result被赋值
  try {
    seckillDao.killByProcedure(map);
    // 获取result
    int result = MapUtils.getInteger(map, "result", -2);
    if (result == 1) {
      SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
      return new SeckillExecution(seckillId, SeckillStatEnum.SUCCESS, successKilled);
    } else {
      return new SeckillExecution(seckillId, SeckillStatEnum.stateOf(result));
    }
  } catch (Exception e) {
    logger.error(e.getMessage(), e);
    return new SeckillExecution(seckillId, SeckillStatEnum.INNER_ERROR);
  }
}
```

测试Service

```java
@Test
public void executeSeckillProcedure() {
  long seckillId = 1001;
  long phone = 13176585643L;
  Exposer exposer = seckillService.exportSeckillUrl(seckillId);
  if (exposer.isExposed()) {
    String md5 = exposer.getMd5();
    SeckillExecution execution = seckillService.executeSeckillProcedure(seckillId, phone, md5);
    logger.info(execution.getStateInfo());
  }
}
```

修改Controller的调用方法

```java
@RequestMapping(value = "/{seckillId}/{md5}/execution",
            method = RequestMethod.POST, produces = {"application/json;charset=UTF-8"})
@ResponseBody
public SeckillResult<SeckillExecution> execute(@PathVariable("seckillId") Long seckillId,
                                               @PathVariable("md5") String md5,
                                               @CookieValue(value = "killPhone", required = false) Long phone) {
  // 当用户传入很多参数需要验证时，使用SpringMVC valid
  if (phone == null) {
    return new SeckillResult<SeckillExecution>(false, "未注册");
  }
  SeckillResult<SeckillException> result;
  try {
    // 使用存储过程
    SeckillExecution execution = seckillService.executeSeckillProcedure(seckillId, phone, md5);
    // SeckillExecution execution = seckillService.executeSeckill(seckillId, phone, md5);
    return new SeckillResult<SeckillExecution>(true, execution);
  } catch (RepeatKillException e) {
    // 重复秒杀
    SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.REPEAT_KILL);
    return new SeckillResult<SeckillExecution>(true, execution);
  } catch (SeckillCloseException e) {
    // 秒杀结束
    SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.END);
    return new SeckillResult<SeckillExecution>(true, execution);
  } catch (Exception e) {
    logger.error(e.getMessage(), e);
    // 系统异常
    SeckillExecution execution = new SeckillExecution(seckillId, SeckillStatEnum.INNER_ERROR);
    return new SeckillResult<SeckillExecution>(true, execution);
  }
}
```

启动tomcat服务器

访问http://localhost:8080/seckill/list