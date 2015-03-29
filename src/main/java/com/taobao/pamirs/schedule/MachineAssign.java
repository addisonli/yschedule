package com.taobao.pamirs.schedule;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.taobao.pamirs.schedule.assign.IMachineAssign;

/**
 * @author pin
 *
 */
public class MachineAssign implements IMachineAssign {

	private static transient Log log = LogFactory.getLog(IMachineAssign.class);

	private TBScheduleManagerFactory tbScheduleManagerFactory;
	private IScheduleConfigCenterClient scheduleConfigCenter;

	@Override
	public List<String> selectRunningMachine(String taskType) throws Exception {
		List<ScheduleServer> servList = scheduleConfigCenter
				.selectAllValidScheduleServer(taskType);
		List<String> runningMachine = new ArrayList<String>();
		if (servList != null && !servList.isEmpty()) {
			for (ScheduleServer server : servList) {
				if (server.getCenterServerTime().getTime()
						- server.getHeartBeatTime().getTime() > 5 * 60 * 1000) {
					log.warn("机器" + server.getIp() + "心跳已经超过5分钟未更新!");
				} else {
					runningMachine.add(server.getIp());
				}
			}
		}
		return runningMachine;
	}

	@Override
	public void joinMachineDeal(String taskType) throws Exception {
		String[] task = taskType.split("\\$");
		String ownSign = "";
		if (task.length == 1) {
			ownSign = "BASE";
		} else if (task.length == 2) {
			taskType = task[0];
			ownSign = task[1];
		} else {
			throw new Exception("taskType格式错误，请检查配置");
		}
		log.info("任务" + taskType + "$" + ownSign + "符合机器执行策略,创建任务");
		tbScheduleManagerFactory.createTBScheduleManager(taskType, ownSign);
	}

	@Override
	public void removeMachineDeal(String taskType) throws Exception {
		for (String key : tbScheduleManagerFactory.getManagerMap().keySet()) {
			int index = taskType.contains("$") ? key.lastIndexOf('$') : key
					.indexOf('$');
			if (taskType.equals(key.substring(0, index))) {
				TBScheduleManager tbScheduleManager = tbScheduleManagerFactory
						.getManagerMap().get(key);
				if (tbScheduleManager != null) {
					log.info("任务" + taskType + "不符合机器执行策略,停止任务");
					tbScheduleManager.stopScheduleServer();
					tbScheduleManagerFactory.getManagerMap().remove(key);
					break;
				}
			}
		}
	}

	@Override
	public int getLocalManagerNum(String taskType) throws Exception {
		int managerNum = 0;
		for (String key : tbScheduleManagerFactory.getManagerMap().keySet()) {
			int index = taskType.contains("$") ? key.lastIndexOf('$') : key
					.indexOf('$');
			if (taskType.equals(key.substring(0, index))) {
				TBScheduleManager tbScheduleManager = tbScheduleManagerFactory
						.getManagerMap().get(key);
				if (tbScheduleManager != null) {
					managerNum++;
				}
			}
		}
		return managerNum;
	}

	public void setTbScheduleManagerFactory(
			TBScheduleManagerFactory tbScheduleManagerFactory) {
		this.tbScheduleManagerFactory = tbScheduleManagerFactory;
	}

	public void setScheduleConfigCenter(
			IScheduleConfigCenterClient scheduleConfigCenter) {
		this.scheduleConfigCenter = scheduleConfigCenter;
	}

}
