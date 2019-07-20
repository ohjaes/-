--이건 sys 계쩡으로 들어온거
show user;

@?/rdbms/admin/utlexcpt.sql    --이게 수행되면 exception table만들어주는건데 이거 안돌아감 ?까지가 현재위치인데 안맞아서 그러는듯?

@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\utlexcpt.sql

create table hr.t500(
    no number constraint t500_ck check(no > 5)
);   --hr의 권한이 있는 디비에 t500이라는 테이블 만든거
alter table hr.t500 disable constraint t500_ck;    --validate나 novalidate안넣으면 기본이 novalidate다
insert into hr.t500 values(1);
insert into hr.t500 values(6);
insert into hr.t500 values(7);
commit;
select * from hr.t500;

alter table hr.t500 enable validate constraint t500_ck exceptions into sys.exceptions;   --문제가 되는 위치를 알고싶어서 하는거
select * from exceptions;  --오류난 위치를 위에서 넣어준 테이블
update hr.t500 set no = 8 where rowid = 'AAAE6lAAEAAAAM+AAA';
commit;

truncate table sys.exceptions;

alter table hr.t500 enable validate constraint t500_ck exceptions into sys.exceptions;   --작동되었다는 것은 이전 데이터중에 문제되는게 없다는 뜻
select * from exceptions;  --오류난 위치를 위에서 넣어준 테이블



