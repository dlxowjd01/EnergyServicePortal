package kr.co.ewp.api.model;

import java.util.Date;

public class BmsEquipmentModel {
//  private Integer resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String bmsId;// /*** 12.12 이우람 수정 ***/
  private String bmsName;// /*** 12.12 이우람 수정 ***/
  private Date timestamp;// timestamp in millisecond /*** 12.12 이우람 수정 ***/
  private Integer sysMode;// 0: Idle, 1: Charge, 2: Discharge, 3: MainS/W on/off, 4: Off-line, 5: Ready, 6: Fault, 7: Warning /*** 12.12 이우람 수정 ***/
  private String alarmMsg;// Last alarm message /*** 12.12 이우람 추가 ***/
//  private String socMax;// /*** 12.12 이우람 수정-주석 ***/
//  private String socMin;// /*** 12.12 이우람 수정-주석 ***/
  private Integer sysSoc;// (%) /*** 12.12 이우람 수정 ***/
  private Integer currSoc;// (Wh) /*** 12.12 이우람 수정 ***/
  private Integer sysSoh;// (%) /*** 12.12 이우람 수정 ***/
  private Integer sysVoltage;// (V) /*** 12.12 이우람 수정 ***/
  private Integer sysCurrent;// (A) /*** 12.12 이우람 수정 ***/
  private Integer dod;// (%) /*** 12.12 이우람 수정 ***/

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
	
  public Integer getSysSoc() {
		return sysSoc;
	}
	
  public void setSysSoc(Integer sysSoc) {
		this.sysSoc = sysSoc;
	}
	
  public Integer getCurrSoc() {
		return currSoc;
	}
	
  public void setCurrSoc(Integer currSoc) {
		this.currSoc = currSoc;
	}
	
  public Integer getSysSoh() {
		return sysSoh;
	}
	
  public void setSysSoh(Integer sysSoh) {
		this.sysSoh = sysSoh;
	}
	
  public Integer getSysVoltage() {
		return sysVoltage;
	}
	
  public void setSysVoltage(Integer sysVoltage) {
		this.sysVoltage = sysVoltage;
	}
	
  public Integer getSysCurrent() {
		return sysCurrent;
	}
	
  public void setSysCurrent(Integer sysCurrent) {
		this.sysCurrent = sysCurrent;
	}
	
  public Integer getDod() {
		return dod;
	}
	
  public void setDod(Integer dod) {
		this.dod = dod;
	}
}
