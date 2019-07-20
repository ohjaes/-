--ddl
--1. create
create table tbl (
    no number(3),
    name varchar2(10),
    birth date
);
desc tbl;
select * from tbl;

create table tbl (
    no number(3),
    name varchar2(10),
    birth date
);   --���� ���̺���� �� ���� �� ����.
drop table tbl; --table �������� ���� �� drop�� delete �����ض�   drop�� �����ͺ��̽��� �ٷ�� delete�� �����͸� �ٷ��.
drop table tbl2;
create table tbl2 (
    no number(3,1) default 0,
    name varchar2(10) default '�ƹ���',
    birth date default sysdate
);   
insert into tbl (no, name, birth)
values (1.55, 'ȫ�浿', sysdate);
insert into tbl (no)
values (1);
insert into tbl values (123,'gf',sysdate);
select * from tbl;

insert into tbl2 (no, name, birth)
values (1.55, 'ȫ�浿', sysdate);
insert into tbl2 (no)
values (1);
select * from tbl2;  --default �־ ������ ��� �ٸ� null�ȳ���

create table ���̺� (
    ��ȣ number(3,1) default 0,
    �̸� varchar2(10) default '�ƹ���',
    ���� date default sysdate
);   
desc ���̺�;
insert into ���̺� (��ȣ, �̸�, ����)
values (1, 'ȫ�浿', sysdate);
select * from ���̺�;  --�����ϸ� �ѱ۷� ������ ���� �����Ƽ�

--�ӽ� ���̺� �����   �̰� ���� �Ⱦ�
create global temporary table tmp (
    no number,     --���� ���ָ� ���� ���� ����
    name varchar2(10))
    on commit delete rows;  --commit�� ������ �� �� ����
insert into tmp values(1,'test'); --������ ������ �÷� �Ƚᵵ �� ������ �������
insert into tmp(no) values(5);  --���� �ٸ��� �̷��� �ؾ���
select * from tmp;
commit;
select * from tmp;  -- commit ������ �� �� ��������

select temporary, duration from user_tables where table_name = 'TMP';
select temporary, duration from user_tables where table_name = 'EMP';

--table �����ϱ� ��û �߿��� ctas
--1. ��ü �����ϱ�
create table dept3 as 
    select * from dept2;
select * from dept2;
select * from dept3;

--2.�Ϻ� �����ϱ�
create table dept4 as 
    select dcode, dname from dept2;
select * from dept2;
select * from dept4;
delete from dept4; --���� ���ְ� �̷��� �ϸ� ���� �� ����
select * from dept4;

--3.������ ����
create table dept5 as 
    select dcode, dname from dept2
    where 1=2;  --������ 1=2�� ���� �ȵŴϱ� �´°� ���� �׷��� ������ ���� ������ �����´�.
select * from dept5;

create table dept6 as 
    select * from dept2
    where dcode in (1000,1001,1002);  
select * from dept6;

--���̺�� �ٲٱ�
rename dept6 to depts;
select * from depts;
rename depts to dept6;

--��������� update ���� ������ alter
alter table dept6 add (loc varchar2(10));   --loc�̶�� varchar2 �߰�
alter table dept6 add (loc2 varchar2(10) default '��õ');  --�÷� �߰��Ҷ� ������ null�� ���ϱ� ����Ʈ �� ��
desc dept6;
select * from dept6;      

--�÷��� �̸��� �ٲٴ� ��    �̰� ��û ���� ��
alter table dept6 rename COLUMN LOC2 to AREA1;
alter table dept6 rename column loc to position;
select * from dept6;

--�÷� Ÿ�԰� ũ�� �ٲٴ� ��  �����ϴ°Ŷ� modify
alter table dept6 modify (area varchar2(20) default 'asd');
desc dept6;

--�÷� ��ü�� �����°�             alter�� �� �����ض� �߿��ϴ�.
alter table dept6 drop column position;

--delete�� ���� ������ �״�� �ְ� �ȿ� �����͸� �������µ� truncate�� �������� �� ���ְ� ������ ���ܵд�. drop�� �ƿ� �� ���ִ°�

select * from dept6;
delete from dept6 where dcode = 1000;
select * from dept6;

select * from dept6;
truncate table dept6;  --Ʈ��Ĺ�� �� �Ⱦ���.
select * from dept6;

drop table dept6;
select * from dept6;  --table ���������� ��������.

--�б� ���� ���̺� �����
create table abc(
    no number,
    name varchar2(10)
);
insert into abc values (1, 'aaa' );
select * from abc;
commit;

alter table abc read only;  --abc���̺��� �б� �������� ����� ��ɾ�
select * from abc;  --select�� ����������
insert into abc values (3, '�ФФ�' );  --�̰� ������� �ֳ��ϸ� �б����� ���̺��̶�
alter table abc add (loc varchar2(10) default '��õ');  --�̰͵� �б����� ���̺��̶� �ȸ��� ������  drop�� �Դ´�.
alter table abc read write;   --�ٽ� �а� ���� �����ϰ� �ٲ۰�
select * from abc;
insert into abc (no, loc, name) values (4,'la','ddd');  --insert�� �÷� ���� ���ָ� ���� �ٲ㵵 ���̺� �°� ����.
select * from abc;

select table_name, read_only from user_tables where table_name = 'EMP';  --�б� ���� ���̺����� Ȯ���� �� ����.

-- ���� �÷�    3���� �÷��� ù������ �ι����� ���� �÷�
create table vt(
    c1 number,
    c2 number,
    c3 number GENERATED ALWAYS as (c1 + c2)  --generated always as�� �����÷� ����� ��ɾ�
); --c1�� c2�� ��¥ �÷��̰� c3�� �����÷�
desc vt;
insert into vt values(1,2,3);  --�̰� �������. ���� �÷��� insert�� ������
insert into vt values(1,2);   --�̰͵� �������. �÷��� ������ �ȸ¾Ƽ�.
insert into vt(c1,c2) values(1,2); --�̰� ����. �̷��� �ݵ�� �÷� ��� �־��
select * from vt;

--������ ���� update
update vt SET c1 = 5;   --c1�÷��� �� 5�� �ٲٴ°�

--���� �÷� �߰��ϱ�
alter table vt add (c4 number generated always as ((c1*12) + c2));  --number�������� �ڿ� �ֵ鿡 ���ؼ� �ڵ����� �������� ������ ���°� ��Ģ
select * from vt;
insert into vt (c1, c2) values (10,20);

select * from SYS.user_tab_columns where table_name = 'VT';


create table sale(
  no number,
  code char(4),
  date char(8),
  qty number,
  bungi number(1) generated always as (
    case
        when substr(date,5,2) in ('01','02','03') then 1
        when substr(date,5,2) in ('04','05','06') then 2
        when substr(date,5,2) in ('07','08','09') then 3
        else 4
    end
  ) virtual
);       --�ĺ��ڿ� ������ �ִ�. ���⼭�� date�� ������ �ٸ� �̸����� �ٲ��ָ� �´�

create table sale(
  no number,
  code char(4),
  pdate char(8),
  qty number,
  bungi number(1) generated always as (
    case
        when substr(pdate,5,2) in ('01','02','03') then 1
        when substr(pdate,5,2) in ('04','05','06') then 2
        when substr(pdate,5,2) in ('07','08','09') then 3
        else 4
    end
  ) virtual
); 
insert into sale(no, code, pdate, qty) values (1,'100','20180128',10);
insert into sale(no, code, pdate, qty) values (2,'200','20180528',20);
insert into sale(no, code, pdate, qty) values (3,'300','20180828',30);
insert into sale(no, code, pdate, qty) values (4,'400','20181128',40);
select * from sale;

--sid?


