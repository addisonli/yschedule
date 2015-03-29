package com.taobao.pamirs.schedule.assign;

import java.util.List;
/**
 * 机器分配客户端接口
 * @author pin
 *
 */

public interface IMachineAssign {

	/**
	 * 获取正在运行任务的机器
	 * @param taskType
	 * @return
	 * @throws Exception
	 */
	public List<String> selectRunningMachine(String taskType) throws Exception;

	/**
	 * 机器开启功能，需实现该方法执行程序
	 * @param taskType
	 * @throws Exception
	 */
	public void joinMachineDeal(String taskType) throws Exception;

	/**
	 * 机器停止功能，需实现该方法停止程序
	 * @param taskType
	 * @throws Exception
	 */
	public void removeMachineDeal(String taskType) throws Exception;
	
	/**
	 * 机器内部运转的程序数量
	 * @param taskType
	 * @throws Exception
	 */
	public int getLocalManagerNum(String taskType) throws Exception; 

}
