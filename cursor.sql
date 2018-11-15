set SERVEROUTPUT ON;
/* 游标
逐行处理查询结果, 已变成的方式访问数据

游标的类型:
1. 隐式游标: 在pl/sql程序中执行DML SQL语句时自动创建隐式游标
    * 在PL/SQL中使用DML语句时自动创建隐式游标
    * 隐式游标自动声明, 打开和关闭, 名为SQL
    * 通过检查隐式游标的属性可以获得最近执行的DML语句的信息
    * 隐式游标的属性有:
      - %FOUND      - SQL语句影响了一行或多行时为TRUE
      - %NOTFOUND   - SQL语句没有影响任何行时为TRUE
      - %ROWCOUNT   - SQL语句影响的行数
      - %ISOPEN     - 游标是否打开, 始终为FALSE
2. 显式游标: 显示游标用于处理返回多行的查询
3. REF游标: REF游标用于处理运行时才能确定的动态SQL查询的结果
*/
CREATE TABLE email_a (email VARCHAR2(100));
CREATE TABLE email_b (email VARCHAR2(100));

INSERT INTO email_a VALUES ('1@163.com');
INSERT INTO email_a VALUES ('2@163.com');
INSERT INTO email_a VALUES ('3@163.com');
INSERT INTO email_a VALUES ('4@163.com');

INSERT INTO email_b VALUES ('1@163.com');
INSERT INTO email_b VALUES ('1@163.com');
INSERT INTO email_b VALUES ('6@163.com');
INSERT INTO email_b VALUES ('ab@163.com');
COMMIT;

-- 隐式游标
BEGIN
  update student set sage = sage + 10 where sno > 50;
  if sql%found then
    dbms_output.put_line('更新了记录');
  else
    dbms_output.put_line('没有更新');
  end if;
  dbms_output.put_line('更新了' || sql%rowcount || '行');
END;
/
rollback;

declare
  sname1 varchar2(10);
begin
  select sname into sname1
  from student;
  dbms_output.put_line(sname1);
exception
  when too_many_rows then
    dbms_output.put_line('取出的名字多于一个');
end;
/

-- 显式游标在PL/SQL块的声明部分定义查询. 该查询可以返回多行
-- 显式有标的操作过程
-- 声明 -> 打开 -> 使用 -> 取出记录 -> 关闭 -> deallocate游标
declare
  stu1 student%rowtype;
  cursor mycur is select * from student;
begin
  open mycur;
  fetch mycur into stu1;
  while mycur%found loop
    dbms_output.put_line('sno: ' || stu1.sno || ' sname: ' || stu1.sname || ' sage: ' || stu1.sage);
    fetch mycur into stu1;
  end loop;
  close mycur;
end;
/
-- 声明显式游标时可以带参数以提高灵活性
declare
  sno1 student.sno%type;
  stu1 student%rowtype;
  cursor mycur(input_no number) is select * from student where sno > input_no;
begin
  sno1 := &s_no;
  open mycur(sno1);
  fetch mycur into stu1;
  while mycur%found loop
    dbms_output.put_line('sno: ' || stu1.sno || ' sname: ' || stu1.sname || ' sage: ' || stu1.sage);
    fetch mycur into stu1;
  end loop;
  close mycur;
end;
/

-- 使用游标删除或更新活动集中的行
-- 声明游标时必须使用select ... for update
declare
  stu1 student%rowtype;
  cursor mycur is select * from student where sno = 2 or sno = 3 for update;
begin
  open mycur;
  fetch mycur into stu1;
  while mycur%found loop
    update student set sno = sno + 100 where current of mycur;
    dbms_output.put_line('sno: ' || stu1.sno || ' sname: ' || stu1.sname || ' sage: ' || stu1.sage);
    fetch mycur into stu1;
  end loop;
  close mycur;
end;
/
rollback;

-- 循环游标用于简化游标处理代码, 但只能用于查询
-- 当用户需要从游标中提取所有记录时使用
declare
  stu1 student%rowtype;
  cursor mycur is select * from student;
begin
  for cur_2 in mycur loop
    dbms_output.put_line('sno: ' || cur_2.sno || ' sname: ' || cur_2.sname || ' sage: ' || cur_2.sage);
  end loop;
end;
/