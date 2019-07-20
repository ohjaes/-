--제약조건 중요함.   낫 널은 데이터 없으면 에러,  유니크는 무조건 구별이 되야함,  프라이머리키는 테이블당 1개만 설정할 수 있고 구별할 수 있는 기준 키이며 낫널과 유니크 합친거
--                 포린키는 외래키,  체크는 필요한 부분의 조건 예를들면 범위등을 조절?
-- 부모테이블의 프라이머리키를 다른 테이블에서 포린키로 걸어서 참조할 수 있다  예를 들면 부서번호 포린키로 걸 수 있음
-- 보통은 이름 안주고 그냥 제약조건만 준다.

--테이블 만들 때 제약조건 주기
drop table aa;
create table aa (
    no number constraint aa_no_pk primary key ,       --aa_no_pk이런 규칙으로 대부분 이름 준다 
    name varchar2(20) constraint aa_name_nn not null,
    jumin varchar2(13) not null unique,--이건 명칭없이 제약조건 두개 준거   콤마 쓰면 안된다.
    loc number(1) constraint aa_loc_ck check(loc < 5),
    deptno varchar2(6) constraint aa_deptno_fk                       --참조하는 컬럼과 지금 내 컬럼과 크기를 맞춰줘야 땡겨올 수 있다.
                        references dept2(dcode)                      --레퍼런스에 꼭 s써라 
);

--테이블 만든 후 제약조건 추가하기
alter table aa add constraint aa_name_uk unique(name);
alter table aa add constraint aa_loc_nn not null(loc);  --오류남  기본적으로 널은 허용으로 되어있어서 add가 아니고 modify 써야함
alter table aa modify (loc constraint aa_loc_nn not null);  --이제 loc은 널 허용안되고 그 숫자가 5 보다 작아야 하는 제약조건이 있는거다.

alter table aa add constraint aa_no_fk foreign key(no)
                references emp2(empno);    --포린키 거는 명령어,  테이블 만들떄 포린키 만드는거랑 이거랑 차이 잘 봐두기, emp2에서는 empno가 프라이머리키라 이건 괜찮음
                
alter table aa add constraint aa_name_fk foreign key(name)
                references emp2(name);     --이건 에러남.  emp2의 네임이 유니크가 아니거나 프라이머리가 아니라서 참조를 못함. 포린키 걸 때 부모의 유니크나 프라이머리를 참조해야함.
                                            --한 테이블에 프라이머리키는 2개 불가능이라 emp2에서 name을 유니크로 만들어야함
alter table emp2 add constraint emp2_name_uk unique(name);
alter table aa add constraint aa_name_fk foreign key(name)
                references emp2(name);      --이제 에러 안뜨고 됨

--제거 할 때 같이 제거해버리는 기능   on delete cascade /  on delete set null
create table test1(
    no number,
    name varchar2(6),
    deptno NUMBER
);

create table test2(
    no number,
    name varchar2(10)
);

alter table test1 add constraint test1_deptno_fk foreign key(deptno)
                    references test2(no);     --test2의 no가 프라이머리키도 아니고 유니크도 아니라서 오류
alter table test2 add constraint test2_no_uk unique(no);
alter table test1 add constraint test1_deptno_fk foreign key(deptno)
                    references test2(no);

insert into test2 values(10,'AAA');
insert into test2 values(20,'BBB');
insert into test2 values(30,'CCC');
commit;

insert into test1 values(1,'test1',10);
insert into test1 values(2,'test2',10);
insert into test1 values(3,'test3',30);
insert into test1 values(4,'test1',20);
insert into test1 values(5,'test1',40);   --이건 제약이 걸려있어서 못넣음 40은 안됨
commit;

select * from test1;
select * from test2;

delete from test2 where no = 10;   --에러뜬다 못지운다고 나온다. 이유는 얘랑 연결된 자식 레코드가 존재해서 못 지움 그래서 먼저
delete from test1 where deptno = 10;    --이거부터 해주고 위에꺼 해줘야 된다 참조하는 것을 지우니까 이제 연관된거 없으니 지우기 가능
delete from test2 where no = 10;

drop table test1;
drop table test2; --테이블 자체를 날릴떄는 제약조건 있으나 마나 필요없음

create table test1(
    no number,
    name varchar2(6),
    deptno NUMBER
);

create table test2(
    no number,
    name varchar2(10)
);
alter table test2 add constraint test2_no_uk unique(no);
alter table test1 add constraint test1_deptno_fk foreign key(deptno)
                    references test2(no)
                    on delete cascade;     --아까 저 위에서 만든거랑 다른 점은 이거 써주면 지울 때 따라가면서 다 지워줌
                    
insert into test2 values(10,'AAA');
insert into test2 values(20,'BBB');
insert into test2 values(30,'CCC');
commit;

insert into test1 values(1,'test1',10);
insert into test1 values(2,'test2',10);
insert into test1 values(3,'test3',30);
insert into test1 values(4,'test1',20);
insert into test1 values(5,'test1',40);   
commit;
delete from test2 where no = 10;   --이부분 책에서 다시 해보기 cascade주고 지울떄 잘 지워지나 해보기 

alter table test1 drop constraint test1_deptno_fk;  --제약조건 없애는 거
alter table test1 add constraint test1_deptno_fk foreign key(deptno)
                    references test2(no)
                    on delete set null;
select * from test2;
delete from test2 where no = 20;
delete from test1 where deptno = 10;   --delete set null 차이 한번 보기  set null 은 다 지워지즌게 아니고 deptno만 지워져서 null 되는거?
select * from test1;
select * from test2;

alter table test1 modify (deptno constraint test1_dno_nn not null);  --null때문에 만들 수 없는 상황이 되서 에러? set null로 deptno지워서 null 포함되어있어서?
update test1 set deptno = 30 where no = 4;   --이제 null deptno에 값이 채워졌다
alter table test1 modify (deptno constraint test1_dno_nn not null);  --이제 작동한다.
select * from test1;
delete from test2 where no = 30;  --에러뜬다  얘를 지우면 test1에 deptno에 null로 세팅되야하는데 not null제약조건이 있어서 서로 충돌나서 못지운다. 지우려면 test1의 데이터를 다 지워야 이걸 지울 수 있음


-- p345제약조건 관리하기
insert into t_novalidate values(4,'C');
create table noval as
    select * from t_novalidate;   --테이블 복사했는데 제약조건 중에 primary key는 못가져온다. 제약조건 확인해보면 알 수 있다
select * from noval;
insert into noval values (1, 'DDD');   --데이터가 삽입이 된다. 원래 테이블에서는 프라이머리키라 안들어가지만 이건 프라이머리키 못가져와서 들어갈 수 있음
delete from noval where name = 'DDD' ;
alter table noval add constraint noval_no_pk primary key(no);  --프라이머리키 주는거
insert into noval values (1, 'DDD');  --이제 프라이머리키라서 안들어간다.  프라이머리키가 있어서 못넣는데 이걸 어떻게든 넣고싶으면 드롭해서 넣거나 잠시 이 제약조건을 못쓰게 하는 방법이 있다

alter table noval disable novalidate constraint noval_no_pk;   --novalidate는 제약조건 잠시 못쓰게 만드는거
insert into noval values (1, 'DDD');    --이제 데이터 들어간다.

select * from t_validate;
rename t_validate to val;    --테이블 이름 길어서 짧게 바꿈
select * from val;
insert into val values(4, null);  --에러남. name이 not null로 제약걸려있어서
alter table val disable validate constraint tv_name_nn;   --validate는 read only로 만드는 효과가 있음 그래서 인서트도 안됨.
insert into val values(4, null);

select * from t_enable;
insert into t_enable values(1,'AAA');
insert into t_enable values(2,'BBB');
insert into t_enable values(3,NULL);  --안들어감 제약조건 있어서
alter table t_enable disable novalidate constraint te_name_nn;
insert into t_enable values(3,NULL);  --이제 삽입이 왼다 제약조건 잠시 꺼서
alter table t_enable enable novalidate constraint te_name_nn;  --이거 이후부터는 다시 제약조건 실행되서 데이터 잘 안들어감 enable novalidate는 기존에 null있는건 신경안쓰고 이후에 들어오는 것만 신경쓴다
insert into t_enable values(1,'AAA');
insert into t_enable values(2,'BBB');
alter table t_enable disable novalidate constraint te_name_nn;
alter table t_enable enbale validate constraint te_name_nn;  --이거는 기존에 null이 있으면 안됨 제약조건에 하나라도 안맞으면 안됨
update t_enable set name = 'CCC' where no = 3;
alter table t_enable enbale validate constraint te_name_nn;    --이거 책보고 다시 고쳐보기 코드 오류났음

--dos에서 명령어 친 후
--p352
--p355  : sys계정에서 한거 hr에서 하는거?
@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\utlexcpt.sql
--sys랑 다른점은 sys.exception대신 sys빼면 된다? 책보고 해봐라

--p358
select * from user_constraints where table_name = 'AA';  --여기서 테이블 명은 꼭 대문자

--p360
alter table aa drop constraint aa_name_fk;
select * from user_constraints where table_name = 'AA';
