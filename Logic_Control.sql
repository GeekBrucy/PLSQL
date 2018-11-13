SET SERVEROUTPUT ON;
------------------- PL/SQL支持的流程控制结构:
/* 条件控制
  - IF 语句
  - CASE 语句
*/
-- IF 语句根据条件执行一系列语句, 有三种形式:
-- IF-THEN, IF-THEN-ELSE, IF-THEN-ELSIF
CREATE TABLE student2 (
  sno       INT
, sname     VARCHAR2(10)
, sbirthday DATE
);

INSERT INTO student2 VALUES (1, '张三', TO_DATE('19800311', 'yyyymmdd'));
INSERT INTO student2 VALUES (2, '李四', TO_DATE('19810311', 'yyyymmdd'));
INSERT INTO student2 VALUES (3, '王五', TO_DATE('19820311', 'yyyymmdd'));
COMMIT;

SELECT  *
FROM    student2;

DECLARE
  sbirth1   student2.sbirthday%TYPE;
BEGIN
  SELECT    sbirthday
  INTO      sbirth1
  FROM      student2
  WHERE     sno = 1;
  
  IF sbirth1 < TO_DATE('19850101', 'yyyymmdd')
  THEN
    DBMS_OUTPUT.PUT_LINE('大于 25');
  END IF;
  IF sbirth1 >= TO_DATE('19850101', 'yyyymmdd')
  THEN
    DBMS_OUTPUT.PUT_LINE('小于等于 25');
  END IF;
END;
/
DECLARE
  sbirth1   student2.sbirthday%TYPE;
BEGIN
  SELECT    sbirthday
  INTO      sbirth1
  FROM      student2
  WHERE     sno = 1;
  
  IF sbirth1 < TO_DATE('19850101', 'yyyymmdd')
  THEN
    DBMS_OUTPUT.PUT_LINE('大于 25');
  ELSE
    DBMS_OUTPUT.PUT_LINE('小于等于 25');
  END IF;
END;
/

-- CASE 语句
DECLARE
  outgrade  VARCHAR2(20);
BEGIN
  outgrade  := CASE '&grade'
      WHEN  'A' THEN '优秀'
      WHEN  'B' THEN '良好'
      WHEN  'C' THEN '中等'
      WHEN  'D' THEN '及格'
      WHEN  'E' THEN '不及格'
      ELSE  '没有此成绩'
    END;
  DBMS_OUTPUT.PUT_LINE(outgrade);
END;
/
/* 循环控制
  - LOOP 循环 - 无条件
  - WHILE 循环 - 根据条件循环
  - FOR 循环 - 循环固定次数
*/
-- loop
DECLARE
  j NUMBER := 0;
BEGIN
  j := 1;
  LOOP
    DBMS_OUTPUT.PUT_LINE(j || '---');
    EXIT WHEN j > 7;
    j := j + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ENDING');
END;
/

-- while
DECLARE
  j NUMBER := 0;
BEGIN
  j := 1;
  WHILE j <= 8
  LOOP
    DBMS_OUTPUT.PUT_LINE(j || '---');
    j := j + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ENDING');
END;
/

-- for
DECLARE
  j NUMBER := 0;
BEGIN
  j := 1;
  FOR j IN 1..8
  LOOP
    DBMS_OUTPUT.PUT_LINE(j || '---');
    EXIT WHEN j > 4;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ENDING');
END;
/

-- continue
DECLARE
  j NUMBER := 1;
BEGIN
  LOOP
    j := j + 1;
    EXIT WHEN j > 8;
    CONTINUE WHEN j > 4;
    DBMS_OUTPUT.PUT_LINE(j || '---');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ENDING');
END;
/

/* 顺序控制
  - GOTO 语句
  - NULL 语句
*/

-- goto
-- null
DECLARE
  j NUMBER := 0;
BEGIN
  j := 1;
  <<aa>>
    DBMS_OUTPUT.PUT_LINE(j || '---');
    j := j + 1;
    IF j <= 7 
    THEN GOTO aa;
    END IF;
    IF j > 7 
    THEN GOTO bb;
    END IF;
  <<bb>>  NULL;
  DBMS_OUTPUT.PUT_LINE('ENDING');
END;
/

/*
* 动态SQL是指在PL/SQL程序执行时生成的SQL语句
* 编译程序对动态SQL不作处理, 而是在程序运行时动态构造语句,对语句进行语法分析并执行
* DDL语句命令和会话控制语句不能在PL/SQL中直接使用, 但是可以通过动态SQL来执行
* 执行动态SQL的语法:
  EXECUTE IMMEDIATE dynamic_sql_string
  [INTO define_variable_list]
  [USING bind_argument_list];
*/
BEGIN
  EXECUTE IMMEDIATE 'create table T(t1 INT)';
END;
/


/*
错误处理
* 在运行程序时出现的错误叫做异常
* 发生异常后, 语句将停止执行, 控制权转移到PL/SQL块的异常处理部分
* 异常有两种类型
  - 预定义异常- 当PL/SQL程序违反Oracle规则或超越系统限制时隐式引发
  - 用户定义异常 - 用户可以在PL/SQL块的声明部分定义异常, 自定义的异常通过RAISE语句显式引发
*/

-- 预定义异常
DECLARE
  sname1 student.sname%TYPE;
BEGIN
  SELECT sname
  INTO   sname1
  FROM   student
  WHERE  sno = 5;
  DBMS_OUTPUT.PUT_LINE(sname1);
EXCEPTION
  WHEN no_data_found
  THEN DBMS_OUTPUT.PUT_LINE('NO THIS STUDENT');
END;
/

-- 用户定义异常
DECLARE
  sbirth1 student2.sbirthday%TYPE;
  except1 EXCEPTION;
BEGIN
  SELECT sbirthday
  INTO   sbirth1
  FROM   student2
  WHERE  sno = 4;
  IF     sbirth1 > TO_DATE('20030101', 'yyyymmdd')
  THEN   RAISE except1;
  ELSE   DBMS_OUTPUT.PUT_LINE('Birthday Valid');
  END IF;
EXCEPTION
  WHEN except1
  THEN DBMS_OUTPUT.PUT_LINE('WRONG BIRTHDAY');
END;
/
-- RAISE_APPLICATION_ERROR过程
-- * 用于创建用户定义的错误信息
-- * 可以在可执行部分和异常处理部分使用
-- * 错误编号必须介于-20000和-20999之间
-- * 错误消息的长度可长达2048个字节
-- 引发应用程序错误的语法:
--   RAISE_APPLICATION_ERROR(error_number, error_message);
DECLARE
  sbirth1 student2.sbirthday%TYPE;
  except1 EXCEPTION;
BEGIN
  SELECT sbirthday
  INTO   sbirth1
  FROM   student2
  WHERE  sno = 4;
  IF     sbirth1 > TO_DATE('20030101', 'yyyymmdd')
  THEN   RAISE except1;
  ELSE   DBMS_OUTPUT.PUT_LINE('Birthday Valid');
  END IF;
EXCEPTION
  WHEN except1
  THEN 
  DBMS_OUTPUT.PUT_LINE('WRONG BIRTHDAY');
  RAISE_APPLICATION_ERROR(-20001, 'INVALID AGE');
END;
/











