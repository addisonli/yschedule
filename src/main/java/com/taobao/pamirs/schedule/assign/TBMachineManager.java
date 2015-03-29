package com.taobao.pamirs.schedule.assign;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 
 * @author pin
 *
 */
public class TBMachineManager {

	private static transient Log log = LogFactory
			.getLog(TBMachineManager.class);

	private MachineStrategy machineStrategy;
	private IMachineConfigCenterClient machineCenter;
	/**
	 * 任务处理的接口类
	 */
	protected IMachineAssign machineProcessor;

	public TBMachineManager(IMachineConfigCenterClient machineCenter,
			IMachineAssign machineProcessor) throws Exception {
		this.machineCenter = machineCenter;
		this.machineProcessor = machineProcessor;
	}

	public void assignServerRun(String taskType, ServerStruct localTaskServer)
			throws Exception {
		this.machineStrategy = machineCenter.loadMachineStrategy(taskType);
		List<String> runningServerList = machineProcessor
				.selectRunningMachine(taskType);
		String localIP = InetAddress.getLocalHost().getHostAddress();
		if (machineStrategy != null) {
			try {
				initServerStruct(machineStrategy.getServer(), localTaskServer,
						runningServerList, taskType);
			} catch (Exception e) {
				log.error("错误的配置，请检查策略表server字段的配置是否正确", e);
			}
			int aliveNum = runningServerList != null ? runningServerList.size()
					: 0;
			if (aliveNum != machineStrategy.getAliveNum()) {
				MachineStrategy ms = new MachineStrategy(machineStrategy);
				ms.setAliveNum(aliveNum);
				String runningServers = addRunningServer(runningServerList, "");
				ms.setRunningServer(runningServers);
				boolean success = machineCenter.assignMachineStrategy(ms,
						machineStrategy.getAliveNum());
				if (success) {
					machineStrategy.setAliveNum(aliveNum);
					machineStrategy.setRunningServer(runningServers);
				}
			}
			if (aliveNum < machineStrategy.getAssignNum()
					&& localTaskServer.getAliveNum() < localTaskServer
							.getAssignNum()) {
				localTaskServer.setAliveNum(localTaskServer.getAliveNum() + 1);
				String localServerInfo = localIP + "$"
						+ localTaskServer.getAliveNum();
				MachineStrategy ms = new MachineStrategy(machineStrategy);
				ms.setAliveNum(aliveNum + 1);
				ms.setRunningServer(addRunningServer(runningServerList,
						localServerInfo));
				boolean startProcess = machineCenter.assignMachineStrategy(ms,
						machineStrategy.getAliveNum());
				if (startProcess) {
					try {
						machineProcessor.joinMachineDeal(taskType);
					} catch (Exception e) {
						log.error(e.getMessage(), e);
						localTaskServer.setAliveNum(localTaskServer
								.getAliveNum() - 1);
						localServerInfo = localTaskServer.getAliveNum() == 0 ? ""
								: localIP + "$" + localTaskServer.getAliveNum();
						ms.setAliveNum(aliveNum - 1);
						ms.setRunningServer(removeRunningServer(
								runningServerList, localServerInfo));
						machineCenter.assignMachineStrategy(ms,
								machineStrategy.getAliveNum());
					}
				}
			}
			if (localTaskServer.getAliveNum() > 0
					&& (aliveNum > machineStrategy.getAssignNum() || localTaskServer
							.getAliveNum() > localTaskServer.getAssignNum())) {
				localTaskServer.setAliveNum(localTaskServer.getAliveNum() - 1);
				String localServerInfo = localTaskServer.getAliveNum() == 0 ? localIP
						: localIP + "$" + localTaskServer.getAliveNum();
				MachineStrategy ms = new MachineStrategy(machineStrategy);
				ms.setAliveNum(aliveNum - 1);
				ms.setRunningServer(removeRunningServer(runningServerList,
						localServerInfo));
				boolean stopProcess = machineCenter.assignMachineStrategy(ms,
						machineStrategy.getAliveNum());
				if (stopProcess) {
					try {
						machineProcessor.removeMachineDeal(taskType);
					} catch (Exception e) {
						log.error(e.getMessage(), e);
						localTaskServer.setAliveNum(localTaskServer
								.getAliveNum() + 1);
						localServerInfo = localIP + "$"
								+ localTaskServer.getAliveNum();
						ms.setAliveNum(aliveNum + 1);
						ms.setRunningServer(addRunningServer(runningServerList,
								localServerInfo));
						machineCenter.assignMachineStrategy(ms,
								machineStrategy.getAliveNum());
					}
				}
			}
		}
	}

	private void initServerStruct(String server, ServerStruct localTaskServer,
			List<String> runningServerList, String taskType) throws Exception {
		String[] serverList = server.split(",");
		boolean isLocalCancel = true;
		for (String serv : serverList) {
			if (serv.contains(localTaskServer.getServer())) {
				if (runningServerList.contains(localTaskServer.getServer())) {
					localTaskServer.setAliveNum(machineProcessor
							.getLocalManagerNum(taskType));
				} else {
					localTaskServer.setAliveNum(0);
				}
				if (serv.contains("$")) {
					String[] servs = serv.split("\\$");
					localTaskServer.setAssignNum(Integer.valueOf(servs[1]));
				} else {
					localTaskServer.setAssignNum(1);
				}
				isLocalCancel = false;
				return;
			}
		}
		if (isLocalCancel) {
			localTaskServer.setAssignNum(0);
		}
	}

	private String addRunningServer(List<String> sStr, String tStr) {
		boolean isLocalAdd = false;
		if (sStr == null || sStr.isEmpty()) {
			return tStr;
		}
		List<String> delList = new ArrayList<String>();
		Map<String, Integer> map = new HashMap<String, Integer>();
		for (String str : sStr) {
			if (map.containsKey(str)) {
				map.put(str, map.get(str) + 1);
			} else {
				map.put(str, 1);
			}
			if (tStr.contains(str)) {
				delList.add(str);
			}
		}
		if (delList.size() > 0) {
			sStr.removeAll(delList);
			if (tStr.contains("$")) {
				sStr.add(tStr);
			}
			isLocalAdd = true;
		}
		if (!isLocalAdd && !sStr.contains(tStr) && !tStr.isEmpty()) {
			sStr.add(tStr);
		}
		StringBuffer sb = new StringBuffer();
		if (tStr.isEmpty()) {
			Iterator iter = map.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				sb.append(entry.getKey() + "$" + entry.getValue()).append(",");
			}
		} else {
			for (String str : sStr) {
				if (!str.contains("$")) {
					str = str + "$1";
				}
				sb.append(str).append(",");
			}
		}
		return sb.deleteCharAt(sb.length() - 1).toString();
	}

	private String removeRunningServer(List<String> sStr, String tStr) {
		boolean isLocalRemove = false;
		if (sStr == null || sStr.isEmpty()) {
			return "";
		}
		List<String> delList = new ArrayList<String>();
		for (String str : sStr) {
			if (tStr.contains(str)) {
				delList.add(str);
			}
		}
		if (delList.size() > 0) {
			sStr.removeAll(delList);
			if (tStr.contains("$")) {
				sStr.add(tStr);
			}
			isLocalRemove = true;
		}
		if (!isLocalRemove && sStr.contains(tStr)) {
			sStr.remove(tStr);
			if (sStr.isEmpty()) {
				return "";
			}
		}
		StringBuffer sb = new StringBuffer();
		for (String str : sStr) {
			sb.append(str).append(",");
		}
		return sb.length() > 0 ? sb.deleteCharAt(sb.length() - 1).toString()
				: "";
	}

}

class ServerStruct {
	private String server;
	private int assignNum;
	private int aliveNum;

	public ServerStruct(String localIP) {
		this.server = localIP;
	}

	public String getServer() {
		return server;
	}

	public void setServer(String server) {
		this.server = server;
	}

	public int getAssignNum() {
		return assignNum;
	}

	public void setAssignNum(int assignNum) {
		this.assignNum = assignNum;
	}

	public int getAliveNum() {
		return aliveNum;
	}

	public void setAliveNum(int aliveNum) {
		this.aliveNum = aliveNum;
	}

}