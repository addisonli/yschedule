CREATE TABLE pamirs_schedule_queue (
  ID bigint(20) NOT NULL,
  TASK_TYPE varchar(50) NOT NULL,
  QUEUE_ID varchar(50) NOT NULL,
  CUR_SERVER varchar(100) default NULL,
  REQ_SERVER varchar(100) default NULL,
  OWN_SIGN varchar(50) NOT NULL,
  BASE_TASK_TYPE varchar(50) default NULL,
  GMT_CREATE datetime NOT NULL,
  GMT_MODIFIED datetime NOT NULL,
  PRIMARY KEY  (ID),
  UNIQUE KEY IND_PAMIRS_SCHEDULE_QUEUEID (TASK_TYPE,QUEUE_ID,OWN_SIGN)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE pamirs_schedule_server (
  ID bigint(20) NOT NULL,
  UUID varchar(100) NOT NULL,
  TASK_TYPE varchar(50) NOT NULL,
  IP varchar(50) NOT NULL,
  HOST_NAME varchar(50) NOT NULL,
  MANAGER_PORT bigint(10) NOT NULL,
  THREAD_NUM bigint(5) NOT NULL,
  REGISTER_TIME datetime NOT NULL,
  HEARTBEAT_TIME datetime NOT NULL,
  LAST_FETCH_DATA_TIME datetime default NULL,
  VERSION bigint(12) NOT NULL,
  JMX_URL varchar(200) default NULL,
  DEALINFO_DESC varchar(1000) default NULL,
  NEXT_RUN_START_TIME varchar(100) default NULL,
  NEXT_RUN_END_TIME varchar(100) default NULL,
  OWN_SIGN varchar(50) default NULL,
  BASE_TASK_TYPE varchar(50) default NULL,
  GMT_CREATE datetime NOT NULL,
  GMT_MODIFIED datetime NOT NULL,
  PRIMARY KEY  (ID),
  KEY IND_PAMIRS_SCHEDULE_UUID (UUID)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE pamirs_schedule_tasktrun (
  ID bigint(20) NOT NULL,
  TASK_TYPE varchar(100) NOT NULL,
  OWN_SIGN varchar(50) default NULL,
  BASE_TASK_TYPE varchar(50) default NULL,
  LAST_ASSIGN_TIME datetime default NULL,
  LAST_ASSIGN_UUID varchar(100) default NULL,
  GMT_CREATE datetime NOT NULL,
  GMT_MODIFIED datetime NOT NULL,
  PRIMARY KEY  (ID),
  KEY IND_PAMIRS_SCHEDULE_RUN_TASK (TASK_TYPE,OWN_SIGN)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE pamirs_schedule_tasktype (
  ID bigint(20) NOT NULL,
  TASK_TYPE varchar(100) NOT NULL,
  LAST_ASSIGN_TIME datetime default NULL,
  LAST_ASSIGN_UUID varchar(100) default NULL,
  HEARTBEAT_RATE bigint(10) default NULL,
  JUDGE_DEAD_INTERVAL bigint(10) default NULL,
  THREAD_NUMBER bigint(5) default NULL,
  EXECUTE_NUMBER int(11) default NULL,
  FETCH_NUMBER int(11) default NULL,
  SLEEP_TIME_NODATA float(10,3) default NULL,
  SLEEP_TIME_INTERVAL float(10,3) default NULL,
  PROCESSOR_TYPE varchar(20) default NULL,
  PERMIT_RUN_START_TIME varchar(100) default NULL,
  PERMIT_RUN_END_TIME varchar(100) default NULL,
  DEAL_BEAN_NAME varchar(100) NOT NULL,
  EXPIRE_OWN_SIGN_INTERVAL float(10,2) default NULL,
  GMT_CREATE datetime NOT NULL,
  GMT_MODIFIED datetime NOT NULL,
  PRIMARY KEY  (ID),
  UNIQUE KEY IND_PAMIRS_TASKTYPE_TASKTYPE (TASK_TYPE)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE pamirs_schedule_server_his (
  ID bigint(20) NOT NULL,
  UUID varchar(100) NOT NULL,
  TASK_TYPE varchar(50) NOT NULL,
  IP varchar(50) NOT NULL,
  HOST_NAME varchar(50) NOT NULL,
  MANAGER_PORT bigint(10) NOT NULL,
  THREAD_NUM bigint(5) NOT NULL,
  REGISTER_TIME datetime NOT NULL,
  HEARTBEAT_TIME datetime NOT NULL,
  VERSION bigint(12) NOT NULL,
  JMX_URL varchar(200) default NULL,
  DEALINFO_DESC varchar(1000) default NULL,
  NEXT_RUN_START_TIME varchar(100) default NULL,
  NEXT_RUN_END_TIME varchar(100) default NULL,
  OWN_SIGN varchar(50) default NULL,
  BASE_TASK_TYPE varchar(50) default NULL,
  GMT_CREATE datetime NOT NULL,
  GMT_MODIFIED datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE pamirs_schedule_strategy (
	ID  bigint(20) NOT NULL ,
	TASK_TYPE  varchar(100) NOT NULL ,
	SERVER  varchar(300) NOT NULL ,
	RUNNING_SERVER  varchar(300) DEFAULT NULL ,
	ALIVE_NUM  bigint(12) DEFAULT NULL ,
	ASSIGN_NUM  bigint(12) NOT NULL ,
	STATUS  bigint(12) NOT NULL ,
	GMT_CREATE  datetime NOT NULL ,
	GMT_MODIFIED  datetime NOT NULL ,
	PRIMARY KEY (ID),
	UNIQUE KEY IND_PAMIRS_STRATEGY_TASKTYPE (TASK_TYPE)
)ENGINE=MyISAM DEFAULT CHARSET=utf8;
