--�̰� sys �������� ���°�
show user;

@?/rdbms/admin/utlexcpt.sql    --�̰� ����Ǹ� exception table������ִ°ǵ� �̰� �ȵ��ư� ?������ ������ġ�ε� �ȸ¾Ƽ� �׷��µ�?

@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\utlexcpt.sql

create table hr.t500(
    no number constraint t500_ck check(no > 5)
);   --hr�� ������ �ִ� ��� t500�̶�� ���̺� �����
alter table hr.t500 disable constraint t500_ck;    --validate�� novalidate�ȳ����� �⺻�� novalidate��
insert into hr.t500 values(1);
insert into hr.t500 values(6);
insert into hr.t500 values(7);
commit;
select * from hr.t500;

alter table hr.t500 enable validate constraint t500_ck exceptions into sys.exceptions;   --������ �Ǵ� ��ġ�� �˰�; �ϴ°�
select * from exceptions;  --������ ��ġ�� ������ �־��� ���̺�
update hr.t500 set no = 8 where rowid = 'AAAE6lAAEAAAAM+AAA';
commit;

truncate table sys.exceptions;

alter table hr.t500 enable validate constraint t500_ck exceptions into sys.exceptions;   --�۵��Ǿ��ٴ� ���� ���� �������߿� �����Ǵ°� ���ٴ� ��
select * from exceptions;  --������ ��ġ�� ������ �־��� ���̺�



