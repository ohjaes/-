--ddl
--1. create
create table tbl (
    no number(3),
    name varchar2(10),
    birth date
);
desc tbl;
select * from tbl;

create table tbl (
    no number(3),
    name varchar2(10),
    birth date
);   --같은 테이블명은 또 만들 수 없다.
drop table tbl; --table 날리려고 쓰는 거 drop과 delete 구분해라   drop은 데이터베이스를 다루고 delete는 데이터를 다룬다.
drop table tbl2;
create table tbl2 (
    no number(3,1) default 0,
    name varchar2(10) default '아무개',
    birth date default sysdate
);   
insert into tbl (no, name, birth)
values (1.55, '홍길동', sysdate);
insert into tbl (no)
values (1);
insert into tbl values (123,'gf',sysdate);
select * from tbl;

insert into tbl2 (no, name, birth)
values (1.55, '홍길동', sysdate);
insert into tbl2 (no)
values (1);
select * from tbl2;  --default 있어서 위에랑 결과 다름 null안나옴

create table 테이블 (
    번호 number(3,1) default 0,
    이름 varchar2(10) default '아무개',
    생일 date default sysdate
);   
desc 테이블;
insert into 테이블 (번호, 이름, 생일)
values (1, '홍길동', sysdate);
select * from 테이블;  --가능하면 한글로 만들지 마라 귀찮아서

--임시 테이블 만들기   이거 거의 안씀
create global temporary table tmp (
    no number,     --숫자 안주면 길이 제한 없음
    name varchar2(10))
    on commit delete rows;  --commit할 떄마다 열 다 삭제
insert into tmp values(1,'test'); --개수가 맞으면 컬럼 안써도 돼 순서도 맞춰야함
insert into tmp(no) values(5);  --개수 다르면 이렇게 해야함
select * from tmp;
commit;
select * from tmp;  -- commit 떄려서 열 다 지워졌다

select temporary, duration from user_tables where table_name = 'TMP';
select temporary, duration from user_tables where table_name = 'EMP';

--table 복사하기 엄청 중요함 ctas
--1. 전체 복사하기
create table dept3 as 
    select * from dept2;
select * from dept2;
select * from dept3;

--2.일부 복사하기
create table dept4 as 
    select dcode, dname from dept2;
select * from dept2;
select * from dept4;
delete from dept4; --조건 안주고 이렇게 하면 내용 다 삭제
select * from dept4;

--3.구조만 복사
create table dept5 as 
    select dcode, dname from dept2
    where 1=2;  --조건이 1=2가 말이 안돼니까 맞는게 없다 그래서 데이터 없이 구조만 가져온다.
select * from dept5;

create table dept6 as 
    select * from dept2
    where dcode in (1000,1001,1002);  
select * from dept6;

--테이블명 바꾸기
rename dept6 to depts;
select * from depts;
rename depts to dept6;

--내용수정은 update 구조 수정은 alter
alter table dept6 add (loc varchar2(10));   --loc이라는 varchar2 추가
alter table dept6 add (loc2 varchar2(10) default '인천');  --컬럼 추가할때 무조건 null로 들어가니까 디폴트 준 것
desc dept6;
select * from dept6;      

--컬럼의 이름을 바꾸는 것    이거 엄청 많이 씀
alter table dept6 rename COLUMN LOC2 to AREA1;
alter table dept6 rename column loc to position;
select * from dept6;

--컬럼 타입과 크기 바꾸는 것  수정하는거라 modify
alter table dept6 modify (area varchar2(20) default 'asd');
desc dept6;

--컬럼 자체를 버리는거             alter는 꼭 연습해라 중요하다.
alter table dept6 drop column position;

--delete는 만든 공간은 그대로 있고 안에 데이터만 없어지는데 truncate는 공간마저 다 없애고 구조만 남겨둔다. drop은 아예 다 없애는거

select * from dept6;
delete from dept6 where dcode = 1000;
select * from dept6;

select * from dept6;
truncate table dept6;  --트런캣은 잘 안쓴다.
select * from dept6;

drop table dept6;
select * from dept6;  --table 없어졌으니 오류난다.

--읽기 전용 테이블 만들기
create table abc(
    no number,
    name varchar2(10)
);
insert into abc values (1, 'aaa' );
select * from abc;
commit;

alter table abc read only;  --abc테이블을 읽기 전용으로 만드는 명령어
select * from abc;  --select는 문제없지만
insert into abc values (3, 'ㅠㅠㅠ' );  --이건 에러뜬다 왜냐하면 읽기전용 테이블이라서
alter table abc add (loc varchar2(10) default '인천');  --이것도 읽기전용 테이블이라서 안먹힘 에러남  drop은 먹는다.
alter table abc read write;   --다시 읽고 쓰기 가능하게 바꾼것
select * from abc;
insert into abc (no, loc, name) values (4,'la','ddd');  --insert는 컬럼 순서 써주면 순서 바꿔도 테이블에 맞게 들어간다.
select * from abc;

select table_name, read_only from user_tables where table_name = 'EMP';  --읽기 전용 테이블인지 확인할 수 있음.

-- 가상 컬럼    3번쨰 컬럼은 첫번쨰와 두번쨰의 합인 컬럼
create table vt(
    c1 number,
    c2 number,
    c3 number GENERATED ALWAYS as (c1 + c2)  --generated always as가 가상컬럼 만드는 명령어
); --c1과 c2는 진짜 컬럼이고 c3만 가상컬럼
desc vt;
insert into vt values(1,2,3);  --이건 에러뜬다. 가상 컬럼은 insert로 못넣음
insert into vt values(1,2);   --이것도 에러뜬다. 컬럼의 개수가 안맞아서.
insert into vt(c1,c2) values(1,2); --이건 들어간다. 이렇게 반드시 컬럼 잡고 넣어라
select * from vt;

--데이터 수정 update
update vt SET c1 = 5;   --c1컬럼을 다 5로 바꾸는거

--가상 컬럼 추가하기
alter table vt add (c4 number generated always as ((c1*12) + c2));  --number안적으면 뒤에 애들에 의해서 자동으로 정해지긴 하지만 적는게 원칙
select * from vt;
insert into vt (c1, c2) values (10,20);

select * from SYS.user_tab_columns where table_name = 'VT';


create table sale(
  no number,
  code char(4),
  date char(8),
  qty number,
  bungi number(1) generated always as (
    case
        when substr(date,5,2) in ('01','02','03') then 1
        when substr(date,5,2) in ('04','05','06') then 2
        when substr(date,5,2) in ('07','08','09') then 3
        else 4
    end
  ) virtual
);       --식별자에 문제가 있다. 여기서는 date가 문제임 다른 이름으로 바꿔주면 됀다

create table sale(
  no number,
  code char(4),
  pdate char(8),
  qty number,
  bungi number(1) generated always as (
    case
        when substr(pdate,5,2) in ('01','02','03') then 1
        when substr(pdate,5,2) in ('04','05','06') then 2
        when substr(pdate,5,2) in ('07','08','09') then 3
        else 4
    end
  ) virtual
); 
insert into sale(no, code, pdate, qty) values (1,'100','20180128',10);
insert into sale(no, code, pdate, qty) values (2,'200','20180528',20);
insert into sale(no, code, pdate, qty) values (3,'300','20180828',30);
insert into sale(no, code, pdate, qty) values (4,'400','20181128',40);
select * from sale;

--sid?


