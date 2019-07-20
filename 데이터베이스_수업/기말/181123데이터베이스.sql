--ddl���� ������ alter dml������ update

--INSERT
select * from dept2;
insert into dept2(dcode, dname, pdept, area) values(9000,'temp1',1006,'temp area');
insert into dept2 values(9001,'temp2',1006,'temp area');  --�÷��� �Ⱦ��� ���̺� ������ �°� �־��ָ� �ȴ� �� ������ �� ��.
insert into dept2(dcode,dname,area) values(9002,'temp3','temp area');  --pdept���� �ֱ� ���� ��� �÷��� ���� �ٲٸ� ������ ������ �ٲ㼭 �־��ָ� �ȴ�.
--��¥ �Է��ϱ�
select * from professor;
insert into professor(profno, name, id, position, pay, hiredate) values(5001,'James Bond','Love_me','a full professor',500,'2018-11-23'); --��¥ �ִ°� ���� ������ ������ �� �� �ִ�. 
alter session set nls_date_format = 'YYYY-MM-DD:HH24:MI:SS';
select * from professor;  --session �ٲ㼭 ���°� ����ó�� �޶����ִ�.
alter session set nls_date_format = 'YY/MM/DD'; --���� ���·� ���ư��� ��ɾ�

--number ���ϱ�
create table TT(
    no1 number,
    no2 number(3),
    no3 number(3,2)
);
desc TT;
insert into TT values(1,1,1);
TRUNCATE table TT;  --������ ������
insert into TT values(1,1,1);
insert into TT values(1.676,1.676,1.676);
select * from TT;     --number(3)�� ������ �Ҽ��κ� �ڸ��� ������.
insert into TT values(-1.6,-1.6,-1.6);
select * from TT;
insert into TT values(1.5678,1.5678,1.5678);
select * from TT;  --number�� �Ҽ��� �� ���, number(3)�� �ڸ��� ������ �ݿø����� �÷�����, number(3,2)�� �Ҽ��� ���ڸ����� ��Ÿ���� 3���ڸ����� �ݿø�
--2�ڸ��� ���߷��� to_character�� ���ڸ� ������� �Ѵ�.

--ITAS(insert table as)     insert�������� �ϱ� �����Ƽ�
create table prof3 as
    select * from professor where 1=2;    --������ ��������
insert into prof3
    select * from professor;  --�̰Ŷ� �������� ��ģ�� ������ ������ ��ü �ѹ��� �������°�

create table prof4 as
    select profno, name, pay from professor where 1 = 2;
insert into prof4 
    select profno, name, pay from professor where profno > 4000;


create table p1(
    profno number,
    name varchar2(25)
);
create table p2(
    profno number,
    name varchar2(25)
);
insert all 
    when profno between 1000 and 1999 then
        into p1 values(profno, name)
    when profno between 2000 and 2999 then
        into p2 values(profno, name)
    select profno, name from professor;   --���� ���� insert ���൵ ������ �� ���� �Ϸ��� insert all �� �Ŵ�.
select * from p1;
select * from p2;

insert all    --�̰� Ȱ�뵵 ����.
    into p1 values(profno, name)
    into p2 values(profno, name)
    select profno, name from professor where profno between 3000 and 3999; --������ �����͸� 2���� table�� �Ѳ����� ���� ��.


--update
select * from p1;
update p1 set name = '???';   --���� ���ָ� ��� name�� ???�� �ٲ��

select * from p2;
update p2 set name = '???' where profno = 2001;

rename professor to prof;  --professor�� ���� �����Ƽ� ���̺� �̸� �ٲ� ��

select * from prof where position = 'assistant professor';
update prof set bonus = 200 where position = 'assistant professor';

select position from prof where name = 'Sharon Stone'; --���н����� position�� Ȯ���Ѵ�
select name, position, pay from prof where position = 'instructor'; --position�� instructor�� ������� pay�� 250 �Ѵ��� Ȯ��
--sub������ ���� 2�� �ѹ��� ����
select name, position, pay from prof
    where position = (
        select position from prof where name = 'Sharon Stone'
    );

update prof set pay = pay * 1.15 
    where position = (
        select position from prof where name = 'Sharon Stone'
    )
    and pay < 250;   --250���� ���� ������ ���н���� ���� ����� �޿��� 15% �ö���.
    
    

select * from p1;
delete from p1;
select * from p2;
delete from p2 where profno = 2001;
select * from p2;
--���̺� ����� �����ϰ� �����ϰ� ������ ����ְ� ������ �����ϰ� ������ ���� �� �ִ�.

--4. MERGE
create table c1(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
create table c2(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
create table ctotal(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
insert into c1 values ('111111',1000,2,1000);
insert into c1 values ('111111',1001,2,1000);
insert into c1 values ('111111',1002,1,500);

insert into c2 values ('121212',1000,3,1500);
insert into c2 values ('121212',1001,4,2000);
insert into c2 values ('121212',1003,1,500);
commit;
select * from c1;
select * from c2;
--����
merge into ctotal tot   --tot�� ���
using c1 c1
on (tot.cdate = c1.cdate)
when matched then
    update set tot.cno = c1.cno
when not matched then
    insert values(c1.cdate, c1.cno, c1.ctime, c1.charge);   --ctotal�� ����־����ϱ� ������ �´°� ����. �׷��� �ؿ� ���� ���� �׷��� c1���̺��� �����͵� �� insert����.

select * from ctotal;

merge into ctotal tot   --tot�� ���
using c2 c2
on (tot.cdate = c2.cdate)
when matched then
    update set tot.cno = c2.cno
when not matched then
    insert values(c2.cdate, c2.cno, c2.ctime, c2.charge);

select * from ctotal;

insert into c1 values ('111111',1004,2,500);
select * from c1;  
commit;

truncate table ctotal;

merge into ctotal tot   --tot�� ���
using c1 c1
on (tot.cno = c1.cno)
when matched then
    update set tot.cdate = c1.cdate
when not matched then
    insert values(c1.cdate, c1.cno, c1.ctime, c1.charge);   --total������� �׳� 4���� ���������� ����

select * from ctotal;

merge into ctotal tot   --tot�� ���
using c2 c2
on (tot.cno = c2.cno)
when matched then
    update set tot.cdate = c2.cdate
when not matched then
    insert values(c2.cdate, c2.cno, c2.ctime, c2.charge);  
select * from ctotal;  --5���� ���� ������ 1000���� 1001���� update�� �� ��.   ������ ������ ��¥�� update������ ������ �������� ���ؼ� �� ���� �ְ� �پ��ϴϱ� �� ����� �ؿ� ���ָ� �ȴ�.

--update join ����



----------------���� ����-----------------------------------------------------------------------------------
--not null
--unique
--primary key:  not null�̸鼭 unique�ؾ���,  �� �߿���
--foreign key: �����͸� ���� �� ���� ���� �� �ִ�
--check

--constraint ������ �� �� �޸� ����!! �����ؾ���    ���÷��� �������� �Ŵ°Ŷ�  �޸��� �÷��� �÷����̿� ���°Ŵ�
--�߿�
create table aa(
    no number(4) constraint aa_no_pk primary key,
    name varchar2(20) not null,
    jumin varchar2(13) constraint aa_jm_nn not null       --�̸� �ذ�
                        unique,                           --�̸� �� �ذ�
    loc number(1) check(loc<5),
    deptno varchar2(6) constraint aa_dn_fk
                    references dept2(dcode)       --���� dcode�� ũ�Ⱑ varchar2(6)�̶� ���ƾ� �Ѵ�
);
desc aa;
select * from dept2;   --decode��ȣ Ȯ��
insert into aa values(1, 'ȫ�浿', 1234567891234,3,1000);
select * from aa;

--�ؿ� �κ� �� Ȯ���غ���
insert into aa values(1, 'ȫ�浿', 1234567891234,3,1000);  --�̰� ���� �����̸Ӹ�Ű�� �� �����ϱ� �ȵǴ°Ŵ�.
insert into aa values(2, 'ȫ�浿', 1234567891234,3,1000);  --�̰͵� ������ �ֹι�ȣ�� unique�� �����ߴ°Ŵ�
insert into aa values(2, 'ȫ�浿', 2234567891234,3,1000);
insert into aa values(3, 'ȫ�浿', 2234567891234,7,1000);  --5���Ϸ� �ִ´ٰ� �Ǿ��ִµ� 7 �־ ����
insert into aa values(4, 'ȫ�浿', 4234567891234,3,5555);  --5555�� dept2�� dcode�� ���� �Ŵ�
