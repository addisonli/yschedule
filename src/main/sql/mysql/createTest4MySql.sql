CREATE TABLE SCHEDULE_TEST (
  ID bigint(15) default NULL,
  DEAL_COUNT int(11) default NULL,
  STS varchar(2) default NULL,
  OWN_SIGN varchar(50) not NULL,
  PRIMARY KEY (ID)
);


insert into PAMIRS_SCHEDULE_TASKTYPE (ID,TASK_TYPE,HEARTBEAT_RATE, JUDGE_DEAD_INTERVAL, 
THREAD_NUMBER, EXECUTE_NUMBER, FETCH_NUMBER,SLEEP_TIME_NODATA,SLEEP_TIME_INTERVAL,PROCESSOR_TYPE,DEAL_BEAN_NAME,GMT_CREATE,GMT_MODIFIED)
values (1,'PamirsScheduleTest',5, 60,5, 10, 500,0.5,0,'NOTSLEEP','queueTestTask',now(),now());

insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (1,'PamirsScheduleTest', '0','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (2,'PamirsScheduleTest', '1','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (3,'PamirsScheduleTest', '2','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (4,'PamirsScheduleTest', '3','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (5,'PamirsScheduleTest', '4','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (6,'PamirsScheduleTest', '5','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (7,'PamirsScheduleTest', '6','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (8,'PamirsScheduleTest', '7','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (9,'PamirsScheduleTest', '8','BASE',now(),now());
insert into PAMIRS_SCHEDULE_QUEUE (ID, TASK_TYPE, QUEUE_ID, OWN_SIGN, GMT_CREATE, GMT_MODIFIED)values (10,'PamirsScheduleTest', '9','BASE',now(),now());

commit;

--动态的造几十万数据
CREATE  PROCEDURE CREATE_TEST_DATA(IN ownSign varchar(50),IN datanum INTEGER(11))
BEGIN
 declare i int DEFAULT 1;
  WHILE i <= datanum DO
    insert into SCHEDULE_TEST VALUES(i,0,'N',ownSign); 
   set i = i + 1;
  END WHILE;
END;

CALL CREATE_TEST_DATA('BASE',100000);