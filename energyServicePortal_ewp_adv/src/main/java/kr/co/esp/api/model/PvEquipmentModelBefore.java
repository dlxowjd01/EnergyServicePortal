package kr.co.esp.api.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvEquipmentModelBefore {
	//  private String resultCnt;//
	private String ivtId;//
	private String ivtName;//
	private Date timestamp;// YYYYMMDDhhmmss
	private Integer status;//
	private String alarmMsg;//
	private Integer temperature;// (℃)
	private Float totalGenPower;// (Wh)
	private Float todayGenPower;// (Wh)

	private Float acVoltage;
	private Float acPower;
	private Float acCurrent;
	private Float acFreq;
	private Float dcVoltage;
	private Float dcPower;
	private Float dcCurrent;
	private Float dcFreq;

	public String getIvtId() {
		return ivtId;
	}

	public void setIvtId(String ivtId) {
		this.ivtId = ivtId;
	}

	public String getIvtName() {
		return ivtName;
	}

	public void setIvtName(String ivtName) {
		this.ivtName = ivtName;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getAlarmMsg() {
		return alarmMsg;
	}

	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}

	public Integer getTemperature() {
		return temperature;
	}

	public void setTemperature(Integer temperature) {
		this.temperature = temperature;
	}

	public Float getTotalGenPower() {
		return totalGenPower;
	}

	public void setTotalGenPower(Float totalGenPower) {
		this.totalGenPower = totalGenPower;
	}

	public Float getTodayGenPower() {
		return todayGenPower;
	}

	public void setTodayGenPower(Float todayGenPower) {
		this.todayGenPower = todayGenPower;
	}

	public Float getAcVoltage() {
		return acVoltage;
	}

	public void setAcVoltage(Float acVoltage) {
		this.acVoltage = acVoltage;
	}

	public Float getAcPower() {
		return acPower;
	}

	public void setAcPower(Float acPower) {
		this.acPower = acPower;
	}

	public Float getAcCurrent() {
		return acCurrent;
	}

	public void setAcCurrent(Float acCurrent) {
		this.acCurrent = acCurrent;
	}

	public Float getAcFreq() {
		return acFreq;
	}

	public void setAcFreq(Float acFreq) {
		this.acFreq = acFreq;
	}

	public Float getDcVoltage() {
		return dcVoltage;
	}

	public void setDcVoltage(Float dcVoltage) {
		this.dcVoltage = dcVoltage;
	}

	public Float getDcPower() {
		return dcPower;
	}

	public void setDcPower(Float dcPower) {
		this.dcPower = dcPower;
	}

	public Float getDcCurrent() {
		return dcCurrent;
	}

	public void setDcCurrent(Float dcCurrent) {
		this.dcCurrent = dcCurrent;
	}

	public Float getDcFreq() {
		return dcFreq;
	}

	public void setDcFreq(Float dcFreq) {
		this.dcFreq = dcFreq;
	}

	@Override
	public String toString() {
		return "PvEquipmentModelBefore [ivtId=" + ivtId + ", ivtName=" + ivtName + ", timestamp=" + timestamp
				+ ", status=" + status + ", alarmMsg=" + alarmMsg + ", temperature=" + temperature + ", totalGenPower="
				+ totalGenPower + ", todayGenPower=" + todayGenPower + ", acVoltage=" + acVoltage + ", acPower="
				+ acPower + ", acCurrent=" + acCurrent + ", acFreq=" + acFreq + ", dcVoltage=" + dcVoltage
				+ ", dcPower=" + dcPower + ", dcCurrent=" + dcCurrent + ", dcFreq=" + dcFreq + "]";
	}

}
