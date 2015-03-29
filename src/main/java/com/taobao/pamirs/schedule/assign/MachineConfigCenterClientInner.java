package com.taobao.pamirs.schedule.assign;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author pin
 *
 */
public class MachineConfigCenterClientInner {

	Map<String, String> tableMap;
	/**
	 * 配置中心的数据库类型
	 */
	String dataBaseType = null;

	protected MachineConfigCenterClientInner(String aDataBaseType,
			Map<String, String> aTableMap) {
		this.dataBaseType = aDataBaseType;
		this.tableMap = aTableMap;
	}

	public MachineStrategy loadMachineStrategy(Connection conn, String taskType)
			throws Exception {
		MachineStrategy result = null;
		String sql = " SELECT TASK_TYPE,SERVER,ASSIGN_NUM,ALIVE_NUM,RUNNING_SERVER"
				+ " from "
				+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
				+ " where TASK_TYPE = ? and STATUS = 1";
		PreparedStatement statement = conn.prepareStatement(sql);
		statement.setString(1, taskType);
		ResultSet resultSet = statement.executeQuery();
		if (resultSet.next()) {
			result = new MachineStrategy();
			result.setTaskType(resultSet.getString("TASK_TYPE"));
			result.setAssignNum(resultSet.getInt("ASSIGN_NUM"));
			result.setAliveNum(resultSet.getInt("ALIVE_NUM"));
			result.setServer(resultSet.getString("SERVER"));
			result.setRunningServer(resultSet.getString("RUNNING_SERVER"));
		}
		resultSet.close();
		statement.close();
		return result;
	}

	public List<MachineStrategy> loadAllValidMachineStrategy(Connection conn)
			throws Exception {
		List<MachineStrategy> result = new ArrayList<MachineStrategy>();
		String sql = " SELECT TASK_TYPE,SERVER,ASSIGN_NUM,ALIVE_NUM,RUNNING_SERVER"
				+ " from "
				+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
				+ " where STATUS = 1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet resultSet = stmt.executeQuery();
		while (resultSet.next()) {
			MachineStrategy strategy = new MachineStrategy();
			strategy.setTaskType(resultSet.getString("TASK_TYPE"));
			strategy.setAssignNum(resultSet.getInt("ASSIGN_NUM"));
			strategy.setAliveNum(resultSet.getInt("ALIVE_NUM"));
			strategy.setServer(resultSet.getString("SERVER"));
			strategy.setRunningServer(resultSet.getString("RUNNING_SERVER"));
			result.add(strategy);
		}
		resultSet.close();
		stmt.close();
		return result;
	}

	public boolean assignMachineStrategy(Connection conn,
			MachineStrategy machineStrategy, int oldAliveNum) throws Exception {
		if (oldAliveNum == 0) {
			String UPDATE_ALIVE_NUM_NULL_SQL = " UPDATE "
					+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
					+ " SET ALIVE_NUM = ?"
					+ " WHERE TASK_TYPE = ? and ALIVE_NUM is null";
			PreparedStatement statement = conn
					.prepareStatement(UPDATE_ALIVE_NUM_NULL_SQL);
			statement.setInt(1, machineStrategy.getAliveNum());
			statement.setString(2, machineStrategy.getTaskType());
			if (statement.executeUpdate() != 0) {
				String ASSIGN_STRATEGY_SQL = " UPDATE "
						+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
						+ " SET ALIVE_NUM = ?,RUNNING_SERVER = ?,GMT_MODIFIED = "
						+ getDataBaseSysdateString(conn)
						+ " WHERE TASK_TYPE = ?";
				PreparedStatement ps = conn
						.prepareStatement(ASSIGN_STRATEGY_SQL);
				ps.setInt(1, machineStrategy.getAliveNum());
				ps.setString(2, machineStrategy.getRunningServer());
				ps.setString(3, machineStrategy.getTaskType());
				ps.executeUpdate();
				ps.close();
				statement.close();
				return true;
			} else {
				statement.close();
			}
		}
		String UPDATE_ALIVE_NUM_SQL = " UPDATE "
				+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
				+ " SET ALIVE_NUM = ?"
				+ " WHERE TASK_TYPE = ? and ALIVE_NUM =?";
		PreparedStatement statement = conn
				.prepareStatement(UPDATE_ALIVE_NUM_SQL);
		statement.setInt(1, machineStrategy.getAliveNum());
		statement.setString(2, machineStrategy.getTaskType());
		statement.setInt(3, oldAliveNum);
		int count = statement.executeUpdate();
		if (count != 0) {
			String ASSIGN_STRATEGY_SQL = " UPDATE "
					+ transferTableName(conn, "PAMIRS_SCHEDULE_STRATEGY")
					+ " SET ALIVE_NUM = ?,RUNNING_SERVER = ?,GMT_MODIFIED = "
					+ getDataBaseSysdateString(conn) + " WHERE TASK_TYPE = ?";
			PreparedStatement ps = conn.prepareStatement(ASSIGN_STRATEGY_SQL);
			ps.setInt(1, machineStrategy.getAliveNum());
			ps.setString(2, machineStrategy.getRunningServer());
			ps.setString(3, machineStrategy.getTaskType());
			ps.executeUpdate();
			ps.close();
			statement.close();
			return true;
		} else {
			statement.close();
			return false;
		}
	}

	/**
	 * 获取不同数据库获取系统时间的方法字符串
	 * 
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public String getDataBaseSysdateString(Connection conn) throws Exception {
		String type = this.getDataBaseType(conn);
		if ("oracle".equalsIgnoreCase(type)) {
			return "sysdate";
		} else if ("mysql".equalsIgnoreCase(type)) {
			return "now()";
		} else {
			throw new Exception("不支持的数据库类型：" + type);
		}
	}

	public String getDataBaseType(Connection conn) throws SQLException {
		if (dataBaseType == null) {
			dataBaseType = conn.getMetaData().getDatabaseProductName();
			if ("oracle".equalsIgnoreCase(dataBaseType) == false
					&& "mysql".equalsIgnoreCase(dataBaseType) == false) {
				throw new SQLException("不支持的数据库类型：" + dataBaseType
						+ ",请设置数据库属性dataBaseType：oracle or mysql");
			}
		}
		return dataBaseType;
	}

	public String transferTableName(Connection conn, String name) {
		if (this.tableMap == null) {
			return name.toLowerCase();
		} else if (this.tableMap.containsKey(name)) {
			return tableMap.get(name).toLowerCase();
		} else {
			return name.toLowerCase();
		}
	}
}
