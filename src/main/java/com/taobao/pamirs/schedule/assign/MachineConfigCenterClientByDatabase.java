package com.taobao.pamirs.schedule.assign;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.InitializingBean;

/**
 * 基于数据库的机器配置中心客户端
 * @author pin
 *
 */
public class MachineConfigCenterClientByDatabase implements
		IMachineConfigCenterClient, InitializingBean {

	Map<String, String> tableMap;
	/**
	 * 配置中心数据库的数据源
	 */
	DataSource dataSource;

	/**
	 * 配置中心的数据可类型
	 */
	String dataBaseType = null;

	MachineConfigCenterClientInner clientInner;

	//在Spring对象创建完毕后，创建内部对象
	public void afterPropertiesSet() throws Exception {
		clientInner = new MachineConfigCenterClientInner(this.dataBaseType,
				this.tableMap);
	}

	public void setTableMap(Map<String, String> aTableMap) {
		this.tableMap = new HashMap<String, String>();
		for (Object e : aTableMap.keySet()) {
			String key = ((String) e).toUpperCase();
			if (aTableMap.get(e) != null
					&& aTableMap.get(e).toString().trim().length() > 0) {
				this.tableMap.put(key.trim(), aTableMap.get(e).toString()
						.trim());
			}
		}
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public void setDataBaseType(String dataBaseType) {
		this.dataBaseType = dataBaseType;
	}

	private Connection getConnection() throws SQLException {
		Connection result = this.dataSource.getConnection();
		if (result.getAutoCommit() == true) {
			result.setAutoCommit(false);
		}
		return result;
	}

	public MachineStrategy loadMachineStrategy(String taskType)
			throws Exception {
		Connection conn = null;
		try {
			conn = this.getConnection();
			MachineStrategy result = clientInner.loadMachineStrategy(conn,
					taskType);
			conn.commit();
			return result;
		} catch (Throwable e) {
			if (conn != null) {
				conn.rollback();
			}
			if (e instanceof Exception) {
				throw (Exception) e;
			} else {
				throw new Exception(e);
			}
		} finally {
			if (conn != null) {
				conn.close();
			}
		}
	}

	public boolean assignMachineStrategy(MachineStrategy machineStrategy,
			int oldAliveNum) throws Exception {
		Connection conn = null;
		try {
			conn = this.getConnection();
			boolean result = clientInner.assignMachineStrategy(conn,
					machineStrategy, oldAliveNum);
			conn.commit();
			return result;
		} catch (Throwable e) {
			if (conn != null) {
				conn.rollback();
			}
			if (e instanceof Exception) {
				throw (Exception) e;
			} else {
				throw new Exception(e);
			}
		} finally {
			if (conn != null) {
				conn.close();
			}
		}
	}

	public List<MachineStrategy> loadAllValidMachineStrategy() throws Exception {
		Connection conn = null;
		try {
			conn = this.getConnection();
			List<MachineStrategy> result = clientInner
					.loadAllValidMachineStrategy(conn);
			conn.commit();
			return result;
		} catch (Throwable e) {
			if (conn != null) {
				conn.rollback();
			}
			if (e instanceof Exception) {
				throw (Exception) e;
			} else {
				throw new Exception(e);
			}
		} finally {
			if (conn != null) {
				conn.close();
			}
		}
	}

}
