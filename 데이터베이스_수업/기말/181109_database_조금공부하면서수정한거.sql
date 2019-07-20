--join
--oracle join�� ansi join �Ѵ� ����.
--��� �ɰ��� ���� ����ȭ��� �Ѵ�.
--�տ� �ִ� ���̺�(����)�� ����

--īƼ�� ������Ʈ(������)  ���󵵵Ǵ� ����
select * from emp;  --13
select * from dept;  --4
select * from emp, dept;   --�̰� 52���� ���´�. ���������� ���ٿ� �ѿ��� �� ����?
--ǥ�� ��� ansi
select * from emp cross join dept;  --īƼ�� ������Ʈ. 52��  īƼ�� ������Ʈ�� ���� �Ⱦ���.
--����Ŭ ���
select e.ename, d.dname from emp e, dept d;
select emp.ename, d.dname from emp e, dept d;  --���̰� ��������. ��Ī�� �Ἥ.

--equi join
select * from emp e, dept d where e.deptno = d.deptno;
select e.ename,e.deptno,d.dname from emp e, dept d where e.deptno = d.deptno;  --����Ŭ���
select e.ename,e.deptno,d.dname from emp e join dept d on e.deptno = d.deptno;  --ǥ�� ���
--ex2
select * from student;
select * from professor;
select s.name �л�, p.name ���� from student s, professor p where s.profno = p.profno; 
select * from student s join professor p on s.profno = p.profno; 
--ex3
select * from student;
select * from professor;
select * from department;
select s.name �л��̸�,d.dname �а���,p.name �����̸� from student s, department d, professor p where s.deptno1 = d.deptno and s.profno = p.profno;
select s.name �л��̸�,d.dname �а���,p.name �����̸� from student s join department d on s.deptno1 = d.deptno join professor p on s.profno = p.profno;
--ex4
select * from student s, professor p where s.profno = p.profno and s.deptno1 = 101;  --where�� ���� �߿���. �̰� ����������ȣ ã�� deptno1 101 ã�°Ŵ� where������ ���� �ӵ� ���̰� ����.
select * from student s join professor p on s.profno = p.profno and s.deptno1 = 101;  --on�ٷ� �������� ������ ������ �־���Ѵ�.
select * from student s join professor p on s.profno = p.profno where s.deptno1 = 101;

--non-equi join (����)
select * from customer;
select * from gift;
select c.gname, c.point, g.gname from customer c, gift g where c.point > g.g_start and c.point <= g.g_end;
select c.gname, c.point, g.gname from customer c, gift g where c.point between g.g_start and g.g_end;  --between���� �������� �� ����
select c.gname, c.point, g.gname from customer c join gift g on c.point between g.g_start and g.g_end;

--ex2
select * from student;
select * from score;
select * from hakjum;
select * from student s, score sc, hakjum h where s.studno = sc.studno and sc.total between  h.min_point and h.max_point;
select * from student s join score sc on s.studno = sc.studno join hakjum h on sc.total between  h.min_point and h.max_point;

--outer join p244  ���� ������ ����
select * from student;  --20��
select * from student s, professor p where s.profno = p.profno;  --15��,  �л��� 20���ε� ���������� 5���� ��� 15�� ��µ�. ���� ����� null�̸� ������.
select s.name,p.name from student s, professor p where s.profno = p.profno(+);   --���� �� �����͸� �� ���� �����ְڴٴ� �ǹ�  �̷��� �ϸ� 20�� ���´�
select s.name,p.name from student s left outer join professor p on s.profno = p.profno;  --������ ���� ����� �ݴ��̴�.  �̰Ŷ� ������ �ٽ� �غ��� �����ؼ� ����.

--ex2
select s.name,p.name, s.profno, p.profno from student s, professor p where s.profno(+) = p.profno order by 4;
select s.name,p.name from student s right outer join professor p on s.profno = p.profno;

--ex3
select s.name,p.name from student s full outer join professor p on s.profno = p.profno;  --���� �Ѵ�
select s.name,p.name from student s, professor p where s.profno = p.profno(+)
union
select s.name,p.name from student s, professor p where s.profno(+) = p.profno order by 1,2;  --ǥ�ع�Ŀ����� �ٷ� �ϴ°� ����

--����1   ���� �߸��Ǵ� ���� �� å���� �ٽ� Ȯ���ϱ�
select * 
from dept d, emp e 
where d.deptno = e.deptno(+) 
and e.deptno = 20;  --���� ��ü�� �μ��� 20�� �ֿ����� ���Ŵ�?



select e.empno, e.ename, e.sal, d.deptno AA,e.deptno BB from dept d, emp e 
where d.deptno = e.deptno(+) 
and e.deptno(+) = 20;  --���� �����鼭 20�� �μ��� ���ؼ��� ��� �������� null��


select e.empno, e.ename, e.sal, d.deptno, e.deptno from dept d left outer join emp e 
on d.deptno = e.deptno 
and e.deptno = 20;

select e.empno, e.ename, e.job, d.deptno, d.dname, d.loc from emp e left outer join dept d on 
(e.deptno = d.deptno and d.loc = 'CHICAGO') 
WHERE e.job = 'CLERK'; --�̰� ������ �ִ� ��


select e.empno, e.ename, e.job, d.deptno, d.dname, d.loc from emp e left outer join dept d on 
(e.deptno = d.deptno and d.loc = 'CHICAGO' and e.job = 'CLERK');  --��ü���� Ŭ���̸鼭 ��ī���� �ֵ� ���

--self join
select * from emp;  --13��
select e1.ename, e2.ename from emp e1, emp e2 where e1.mgr = e2.empno order by 1;
select e1.ename, e2.ename from emp e1 join emp e2 on e1.mgr = e2.empno order by 1;  --king�� ��簡 ��� ����� 12��
select e1.ename, nvl(e2.ename,'����') from emp e1 left outer join emp e2 on e1.mgr = e2.empno order by 1;

--�������� �����ֱ��� ����


--ddl  ���̺� �����
CREATE TABLE NEW_T(
    NO NUMBER(3),
    NAME VARCHAR2(10),
    BIRTH DATE
);  --VARCHAR2()�� ���ڸ�ŭ�� ������� �׷��� CHAR()�� ���ڸ�ŭ ������ ���� ������ ���
DESC NEW_T;

INSERT INTO NEW_T VALUES(1,'ȫ�浿', SYSDATE);

CREATE TABLE NEW_T2(
    NO NUMBER(3) DEFAULT 0,
    NAME VARCHAR2(10) DEFAULT 'NO NAME',
    BIRTH DATE DEFAULT SYSDATE
);  --����Ʈ�� �� ���ָ� �ڱⰡ �˾Ƽ� ����� ��

INSERT INTO NEW_T2(NO) VALUES(1);
SELECT * FROM NEW_T2;