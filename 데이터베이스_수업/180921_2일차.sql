--between a and b
select * from emp;
select empno,ename,sal,sal*12 as "����" from emp;
select empno,ename,sal,sal*12 as ���� from emp;
select empno,ename,sal,sal*12 ���� from emp;
select empno,ename,sal,sal*12 as "����" from emp where empno = 7369;
select empno,ename,sal,sal*12 as "����" from emp where ename = 'KING';  --''������ �˻� ����
select empno,ename,sal,sal*12 as "����" from emp where SAL > 2000;
select empno,ename,sal,sal*12 as "����" from emp where SAL > 2000 AND sal < 3000;
select empno,ename,sal,sal*12 as "����" from emp where SAL >= 2000 and sal <= 3000;
select empno,ename,sal,sal*12 as "����" from emp where sal between 2000 and 3000;  --between�� �����̴�.
select empno,ename,sal,sal*12 as "����" from emp where sal between 3000 and 2000;  --�̰� �ȵ� between�� ���� �۾ƾ���
select empno,ename from emp where ename between 'A' and 'C';   --�ؿ� ������ ��� �ٸ��� Ȯ���ϱ� �̰� c�� �����ϴ°͸� ã�°�?
select empno,ename from emp where ename between 'A' and 'CLARK';
select empno,ename from emp where ename between 'A' and 'D';
select ename, hiredate from emp where hiredate between '81/05/01' and '81/09/30';  --��¥�� ���䶧���� �˻��ҋ� �� ���� �ض�. �׸��� 81/05/01�� �� �۱⋚���� �տ��ٰ� �����.

--IN������
select ename,deptno from emp where deptno = 10;
select ename, deptno from emp where deptno = 10 or deptno = 20;
select ename, deptno from emp where deptno = 10 union select ename, deptno from emp where deptno = 20;  --union�̶�°͵� �ִµ� ���߿� ���.
select ename, deptno from emp where deptno in (10,20);  --10�� 20�� �͵� �̾��ش�.
select ename, deptno from emp where deptno <= 20;

--LIKE������  %:0���� ���Ѵ����, _:������ ������ 1����,    like = �̷� ���� ���� �̷��� ���� ���ƾ� ���� ���� �̰� ��󳻴°� ���蹮����.
select ename from emp where ename = 'KING'; --��Ȯ�� �Ѹ� �̾ƿö� ��
select * from emp where ename like 'S%';   --S�� �����ϴ� �� ��ã�ƿ�
select * from emp where ename like '%S';   --���� S�� �ִ°� �� ã�ƿ�
select * from emp where ename like '%S%';  --s�� ���ִ°� �� ã�ƿ�
select * from emp where ename like '%IT%';
select * from emp where ename like 'S_%';  --s�� �����ϰ� �ڿ� �ƹ��ڳ� �͵���
select * from emp where ename like 'S_I%';
select * from emp where ename like '_M%';
select ename, hiredate from emp where hiredate between '81/01/01' and '81/12/30';
select ename, hiredate from emp where hiredate like '81%';  --81��� ã�°�
select ename, hiredate from emp where hiredate like '___02%';
select ename, hiredate from emp where hiredate like '__/02%';

--is null  /  is not null
select ename,sal,comm,sal * 12 + comm from emp;  -- comm�� null�� �־ ���� ���ϰ� �ȴ�.
select ename,sal,comm from emp where comm = NULL;  --NULL�� ���� �ƴ϶� ã�� ���� ����. �˻� �Ұ�!!!.
select ename,sal,comm from emp where comm is null;  --null�� �͸� �̾ƿ��°�. ���߿� null�� 0���� �ٲ���Ѵ�.
select ename,sal,comm from emp where comm is not null;

--2�� �̻��� ���� �˻� and / or
select * from emp;
select ename,hiredate,sal from emp where hiredate >= '82/01/01' and sal >= 1300;   --��¥�� ''����Ѵ�. ���ھƴ�.
select ename,hiredate,sal from emp where hiredate >= '82/01/01' or sal >= 1300;
select ename,sal,comm from emp where sal >= 1000 and comm < 1000 or comm is null;  --and�� �켱������ �ؿ��� �ٸ�
select ename,sal,comm from emp where sal >= 1000 and (comm < 1000 or comm is null); 

--�ܺ� ������ �Է� ��� &
select * from emp where deptno = &NO;  --&NO�ϸ� ������ ��ȣ �Է��ϰ� â�ϳ� ��. ������ ���� �޾ƿ��°Ŵ�.
select * from &table;

--���� order by
select empno,ename,sal,hiredate from emp order by empno desc;
select empno,ename,sal,hiredate,deptno from emp order by sal desc;
select empno,ename,sal,hiredate,deptno from emp order by deptno,sal desc;
select empno,ename,sal,hiredate,deptno from emp order by 5,3 desc; --����ȣ�� �ᵵ ������ �Ȱ���.

--���տ�����
select ename,deptno from emp where deptno = 10
union
select ename,deptno from emp where deptno = 20;  --10�� 20 �̴°ǵ� or ���°Ŷ� �Ȱ����� �������� �������� union���ͻ�. ����� ����.

select studno,name,deptno1,1 from student where deptno1 = 101
union
select profno,name,deptno,2 from professor where deptno = 101;   --��ġ���� �÷� ���� ���ƾ��ϰ� ���ĵ� ���ƾ� ��ĥ �� ����. 1�� 2�� �л��� ���� ����. �׸��� union�� ��ġ�鼭 �ڵ����� ���ĵ�

select studno,name,deptno1,1 from student where deptno1 = 101
union all
select profno,name,deptno,2 from professor where deptno = 101;  --union all �� ���� ����
--union: �ߺ����� ���ְ� ���ı��� ����. �׷��� union�� ������ �������༭.
--union all: �ߺ� ����ϰ� ���� ������.
--union�� �� �Ⱦ��ϱ� �׳� �۷θ� �˰��־��.

--intersect������
select studno, name from student where deptno1 = 101
intersect
select studno, name from student where deptno2 = 201;  --1������ 101�̰� 2������ 201�� �л� �������°�.

select studno, name from student where deptno1 = 101
union
select studno, name from student where deptno2 = 201;  --�ߺ� �����ؼ� 5�� ����

select studno, name from student where deptno1 = 101
union all
select studno, name from student where deptno2 = 201;  --�ߺ� ���� ���ؼ� 6�� ����

select studno, name from student where deptno1 = 101
minus
select studno, name from student where deptno2 = 201;

------------------------------------------------ch2-------------------------------------------------------------------------
--�����Լ�
--(1) initcap():ù ���� �빮�ڷ� ��ȯ
    select ename,initcap(ename) from emp;
    select position, initcap(position) from professor;
--(2) lower/upper
    select ename, lower(ename),upper(ename) from emp;
--(3) length, lengthb
    select ename,length(ename),lengthb(ename) from emp;  --�����ڴ� �ѱ��ڰ� �� ����Ʈ��.
    select '���ϴ�',length('���ϴ�'),lengthb('���ϴ�') from dual;  --dual�̶�� �ý��ۿ� �ִ� �� ���̺� ���°���. ���ϴ�� emp�� ���� ������. �ѱ��� �ý��ۿ� ���� ����Ʈ �ٸ���.
    select ename, length(ename) from emp where length(ename) > length(&NAME);  --�޾ƿ��°� �������� �𸣱� ������ ��������!!!
    select ename, length(ename) from emp where length(ename) > length('&NAME');
--(4) concat()
    select ename,job,concat(ename,job) from emp where deptno = 10;
    select ename,job,concat(ename,job),ename || ' ' || job from emp where deptno = 10;
--(5) substr() / substrb()
    select substr('ABCDE',3,1) from dual;
    select substr('ABCDE',3,2) from dual;
    select substr('ABCDE',1) from dual;
    select substr('ABCDE',-3,2) from dual;
    select substr('ABCDE',-5,2) from dual;
    select substr('ABCDE',-1,4) from dual;
    select substr('ABCDE',-5,4) from dual;
    select name,jumin,substr(jumin,7,1) ���� from student;
    select name,jumin,substr(jumin,5,2) "��������" from student;   --�̰� �������ķ� ��µǹǷ� ������
    select name,jumin,substr(jumin,5,2)-1 �������� from student;   --�̰� ������ ���ķ� ��µǹǷ� ����   substr�� �̾Ƴ��°� ���ڴ�. ���⿡ -1�� �־ �ڵ����� ����ȯ�Ǽ� ���ڵ�.
    select '���ϴ�', substr('���ϴ�',2,1),substrb('���ϴ�',1,3),substrb('���ϴ�',4,3),substrb('���ϴ�',7,3) from dual;
    --00��00��00��
    