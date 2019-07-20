--sql문 사용하기
--select문
select * from emp;
select *
from emp;
select empno,ename,job,mgr from emp;
select empno,ename from emp;
--데이터 어떻게 되어있나 보는 방법
desc emp;
--표현식 사용하기
select * from dept;
--문자는 기본 왼쪽정렬, 숫자는 오른쪽 정렬, 그리고 큰따옴표 쓰면 안되고 작은따옴표 써야된다.문자열 데이터는 무조건 홑따옴표.
select dname, '사람',1 from dept;
select "사람" from dept;
--여기서 큰따옴표 쓰는데 이렇게 쓰면 큰따옴표는 열이름으로 됌. as 생략가능.
select dname, '사람'"사람12" from dept;  
select dname, '사람'as"사람12",1 from dept;
select dname, '사람"마음' as "사람12",1"숫자" from dept; --어퍼스트로피 출력하기 위해서 저렇게 씀?
select dname, Q'[it's deptno]','test' as 테스트 from dept; --테스트는 따옴표 안써도 되지만 앞에 데이터는 항상 홑따옴표 써야함
select distinct deptno from emp; --구분되는 것들만 뽑는거 == 중복제거하는거 distinct
select distinct deptno from emp order by deptno; --order by 순서 넣는거.
select distinct deptno from emp order by deptno desc; --desc는 내림차순 asc는 오름차순으로 default다.
select distinct deptno from emp order by 1; --1써도 순서 될수있음? 열번호 쓰면 된다.
select job,ename from emp;
select distinct job,ename from emp; --두개를 써서 두개 모두 겹치지 않는 거 뽑은 것이다
select distinct job,ename from emp order by job;
select distinct job,ename from emp order by job, ename; --order by 다음에 순서대로 1차정렬 2차정렬이다.
select distinct job,ename from emp order by job, ename desc; --이렇게 하면 ename은 desc로 한다.  1차정렬은 오름차순, 2차정렬은 내림차순으로 된다는 쿼리문.
select distinct job,ename from emp order by 1,2 desc;  --이름대신 열 번호 써도 된다.

--디비는 정렬쓰면 속도가 느려져서 안쓰는 게 좋다.

--연결 연산자
select ename,job from emp;
select ename|| job from emp;  --한칸에 출력함 붙여서.
select ename|| job as "사람의 직업" from emp;
select ename||' '||job as "사람의 직업" from emp; --공백문자 넣어서 한칸 띈 것.
select ename||'"s job is '||job as "사람의 직업" from emp; -- 어퍼스트로피 찍는 것.
select ename||Q'['s job is ]'||job as "사람의 직업" from emp;

--조건      row를 record라고도 함
select * from emp where ename = 'SMITH'; --조건 내용은 대소문자 같아야함.
select * from emp where deptno >= 20; --문자는 따옴표 숫자는 따옴표 필요없음.
select * from emp where empno = 7369;
select * from emp where empno = '7369'; --숫자는 따옴표 써도 잘 찾는다. 숫자는 자동적으로 형변환 해준다.
select * from emp where hiredate ='1980-12-17';
select * from emp where hiredate ='19801217';
select * from emp where hiredate ='1980/12/17';
select * from emp where hiredate ='80-12-17';  --지금 데이터는 1980년 이렇게 넣어서 안되지만 19없이 넣은 데이터면 나올것이다 밑에꺼도 같다.
select * from emp where hiredate ='80/12/17';
--alter session set nls_date_format='YY-MM-DD'; 날짜 포멧 바꾸는거
alter session set nls_date_format='YYYY/MM/DD';
select * from emp where hiredate='1980-12-17';
--그래서 날짜는 보여지는거랑 데이터랑 다를 수 있음 그래서 내부적으로 어떻게 되어있나 보는게 찾을 때 좋다.
select ename,hiredate from emp order by hiredate desc;

--기본연산자
select ename,sal,sal*12 as "연봉",(sal*12)*0.05 as "내야할 세금" from emp where deptno = 10; --필드명에 바로 연산 때려도 됨

--비교 연산자
select * from emp where sal >= 2450;
select * from emp where sal != 2450;
select * from emp where hiredate > '1980-12-17'; --내 입사일 보다 큰애들==나보다 후배들 찾는 것.
select ename,sal,deptno from emp where hiredate > '1980-12-17'; --내 입사일 보다 큰애들==나보다 후배들 찾는 것.
select ename, sal from emp where sal <= 3000 and sal >= 2000;  --and연산자
select ename, sal from emp where sal between 2000 and 3000; --사잇값 구하는거 between, 2000이랑 3000도 포함한다. 위에 식이랑 같음
select * from emp where ename = 'SMITH';
select * from emp where ename like 'S%';  --like쓰고 %위체아 따라 해당 문자로 시작하는 거 찾아줌
select * from emp where ename like '%R';  --like쓰고 %위체아 따라 해당 문자로 끝나는 거 찾아줌
select * from emp where ename like 'T%R';  --T로 시작하고 R로 끝나는거
select * from emp where ename like '%AR%';  --중간에 AR 들어간거,  % % 이건 자릿수 제한이 없다
select * from emp where ename like '_AR%';  -- 언더바 갯수 만큼 앞에 아무거나 와야한다. 따라서 2번째 자리에 AR이 오는거 찾아줌

