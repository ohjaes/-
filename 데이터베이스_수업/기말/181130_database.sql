--�������� �߿���.   �� ���� ������ ������ ����,  ����ũ�� ������ ������ �Ǿ���,  �����̸Ӹ�Ű�� ���̺�� 1���� ������ �� �ְ� ������ �� �ִ� ���� Ű�̸� ���ΰ� ����ũ ��ģ��
--                 ����Ű�� �ܷ�Ű,  üũ�� �ʿ��� �κ��� ���� ������� �������� ����?
-- �θ����̺��� �����̸Ӹ�Ű�� �ٸ� ���̺��� ����Ű�� �ɾ ������ �� �ִ�  ���� ��� �μ���ȣ ����Ű�� �� �� ����
-- ������ �̸� ���ְ� �׳� �������Ǹ� �ش�.

--���̺� ���� �� �������� �ֱ�
drop table aa;
create table aa (
    no number constraint aa_no_pk primary key ,       --aa_no_pk�̷� ��Ģ���� ��κ� �̸� �ش� 
    name varchar2(20) constraint aa_name_nn not null,
    jumin varchar2(13) not null unique,--�̰� ��Ī���� �������� �ΰ� �ذ�   �޸� ���� �ȵȴ�.
    loc number(1) constraint aa_loc_ck check(loc < 5),
    deptno varchar2(6) constraint aa_deptno_fk                       --�����ϴ� �÷��� ���� �� �÷��� ũ�⸦ ������� ���ܿ� �� �ִ�.
                        references dept2(dcode)                      --���۷����� �� s��� 
);

--���̺� ���� �� �������� �߰��ϱ�
alter table aa add constraint aa_name_uk unique(name);
alter table aa add constraint aa_loc_nn not null(loc);  --������  �⺻������ ���� ������� �Ǿ��־ add�� �ƴϰ� modify �����
alter table aa modify (loc constraint aa_loc_nn not null);  --���� loc�� �� ���ȵǰ� �� ���ڰ� 5 ���� �۾ƾ� �ϴ� ���������� �ִ°Ŵ�.

alter table aa add constraint aa_no_fk foreign key(no)
                references emp2(empno);    --����Ű �Ŵ� ��ɾ�,  ���̺� ���鋚 ����Ű ����°Ŷ� �̰Ŷ� ���� �� ���α�, emp2������ empno�� �����̸Ӹ�Ű�� �̰� ������
                
alter table aa add constraint aa_name_fk foreign key(name)
                references emp2(name);     --�̰� ������.  emp2�� ������ ����ũ�� �ƴϰų� �����̸Ӹ��� �ƴ϶� ������ ����. ����Ű �� �� �θ��� ����ũ�� �����̸Ӹ��� �����ؾ���.
                                            --�� ���̺� �����̸Ӹ�Ű�� 2�� �Ұ����̶� emp2���� name�� ����ũ�� ��������
alter table emp2 add constraint emp2_name_uk unique(name);
alter table aa add constraint aa_name_fk foreign key(name)
                references emp2(name);      --���� ���� �ȶ߰� ��

--���� �� �� ���� �����ع����� ���   on delete cascade /  on delete set null
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
                    references test2(no);     --test2�� no�� �����̸Ӹ�Ű�� �ƴϰ� ����ũ�� �ƴ϶� ����
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
insert into test1 values(5,'test1',40);   --�̰� ������ �ɷ��־ ������ 40�� �ȵ�
commit;

select * from test1;
select * from test2;

delete from test2 where no = 10;   --������� ������ٰ� ���´�. ������ ��� ����� �ڽ� ���ڵ尡 �����ؼ� �� ���� �׷��� ����
delete from test1 where deptno = 10;    --�̰ź��� ���ְ� ������ ����� �ȴ� �����ϴ� ���� ����ϱ� ���� �����Ȱ� ������ ����� ����
delete from test2 where no = 10;

drop table test1;
drop table test2; --���̺� ��ü�� �������� �������� ������ ���� �ʿ����

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
                    on delete cascade;     --�Ʊ� �� ������ ����Ŷ� �ٸ� ���� �̰� ���ָ� ���� �� ���󰡸鼭 �� ������
                    
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
delete from test2 where no = 10;   --�̺κ� å���� �ٽ� �غ��� cascade�ְ� ��� �� �������� �غ��� 

alter table test1 drop constraint test1_deptno_fk;  --�������� ���ִ� ��
alter table test1 add constraint test1_deptno_fk foreign key(deptno)
                    references test2(no)
                    on delete set null;
select * from test2;
delete from test2 where no = 20;
delete from test1 where deptno = 10;   --delete set null ���� �ѹ� ����  set null �� �� ��������� �ƴϰ� deptno�� �������� null �Ǵ°�?
select * from test1;
select * from test2;

alter table test1 modify (deptno constraint test1_dno_nn not null);  --null������ ���� �� ���� ��Ȳ�� �Ǽ� ����? set null�� deptno������ null ���ԵǾ��־?
update test1 set deptno = 30 where no = 4;   --���� null deptno�� ���� ä������
alter table test1 modify (deptno constraint test1_dno_nn not null);  --���� �۵��Ѵ�.
select * from test1;
delete from test2 where no = 30;  --�������  �긦 ����� test1�� deptno�� null�� ���õǾ��ϴµ� not null���������� �־ ���� �浹���� �������. ������� test1�� �����͸� �� ������ �̰� ���� �� ����


-- p345�������� �����ϱ�
insert into t_novalidate values(4,'C');
create table noval as
    select * from t_novalidate;   --���̺� �����ߴµ� �������� �߿� primary key�� �������´�. �������� Ȯ���غ��� �� �� �ִ�
select * from noval;
insert into noval values (1, 'DDD');   --�����Ͱ� ������ �ȴ�. ���� ���̺����� �����̸Ӹ�Ű�� �ȵ����� �̰� �����̸Ӹ�Ű �������ͼ� �� �� ����
delete from noval where name = 'DDD' ;
alter table noval add constraint noval_no_pk primary key(no);  --�����̸Ӹ�Ű �ִ°�
insert into noval values (1, 'DDD');  --���� �����̸Ӹ�Ű�� �ȵ���.  �����̸Ӹ�Ű�� �־ ���ִµ� �̰� ��Ե� �ְ������ ����ؼ� �ְų� ��� �� ���������� ������ �ϴ� ����� �ִ�

alter table noval disable novalidate constraint noval_no_pk;   --novalidate�� �������� ��� ������ ����°�
insert into noval values (1, 'DDD');    --���� ������ ����.

select * from t_validate;
rename t_validate to val;    --���̺� �̸� �� ª�� �ٲ�
select * from val;
insert into val values(4, null);  --������. name�� not null�� ����ɷ��־
alter table val disable validate constraint tv_name_nn;   --validate�� read only�� ����� ȿ���� ���� �׷��� �μ�Ʈ�� �ȵ�.
insert into val values(4, null);

select * from t_enable;
insert into t_enable values(1,'AAA');
insert into t_enable values(2,'BBB');
insert into t_enable values(3,NULL);  --�ȵ� �������� �־
alter table t_enable disable novalidate constraint te_name_nn;
insert into t_enable values(3,NULL);  --���� ������ �޴� �������� ��� ����
alter table t_enable enable novalidate constraint te_name_nn;  --�̰� ���ĺ��ʹ� �ٽ� �������� ����Ǽ� ������ �� �ȵ� enable novalidate�� ������ null�ִ°� �Ű�Ⱦ��� ���Ŀ� ������ �͸� �Ű澴��
insert into t_enable values(1,'AAA');
insert into t_enable values(2,'BBB');
alter table t_enable disable novalidate constraint te_name_nn;
alter table t_enable enbale validate constraint te_name_nn;  --�̰Ŵ� ������ null�� ������ �ȵ� �������ǿ� �ϳ��� �ȸ����� �ȵ�
update t_enable set name = 'CCC' where no = 3;
alter table t_enable enbale validate constraint te_name_nn;    --�̰� å���� �ٽ� ���ĺ��� �ڵ� ��������

--dos���� ��ɾ� ģ ��
--p352
--p355  : sys�������� �Ѱ� hr���� �ϴ°�?
@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\utlexcpt.sql
--sys�� �ٸ����� sys.exception��� sys���� �ȴ�? å���� �غ���

--p358
select * from user_constraints where table_name = 'AA';  --���⼭ ���̺� ���� �� �빮��

--p360
alter table aa drop constraint aa_name_fk;
select * from user_constraints where table_name = 'AA';
