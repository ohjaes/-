--ddl에서 수정은 alter dml에서는 update

--INSERT
select * from dept2;
insert into dept2(dcode, dname, pdept, area) values(9000,'temp1',1006,'temp area');
insert into dept2 values(9001,'temp2',1006,'temp area');  --컬럼명 안쓰면 테이블 구조에 맞게 넣어주면 된다 안 맞으면 안 들어감.
insert into dept2(dcode,dname,area) values(9002,'temp3','temp area');  --pdept없이 넣기 위한 방법 컬럼의 순서 바꾸면 데이터 순서도 바꿔서 넣어주면 된다.
--날짜 입력하기
select * from professor;
insert into professor(profno, name, id, position, pay, hiredate) values(5001,'James Bond','Love_me','a full professor',500,'2018-11-23'); --날짜 넣는게 포맷 때문에 오류가 날 수 있다. 
alter session set nls_date_format = 'YYYY-MM-DD:HH24:MI:SS';
select * from professor;  --session 바꿔서 형태가 위에처럼 달라져있다.
alter session set nls_date_format = 'YY/MM/DD'; --예전 형태로 돌아가는 명령어

--number 비교하기
create table TT(
    no1 number,
    no2 number(3),
    no3 number(3,2)
);
desc TT;
insert into TT values(1,1,1);
TRUNCATE table TT;  --데이터 날리기
insert into TT values(1,1,1);
insert into TT values(1.676,1.676,1.676);
select * from TT;     --number(3)은 무조건 소수부분 자르고 정수로.
insert into TT values(-1.6,-1.6,-1.6);
select * from TT;
insert into TT values(1.5678,1.5678,1.5678);
select * from TT;  --number는 소수점 다 출력, number(3)은 자릿수 넘으면 반올림으로 올려버림, number(3,2)은 소수점 두자리까지 나타내서 3쨰자리에서 반올림
--2자리로 맞추려면 to_character로 두자리 맞춰줘야 한다.

--ITAS(insert table as)     insert한줄한줄 하기 귀찮아서
create table prof3 as
    select * from professor where 1=2;    --구조만 가져오기
insert into prof3
    select * from professor;  --이거랑 위에꺼랑 합친게 구조랑 데이터 전체 한번에 가져오는거

create table prof4 as
    select profno, name, pay from professor where 1 = 2;
insert into prof4 
    select profno, name, pay from professor where profno > 4000;


create table p1(
    profno number,
    name varchar2(25)
);
create table p2(
    profno number,
    name varchar2(25)
);
insert all 
    when profno between 1000 and 1999 then
        into p1 values(profno, name)
    when profno between 2000 and 2999 then
        into p2 values(profno, name)
    select profno, name from professor;   --한줄 한줄 insert 해줘도 되지만 한 번에 하려고 insert all 쓴 거다.
select * from p1;
select * from p2;

insert all    --이거 활용도 높음.
    into p1 values(profno, name)
    into p2 values(profno, name)
    select profno, name from professor where profno between 3000 and 3999; --동일한 데이터를 2개의 table에 한꺼번에 넣을 때.


--update
select * from p1;
update p1 set name = '???';   --조건 안주면 모든 name이 ???로 바뀐다

select * from p2;
update p2 set name = '???' where profno = 2001;

rename professor to prof;  --professor다 쓰기 귀찮아서 테이블 이름 바꾼 것

select * from prof where position = 'assistant professor';
update prof set bonus = 200 where position = 'assistant professor';

select position from prof where name = 'Sharon Stone'; --샤론스톤의 position을 확인한다
select name, position, pay from prof where position = 'instructor'; --position이 instructor인 사람들의 pay가 250 넘는지 확인
--sub쿼리로 위에 2줄 한번에 쓰기
select name, position, pay from prof
    where position = (
        select position from prof where name = 'Sharon Stone'
    );

update prof set pay = pay * 1.15 
    where position = (
        select position from prof where name = 'Sharon Stone'
    )
    and pay < 250;   --250보다 작은 직위가 샤론스톤과 같은 사람의 급여가 15% 올랐다.
    
    

select * from p1;
delete from p1;
select * from p2;
delete from p2 where profno = 2001;
select * from p2;
--테이블 만들고 수정하고 삭제하고 데이터 집어넣고 데이터 수정하고 데이터 지울 수 있다.

--4. MERGE
create table c1(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
create table c2(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
create table ctotal(
    cdate varchar2(6),
    cno number,
    ctime number,
    charge number
);
insert into c1 values ('111111',1000,2,1000);
insert into c1 values ('111111',1001,2,1000);
insert into c1 values ('111111',1002,1,500);

insert into c2 values ('121212',1000,3,1500);
insert into c2 values ('121212',1001,4,2000);
insert into c2 values ('121212',1003,1,500);
commit;
select * from c1;
select * from c2;
--병합
merge into ctotal tot   --tot은 약어
using c1 c1
on (tot.cdate = c1.cdate)
when matched then
    update set tot.cno = c1.cno
when not matched then
    insert values(c1.cdate, c1.cno, c1.ctime, c1.charge);   --ctotal은 비어있었으니까 조건이 맞는게 없다. 그래서 밑에 조건 수행 그래서 c1테이블의 데이터들 다 insert했음.

select * from ctotal;

merge into ctotal tot   --tot은 약어
using c2 c2
on (tot.cdate = c2.cdate)
when matched then
    update set tot.cno = c2.cno
when not matched then
    insert values(c2.cdate, c2.cno, c2.ctime, c2.charge);

select * from ctotal;

insert into c1 values ('111111',1004,2,500);
select * from c1;  
commit;

truncate table ctotal;

merge into ctotal tot   --tot은 약어
using c1 c1
on (tot.cno = c1.cno)
when matched then
    update set tot.cdate = c1.cdate
when not matched then
    insert values(c1.cdate, c1.cno, c1.ctime, c1.charge);   --total비었으니 그냥 4개행 정상적으로 들어간다

select * from ctotal;

merge into ctotal tot   --tot은 약어
using c2 c2
on (tot.cno = c2.cno)
when matched then
    update set tot.cdate = c2.cdate
when not matched then
    insert values(c2.cdate, c2.cno, c2.ctime, c2.charge);  
select * from ctotal;  --5개가 나온 이유는 1000번과 1001번이 update가 된 것.   병합을 지금은 날짜만 update했지만 개수를 기존꺼랑 더해서 할 수도 있고 다양하니까 더 명령을 밑에 해주면 된다.

--update join 안함



----------------제약 조건-----------------------------------------------------------------------------------
--not null
--unique
--primary key:  not null이면서 unique해야함,  젤 중요함
--foreign key: 데이터를 받을 지 말지 정할 수 있다
--check

--constraint 여러개 쓸 때 콤마 없다!! 주의해야함    한컬럼에 제약조건 거는거라  콤마는 컬럼과 컬럼사이에 쓰는거다
--중요
create table aa(
    no number(4) constraint aa_no_pk primary key,
    name varchar2(20) not null,
    jumin varchar2(13) constraint aa_jm_nn not null       --이름 준거
                        unique,                           --이름 안 준거
    loc number(1) check(loc<5),
    deptno varchar2(6) constraint aa_dn_fk
                    references dept2(dcode)       --여기 dcode의 크기가 varchar2(6)이랑 같아야 한다
);
desc aa;
select * from dept2;   --decode번호 확인
insert into aa values(1, '홍길동', 1234567891234,3,1000);
select * from aa;

--밑에 부분 잘 확인해보기
insert into aa values(1, '홍길동', 1234567891234,3,1000);  --이건 에러 프라이머리키가 또 들어오니까 안되는거다.
insert into aa values(2, '홍길동', 1234567891234,3,1000);  --이것도 에러다 주민번호도 unique라서 에러뜨는거다
insert into aa values(2, '홍길동', 2234567891234,3,1000);
insert into aa values(3, '홍길동', 2234567891234,7,1000);  --5이하로 넣는다고 되어있는데 7 넣어서 에러
insert into aa values(4, '홍길동', 4234567891234,3,5555);  --5555가 dept2에 dcode에 없는 거다
