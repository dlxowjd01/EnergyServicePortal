package kr.co.ewp.api.model;

import java.util.Date;

public class PvEquipmentModel {
//  private String resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String ivtId;// /*** 12.12 이우람 수정 ***/
  private String ivtName;// /*** 12.12 이우람 수정 ***/
  private Date timestamp;// YYYYMMDDhhmmss /*** 12.12 이우람 수정 ***/
  private Integer status;// /*** 12.12 이우람 수정 ***/
  private String alarmMsg;//
  private Integer temperature;// (℃) /*** 12.12 이우람 수정 ***/
  private Integer totalGenPower;// (Wh) /*** 12.12 이우람 수정 ***/
  private Integer todayGenPower;// (Wh) /*** 12.12 이우람 추가 ***/
  
  private Integer acVoltage;// (V) /*** 12.12 이우람 추가 ***/
  private Integer acPower;// (W) /*** 12.12 이우람 추가 ***/
  private Integer acCurrent;// (A) /*** 12.12 이우람 추가 ***/
  private Integer acFreq;// (Hz) /*** 12.12 이우람 추가 ***/
  private Integer dcVoltage;// (V) /*** 12.12 이우람 추가 ***/
  private Integer dcPower;// (W) /*** 12.12 이우람 추가 ***/
  private Integer dcCurrent;// (A) /*** 12.12 이우람 추가 ***/
  private Integer dcFreq;// (Hz) /*** 12.12 이우람 추가 ***/

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

}
