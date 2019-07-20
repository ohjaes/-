--index  :기본적으로 오름차순으로 만든다.

--unique index  :중복없는 유일한 인덱스, unique key걸린애들하테 unique index거는게 일반적, 유니크인덱스는 지금부터 추가되는 애들이 유니크해야함,유니크인덱스 많이는 안씀
select * from dept2;
create unique index idx_dept2_dname on dept2(dname);  --dept2테이블에 dname에 인덱스 주는거
insert into dept2 values(9100,'AAA',1006,'XXX');  --기존이름이랑 AAA랑 겹치지 않아서 잘 들어감
insert into dept2 values(9101,'AAA',1006,'YYY');  --기존이름이랑 AAA랑 겹쳐서 안들어감 유니크 인덱스때문

--non-unique index  :  인덱스는 대부분 where절에 쓰는 것들을 인덱스 건다.
create index idx_dept2_area on dept2(area);

--FBI(function based index)
select * from emp where sal + 100 = 1000;   --이런건 인덱스 효과 없음 만약 sal로 인덱스 걸었으면 sal만 가능 sal + 100같은건 안돼 = index suppressing error
--index suppressing error
create index idx_emp_pay_fbi on emp(sal + 100);  --sal+100을 위한 인덱스를 만든거다.

--내림차순으로 index 만드는 법
create index idx_emp_sal on emp(sal desc);

--결합 index
select * from emp;
select ename, job from emp where ename='SMITH' and job = 'CLERK';  --얘찾을때 full scan 다해서 오래걸림. 하나만(ename) 인덱스 걸면 ename은 인덱스로 빨리찾지만 job은 또 풀스캔
create index idx_emp_ename_job on emp(ename,job);  --복합 인덱스 만든 것, ename이나 job 둘중에 순서 먼저줘도 상관없는데 데이터 뒤지는게 다르다, 그래서 속도 빠르게 하려면 순서 중요 p381,382

--bitmap   :통계자료 같은거, 분석용데이터는 비트맵이 좋음. 가능하면 변화 없는 데이터. 이거 잘 안씀

--인덱스의 주의사항: 풀스캔을 해야하기 때문에 속도가 오래걸려서 DML에 취약하다. 인덱스 만드는 중간에 데이터 변화있으면 인덱스 못만듦.
--                  insert가 계속 되면 블록이 넘쳐 블록이 쪼개짐(데이터가 다른 인덱스로 옮겨갈수도이씀) = index split현상
--                  data를 지운다고해서 index가 지워지지 않는다.  update는 delete + insert현상이 발생한다
--                  타 sql 실행에 악영향을 줄 수 있다.
--**    dictionary 이름은 시험에 안나옴 ex) user_ind_columns 같은거**

select * from user_ind_columns where table_name = 'EMP'; --이거는 시험에 안나옴

--rowid
select rowid,* from emp;  --이건 에러
select rowid, empno, ename from emp;  --rowid는 데이터오브젝트번호, 파일번호, 블록번호, row번호로 구분


--단순 view : 보안과 편리성에 좋음
create view vemp as
    select empno, ename, hiredate from emp;
select * from vemp;   --마치 테이블처럼 쓴다. 필요한 정보들만 빼서 가짜 테이블을 만든다(얘는 데이터가 안들어있고 실행될떄 원본에 가서 정보불러오는것뿐, 그래서 원본바뀌면 뷰도 같이 바뀜,연결되어있음)
create view vemp as
    select empno, ename, hiredate from emp;  --이미 있어서 에러뜸
create or replace view vemp as
    select empno, ename, hiredate from emp;  --or replace있어서 실행된다.
--view에는 제약조건(인덱스같은거) 못준다.
create index idx_vemp_ename on vemp(ename);  --에러난다. 원본테이블 가서 제약조건 걸으라고 에러남

--view에 데이터 삽입하면 실제로는 원본에 들어감, 물론 뷰에서도 보임
create table tbl(
    A number,
    B number
);
create or replace view vtbl as
    select A, B from tbl;
insert into vtbl values(1,2);
select * from vtbl;
select * from tbl;
rollback;  --트랜젝션. 커밋하기전 롤백하면 커밋하기 전 원래상태로 돌아감  insert 동작이 실행되기 전으로 돌아감

--with read only
create view view2 as
    select A, B from tbl with read only;  --읽기 전용으로만 뷰 만들기
insert into view2 values(3,4);  --읽기 전용 뷰라서 데이터 삽입 안된다.
insert into tbl values(3,4);  --이렇게 원본 테이블에 넣으면 데이터 들어가서 일기 전용 뷰에서도 보임
select * from view2;
insert into vtbl values(5,6);  --얘는 잘 들어감 읽기 전용이 아니라서.
select * from view2;
--with check option
create view view3 as 
    select A, B from tbl where A = 3 with check option;
update view3 set A = 5 where B = 4;   --with check option걸어놔서 A=3인 놈은 바꿀 수 없다.
update view3 set B = 6 where A = 3;   --이건 업데이트 된다??  이거 다시 보기 a는 가만히 있고 B를 바꾸는거라 된다??
select * from vtbl;
select * from view2;
select * from view3;

--복합 뷰
select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;  --매번 이렇게 복잡하게 부르면 귀찬ㅇ르니까
create or replace view v_emp_dept as
    select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;  --복합뷰
select * from v_emp_dept;  --서브쿼리를 이렇게 쉽게 볼 수 있게 뷰로 만들어 놓는 것.
select ename from v_emp_dept;

--수정 삽입같은거 뷰에서 하지말고 가능하면 원본에서 하라

--인라인 뷰
select deptno, max(sal) from emp group by deptno; --부서별 봉급이 젤 많은 거 출력
select e.deptno,d.dname, max(sal) from emp e, dept d where e.deptno = d.deptno group by e.deptno, d.dname;
select e.deptno,d.dname, sal from (select deptno, max(sal) sal from emp group by deptno) e, dept d
    where e.deptno = d.deptno;   --from 뒤에 저렇게 넣ㅇ는게 인라인뷰   첫번쨰 select에 max(sal)말고 sal로 써야되는 건 프롬뒤에 이미 sal을 그룹바이해서

create or replace view v_emp_dept2 as
    select e.deptno, d.dname, max(sal) sal from emp e, dept d where e.deptno = d.deptno group by e.deptno, d.dname;
select * from v_emp_dept2;

--view제거:  drop을 쓴다  내용지우는거 딜리트, 컬럼이나 테이블날리는거 드롭
select * from user_views;
drop view view3;


--시퀀스
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
insert into orders values(jno_seq.nextval, 'JAMES','APPLE',5);  --jno_seq.nextval을 넣을 수 있다? 책으로 다시 보기
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
insert into rev values (rev_seq.nextval); --여기서 에러뜬다 최솟값이 0이라서 더 작은 수는 못 넣는다. cycle을 안줘서

drop sequence test_seq;
create sequence test_seq;  --가장 디폴트로만 만들어지는거
select test_seq.nextval from dual;
select test_seq.nextval from dual;
select test_seq.nextval from dual;  --계속 증가시켰는데 잘못해서 다시 1부터 하고 싶을떄는 지우는게 가장 빠름

select test_seq.currval from dual;
--alter sequence test_seq increment by -2;
alter sequence test_seq increment by -8;   --test_seq의 최솟값이 1이라 1까지만 줄여야한다. 이거 할 당시 9여서 -8한거임
select test_seq.currval from dual;
select test_seq.nextval from dual;
alter sequence test_seq increment by 1;  --다시 증가범위 1로 바꿔줘야 올라간다. 최솟값까지 줄였으니까
select test_seq.nextval from dual;


--동의어  :테이블명을 숨기고 싶을 때
create synonym e for emp;   --rename은 emp자체가 바뀌는거고 이거는 e라는 별칭으로 하나 만드는거다
select * from e;

create public synonym d2 for dept;  --에러난다. 권한이 불충분하다고 나옴 cmd가서  conn / as sysdba; grant create public synonym to hr; 하면 된다
create public synonym d2 for dept;   --이제 작동 될 것이다.

--여기까지 기말고사