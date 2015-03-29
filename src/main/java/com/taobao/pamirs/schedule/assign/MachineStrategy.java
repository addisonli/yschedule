package com.taobao.pamirs.schedule.assign;
/**
 * 机器策略对象
 * @author pin
 *
 */
public class MachineStrategy {

	public MachineStrategy() {
		super();
	}

	public MachineStrategy(MachineStrategy ms) {
		this.taskType = ms.getTaskType();
		this.server = ms.getServer();
		this.runningServer = ms.getRunningServer();
		this.assignNum = ms.getAssignNum();
		this.aliveNum = ms.getAliveNum();
	}

	/**
	 * 任务类型
	 */
	private String taskType;

	/**
	 * 主机IP或主机名称  格式: ip,ip,ip 逗号拼接
	 */
	private String server;

	/**
	 * 正在运行中的主机
	 */
	private String runningServer;

	/**
	 * 指定需要执行调度的机器数量
	 */
	private int assignNum;

	/**
	 * 存活（正常运行中）机器数量
	 */
	private int aliveNum;

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

	public String getTaskType() {
		return taskType;
	}

	public void setTaskType(String taskType) {
		this.taskType = taskType;
	}

	public String getRunningServer() {
		return runningServer;
	}

	public void setRunningServer(String runningServer) {
		this.runningServer = runningServer;
	}

	public int getAliveNum() {
		return aliveNum;
	}

	public void setAliveNum(int aliveNum) {
		this.aliveNum = aliveNum;
	}

}
