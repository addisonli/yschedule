-- Create 调度任务表
create table PAMIRS_SCHEDULE_TASKTYPE
(
  ID                       NUMBER not null,
  TASK_TYPE                VARCHAR2(100) not null,  
  DEAL_BEAN_NAME           VARCHAR2(100) not null,
  HEARTBEAT_RATE           NUMBER(10) not null,
  JUDGE_DEAD_INTERVAL      NUMBER(10) not null,
  THREAD_NUMBER            NUMBER(5) not null,
  EXECUTE_NUMBER           NUMBER(5),
  FETCH_NUMBER             NUMBER(5),
  SLEEP_TIME_NODATA        NUMBER(10,3),
  SLEEP_TIME_INTERVAL      NUMBER(10,3),
  PROCESSOR_TYPE           VARCHAR2(20),
  PERMIT_RUN_START_TIME    VARCHAR2(100),
  PERMIT_RUN_END_TIME      VARCHAR2(100),
  LAST_ASSIGN_TIME         DATE,
  LAST_ASSIGN_UUID         VARCHAR2(100),
  EXPIRE_OWN_SIGN_INTERVAL NUMBER(10,2),
  GMT_CREATE               DATE not null,
  GMT_MODIFIED             DATE not null
);

alter table PAMIRS_SCHEDULE_TASKTYPE  add constraint PK_PAMIRS_SCHEDULE_TASKTYPE primary key (ID);
create unique index IND_PAMIRS_TASKTYPE_TASKTYPE on PAMIRS_SCHEDULE_TASKTYPE (TASK_TYPE);

comment on table PAMIRS_SCHEDULE_TASKTYPE is  '调度处理的任务类型';
comment on column PAMIRS_SCHEDULE_TASKTYPE.ID is  '唯一编号，是数据库管理的需要';
comment on column PAMIRS_SCHEDULE_TASKTYPE.TASK_TYPE is  '任务类型，要求唯一性，建立唯一索引';
comment on column PAMIRS_SCHEDULE_TASKTYPE.HEARTBEAT_RATE is  '心跳频率';
comment on column PAMIRS_SCHEDULE_TASKTYPE.JUDGE_DEAD_INTERVAL is  '判断服务器死亡的心跳间隔';
comment on column PAMIRS_SCHEDULE_TASKTYPE.THREAD_NUMBER is  '每一个调度服务器的线程数量';
comment on column PAMIRS_SCHEDULE_TASKTYPE.EXECUTE_NUMBER is  '批处理的时候，每次执行的数据量';
comment on column PAMIRS_SCHEDULE_TASKTYPE.FETCH_NUMBER is  '每次查询获取的数据量';
comment on column PAMIRS_SCHEDULE_TASKTYPE.SLEEP_TIME_NODATA is  '当没有取到数据时候，休眠的时间,缺省是0，不休眠(单位秒)';
comment on column PAMIRS_SCHEDULE_TASKTYPE.SLEEP_TIME_INTERVAL is  '休眠时间，每一批数据处理完成后，缺省是0，不休眠(单位秒)';
comment on column PAMIRS_SCHEDULE_TASKTYPE.PROCESSOR_TYPE is  '处理器类型：SLEEP  或者 NOTSLEEP,缺省是SLEEP';
comment on column PAMIRS_SCHEDULE_TASKTYPE.PERMIT_RUN_START_TIME is  '允许执行时段的开始时间crontab的时间格式.以startrun:开始，则表示开机立即启动调度';
comment on column PAMIRS_SCHEDULE_TASKTYPE.PERMIT_RUN_END_TIME is  '允许执行时段的结束时间crontab的时间格式,如果不设置，表示取不到数据就停止';
comment on column PAMIRS_SCHEDULE_TASKTYPE.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_TASKTYPE.GMT_MODIFIED is  '修改时间';
comment on column PAMIRS_SCHEDULE_TASKTYPE.LAST_ASSIGN_TIME is  '最近进行环境处理时间';
comment on column PAMIRS_SCHEDULE_TASKTYPE.LAST_ASSIGN_UUID is  '最近进行环境处理的Server';
comment on column PAMIRS_SCHEDULE_TASKTYPE.EXPIRE_OWN_SIGN_INTERVAL is  '清除过期环境数据的时间间隔,单位是天，2.0版本新增';
comment on column PAMIRS_SCHEDULE_TASKTYPE.DEAL_BEAN_NAME is  '处理任务Bean的名称，Spring中的配置，2.0版本新增';

--create 调度任务队列表
create table PAMIRS_SCHEDULE_QUEUE
(
  ID             NUMBER not null,
  TASK_TYPE      VARCHAR2(50) not null,
  QUEUE_ID       VARCHAR2(50) not null,
  OWN_SIGN       VARCHAR2(50) not null,
  BASE_TASK_TYPE VARCHAR2(50),
  CUR_SERVER     VARCHAR2(100),
  REQ_SERVER     VARCHAR2(100),
  GMT_CREATE     DATE not null,
  GMT_MODIFIED   DATE not null
);

alter table PAMIRS_SCHEDULE_QUEUE  add constraint PK_PAMIRS_SCHEDULE_QUEUE primary key (ID);
create unique index IND_PAMIRS_SCHEDULE_QUEUEID on PAMIRS_SCHEDULE_QUEUE (TASK_TYPE, QUEUE_ID, OWN_SIGN);

comment on table PAMIRS_SCHEDULE_QUEUE is  '调度队列';
comment on column PAMIRS_SCHEDULE_QUEUE.ID is  '主键ID';
comment on column PAMIRS_SCHEDULE_QUEUE.TASK_TYPE is  '任务类型,由BASE_TASK_TYPE-OWN_SIGN构成，如果是BASE，则是BASE_TASK_TYPE';
comment on column PAMIRS_SCHEDULE_QUEUE.QUEUE_ID is  '任务队列编号';
comment on column PAMIRS_SCHEDULE_QUEUE.CUR_SERVER is  '当前持有的调度服务器';
comment on column PAMIRS_SCHEDULE_QUEUE.REQ_SERVER is  '请求调度的服务器';
comment on column PAMIRS_SCHEDULE_QUEUE.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_QUEUE.GMT_MODIFIED is  '修改时间';
comment on column PAMIRS_SCHEDULE_QUEUE.OWN_SIGN is  '环境，例如 开发、测试、预发、线上。缺省BASE，2.0版本新增';
comment on column PAMIRS_SCHEDULE_QUEUE.BASE_TASK_TYPE is  '基础任务类型，2.0版本新增';
  
  
-- Create 运行期任务表
create table PAMIRS_SCHEDULE_TASKTRUN
(
  ID               NUMBER not null,
  TASK_TYPE        VARCHAR2(100) not null,
  OWN_SIGN         VARCHAR2(50),
  BASE_TASK_TYPE   VARCHAR2(50),
  LAST_ASSIGN_TIME DATE,
  LAST_ASSIGN_UUID VARCHAR2(100),
  GMT_CREATE       DATE not null,
  GMT_MODIFIED     DATE not null
);

alter table PAMIRS_SCHEDULE_TASKTRUN  add constraint PK_PAMIRS_SCHEDULE_RUN primary key (ID);
create index IND_PAMIRS_SCHEDULE_RUN_TASK on PAMIRS_SCHEDULE_TASKTRUN (TASK_TYPE, OWN_SIGN);

comment on table PAMIRS_SCHEDULE_TASKTRUN is  '运行期任务表，2.0版本新增';
comment on column PAMIRS_SCHEDULE_TASKTRUN.ID is  '主键ID';
comment on column PAMIRS_SCHEDULE_TASKTRUN.TASK_TYPE is  '任务类型，由BASE_TASK_TYPE-OWN_SIGN构成，如果是BASE，则是BASE_TASK_TYPE';
comment on column PAMIRS_SCHEDULE_TASKTRUN.LAST_ASSIGN_TIME is  '最近一次任务分配时间';
comment on column PAMIRS_SCHEDULE_TASKTRUN.LAST_ASSIGN_UUID is  '最近一次进行任务分配的服务器';
comment on column PAMIRS_SCHEDULE_TASKTRUN.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_TASKTRUN.GMT_MODIFIED is  '修改时间';
comment on column PAMIRS_SCHEDULE_TASKTRUN.OWN_SIGN is  '环境，例如 开发、测试、预发、线上。缺省BASE';
comment on column PAMIRS_SCHEDULE_TASKTRUN.BASE_TASK_TYPE is  '基础任务类型';
  
-- Create 调度服务器表
create table PAMIRS_SCHEDULE_SERVER
(
  ID                  NUMBER not null,
  UUID                VARCHAR2(100) not null,
  TASK_TYPE           VARCHAR2(50) not null,
  OWN_SIGN            VARCHAR2(50) not null,
  BASE_TASK_TYPE      VARCHAR2(50) not null,  
  IP                  VARCHAR2(50) not null,
  HOST_NAME           VARCHAR2(50) not null,
  MANAGER_PORT        NUMBER(10) not null,
  THREAD_NUM          NUMBER(5) not null,
  REGISTER_TIME       DATE not null,
  HEARTBEAT_TIME      DATE not null,
  LAST_FETCH_DATA_TIME DATE,
  VERSION             NUMBER(12) not null,
  JMX_URL             VARCHAR2(200),
  DEALINFO_DESC       VARCHAR2(1000),
  NEXT_RUN_START_TIME VARCHAR2(100),
  NEXT_RUN_END_TIME   VARCHAR2(100),
  GMT_CREATE          DATE not null,
  GMT_MODIFIED        DATE not null
);

alter table PAMIRS_SCHEDULE_SERVER add constraint PK_PAMIRS_SCHEDULE_SERVER primary key (ID);
create index IND_PAMIRS_SCHEDULE_UUID on PAMIRS_SCHEDULE_SERVER (UUID); 
 
comment on table PAMIRS_SCHEDULE_SERVER is  '调度服务器';
comment on column PAMIRS_SCHEDULE_SERVER.ID is  '主键ID';
comment on column PAMIRS_SCHEDULE_SERVER.UUID is  '调度服务器唯一编号';
comment on column PAMIRS_SCHEDULE_SERVER.TASK_TYPE is  '任务类型。由BASE_TASK_TYPE-OWN_SIGN构成，如果是BASE，则是BASE_TASK_TYPE';
comment on column PAMIRS_SCHEDULE_SERVER.IP is  'IP地址';
comment on column PAMIRS_SCHEDULE_SERVER.HOST_NAME is  '主机名称';
comment on column PAMIRS_SCHEDULE_SERVER.MANAGER_PORT is  'JMX的HTTP协议远程管理端口';
comment on column PAMIRS_SCHEDULE_SERVER.THREAD_NUM is  '线程数量';
comment on column PAMIRS_SCHEDULE_SERVER.REGISTER_TIME is  '注册时间';
comment on column PAMIRS_SCHEDULE_SERVER.HEARTBEAT_TIME is  '最后一次心跳时间';
comment on column PAMIRS_SCHEDULE_SERVER.VERSION is  '版本号';
comment on column PAMIRS_SCHEDULE_SERVER.JMX_URL is  'JMX的连接串';
comment on column PAMIRS_SCHEDULE_SERVER.DEALINFO_DESC is  '调度处理情况描述';
comment on column PAMIRS_SCHEDULE_SERVER.NEXT_RUN_START_TIME is  '当限制直接时间段的时候，下一次启动时间';
comment on column PAMIRS_SCHEDULE_SERVER.NEXT_RUN_END_TIME is  '当限制直接时间段的时候，下一次必须终止的时间';
comment on column PAMIRS_SCHEDULE_SERVER.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_SERVER.GMT_MODIFIED is  '修改时间';
comment on column PAMIRS_SCHEDULE_SERVER.OWN_SIGN is  '环境，例如 开发、测试、预发、线上。缺省BASE，2.0版本新增';
comment on column PAMIRS_SCHEDULE_SERVER.BASE_TASK_TYPE is  '基础任务类型，2.0版本新增';



-- Create 调度服务器历史表
create table PAMIRS_SCHEDULE_SERVER_HIS
(
  ID                  NUMBER not null,
  UUID                VARCHAR2(100) not null,
  TASK_TYPE           VARCHAR2(100) not null,
  OWN_SIGN            VARCHAR2(50) not null,
  BASE_TASK_TYPE      VARCHAR2(50) not null,  
  IP                  VARCHAR2(50) not null,
  HOST_NAME           VARCHAR2(50) not null,
  MANAGER_PORT        NUMBER(10) not null,
  THREAD_NUM          NUMBER(5) not null,
  REGISTER_TIME       DATE not null,
  HEARTBEAT_TIME      DATE not null,
  VERSION             NUMBER(12) not null,
  JMX_URL             VARCHAR2(200),
  DEALINFO_DESC       VARCHAR2(1000),
  NEXT_RUN_START_TIME VARCHAR2(100),
  NEXT_RUN_END_TIME   VARCHAR2(100),
  GMT_CREATE          DATE not null,
  GMT_MODIFIED        DATE not null
);

 
comment on table PAMIRS_SCHEDULE_SERVER_HIS is  '调度服务器';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.ID is  '主键ID';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.UUID is  '调度服务器唯一编号';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.TASK_TYPE is  '任务类型。由BASE_TASK_TYPE-OWN_SIGN构成，如果是BASE，则是BASE_TASK_TYPE';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.IP is  'IP地址';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.HOST_NAME is  '主机名称';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.MANAGER_PORT is  'JMX的HTTP协议远程管理端口';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.THREAD_NUM is  '线程数量';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.REGISTER_TIME is  '注册时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.HEARTBEAT_TIME is  '最后一次心跳时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.VERSION is  '版本号';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.JMX_URL is  'JMX的连接串';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.DEALINFO_DESC is  '调度处理情况描述';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.NEXT_RUN_START_TIME is  '当限制直接时间段的时候，下一次启动时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.NEXT_RUN_END_TIME is  '当限制直接时间段的时候，下一次必须终止的时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.GMT_MODIFIED is  '修改时间';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.OWN_SIGN is  '环境，例如 开发、测试、预发、线上。缺省BASE，2.0版本新增';
comment on column PAMIRS_SCHEDULE_SERVER_HIS.BASE_TASK_TYPE is  '基础任务类型，2.0版本新增';

CREATE TABLE PAMIRS_SCHEDULE_STRATEGY (
	ID  NUMBER NOT NULL ,
	TASK_TYPE  VARCHAR2(100) NOT NULL ,
	SERVER  VARCHAR2(300) NOT NULL ,
	RUNNING_SERVER  VARCHAR2(300) ,
	ALIVE_NUM  NUMBER(10) ,
	ASSIGN_NUM  NUMBER(10) NOT NULL ,
	STATUS  NUMBER(5) NOT NULL ,
	GMT_CREATE  DATE NOT NULL ,
	GMT_MODIFIED  DATE NOT NULL
);
alter table PAMIRS_SCHEDULE_STRATEGY add constraint PK_PAMIRS_SCHEDULE_STRATEGY primary key (ID);
create index IND_PAMIRS_STRATEGY_TASKTYPE on PAMIRS_SCHEDULE_STRATEGY (TASK_TYPE); 
comment on table PAMIRS_SCHEDULE_STRATEGY is  '机器指派策略';
comment on column PAMIRS_SCHEDULE_STRATEGY.ID is  '主键ID';
comment on column PAMIRS_SCHEDULE_STRATEGY.TASK_TYPE is  '主机处理任务标识';
comment on column PAMIRS_SCHEDULE_STRATEGY.SERVER is  '可执行任务的主机IP';
comment on column PAMIRS_SCHEDULE_STRATEGY.RUNNING_SERVER is  '正在运行任务的主机IP';
comment on column PAMIRS_SCHEDULE_STRATEGY.ALIVE_NUM is  '正在运行任务的主机数量';
comment on column PAMIRS_SCHEDULE_STRATEGY.ASSIGN_NUM is  '指定任务执行的主机数量';
comment on column PAMIRS_SCHEDULE_STRATEGY.STATUS is  '是否有效，1.有效 2.无效';
comment on column PAMIRS_SCHEDULE_STRATEGY.GMT_CREATE is  '创建时间';
comment on column PAMIRS_SCHEDULE_STRATEGY.GMT_MODIFIED is  '修改时间';
