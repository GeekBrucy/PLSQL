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
  - LOOP 循环
  - WHILE 循环
  - FOR 循环
*/

/* 顺序控制
  - GOTO 语句
  - NULL 语句
*/