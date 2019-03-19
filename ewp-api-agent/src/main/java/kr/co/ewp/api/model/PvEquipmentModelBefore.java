package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvEquipmentModelBefore {
//  private String resultCnt;//
	private String ivtId;//
	private String ivtName;//
	private Date timestamp;// YYYYMMDDhhmmss
	private Integer status;//
	private String alarmMsg;//
	private Integer temperature;// (℃)
	private Integer totalGenPower;// (kWh)
	private Integer todayGenPower;
	
	private Integer acVoltage;
	private Integer acPower;
	private Integer acCurrent;
	private Integer acFreq;
	private Integer dcVoltage;
	private Integer dcPower;
	private Integer dcCurrent;
	private Integer dcFreq;
	
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
	
	public Integer getTotalGenPower() {
		return totalGenPower;
	}
	
	public void setTotalGenPower(Integer totalGenPower) {
		this.totalGenPower = totalGenPower;
	}
	
	public Integer getTodayGenPower() {
		return todayGenPower;
	}
	
	public void setTodayGenPower(Integer todayGenPower) {
		this.todayGenPower = todayGenPower;
	}
	
	public Integer getAcVoltage() {
		return acVoltage;
	}
	
	public void setAcVoltage(Integer acVoltage) {
		this.acVoltage = acVoltage;
	}
	
	public Integer getAcPower() {
		return acPower;
	}
	
	public void setAcPower(Integer acPower) {
		this.acPower = acPower;
	}
	
	public Integer getAcCurrent() {
		return acCurrent;
	}
	
	public void setAcCurrent(Integer acCurrent) {
		this.acCurrent = acCurrent;
	}
	
	public Integer getAcFreq() {
		return acFreq;
	}
	
	public void setAcFreq(Integer acFreq) {
		this.acFreq = acFreq;
	}
	
	public Integer getDcVoltage() {
		return dcVoltage;
	}
	
	public void setDcVoltage(Integer dcVoltage) {
		this.dcVoltage = dcVoltage;
	}
	
	public Integer getDcPower() {
		return dcPower;
	}
	
	public void setDcPower(Integer dcPower) {
		this.dcPower = dcPower;
	}
	
	public Integer getDcCurrent() {
		return dcCurrent;
	}
	
	public void setDcCurrent(Integer dcCurrent) {
		this.dcCurrent = dcCurrent;
	}
	
	public Integer getDcFreq() {
		return dcFreq;
	}
	
	public void setDcFreq(Integer dcFreq) {
		this.dcFreq = dcFreq;
	}

	@Override
	public String toString() {
		return "PvEquipmentModelBefore [ivtId=" + ivtId + ", ivtName=" + ivtName + ", timestamp=" + timestamp
				+ ", status=" + status + ", alarmMsg=" + alarmMsg + ", temperature=" + temperature + ", totalGenPower="
				+ totalGenPower + ", todayGenPower=" + todayGenPower + ", acVoltage=" + acVoltage + ", acPower="
				+ acPower + ", acCurrent=" + acCurrent + ", acFreq=" + acFreq + ", dcVoltage=" + dcVoltage
				+ ", dcPower=" + dcPower + ", dcCurrent=" + dcCurrent + ", dcFreq=" + dcFreq + ", getIvtId()="
				+ getIvtId() + ", getIvtName()=" + getIvtName() + ", getTimestamp()=" + getTimestamp()
				+ ", getStatus()=" + getStatus() + ", getAlarmMsg()=" + getAlarmMsg() + ", getTemperature()="
				+ getTemperature() + ", getTotalGenPower()=" + getTotalGenPower() + ", getTodayGenPower()="
				+ getTodayGenPower() + ", getAcVoltage()=" + getAcVoltage() + ", getAcPower()=" + getAcPower()
				+ ", getAcCurrent()=" + getAcCurrent() + ", getAcFreq()=" + getAcFreq() + ", getDcVoltage()="
				+ getDcVoltage() + ", getDcPower()=" + getDcPower() + ", getDcCurrent()=" + getDcCurrent()
				+ ", getDcFreq()=" + getDcFreq() + ", getClass()=" + getClass() + ", hashCode()=" + hashCode()
				+ ", toString()=" + super.toString() + "]";
	}

	
}
