SET SERVEROUTPUT ON;
-- Basics syntax
DECLARE
  total_row   NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO   total_row
  FROM   student;
  DBMS_OUTPUT.PUT_LINE('Total Rows: ' || total_row || ' records');
END;
/
--------------------------------------------------------------------------------
DECLARE
  icode     VARCHAR2(6);
  p_catg    VARCHAR2(20);
  p_rate    NUMBER;
  c_rate    CONSTANT NUMBER := 0.10;
BEGIN
  icode   := 'i205';
  SELECT  p_catg, itemrate * c_rate
  INTO    p_catg, p_rate
  FROM    itemfile
  WHERE   itemcode = icode;
END;
/
---------------------------------------------------------------------------------

----------------------- 数据类型 ---------------------------
/* 
* 标量类型
  - 数字
    + BINARY_INTEGER  - 存储有符号整数, 所需存储空间少于NUMBER类型值
      > NATURAL
      > NATURALLN
      > POSITIVE
      > POSITIVEN
      > SIGNTYPE
    + NUMBER          - 存储整数, 实数和浮点数
      > DECIMAL
      > FLOAT
      > INTEGER
      > REAL
    + PLS_INTEGER     - 存储有符号整数, 可使算数计算快速而有效
    + SIMPLE_INTEGER  - -2147483648 ~ +2147483647
*/
/*
  - 字符
    + CHAR
    + VARCHAR2
    + LONG
    + RAW
    + LONG RAW
*/
/*
  - 布尔型 - TRUE, FALSE, NULL
*/
/*
  - 日期时间
    + DATE
    + TIMESTAMP
*/  
/* LOB类型 - 存储非结构化数据块, 例如大文本, 图像, 视频剪辑和声音剪辑. 最大4gb数据
  - BFILE             - 将大型二进制对象存储在操作系统文件中
  - BLOB              - 将大型二进制对象存储在数据库中
  - CLOB              - 将大型字符数据存储在数据库中
  - NCLOB             - 存储大型UNICODE字符数据
*/
-- CLOB
CREATE TABLE testClob
(
  tid         NUMBER PRIMARY KEY,
  t_info      CLOB
);

INSERT INTO testClob values (
  1
, '自推出以来, PL/SQL就一直是在Oracle数据库中编程的首选语言. 经过一段时间的发展, 我们看到, 
  由于该语言可以实现越来越多需要较少编码的功能, 它已经演变为一个综合的开发平台. Oracle数据库11g使得PL/SQL编码
  对程序员更加高效.在文本中, 您将通过某些示例简单了解这个新功能.'
);
/
DECLARE
  clob_v      CLOB;
  amount      INTEGER;
  offset      INTEGER;
  output_var  VARCHAR2(1000);
BEGIN
  SELECT  t_info
  INTO    clob_v
  FROM    testClob
  WHERE   tid = 1;
  amount  := 1000;
  offset  := 1;
  DBMS_LOB.READ(clob_v, amount, offset, output_var);
  DBMS_OUTPUT.PUT_LINE(output_var);
END;
/

-- BLOB
CREATE TABLE person (pid VARCHAR2(20) PRIMARY KEY, photo BLOB);
/
-- Oracle中要存储文件, 先要创建目录逻辑
CREATE DIRECTORY PHOTO AS 'G:\oracle_photo';
GRANT READ, WRITE ON DIRECTORY PHOTO TO USER; -- 其他用户要使用该目录, 需要先赋权限
/
CREATE OR REPLACE PROCEDURE insertBlob(id VARCHAR2, imgFile VARCHAR2)
IS
  img_file    BFILE;
  img_blob    BLOB;
  lob_length  NUMBER;
BEGIN
  -- 先插入一个空值
  INSERT INTO person VALUES(id, empty_blob());
  SELECT  photo 
  INTO    img_blob 
  FROM    person
  WHERE   pid = id;
  -- 读取img_file中的内容
  img_file := bfilename('PHOTO', imgFile);
  DBMS_LOB.OPEN(img_file);
  lob_length := DBMS_LOB.GETLENGTH(img_file);
  DBMS_LOB.LOADFROMFILE(img_blob, img_file, lob_length);
  DBMS_LOB.CLOSE(img_file);
  COMMIT;
END;
/
-- 执行存储过程
EXEC insertBlob('1', '001.jpg')
/
SELECT *
FROM person
/

/* 属性类型
  - %TYPE
  - %ROWTYPE - 提供表示表中一行的记录类型
*/

/*
PL/SQL中取出序列的nextval, currval时, 可以不使用select语句, 可以类似:

DECLARE
  aa  INT;
BEGIN
  aa  := seq1.nextval;
  DBMS_OUTPUT.PUT_LINE('aa 的值是: ' || aa);
END;
/
*/
CREATE SEQUENCE seq1
START WITH 1
INCREMENT BY 1;

DECLARE
  aa  INT;
BEGIN
  aa  := seq1.nextval;
  DBMS_OUTPUT.PUT_LINE('aa 的值是: ' || aa);
END;
/