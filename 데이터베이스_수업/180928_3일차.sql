--�̷�: 
--���� dbms�� ��ü����dbms�� ����
--���̺�� �Ǿ������� �����񿥿���
--�̸��� �ѹ��̶� ���͵� �� ������ ��񿥿���  join�Ἥ �ٿ������°Ŷ� ������
--�����񿥿����� ��ü��°��� ���� �ϴ°�? �̰� ����� ���� �����񿥿�����������
--ddl:������ ���Ǿ�, dml:���������۾�, dcl:������ �����
--select ������ �� dml
--sql�� �������� ���
--ddl�� dml �����ض� delete drop���
--Ʈ�����? ã�ƺ���
--dcl: ������ ������ commit�� �Ἥ ��� �����Ű�°�,roll back�� ó�����·� ����Ű�� ��.���

--�ǽ�:
--instr p76 Ư������ ã���ִ°�
select * from emp where deptno = 10;
select hiredate,instr(hiredate,'/') from emp where deptno = 10; --ù���� ��ġ���� / �� ������ ��ġ�� �˷��ش�.
select hiredate,instr(hiredate,'/',1,1) from emp where deptno = 10;
select hiredate,instr(hiredate,'/',1,2) from emp where deptno = 10; --ù���� ��ġ���� /�� 2���� ������ ��ġ�� �˷��ش�.
select 'A-B-C-D', instr('A-B-C-D','-',1,3) from dual;
select 'A-B-C-D', instr('A-B-C-D','-',-1,3) from dual;  --  -1�� �ǵڿ������� 3���� ã�� ��  substr�̶� ���� �� �����ض�? substr�̶� instr - �־��� �� �ߺ���
select 'A-B-C-D', instr('A-B-C-D','-',-6,2) from dual;  -- substr�̶� �� ���غ�  ��°��� ���ڰ� �ƴ� ��ġ���� ������!!!
select tel from student where deptno1 = 201;
select tel, instr(tel,')') from student where deptno1 = 201; --������ȣ �ڿ� ) ã�ƿ���
select name, tel, instr(tel,'3') from student where deptno1 = 101;
select name, tel, instr(tel,'3',1,2) from student where deptno1 = 101;
select name, tel, instr(tel,'8',1,2) from student where deptno1 = 101;
select tel, substr(tel,3,2) from student where deptno1 = 101;  --3���� ��ġ���� 2�� �̾ƿ���
select name,substr(tel,1,instr(tel,')')-1) from student where deptno1 = 101;  --������ȣ�� �̱�!!
--LPAD, RPAD �Լ�
select name, id,lpad(id,10) from student where deptno1 = 201;  --10�ڸ��� ä��� ������ ����
select name, id,lpad(id,10,'*') from student where deptno1 = 201;  --10�ڸ��� ä��� �������� *�� ä��� ��
select name, id,rpad(id,10,'*') from student where deptno1 = 201; 
select ename,substr('123456789',1,10-length(ename)) || ename from emp where deptno = 10;  --####�̲� �� ������.
select ename,concat(substr('123456789',1,10-length(ename)),ename) from emp where deptno = 10; --concat���� 3�� ���̷��� concat�� concat�� �����.
--ltrim/rtrim
select ename, ltrim(ename, 'C') from emp where deptno = 10;  --c �� ��Ÿ�� ù���� ���ڸ� ���ش�.
select ename, rtrim(ename, 'R') from emp where deptno = 10;  --�ǿ����ʿ� �ִ� r�� ���ش�. Ŭ���� r�� �Ⱦ��� ����.
select name,substr(tel,1,instr(tel,')')-1),rtrim(substr(tel,1,instr(tel,')')),')') from student where deptno1 = 101; --�̰� �� �ٽú��� trim���ε� ������ȣ�� ��°���
--replace    ���� �߿���!!!!!
select 'abcde',replace('abcde','bc','*') from dual;  --bc�� *�� �ٲٴ� ��.
select ename,replace(ename,substr(ename,1,2),'**') from emp where deptno = 10;
select jumin,replace(jumin,substr(jumin,7),'-*******') from student where deptno1 = 101; --�ֹι�ȣ ���ڸ� *�� �ٲٱ�.
---------------------���� ����. p79 substr instr���� , p81 lpad����, p82 rpad����, p84 replace����  ������ ����. ����� �ڵ� ĸ�� ���� �ѱۿ� �ٿ��� ����.

--���� ���� �Լ���,  sysdate�� �� �˾Ƶֶ�
--round, trunc(������ �Լ�)
select round(123.456) from dual;
select round(123.556) from dual;
select round(123.556,0) from dual;
select round(123.556,1) from dual;
select round(123.556,2) from dual;
select round(123.556,-1) from dual;  --  -������ ��� �Ǵ��� �˾Ƴ���
select round(123.556,-2) from dual;
select trunc(123.556) from dual;
select trunc(123.556,0) from dual;
select trunc(123.556,1) from dual;
select trunc(123.556,2) from dual;
select trunc(123.556,-1) from dual;
select trunc(123.556,-2) from dual;
--mod:������ ���ϴ� �Լ�, ceil: �ø��� �Լ�,floor: �����Լ�
select mod(10,3) from dual;
select ceil(0.33) from dual;
select ceil(-0.33) from dual;  --   -������ ��� �Ǵ��� ����
select floor(1.33) from dual;
select floor(-1.33) from dual;  --   -������ ��� �Ǵ��� ����
--rownum �� ��ȣ
select rownum,ename from emp;
select rownum, ceil(rownum/3), ename from emp; --rownum�� �׷��� �����ַ��� 3���� �����ַ��� 3���� ������ �ø��Լ� ��.
--power: ������ ���ϴ°�
select power(2,3) from dual;
select power(2,100) from dual;
--��¥ ���� �Լ�
select sysdate from dual;  -- sysdate�� ��ǻ���� �ý����� ��¥     --18/09/28
alter session set NLS_DATE_FORMAT = 'RRRR-MM-DD:HH24:MI:SS';      --  ��¥ ���� �ٲٷ��� ���°� ���� / �� �Ǿ��ִµ� -�� �ٲٷ���
select sysdate from dual;                                      --2018-09-28:10:40:36
alter session set NLS_DATE_FORMAT = 'RR/MM/DD';    --���� �������� ���ư���
--months_between : �ް� �� ���̿� ����� �־��� ���.  ��~�� �Ⱦ�
select months_between('18/08/31','18/09/30') from dual;  --ū���� �տ� ���;� �ȴ�. ū���� �ڿ� ���ͼ� -����
select months_between('18/09/30','18/08/31') from dual;  --����� �� ǥ��.
select months_between('18/09/30','18/09/01') from dual;  --�Ѵ��� 31�Ϸ� ����ؼ� �Ҽ��� ����. 
select ename, hiredate,months_between(sysdate,hiredate) from emp;
--add_months : �������� �ٿ��༭ �� �ĸ� �����.
select sysdate,add_months(sysdate,7) from dual;
--next_day
select sysdate,next_day(sysdate,'��') from dual; -- ���� ����� �������� ã���ִ� ��.
select sysdate,next_day('18/12/25','��') from dual;
--last_day : �� ���� ������ ���� ������
select last_day(sysdate) from dual;
select last_day(add_months(sysdate,1)) from dual; -- �������� ������ �� ���ϱ�
--round/ trunc
select round(sysdate),trunc(sysdate) from dual;    --12�ð� ������ �������� ��� �ȳ����� �������?  �ѹ� ã�ƺ���.
--����ȯ �Լ�  ##�߿��ϴ�. char varchar2 number date
--������ ��ȯ/ ����� ��ȯ
select 2 + '2' from dual;  --������ ���ڶ� ���� �� ���ϴµ� '2'�տ� to_number�� �ִ� ���� �׷��� �̰� ������ ��ȯ?
select 2 + to_number('2') from dual;  --����� ��ȯ?
select 2 + 'A' from dual;  --�̰� a��� ���ڶ� ���� �� ����. ���� ���ڰ� �ƴ϶�.
-- to_char to_number to_date      p102���� ��¥�� ���ڷ� �ٲٴ� ��

--��¥�� ���ڷ� �ٲٴ� �� rrrr yy rr year�� ������ ��� ���� mm mon month�� ������ ��� ���� dd day ddth
--p105 
select sysdate, to_char(sysdate,'rrrr-mm-dd') from dual;
select sysdate, to_char(sysdate,'year-month-ddth') from dual; --��� �����°� �ٸ��ϱ� �ѹ� �غ���.
--p105 ���� �غ���
select name,birthday from student where to_char(birthday,'mm')='01'; --������ 1���� ����� �̾ƿ���. substr���� �ص� ����� ����.
--p106
select name,birthday from student where to_char(birthday,'mm') in('01','02');  --in �Ǵ� or �ᵵ ������ in�� ���� ������.
--p107  ���ڸ� ���ڷ� �ٲٴ� ��    9�� �ڸ����� �ǹ��Ѵ�.
select empno,ename,sal,to_char((sal*12)+comm,'$99,999.99') from emp where ename='ALLEN';  --õ�ڸ� ���� , ��� �Ҽ��� ��� �տ� �޶� ���
select name,pay,bonus,nvl(bonus,0),(pay*12)+bonus,(pay*12)+nvl(bonus,0) from professor where deptno = 201;  --bonus�� null�� �־ ����� �ٷ� �ȵ�
select to_char((pay*12)+nvl(bonus,0)) from professor;
select to_char(months_between(sysdate,hiredate),'999.9') from emp;
--p108���� ����ȯ �غ���

select '18/09/28' from dual;   --�̰� ��¥�� �ƴϰ� �׳� ������.
select to_date('18-09-28') from dual;  --�̷��� �ؾ� ���ڰ� ��¥�� �ȴ�.











