--join
--oracle join과 ansi join 둘다 배운다.
--디비를 쪼개는 것을 정규화라고 한다.
--앞에 있는 테이블(선행)이 기준

--카티션 프러덕트(순서쌍)  몰라도되는 개념
select * from emp;  --13
select * from dept;  --4
select * from emp, dept;   --이건 52개가 나온다. 곱집합으로 한줄에 한열씩 다 나열?
--표준 방식 ansi
select * from emp cross join dept;  --카티션 프러덕트. 52개  카티션 프러덕트는 전혀 안쓴다.
--오라클 방식
select e.ename, d.dname from emp e, dept d;
select emp.ename, d.dname from emp e, dept d;  --ㅡ이건 에러난다. 별칭을 써서.

--equi join
select * from emp e, dept d where e.deptno = d.deptno;
select e.ename,e.deptno,d.dname from emp e, dept d where e.deptno = d.deptno;  --오라클방식
select e.ename,e.deptno,d.dname from emp e join dept d on e.deptno = d.deptno;  --표준 방식
--ex2
select * from student;
select * from professor;
select s.name 학생, p.name 교수 from student s, professor p where s.profno = p.profno; 
select * from student s join professor p on s.profno = p.profno; 
--ex3
select * from student;
select * from professor;
select * from department;
select s.name 학생이름,d.dname 학과명,p.name 교수이름 from student s, department d, professor p where s.deptno1 = d.deptno and s.profno = p.profno;
select s.name 학생이름,d.dname 학과명,p.name 교수이름 from student s join department d on s.deptno1 = d.deptno join professor p on s.profno = p.profno;
--ex4
select * from student s, professor p where s.profno = p.profno and s.deptno1 = 101;  --where절 순서 중요함. 이건 같은교수번호 찾고 deptno1 101 찾는거다 where순서에 따라 속도 차이가 난다.
select * from student s join professor p on s.profno = p.profno and s.deptno1 = 101;  --on바로 다음에는 조인의 조건을 넣어야한다.
select * from student s join professor p on s.profno = p.profno where s.deptno1 = 101;

--non-equi join (범위)
select * from customer;
select * from gift;
select c.gname, c.point, g.gname from customer c, gift g where c.point > g.g_start and c.point <= g.g_end;
select c.gname, c.point, g.gname from customer c, gift g where c.point between g.g_start and g.g_end;  --between보다 위에것이 더 빠름
select c.gname, c.point, g.gname from customer c join gift g on c.point between g.g_start and g.g_end;

--ex2
select * from student;
select * from score;
select * from hakjum;
select * from student s, score sc, hakjum h where s.studno = sc.studno and sc.total between  h.min_point and h.max_point;
select * from student s join score sc on s.studno = sc.studno join hakjum h on sc.total between  h.min_point and h.max_point;

--outer join p244  많이 쓰지는 않음
select * from student;  --20명
select * from student s, professor p where s.profno = p.profno;  --15명,  학생은 20명인데 지도교수가 5명은 없어서 15명 출력됨. 한쪽 결과가 null이면 버린다.
select s.name,p.name from student s, professor p where s.profno = p.profno(+);   --없는 쪽 데이터를 더 많이 보여주겠다는 의미  이렇게 하면 20명 나온다
select s.name,p.name from student s left outer join professor p on s.profno = p.profno;  --위에랑 쓰는 방식이 반대이다.  이거랑 위에꺼 다시 해보기 구별해서 보기.

--ex2
select s.name,p.name, s.profno, p.profno from student s, professor p where s.profno(+) = p.profno order by 4;
select s.name,p.name from student s right outer join professor p on s.profno = p.profno;

--ex3
select s.name,p.name from student s full outer join professor p on s.profno = p.profno;  --양쪽 둘다
select s.name,p.name from student s, professor p where s.profno = p.profno(+)
union
select s.name,p.name from student s, professor p where s.profno(+) = p.profno order by 1,2;  --표준방식에서는 바로 하는거 없다

--주의1   뭐가 잘못되는 건지 꼭 책보고 다시 확인하기
select * 
from dept d, emp e 
where d.deptno = e.deptno(+) 
and e.deptno = 20;  --조건 자체가 부서가 20인 애에서만 본거다?



select e.empno, e.ename, e.sal, d.deptno AA,e.deptno BB from dept d, emp e 
where d.deptno = e.deptno(+) 
and e.deptno(+) = 20;  --모든걸 뽑으면서 20인 부서에 대해서만 찍고 나머지는 null로


select e.empno, e.ename, e.sal, d.deptno, e.deptno from dept d left outer join emp e 
on d.deptno = e.deptno 
and e.deptno = 20;

select e.empno, e.ename, e.job, d.deptno, d.dname, d.loc from emp e left outer join dept d on 
(e.deptno = d.deptno and d.loc = 'CHICAGO') 
WHERE e.job = 'CLERK'; --이건 문제가 있는 것


select e.empno, e.ename, e.job, d.deptno, d.dname, d.loc from emp e left outer join dept d on 
(e.deptno = d.deptno and d.loc = 'CHICAGO' and e.job = 'CLERK');  --전체에서 클럭이면서 시카고인 애들 출력

--self join
select * from emp;  --13명
select e1.ename, e2.ename from emp e1, emp e2 where e1.mgr = e2.empno order by 1;
select e1.ename, e2.ename from emp e1 join emp e2 on e1.mgr = e2.empno order by 1;  --king은 상사가 없어서 여기는 12명
select e1.ename, nvl(e2.ename,'없음') from emp e1 left outer join emp e2 on e1.mgr = e2.empno order by 1;

--연습문제 다음주까지 제출


--ddl  테이블 만들기
CREATE TABLE NEW_T(
    NO NUMBER(3),
    NAME VARCHAR2(10),
    BIRTH DATE
);  --VARCHAR2()는 글자만큼만 공간사용 그런데 CHAR()는 숫자만큼 고정된 공간 무조건 사용
DESC NEW_T;

INSERT INTO NEW_T VALUES(1,'홍길동', SYSDATE);

CREATE TABLE NEW_T2(
    NO NUMBER(3) DEFAULT 0,
    NAME VARCHAR2(10) DEFAULT 'NO NAME',
    BIRTH DATE DEFAULT SYSDATE
);  --디폴트는 값 안주면 자기가 알아서 만드는 것

INSERT INTO NEW_T2(NO) VALUES(1);
SELECT * FROM NEW_T2;