--between a and b
select * from emp;
select empno,ename,sal,sal*12 as "연봉" from emp;
select empno,ename,sal,sal*12 as 연봉 from emp;
select empno,ename,sal,sal*12 연봉 from emp;
select empno,ename,sal,sal*12 as "연봉" from emp where empno = 7369;
select empno,ename,sal,sal*12 as "연봉" from emp where ename = 'KING';  --''없으면 검색 못함
select empno,ename,sal,sal*12 as "연봉" from emp where SAL > 2000;
select empno,ename,sal,sal*12 as "연봉" from emp where SAL > 2000 AND sal < 3000;
select empno,ename,sal,sal*12 as "연봉" from emp where SAL >= 2000 and sal <= 3000;
select empno,ename,sal,sal*12 as "연봉" from emp where sal between 2000 and 3000;  --between은 포함이다.
select empno,ename,sal,sal*12 as "연봉" from emp where sal between 3000 and 2000;  --이건 안돼 between은 앞이 작아야함
select empno,ename from emp where ename between 'A' and 'C';   --밑에 쿼리랑 결과 다른거 확인하기 이건 c로 시작하는것만 찾는거?
select empno,ename from emp where ename between 'A' and 'CLARK';
select empno,ename from emp where ename between 'A' and 'D';
select ename, hiredate from emp where hiredate between '81/05/01' and '81/09/30';  --날짜는 포멧때문에 검색할떄 잘 보고 해라. 그리고 81/05/01이 더 작기떄문에 앞에다가 써야함.

--IN연산자
select ename,deptno from emp where deptno = 10;
select ename, deptno from emp where deptno = 10 or deptno = 20;
select ename, deptno from emp where deptno = 10 union select ename, deptno from emp where deptno = 20;  --union이라는것도 있는데 나중에 배움.
select ename, deptno from emp where deptno in (10,20);  --10과 20인 것들 뽑아준다.
select ename, deptno from emp where deptno <= 20;

--LIKE연산자  %:0에서 무한대까지, _:무조건 임의이 1글자,    like = 이런 문법 없음 이렇게 쓰지 말아야 됨을 주의 이거 골라내는거 시험문제임.
select ename from emp where ename = 'KING'; --정확히 한명 뽑아올때 씀
select * from emp where ename like 'S%';   --S로 시작하는 것 다찾아옴
select * from emp where ename like '%S';   --끝에 S가 있는것 다 찾아옴
select * from emp where ename like '%S%';  --s가 들어가있는것 다 찾아옴
select * from emp where ename like '%IT%';
select * from emp where ename like 'S_%';  --s로 시작하고 뒤에 아무자나 와도돼
select * from emp where ename like 'S_I%';
select * from emp where ename like '_M%';
select ename, hiredate from emp where hiredate between '81/01/01' and '81/12/30';
select ename, hiredate from emp where hiredate like '81%';  --81년생 찾는거
select ename, hiredate from emp where hiredate like '___02%';
select ename, hiredate from emp where hiredate like '__/02%';

--is null  /  is not null
select ename,sal,comm,sal * 12 + comm from emp;  -- comm에 null이 있어서 일을 안하게 된다.
select ename,sal,comm from emp where comm = NULL;  --NULL은 값이 아니라서 찾을 수가 없음. 검색 불가!!!.
select ename,sal,comm from emp where comm is null;  --null인 것만 뽑아오는거. 나중에 null은 0으로 바꿔야한다.
select ename,sal,comm from emp where comm is not null;

--2개 이상의 조건 검색 and / or
select * from emp;
select ename,hiredate,sal from emp where hiredate >= '82/01/01' and sal >= 1300;   --날짜는 ''써야한다. 숫자아님.
select ename,hiredate,sal from emp where hiredate >= '82/01/01' or sal >= 1300;
select ename,sal,comm from emp where sal >= 1000 and comm < 1000 or comm is null;  --and가 우선순위라 밑에랑 다름
select ename,sal,comm from emp where sal >= 1000 and (comm < 1000 or comm is null); 

--외부 데이터 입력 방법 &
select * from emp where deptno = &NO;  --&NO하면 임의의 번호 입력하게 창하나 뜸. 임의의 값을 받아오는거다.
select * from &table;

--정렬 order by
select empno,ename,sal,hiredate from emp order by empno desc;
select empno,ename,sal,hiredate,deptno from emp order by sal desc;
select empno,ename,sal,hiredate,deptno from emp order by deptno,sal desc;
select empno,ename,sal,hiredate,deptno from emp order by 5,3 desc; --열번호를 써도 위에랑 똑같음.

--집합연산자
select ename,deptno from emp where deptno = 10
union
select ename,deptno from emp where deptno = 20;  --10과 20 뽑는건데 or 쓰는거랑 똑같지만 집합으로 뽑으려고 union쓴것뿐. 결과는 같음.

select studno,name,deptno1,1 from student where deptno1 = 101
union
select profno,name,deptno,2 from professor where deptno = 101;   --합치려면 컬럼 개수 같아야하고 형식도 같아야 합칠 수 있음. 1과 2로 학생과 교수 구분. 그리고 union은 합치면서 자동으로 정렬됨

select studno,name,deptno1,1 from student where deptno1 = 101
union all
select profno,name,deptno,2 from professor where deptno = 101;  --union all 은 정렬 안함
--union: 중복제거 해주고 정렬까지 해줌. 그래서 union이 느리다 정렬해줘서.
--union all: 중복 허용하고 정렬 안해줌.
--union들 잘 안쓰니까 그냥 글로만 알고있어라.

--intersect연산자
select studno, name from student where deptno1 = 101
intersect
select studno, name from student where deptno2 = 201;  --1전공이 101이고 2전공이 201인 학생 가져오는거.

select studno, name from student where deptno1 = 101
union
select studno, name from student where deptno2 = 201;  --중복 제거해서 5개 나옴

select studno, name from student where deptno1 = 101
union all
select studno, name from student where deptno2 = 201;  --중복 제거 안해서 6개 나옴

select studno, name from student where deptno1 = 101
minus
select studno, name from student where deptno2 = 201;

------------------------------------------------ch2-------------------------------------------------------------------------
--문자함수
--(1) initcap():첫 글자 대문자로 변환
    select ename,initcap(ename) from emp;
    select position, initcap(position) from professor;
--(2) lower/upper
    select ename, lower(ename),upper(ename) from emp;
--(3) length, lengthb
    select ename,length(ename),lengthb(ename) from emp;  --영문자는 한글자가 한 바이트다.
    select '인하대',length('인하대'),lengthb('인하대') from dual;  --dual이라는 시스템에 있는 빈 테이블 쓰는거임. 인하대는 emp에 없기 떄문에. 한글은 시스템에 따라 바이트 다르다.
    select ename, length(ename) from emp where length(ename) > length(&NAME);  --받아오는게 문자인지 모르기 떄문에 오류난다!!!
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
    select name,jumin,substr(jumin,7,1) 성별 from student;
    select name,jumin,substr(jumin,5,2) "생일일자" from student;   --이건 왼쪽정렬로 출력되므로 문자임
    select name,jumin,substr(jumin,5,2)-1 생일전날 from student;   --이건 오른쪽 정렬로 출력되므로 숫자   substr이 뽑아내는건 문자다. 여기에 -1이 있어서 자동으로 형변환되서 숫자됨.
    select '인하대', substr('인하대',2,1),substrb('인하대',1,3),substrb('인하대',4,3),substrb('인하대',7,3) from dual;
    --00년00월00일
    