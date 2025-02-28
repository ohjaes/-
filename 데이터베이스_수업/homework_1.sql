--1. SUBSTR/INSTR����
SELECT NAME, TEL,SUBSTR(TEL,1,INSTR(TEL,')')-1) "AREA CODE"
FROM STUDENT
WHERE DEPTNO1 = 201;
--2.LPAD ����
SELECT LPAD(ENAME, 9,SUBSTR('123456789',1,9-LENGTH(ENAME))) LPAD 
FROM EMP
WHERE DEPTNO = 10;
--3.RPAD ����
SELECT RPAD(ENAME, 9,SUBSTR('123456789',LENGTH(ENAME)+1,9-LENGTH(ENAME)))RPAD
FROM EMP
WHERE DEPTNO = 10;
--4.REPLACE ���� 1
SELECT ENAME, REPLACE(ENAME,SUBSTR(ENAME,3,2),'--') REPLACE
FROM EMP
WHERE DEPTNO = 20;
--5.REPLACE ���� 2
SELECT NAME, JUMIN, REPLACE(JUMIN,SUBSTR(JUMIN,7),'-/-/-/-') REPLACE
FROM STUDENT
WHERE DEPTNO1 = 101;
--6.REPLACE ���� 3
SELECT NAME, TEL, REPLACE(TEL,SUBSTR(TEL,5,3),'***') REPLACE
FROM STUDENT
WHERE DEPTNO1 = 102;
--7.REPLACE ���� 4
SELECT NAME, TEL, REPLACE(TEL,SUBSTR(TEL,INSTR(TEL,'-')+1,4),'****') REPLACE
FROM STUDENT
WHERE DEPTNO1 = 101;
--8.�� ��ȯ �Լ� ����: ��¥ ��ȯ�ϱ� 1
SELECT STUDNO, NAME, BIRTHDAY
FROM STUDENT
WHERE TO_CHAR(BIRTHDAY,'MM') = '01';
--9.�� ��ȯ �Լ� ����: ��¥ ��ȯ�ϱ� 2
SELECT EMPNO, ENAME, HIREDATE
FROM EMP
WHERE TO_CHAR(HIREDATE,'MM') IN('01','02','03');
--10.�� ��ȯ �Լ� ���� 3
SELECT EMPNO, ENAME, HIREDATE, (SAL*12+NVL(COMM,0)) SAL,
        (SAL*12+NVL(COMM,0))+(SAL*12+NVL(COMM,0))*0.15 "15% UP"
FROM EMP
WHERE NVL(COMM,99999) != 99999;
