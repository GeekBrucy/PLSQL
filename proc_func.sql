SET SERVEROUTPUT ON;
/* 子程序
* 命名的pl/sql块,编译并存储在数据库中
* 子程序的各个部分
  - 声明部分
  - 可执行部分
  - 异常处理部分(可选)
* 子程序的分类
  - 过程 - 执行某些操作
  - 函数 - 执行操作并返回值
*/
/* 过程参数的三种模式
* IN
  - 用于接受调用程序的值
  - 默认的参数模式
* OUT
  - 用于向调用程序返回值
* IN OUT
  - 用于接收调用程序的值, 并向调用程序返回更新的值
*/
/* 写一个存储过程输出:
*
**
***
****
*****
******
*/
-- in
CREATE OR REPLACE PROCEDURE printStar(
  para  IN   NUMBER
)
IS
  a          VARCHAR2(50);
BEGIN
  a := '';
  FOR j IN 1..para LOOP
    a := a || '*';
    DBMS_OUTPUT.PUT_LINE(a);
  END LOOP;
END;
/
EXEC printStar(5)
/

----------------------------------------------------------
-- out
CREATE OR REPLACE PROCEDURE proc2(
  j OUT INT
)
AS
BEGIN
  j := 100;
  DBMS_OUTPUT.PUT_LINE(j);
END;
/

DECLARE
  k NUMBER;
BEGIN
  proc2(k);
  DBMS_OUTPUT.PUT_LINE(k);
END;
/

------------------------------------------------------------------
-- in out
CREATE OR REPLACE PROCEDURE proc3(p1 IN OUT NUMBER, p2 IN OUT NUMBER)
IS
  v_temp NUMBER;
BEGIN
  v_temp := p1;
  p1 := p2;
  p2 := v_temp;
END;
/
DECLARE
  num1 NUMBER := 100;
  num2 NUMBER := 200;
BEGIN
  proc3(num1, num2);
  DBMS_OUTPUT.PUT_LINE('num1 = ' || num1);
  DBMS_OUTPUT.PUT_LINE('num2 = ' || num2);
END;
/
-------------------------------------
GRANT EXECUTE ON proc3 TO demo;
-------------------------------------

/* 函数
* 函数是可以返回值的
* 只能接收IN参数, 而不能接受IN OUT或OUT参数
* 形参不能是PL/SQL类型, 只能是数据库类型
* 函数的返回类型也必须是数据库类型
* 访问函数的两种方式:
  - 使用PL/SQL块
  - 使用SQL语句
*/
CREATE OR REPLACE FUNCTION fun_hello RETURN VARCHAR2
IS
BEGIN
  RETURN 'Hello';
END;
/
-- SQLPLUS中调用函数
SELECT fun_hello FROM dual;

-- SQL DEVELOPER中调用函数
DECLARE
  ss  VARCHAR2(20);
BEGIN
  ss := fun_hello;
  DBMS_OUTPUT.PUT_LINE(ss);
END;
/

/*
创建一个函数, 可以接受用户输入的学号, 得到该学生的名次, 并输出这个名次
*/
CREATE TABLE score(
  student_no  NUMBER(3)
, name        VARCHAR2(10)
, score       NUMBER(3)
);
INSERT INTO score VALUES(1, '张一', 56);
INSERT INTO score VALUES(2, '张二', 82);
INSERT INTO score VALUES(3, '张三', 90);
COMMIT;
/
CREATE OR REPLACE FUNCTION func1(
  sno1 INT
) RETURN INT
IS
  score1 NUMBER;
  rank   NUMBER;
BEGIN
  SELECT score
  INTO   score1
  FROM   score
  WHERE  student_no = sno1;
  SELECT COUNT(*)
  INTO   rank
  FROM   score
  WHERE  score > score1;
  rank   := rank + 1;
  RETURN rank;
END;
/
SHOW ERROR;

DECLARE
  rank  NUMBER;
BEGIN
  rank := func1(2);
  DBMS_OUTPUT.PUT_LINE('RANK ' || rank);
END;
/

/* 自主事务处理
* 主事务处理启动独立事务处理
* 然后主事务处理被暂停
* 自主事务处理子程序内的SQL操作
* 然后终止自主事务处理
* 恢复主事务处理

-- 特征:
* 与主事务处理的状态无关
* 提交或回滚操作不影响主事务处理
* 自主事务处理的结果对其他事务是可见的
* 能够启动其他自主事务处理
*/

/*
PRAGMA AUTONOMOUS_TRANSACTION: 用于标记子程序为自主事务处理
*/
CREATE OR REPLACE PROCEDURE p1
AS
  b VARCHAR2(50);
BEGIN
  UPDATE student SET sname = '李四'
  WHERE  sno = 2;
  
  p2();
  SELECT sname
  INTO   b
  FROM   student
  WHERE  sno = 2;
  DBMS_OUTPUT.PUT_LINE(b);
END;
/
show error;
CREATE OR REPLACE PROCEDURE p2
AS
  a VARCHAR2(50);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  SELECT sname
  INTO   a
  FROM   student
  WHERE  sno = 2;
  DBMS_OUTPUT.PUT_LINE(a);
  ROLLBACK;
END;
/
show error;