create table SCHEDULE_TEST
(
  ID         NUMBER,
  DEAL_COUNT NUMBER,
  STS        VARCHAR2(10),
  OWN_SIGN   VARCHAR2(10)
);
create index IND_ID on SCHEDULE_TEST (ID);

insert into PAMIRS_SCHEDULE_TASKTYPE (ID,TASK_TYPE,DEAL_BEAN_NAME,HEARTBEAT_RATE, JUDGE_DEAD_INTERVAL, 
THREAD_NUMBER, EXECUTE_NUMBER, FETCH_NUMBER,SLEEP_TIME_NODATA,SLEEP_TIME_INTERVAL,PROCESSOR_TYPE,GMT_CREATE,GMT_MODIFIED)
values (1,'PamirsScheduleTest','queueTestTask',5, 60, 5, 10, 500,0.5,0,'SLEEP',sysdate,sysdate);

insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (1,'PamirsScheduleTest', '0','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (2,'PamirsScheduleTest', '1','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (3,'PamirsScheduleTest', '2','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (4,'PamirsScheduleTest', '3','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (5,'PamirsScheduleTest', '4','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (6,'PamirsScheduleTest', '5','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (7,'PamirsScheduleTest', '6','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (8,'PamirsScheduleTest', '7','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (9,'PamirsScheduleTest', '8','BASE',sysdate,sysdate);
insert into PAMIRS_SCHEDULE_QUEUE (ID,TASK_TYPE,QUEUE_ID,OWN_SIGN,GMT_CREATE,GMT_MODIFIED)values (10,'PamirsScheduleTest', '9','BASE',sysdate,sysdate);

commit;

create or replace procedure CREATE_TEST_DATA(ownSign in varchar2,datanum in  NUMBER) is
I NUMBER;
POINT NUMBER;

begin
I :=1;
LOOP
  EXIT WHEN I > datanum;
  insert into SCHEDULE_TEST VALUES(i,0,'N',ownSign); 
  I:=I+1;
  POINT :=POINT + 1;
  IF POINT > 1000 THEN
    POINT :=0;
    COMMIT;
  END IF;
END LOOP;

COMMIT;

end ;
/

EXECUTE CREATE_TEST_DATA('BASE',100000);
EXECUTE CREATE_TEST_DATA('TEST',100000);
EXECUTE CREATE_TEST_DATA('PRE',100000);