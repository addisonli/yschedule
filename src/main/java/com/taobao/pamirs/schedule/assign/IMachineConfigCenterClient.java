package com.taobao.pamirs.schedule.assign;

import java.util.List;

/**
 * 机器配置中心接口
 * @author pin
 *
 */

public interface IMachineConfigCenterClient {

	/**
	 * 装载机器策略相关信息
	 * @param taskType
	 * @return
	 * @throws Exception
	 */
	public MachineStrategy loadMachineStrategy(String taskType)
			throws Exception;

	/**
	 * 更新机器策略
	 * @param machineStrategy
	 * @return
	 * @throws Exception
	 */
	public boolean assignMachineStrategy(MachineStrategy machineStrategy,
			int oldAliveNum) throws Exception;

	/**
	 * 获取所有有效机器策略
	 * @return
	 * @throws Exception
	 */
	public List<MachineStrategy> loadAllValidMachineStrategy() throws Exception;
}
