package kr.co.esp.api.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvEquipmentModelBefore_bak {
	private String resultCnt;//
	private String equipmentId;//
	private String equipmentName;//
	private String retrieveTime;// YYYYMMDDhhmmss
	private String status;//
	private String alarmMsg;//
	private String temperature;// (℃)
	private String totalPower;// (kWh)

	public String getResultCnt() {
		return resultCnt;
	}

	public void setResultCnt(String resultCnt) {
		this.resultCnt = resultCnt;
	}

	public String getEquipmentId() {
		return equipmentId;
	}

	public void setEquipmentId(String equipmentId) {
		this.equipmentId = equipmentId;
	}

	public String getEquipmentName() {
		return equipmentName;
	}

	public void setEquipmentName(String equipmentName) {
		this.equipmentName = equipmentName;
	}

	public String getRetrieveTime() {
		return retrieveTime;
	}

	public void setRetrieveTime(String retrieveTime) {
		this.retrieveTime = retrieveTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAlarmMsg() {
		return alarmMsg;
	}

	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}

	public String getTemperature() {
		return temperature;
	}

	public void setTemperature(String temperature) {
		this.temperature = temperature;
	}

	public String getTotalPower() {
		return totalPower;
	}

	public void setTotalPower(String totalPower) {
		this.totalPower = totalPower;
	}

	@Override
	public String toString() {
		return "PvEquipmentModelBefore [resultCnt=" + resultCnt + ", equipmentId=" + equipmentId + ", equipmentName="
				+ equipmentName + ", retrieveTime=" + retrieveTime + ", status=" + status + ", alarmMsg=" + alarmMsg
				+ ", temperature=" + temperature + ", totalPower=" + totalPower + "]";
	}


}
