--이론: 
--관계 dbms와 객체관계dbms만 본다
--테이블로 되어있으면 관계디비엠에스
--이름을 한번이라도 들어본것들 다 관계형 디비엠에스  join써서 붙여나가는거라 관계형
--관계디비엠에스에 객체라는것을 만들어서 하는거? 이건 어려움 거의 관계디비엠에스까지만함
--ddl:데이터 정의어, dml:데이터조작어, dcl:데이터 제어어
--select 같은거 다 dml
--sql은 비절차적 언어
--ddl과 dml 구분해라 delete drop등등
--트랜잭션? 찾아보기
--dcl: 데이터 제어어는 commit을 써서 디비에 적용시키는거,roll back은 처음상태로 돌이키는 것.등등

--실습:
--instr p76 특정글자 찾아주는거
select * from emp where deptno = 10;
select hiredate,instr(hiredate,'/') from emp where deptno = 10; --첫번쨰 위치부터 / 이 나오는 위치를 알려준다.
select hiredate,instr(hiredate,'/',1,1) from emp where deptno = 10;
select hiredate,instr(hiredate,'/',1,2) from emp where deptno = 10; --첫번쨰 위치부터 /가 2번쨰 나오는 위치를 알려준다.
select 'A-B-C-D', instr('A-B-C-D','-',1,3) from dual;
select 'A-B-C-D', instr('A-B-C-D','-',-1,3) from dual;  --  -1은 맨뒤에서부터 3번쨰 찾는 것  substr이랑 방향 잘 구분해라? substr이랑 instr - 넣었을 떄 잘봐라
select 'A-B-C-D', instr('A-B-C-D','-',-6,2) from dual;  -- substr이랑 꼭 비교해봐  출력값은 글자가 아닌 위치값인 숫자임!!!
select tel from student where deptno1 = 201;
select tel, instr(tel,')') from student where deptno1 = 201; --지역번호 뒤에 ) 찾아오기
select name, tel, instr(tel,'3') from student where deptno1 = 101;
select name, tel, instr(tel,'3',1,2) from student where deptno1 = 101;
select name, tel, instr(tel,'8',1,2) from student where deptno1 = 101;
select tel, substr(tel,3,2) from student where deptno1 = 101;  --3번쨰 위치부터 2개 뽑아오기
select name,substr(tel,1,instr(tel,')')-1) from student where deptno1 = 101;  --지역번호만 뽑기!!
--LPAD, RPAD 함수
select name, id,lpad(id,10) from student where deptno1 = 201;  --10자리를 채우고 오른쪽 정렬
select name, id,lpad(id,10,'*') from student where deptno1 = 201;  --10자리를 채우고 나머지는 *로 채우는 것
select name, id,rpad(id,10,'*') from student where deptno1 = 201; 
select ename,substr('123456789',1,10-length(ename)) || ename from emp where deptno = 10;  --####이꺼 꼭 봐야함.
select ename,concat(substr('123456789',1,10-length(ename)),ename) from emp where deptno = 10; --concat으로 3개 붙이려면 concat에 concat을 써야함.
--ltrim/rtrim
select ename, ltrim(ename, 'C') from emp where deptno = 10;  --c 가 나타난 첫번쨰 글자를 없앤다.
select ename, rtrim(ename, 'R') from emp where deptno = 10;  --맨오른쪽에 있는 r만 없앤다. 클락에 r은 안없어 진다.
select name,substr(tel,1,instr(tel,')')-1),rtrim(substr(tel,1,instr(tel,')')),')') from student where deptno1 = 101; --이거 꼭 다시보기 trim으로도 지역번호만 출력가능
--replace    가장 중요함!!!!!
select 'abcde',replace('abcde','bc','*') from dual;  --bc를 *로 바꾸는 것.
select ename,replace(ename,substr(ename,1,2),'**') from emp where deptno = 10;
select jumin,replace(jumin,substr(jumin,7),'-*******') from student where deptno1 = 101; --주민번호 뒷자리 *로 바꾸기.
---------------------퀴즈 과제. p79 substr instr퀴즈 , p81 lpad퀴즈, p82 rpad퀴즈, p84 replace퀴즈  과제로 제출. 결과와 코드 캡쳐 떠서 한글에 붙여서 제출.

--숫자 관련 함수들,  sysdate는 꼭 알아둬라
--round, trunc(버리는 함수)
select round(123.456) from dual;
select round(123.556) from dual;
select round(123.556,0) from dual;
select round(123.556,1) from dual;
select round(123.556,2) from dual;
select round(123.556,-1) from dual;  --  -넣으면 어떻게 되는지 알아놓기
select round(123.556,-2) from dual;
select trunc(123.556) from dual;
select trunc(123.556,0) from dual;
select trunc(123.556,1) from dual;
select trunc(123.556,2) from dual;
select trunc(123.556,-1) from dual;
select trunc(123.556,-2) from dual;
--mod:나머지 구하는 함수, ceil: 올리는 함수,floor: 내림함수
select mod(10,3) from dual;
select ceil(0.33) from dual;
select ceil(-0.33) from dual;  --   -넣으면 어떻게 되는지 봐라
select floor(1.33) from dual;
select floor(-1.33) from dual;  --   -넣으면 어떻게 되는지 봐라
--rownum 줄 번호
select rownum,ename from emp;
select rownum, ceil(rownum/3), ename from emp; --rownum을 그룹을 묶어주려고 3개로 묶어주려고 3으로 나누고 올림함수 씀.
--power: 제곱승 구하는거
select power(2,3) from dual;
select power(2,100) from dual;
--날짜 관련 함수
select sysdate from dual;  -- sysdate는 컴퓨터의 시스템의 날짜     --18/09/28
alter session set NLS_DATE_FORMAT = 'RRRR-MM-DD:HH24:MI:SS';      --  날짜 형식 바꾸려고 쓰는거 현재 / 로 되어있는데 -로 바꾸려고
select sysdate from dual;                                      --2018-09-28:10:40:36
alter session set NLS_DATE_FORMAT = 'RR/MM/DD';    --원래 형식으로 돌아가기
--months_between : 달과 달 사이에 몇개월이 있었나 계산.  거~의 안씀
select months_between('18/08/31','18/09/30') from dual;  --큰수가 앞에 나와야 된다. 큰수가 뒤에 나와서 -나옴
select months_between('18/09/30','18/08/31') from dual;  --제대로 쓴 표기.
select months_between('18/09/30','18/09/01') from dual;  --한달을 31일로 계산해서 소숫값 나옴. 
select ename, hiredate,months_between(sysdate,hiredate) from emp;
--add_months : 개월수를 붙여줘서 그 후를 찍어줌.
select sysdate,add_months(sysdate,7) from dual;
--next_day
select sysdate,next_day(sysdate,'월') from dual; -- 제일 가까운 월요일을 찾아주는 것.
select sysdate,next_day('18/12/25','토') from dual;
--last_day : 그 달의 마지막 날이 언제냐
select last_day(sysdate) from dual;
select last_day(add_months(sysdate,1)) from dual; -- 다음달의 마지막 날 구하기
--round/ trunc
select round(sysdate),trunc(sysdate) from dual;    --12시가 넘으면 다음날을 찍고 안넘으면 오늘찍고?  한번 찾아보기.
--형변환 함수  ##중요하다. char varchar2 number date
--묵시적 변환/ 명시적 변환
select 2 + '2' from dual;  --원래는 숫자랑 문자 못 더하는데 '2'앞에 to_number가 있는 거임 그래서 이건 묵시적 변환?
select 2 + to_number('2') from dual;  --명시적 변환?
select 2 + 'A' from dual;  --이건 a라는 문자라서 더할 수 없다. 숫자 문자가 아니라서.
-- to_char to_number to_date      p102부터 날짜를 문자로 바꾸는 것

--날짜를 문자로 바꾸는 거 rrrr yy rr year로 찍히는 결과 보기 mm mon month로 찍히는 결과 보기 dd day ddth
--p105 
select sysdate, to_char(sysdate,'rrrr-mm-dd') from dual;
select sysdate, to_char(sysdate,'year-month-ddth') from dual; --등등 찍히는게 다르니까 한번 해봐라.
--p105 퀴즈 해봐라
select name,birthday from student where to_char(birthday,'mm')='01'; --생일이 1월인 사람들 뽑아오기. substr으로 해도 상관은 없다.
--p106
select name,birthday from student where to_char(birthday,'mm') in('01','02');  --in 또는 or 써도 되지만 in이 제일 간단함.
--p107  숫자를 문자로 바꾸는 것    9는 자리수를 의미한다.
select empno,ename,sal,to_char((sal*12)+comm,'$99,999.99') from emp where ename='ALLEN';  --천자리 마다 , 찍고 소숫점 찍고 앞에 달라 찍기
select name,pay,bonus,nvl(bonus,0),(pay*12)+bonus,(pay*12)+nvl(bonus,0) from professor where deptno = 201;  --bonus에 null이 있어서 계산이 바로 안됨
select to_char((pay*12)+nvl(bonus,0)) from professor;
select to_char(months_between(sysdate,hiredate),'999.9') from emp;
--p108퀴즈 형변환 해보기

select '18/09/28' from dual;   --이건 날짜가 아니고 그냥 문자임.
select to_date('18-09-28') from dual;  --이렇게 해야 문자가 날짜가 된다.











