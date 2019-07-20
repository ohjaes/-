--sql�� ����ϱ�
--select��
select * from emp;
select *
from emp;
select empno,ename,job,mgr from emp;
select empno,ename from emp;
--������ ��� �Ǿ��ֳ� ���� ���
desc emp;
--ǥ���� ����ϱ�
select * from dept;
--���ڴ� �⺻ ��������, ���ڴ� ������ ����, �׸��� ū����ǥ ���� �ȵǰ� ��������ǥ ��ߵȴ�.���ڿ� �����ʹ� ������ Ȭ����ǥ.
select dname, '���',1 from dept;
select "���" from dept;
--���⼭ ū����ǥ ���µ� �̷��� ���� ū����ǥ�� ���̸����� ��. as ��������.
select dname, '���'"���12" from dept;  
select dname, '���'as"���12",1 from dept;
select dname, '���"����' as "���12",1"����" from dept; --���۽�Ʈ���� ����ϱ� ���ؼ� ������ ��?
select dname, Q'[it's deptno]','test' as �׽�Ʈ from dept; --�׽�Ʈ�� ����ǥ �Ƚᵵ ������ �տ� �����ʹ� �׻� Ȭ����ǥ �����
select distinct deptno from emp; --���еǴ� �͵鸸 �̴°� == �ߺ������ϴ°� distinct
select distinct deptno from emp order by deptno; --order by ���� �ִ°�.
select distinct deptno from emp order by deptno desc; --desc�� �������� asc�� ������������ default��.
select distinct deptno from emp order by 1; --1�ᵵ ���� �ɼ�����? ����ȣ ���� �ȴ�.
select job,ename from emp;
select distinct job,ename from emp; --�ΰ��� �Ἥ �ΰ� ��� ��ġ�� �ʴ� �� ���� ���̴�
select distinct job,ename from emp order by job;
select distinct job,ename from emp order by job, ename; --order by ������ ������� 1������ 2�������̴�.
select distinct job,ename from emp order by job, ename desc; --�̷��� �ϸ� ename�� desc�� �Ѵ�.  1�������� ��������, 2�������� ������������ �ȴٴ� ������.
select distinct job,ename from emp order by 1,2 desc;  --�̸���� �� ��ȣ �ᵵ �ȴ�.

--���� ���ľ��� �ӵ��� �������� �Ⱦ��� �� ����.

--���� ������
select ename,job from emp;
select ename|| job from emp;  --��ĭ�� ����� �ٿ���.
select ename|| job as "����� ����" from emp;
select ename||' '||job as "����� ����" from emp; --���鹮�� �־ ��ĭ �� ��.
select ename||'"s job is '||job as "����� ����" from emp; -- ���۽�Ʈ���� ��� ��.
select ename||Q'['s job is ]'||job as "����� ����" from emp;

--����      row�� record��� ��
select * from emp where ename = 'SMITH'; --���� ������ ��ҹ��� ���ƾ���.
select * from emp where deptno >= 20; --���ڴ� ����ǥ ���ڴ� ����ǥ �ʿ����.
select * from emp where empno = 7369;
select * from emp where empno = '7369'; --���ڴ� ����ǥ �ᵵ �� ã�´�. ���ڴ� �ڵ������� ����ȯ ���ش�.
select * from emp where hiredate ='1980-12-17';
select * from emp where hiredate ='19801217';
select * from emp where hiredate ='1980/12/17';
select * from emp where hiredate ='80-12-17';  --���� �����ʹ� 1980�� �̷��� �־ �ȵ����� 19���� ���� �����͸� ���ð��̴� �ؿ����� ����.
select * from emp where hiredate ='80/12/17';
--alter session set nls_date_format='YY-MM-DD'; ��¥ ���� �ٲٴ°�
alter session set nls_date_format='YYYY/MM/DD';
select * from emp where hiredate='1980-12-17';
--�׷��� ��¥�� �������°Ŷ� �����Ͷ� �ٸ� �� ���� �׷��� ���������� ��� �Ǿ��ֳ� ���°� ã�� �� ����.
select ename,hiredate from emp order by hiredate desc;

--�⺻������
select ename,sal,sal*12 as "����",(sal*12)*0.05 as "������ ����" from emp where deptno = 10; --�ʵ�� �ٷ� ���� ������ ��

--�� ������
select * from emp where sal >= 2450;
select * from emp where sal != 2450;
select * from emp where hiredate > '1980-12-17'; --�� �Ի��� ���� ū�ֵ�==������ �Ĺ�� ã�� ��.
select ename,sal,deptno from emp where hiredate > '1980-12-17'; --�� �Ի��� ���� ū�ֵ�==������ �Ĺ�� ã�� ��.
select ename, sal from emp where sal <= 3000 and sal >= 2000;  --and������
select ename, sal from emp where sal between 2000 and 3000; --���հ� ���ϴ°� between, 2000�̶� 3000�� �����Ѵ�. ���� ���̶� ����
select * from emp where ename = 'SMITH';
select * from emp where ename like 'S%';  --like���� %��ü�� ���� �ش� ���ڷ� �����ϴ� �� ã����
select * from emp where ename like '%R';  --like���� %��ü�� ���� �ش� ���ڷ� ������ �� ã����
select * from emp where ename like 'T%R';  --T�� �����ϰ� R�� �����°�
select * from emp where ename like '%AR%';  --�߰��� AR ����,  % % �̰� �ڸ��� ������ ����
select * from emp where ename like '_AR%';  -- ����� ���� ��ŭ �տ� �ƹ��ų� �;��Ѵ�. ���� 2��° �ڸ��� AR�� ���°� ã����

