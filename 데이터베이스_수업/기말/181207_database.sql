--index  :�⺻������ ������������ �����.

--unique index  :�ߺ����� ������ �ε���, unique key�ɸ��ֵ����� unique index�Ŵ°� �Ϲ���, ����ũ�ε����� ���ݺ��� �߰��Ǵ� �ֵ��� ����ũ�ؾ���,����ũ�ε��� ���̴� �Ⱦ�
select * from dept2;
create unique index idx_dept2_dname on dept2(dname);  --dept2���̺� dname�� �ε��� �ִ°�
insert into dept2 values(9100,'AAA',1006,'XXX');  --�����̸��̶� AAA�� ��ġ�� �ʾƼ� �� ��
insert into dept2 values(9101,'AAA',1006,'YYY');  --�����̸��̶� AAA�� ���ļ� �ȵ� ����ũ �ε�������

--non-unique index  :  �ε����� ��κ� where���� ���� �͵��� �ε��� �Ǵ�.
create index idx_dept2_area on dept2(area);

--FBI(function based index)
select * from emp where sal + 100 = 1000;   --�̷��� �ε��� ȿ�� ���� ���� sal�� �ε��� �ɾ����� sal�� ���� sal + 100������ �ȵ� = index suppressing error
--index suppressing error
create index idx_emp_pay_fbi on emp(sal + 100);  --sal+100�� ���� �ε����� ����Ŵ�.

--������������ index ����� ��
create index idx_emp_sal on emp(sal desc);

--���� index
select * from emp;
select ename, job from emp where ename='SMITH' and job = 'CLERK';  --��ã���� full scan ���ؼ� �����ɸ�. �ϳ���(ename) �ε��� �ɸ� ename�� �ε����� ����ã���� job�� �� Ǯ��ĵ
create index idx_emp_ename_job on emp(ename,job);  --���� �ε��� ���� ��, ename�̳� job ���߿� ���� �����൵ ������µ� ������ �����°� �ٸ���, �׷��� �ӵ� ������ �Ϸ��� ���� �߿� p381,382

--bitmap   :����ڷ� ������, �м��뵥���ʹ� ��Ʈ���� ����. �����ϸ� ��ȭ ���� ������. �̰� �� �Ⱦ�

--�ε����� ���ǻ���: Ǯ��ĵ�� �ؾ��ϱ� ������ �ӵ��� �����ɷ��� DML�� ����ϴ�. �ε��� ����� �߰��� ������ ��ȭ������ �ε��� ������.
--                  insert�� ��� �Ǹ� ����� ���� ����� �ɰ���(�����Ͱ� �ٸ� �ε����� �Űܰ������̾�) = index split����
--                  data�� ����ٰ��ؼ� index�� �������� �ʴ´�.  update�� delete + insert������ �߻��Ѵ�
--                  Ÿ sql ���࿡ �ǿ����� �� �� �ִ�.
--**    dictionary �̸��� ���迡 �ȳ��� ex) user_ind_columns ������**

select * from user_ind_columns where table_name = 'EMP'; --�̰Ŵ� ���迡 �ȳ���

--rowid
select rowid,* from emp;  --�̰� ����
select rowid, empno, ename from emp;  --rowid�� �����Ϳ�����Ʈ��ȣ, ���Ϲ�ȣ, ��Ϲ�ȣ, row��ȣ�� ����


--�ܼ� view : ���Ȱ� ������ ����
create view vemp as
    select empno, ename, hiredate from emp;
select * from vemp;   --��ġ ���̺�ó�� ����. �ʿ��� �����鸸 ���� ��¥ ���̺��� �����(��� �����Ͱ� �ȵ���ְ� ����ɋ� ������ ���� �����ҷ����°ͻ�, �׷��� �����ٲ�� �䵵 ���� �ٲ�,����Ǿ�����)
create view vemp as
    select empno, ename, hiredate from emp;  --�̹� �־ ������
create or replace view vemp as
    select empno, ename, hiredate from emp;  --or replace�־ ����ȴ�.
--view���� ��������(�ε���������) ���ش�.
create index idx_vemp_ename on vemp(ename);  --��������. �������̺� ���� �������� ������� ������

--view�� ������ �����ϸ� �����δ� ������ ��, ���� �信���� ����
create table tbl(
    A number,
    B number
);
create or replace view vtbl as
    select A, B from tbl;
insert into vtbl values(1,2);
select * from vtbl;
select * from tbl;
rollback;  --Ʈ������. Ŀ���ϱ��� �ѹ��ϸ� Ŀ���ϱ� �� �������·� ���ư�  insert ������ ����Ǳ� ������ ���ư�

--with read only
create view view2 as
    select A, B from tbl with read only;  --�б� �������θ� �� �����
insert into view2 values(3,4);  --�б� ���� ��� ������ ���� �ȵȴ�.
insert into tbl values(3,4);  --�̷��� ���� ���̺� ������ ������ ���� �ϱ� ���� �信���� ����
select * from view2;
insert into vtbl values(5,6);  --��� �� �� �б� ������ �ƴ϶�.
select * from view2;
--with check option
create view view3 as 
    select A, B from tbl where A = 3 with check option;
update view3 set A = 5 where B = 4;   --with check option�ɾ���� A=3�� ���� �ٲ� �� ����.
update view3 set B = 6 where A = 3;   --�̰� ������Ʈ �ȴ�??  �̰� �ٽ� ���� a�� ������ �ְ� B�� �ٲٴ°Ŷ� �ȴ�??
select * from vtbl;
select * from view2;
select * from view3;

--���� ��
select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;  --�Ź� �̷��� �����ϰ� �θ��� ���������ϱ�
create or replace view v_emp_dept as
    select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;  --���պ�
select * from v_emp_dept;  --���������� �̷��� ���� �� �� �ְ� ��� ����� ���� ��.
select ename from v_emp_dept;

--���� ���԰����� �信�� �������� �����ϸ� �������� �϶�

--�ζ��� ��
select deptno, max(sal) from emp group by deptno; --�μ��� ������ �� ���� �� ���
select e.deptno,d.dname, max(sal) from emp e, dept d where e.deptno = d.deptno group by e.deptno, d.dname;
select e.deptno,d.dname, sal from (select deptno, max(sal) sal from emp group by deptno) e, dept d
    where e.deptno = d.deptno;   --from �ڿ� ������ �֤��°� �ζ��κ�   ù���� select�� max(sal)���� sal�� ��ߵǴ� �� ���ҵڿ� �̹� sal�� �׷�����ؼ�

create or replace view v_emp_dept2 as
    select e.deptno, d.dname, max(sal) sal from emp e, dept d where e.deptno = d.deptno group by e.deptno, d.dname;
select * from v_emp_dept2;

--view����:  drop�� ����  ��������°� ����Ʈ, �÷��̳� ���̺����°� ���
select * from user_views;
drop view view3;


--������
create sequence jno_seq 
    increment by 1 
    start with 100 
    maxvalue 110 
    minvalue 90 
    cycle 
    cache 2;

create table orders(
    no number(4),
    name varchar2(10),
    pname varchar2(20),
    qty number
);
insert into orders values(jno_seq.nextval, 'JAMES','APPLE',5);  --jno_seq.nextval�� ���� �� �ִ�? å���� �ٽ� ����
insert into orders values(jno_seq.nextval, 'FORD','BERRY',3);
select * from orders;

begin
    for i in 1..9 loop
        insert into orders values(jno_seq.nextval,'TEST','AAA',5);
    end loop;
    commit;
end;
/              


insert into orders values(jno_seq.nextval,'TESTx','xxx',5);
select * from orders;

select jno_seq.currval from dual;
select jno_seq.nextval from dual;

create sequence rev_seq increment by -2 minvalue 0 maxvalue 20 start with 10;
create table rev(no number);
insert into rev values (rev_seq.nextval);
select * from rev;
insert into rev values (rev_seq.nextval);
select * from rev;
insert into rev values (rev_seq.nextval);
insert into rev values (rev_seq.nextval);
insert into rev values (rev_seq.nextval);
insert into rev values (rev_seq.nextval);
insert into rev values (rev_seq.nextval); --���⼭ ������� �ּڰ��� 0�̶� �� ���� ���� �� �ִ´�. cycle�� ���༭

drop sequence test_seq;
create sequence test_seq;  --���� ����Ʈ�θ� ��������°�
select test_seq.nextval from dual;
select test_seq.nextval from dual;
select test_seq.nextval from dual;  --��� �������״µ� �߸��ؼ� �ٽ� 1���� �ϰ� �������� ����°� ���� ����

select test_seq.currval from dual;
--alter sequence test_seq increment by -2;
alter sequence test_seq increment by -8;   --test_seq�� �ּڰ��� 1�̶� 1������ �ٿ����Ѵ�. �̰� �� ��� 9���� -8�Ѱ���
select test_seq.currval from dual;
select test_seq.nextval from dual;
alter sequence test_seq increment by 1;  --�ٽ� �������� 1�� �ٲ���� �ö󰣴�. �ּڰ����� �ٿ����ϱ�
select test_seq.nextval from dual;


--���Ǿ�  :���̺���� ����� ���� ��
create synonym e for emp;   --rename�� emp��ü�� �ٲ�°Ű� �̰Ŵ� e��� ��Ī���� �ϳ� ����°Ŵ�
select * from e;

create public synonym d2 for dept;  --��������. ������ ������ϴٰ� ���� cmd����  conn / as sysdba; grant create public synonym to hr; �ϸ� �ȴ�
create public synonym d2 for dept;   --���� �۵� �� ���̴�.

--������� �⸻���