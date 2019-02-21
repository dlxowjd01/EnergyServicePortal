package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PcsEquipmentModel {
//  private Integer resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String pcsId;// /*** 12.12 이우람 수정 ***/
  private String pcsName;// /*** 12.12 이우람 수정 ***/
  private Date timestamp;// timestamp in millisecond /*** 12.12 이우람 수정 ***/
  private Integer opMode;// 0:Scheduled, 1: Manual /*** 12.12 이우람 수정 ***/
  private String alarmMsg;// Last alarm message
  private Integer acVoltage;// (V) /*** 12.12 이우람 수정 ***/
  private Integer acPower;// W) /*** 12.12 이우람 수정 ***/
  private Integer acCurrent;// (A) /*** 12.12 이우람 수정 ***/
  private Integer acFreq;// (Hz) /*** 12.12 이우람 수정 ***/
  private Integer acSetPower;// configured power level in AC (W) /*** 12.12 이우람 수정 ***/
  private Integer acPf;// Power factor /*** 12.12 이우람 수정 ***/
  private Integer dcVoltage;// (V) /*** 12.12 이우람 수정 ***/
  private Integer dcPower;// (W) /*** 12.12 이우람 수정 ***/
  private Integer dcCurrent;// (A) /*** 12.12 이우람 수정 ***/
  private Integer dcFreq;// (Hz) /*** 12.12 이우람 수정 ***/
  private Integer dcPf;// Power factor /*** 12.12 이우람 수정 ***/
  private Integer dcSetPower;// configured power level in DC (W) /*** 12.12 이우람 수정 ***/

  
  private Integer pcsStatus;//   0:OFF, 1:ON, 2:Fault, 3:Warning /*** 12.12 이우람 수정 ***/
  private Integer remoteMode;//  0:Local, 1:Remote /*** 12.12 이우람 수정 ***/
  private Integer pcsCommand;//  0:Stop, 1:Run /*** 12.12 이우람 수정 ***/
  private Integer todayDEnergy;// Total energy discharged today (Wh)  /*** 12.12 이우람 수정 ***/
  private Integer todayCEnergy;// Total energy charged today (Wh)  /*** 12.12 이우람 수정 ***/
  private Integer totalDEnergy;// Accumulated discharged energy (Wh)  /*** 12.12 이우람 수정 ***/
  private Integer totalCEnerge;// Accumulated charged energy (Wh)  /*** 12.12 이우람 수정 ***/


  

  public String getPcsId() {
		return pcsId;
	}
  
	public void setPcsId(String pcsId) {
		this.pcsId = pcsId;
	}
	
	public String getPcsName() {
		return pcsName;
	}
	
	public void setPcsName(String pcsName) {
		this.pcsName = pcsName;
	}
	
	public Date getTimestamp() {
		return timestamp;
	}
	
	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}
	
	public Integer getOpMode() {
		return opMode;
	}
	
	public void setOpMode(Integer opMode) {
		this.opMode = opMode;
	}
	
	public String getAlarmMsg() {
		return alarmMsg;
	}
	
	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
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
	
	public Integer getAcSetPower() {
		return acSetPower;
	}
	
	public void setAcSetPower(Integer acSetPower) {
		this.acSetPower = acSetPower;
	}
	
	public Integer getAcPf() {
		return acPf;
	}
	
	public void setAcPf(Integer acPf) {
		this.acPf = acPf;
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
	
	public Integer getDcPf() {
		return dcPf;
	}
	
	public void setDcPf(Integer dcPf) {
		this.dcPf = dcPf;
	}
	
	public Integer getDcSetPower() {
		return dcSetPower;
	}
	
	public void setDcSetPower(Integer dcSetPower) {
		this.dcSetPower = dcSetPower;
	}
	
	public Integer getPcsStatus() {
		return pcsStatus;
	}
	
	public void setPcsStatus(Integer pcsStatus) {
		this.pcsStatus = pcsStatus;
	}
	
	public Integer getRemoteMode() {
		return remoteMode;
	}
	
	public void setRemoteMode(Integer remoteMode) {
		this.remoteMode = remoteMode;
	}
	
	public Integer getPcsCommand() {
		return pcsCommand;
	}
	
	public void setPcsCommand(Integer pcsCommand) {
		this.pcsCommand = pcsCommand;
	}
	
	public Integer getTodayDEnergy() {
		return todayDEnergy;
	}
	
	public void setTodayDEnergy(Integer todayDEnergy) {
		this.todayDEnergy = todayDEnergy;
	}
	
	public Integer getTodayCEnergy() {
		return todayCEnergy;
	}
	
	public void setTodayCEnergy(Integer todayCEnergy) {
		this.todayCEnergy = todayCEnergy;
	}
	
	public Integer getTotalDEnergy() {
		return totalDEnergy;
	}
	
	public void setTotalDEnergy(Integer totalDEnergy) {
		this.totalDEnergy = totalDEnergy;
	}
	
	public Integer getTotalCEnerge() {
		return totalCEnerge;
	}
	
	public void setTotalCEnerge(Integer totalCEnerge) {
		this.totalCEnerge = totalCEnerge;
	}

	@Override
	public String toString() {
		return "PcsEquipmentModel [pcsId=" + pcsId + ", pcsName=" + pcsName + ", timestamp=" + timestamp + ", opMode="
				+ opMode + ", alarmMsg=" + alarmMsg + ", acVoltage=" + acVoltage + ", acPower=" + acPower
				+ ", acCurrent=" + acCurrent + ", acFreq=" + acFreq + ", acSetPower=" + acSetPower + ", acPf=" + acPf
				+ ", dcVoltage=" + dcVoltage + ", dcPower=" + dcPower + ", dcCurrent=" + dcCurrent + ", dcFreq="
				+ dcFreq + ", dcPf=" + dcPf + ", dcSetPower=" + dcSetPower + ", pcsStatus=" + pcsStatus
				+ ", remoteMode=" + remoteMode + ", pcsCommand=" + pcsCommand + ", todayDEnergy=" + todayDEnergy
				+ ", todayCEnergy=" + todayCEnergy + ", totalDEnergy=" + totalDEnergy + ", totalCEnerge=" + totalCEnerge
				+ "]";
	}

	
}
