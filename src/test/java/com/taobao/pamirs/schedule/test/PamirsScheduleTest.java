package com.taobao.pamirs.schedule.test;


import org.junit.Test;
import org.unitils.UnitilsJUnit4;
import org.unitils.spring.annotation.SpringApplicationContext;
import org.unitils.spring.annotation.SpringBeanByName;

import com.taobao.pamirs.schedule.TBScheduleManagerFactory;
import com.taobao.pamirs.schedule.assign.TBMachineManagerFactory;

/**
 * 调度测试
 * @author xuannan
 *
 */
@SpringApplicationContext( { "schedule.xml" })
public class PamirsScheduleTest  extends UnitilsJUnit4{
	@SpringBeanByName
	TBScheduleManagerFactory tbScheduleManagerFactory;
	@SpringBeanByName
	TBMachineManagerFactory tbMachineManagerFactory;
	
    public void setTbScheduleManagerFactory(
			TBScheduleManagerFactory tbScheduleManagerFactory) {
		this.tbScheduleManagerFactory = tbScheduleManagerFactory;
	}
	public void setTbMachineManagerFactory(
			TBMachineManagerFactory tbMachineManagerFactory) {
		this.tbMachineManagerFactory = tbMachineManagerFactory;
	}
	public void testLoadRunningInfo() throws Exception{
		String baseTaskType ="PamirsScheduleTest";
		String ownSign ="TEST";
		tbScheduleManagerFactory
			.getScheduleConfigCenter().loadTaskTypeRunningInfo(baseTaskType, ownSign, "-100");
		float d = 0.0f;
		tbScheduleManagerFactory
		.getScheduleConfigCenter().clearExpireTaskTypeRunningInfo(baseTaskType,"-1",d);
	}
	@Test    
	public void testRunData() throws Exception {
//		available to test
		Thread.sleep(10000000);
	}
}
