package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class BmsEquipmentModel {
//  private Integer resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String bmsId;// /*** 12.12 이우람 수정 ***/
  private String bmsName;// /*** 12.12 이우람 수정 ***/
  private Date timestamp;// timestamp in millisecond /*** 12.12 이우람 수정 ***/
  private Integer sysMode;// 0: Idle, 1: Charge, 2: Discharge, 3: MainS/W on/off, 4: Off-line, 5: Ready, 6: Fault, 7: Warning /*** 12.12 이우람 수정 ***/
  private String alarmMsg;// Last alarm message /*** 12.12 이우람 추가 ***/
//  private String socMax;// /*** 12.12 이우람 수정-주석 ***/
//  private String socMin;// /*** 12.12 이우람 수정-주석 ***/
  private Float sysSoc;// (%) /*** 12.12 이우람 수정 ***/
  private Float currSoc;// (Wh) /*** 12.12 이우람 수정 ***/
  private Float sysSoh;// (%) /*** 12.12 이우람 수정 ***/
  private Float sysVoltage;// (V) /*** 12.12 이우람 수정 ***/
  private Float sysCurrent;// (A) /*** 12.12 이우람 수정 ***/
  private Float dod;// (%) /*** 12.12 이우람 수정 ***/

  public String getBmsId() {
		return bmsId;
	}
	
  public void setBmsId(String bmsId) {
		this.bmsId = bmsId;
	}
	
  public String getBmsName() {
		return bmsName;
	}
	
  public void setBmsName(String bmsName) {
		this.bmsName = bmsName;
	}
	
  public Date getTimestamp() {
		return timestamp;
	}
	
  public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}
	
  public Integer getSysMode() {
		return sysMode;
	}
	
  public void setSysMode(Integer sysMode) {
		this.sysMode = sysMode;
	}
	
  public String getAlarmMsg() {
		return alarmMsg;
	}
	
  public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}
	
  public Float getSysSoc() {
		return sysSoc;
	}
	
  public void setSysSoc(Float sysSoc) {
		this.sysSoc = sysSoc;
	}
	
  public Float getCurrSoc() {
		return currSoc;
	}
	
  public void setCurrSoc(Float currSoc) {
		this.currSoc = currSoc;
	}
	
  public Float getSysSoh() {
		return sysSoh;
	}
	
  public void setSysSoh(Float sysSoh) {
		this.sysSoh = sysSoh;
	}
	
  public Float getSysVoltage() {
		return sysVoltage;
	}
	
  public void setSysVoltage(Float sysVoltage) {
		this.sysVoltage = sysVoltage;
	}
	
  public Float getSysCurrent() {
		return sysCurrent;
	}
	
  public void setSysCurrent(Float sysCurrent) {
		this.sysCurrent = sysCurrent;
	}
	
  public Float getDod() {
		return dod;
	}
	
  public void setDod(Float dod) {
		this.dod = dod;
	}
}
