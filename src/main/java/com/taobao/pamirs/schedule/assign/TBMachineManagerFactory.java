package com.taobao.pamirs.schedule.assign;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;

/**
 * 
 * @author pin
 *
 */
public class TBMachineManagerFactory implements InitializingBean {

	private static transient Log log = LogFactory
			.getLog(TBMachineManagerFactory.class);

	private IMachineConfigCenterClient machineConfigCenter;
	private Timer serverRunTimer;
	private IMachineAssign machineProcessor;
	private Map<String, ServerStruct> taskServerMap = new HashMap<String, ServerStruct>();
	private static boolean lockFactoryCreated = false;

	@Override
	public void afterPropertiesSet() throws Exception {
		synchronized (this) {
			if (!lockFactoryCreated) {
				createTBMachineManager();
				lockFactoryCreated = true;
			}
		}
	}

	private void createTBMachineManager() throws Exception {
		if (machineConfigCenter == null) {
			throw new Exception("没有设置机器配置中心客户端的接口实现，请在Spring中配置，或者通过程序设置");
		}
		if (machineProcessor == null) {
			throw new Exception(
					"没有注入实现 IMachineAssign接口spring bean，请在Spring中配置");
		}
		List<MachineStrategy> machineStrategyList = this.machineConfigCenter
				.loadAllValidMachineStrategy();
		if (machineStrategyList == null || machineStrategyList.isEmpty()) {
			log.warn("没有找到有效的机器策略，请配置机器策略");
			return;
		}
		TBMachineManager manager = new TBMachineManager(machineConfigCenter,
				machineProcessor);
		String localIP = InetAddress.getLocalHost().getHostAddress();
		for (MachineStrategy machineStrategy : machineStrategyList) {
			String taskType = machineStrategy.getTaskType();
			if (taskServerMap.get(taskType) == null) {
				taskServerMap.put(taskType, new ServerStruct(localIP));
			}
		}
		serverRunTimer = new Timer("MachineAssign");
		serverRunTimer.schedule(new ServerRunTimerTask(manager, taskServerMap),
				new java.sql.Date(System.currentTimeMillis() + 500), 50 * 1000);
	}

	public void setMachineConfigCenter(
			IMachineConfigCenterClient machineConfigCenter) {
		this.machineConfigCenter = machineConfigCenter;
	}

	public void setMachineProcessor(IMachineAssign machineProcessor) {
		this.machineProcessor = machineProcessor;
	}

}

class ServerRunTimerTask extends java.util.TimerTask {
	private static transient Log log = LogFactory
			.getLog(ServerRunTimerTask.class);
	TBMachineManager manager;
	Map<String, ServerStruct> taskServerMap;

	public ServerRunTimerTask(TBMachineManager aManager,
			Map<String, ServerStruct> aTaskServerMap) {
		manager = aManager;
		taskServerMap = aTaskServerMap;
	}

	public void run() {
		Thread.currentThread().setPriority(Thread.MAX_PRIORITY);
		for (Map.Entry<String, ServerStruct> entry : taskServerMap.entrySet()) {
			try {
				manager.assignServerRun(entry.getKey(), entry.getValue());
			} catch (Exception ex) {
				log.error(ex.getMessage(), ex);
			}
		}
	}
}