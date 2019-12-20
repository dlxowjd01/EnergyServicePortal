package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvEquipmentModel {
//  private String resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String ivtId;// /*** 12.12 이우람 수정 ***/
  private String ivtName;// /*** 12.12 이우람 수정 ***/
  private Date timestamp;// timestamp in millisecond /*** 12.12 이우람 수정 ***/
  private Integer status;// 0: Stop, 1: Run, 2: Fault, 3: Warning /*** 12.12 이우람 수정 ***/
  private String alarmMsg;// Last alarm message
  private Float temperature;// (℃) /*** 12.12 이우람 수정 ***/
  private Float totalGenPower;// Today generated energy (Wh) /*** 12.12 이우람 수정 ***/
  private Float todayGenPower;// Accumulated generated energy (Wh) /*** 12.12 이우람 추가 ***/
  
  private Float acVoltage;// (V) /*** 12.12 이우람 추가 ***/
  private Float acPower;// (W) /*** 12.12 이우람 추가 ***/
  private Float acCurrent;// (A) /*** 12.12 이우람 추가 ***/
  private Float acFreq;// (Hz) /*** 12.12 이우람 추가 ***/
  private Float dcVoltage;// (V) /*** 12.12 이우람 추가 ***/
  private Float dcPower;// (W) /*** 12.12 이우람 추가 ***/
  private Float dcCurrent;// (A) /*** 12.12 이우람 추가 ***/
  private Float dcFreq;// (Hz) /*** 12.12 이우람 추가 ***/

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
	
  public Float getTemperature() {
		return temperature;
	}
	
  public void setTemperature(Float temperature) {
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
	return "PvEquipmentModel [ivtId=" + ivtId + ", ivtName=" + ivtName + ", timestamp=" + timestamp + ", status="
			+ status + ", alarmMsg=" + alarmMsg + ", temperature=" + temperature + ", totalGenPower=" + totalGenPower
			+ ", todayGenPower=" + todayGenPower + ", acVoltage=" + acVoltage + ", acPower=" + acPower + ", acCurrent="
			+ acCurrent + ", acFreq=" + acFreq + ", dcVoltage=" + dcVoltage + ", dcPower=" + dcPower + ", dcCurrent="
			+ dcCurrent + ", dcFreq=" + dcFreq + "]";
}

  
}
