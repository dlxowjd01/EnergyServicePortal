package kr.co.esp.api.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PcsEquipmentModel {
	//  private Integer resultCnt;// /*** 12.12 이우람 수정-주석 ***/
	private String pcsId;// /*** 12.12 이우람 수정 ***/
	private String pcsName;// /*** 12.12 이우람 수정 ***/
	private Date timestamp;// timestamp in millisecond /*** 12.12 이우람 수정 ***/
	private Integer opMode;// 0:Scheduled, 1: Manual /*** 12.12 이우람 수정 ***/
	private String alarmMsg;// Last alarm message
	private Float acVoltage;// (V) /*** 12.12 이우람 수정 ***/
	private Float acPower;// W) /*** 12.12 이우람 수정 ***/
	private Float acCurrent;// (A) /*** 12.12 이우람 수정 ***/
	private Float acFreq;// (Hz) /*** 12.12 이우람 수정 ***/
	private Float acSetPower;// configured power level in AC (W) /*** 12.12 이우람 수정 ***/
	private Float acPf;// Power factor /*** 12.12 이우람 수정 ***/
	private Float dcVoltage;// (V) /*** 12.12 이우람 수정 ***/
	private Float dcPower;// (W) /*** 12.12 이우람 수정 ***/
	private Float dcCurrent;// (A) /*** 12.12 이우람 수정 ***/
	private Float dcFreq;// (Hz) /*** 12.12 이우람 수정 ***/
	private Float dcPf;// Power factor /*** 12.12 이우람 수정 ***/
	private Float dcSetPower;// configured power level in DC (W) /*** 12.12 이우람 수정 ***/


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

	public Float getAcSetPower() {
		return acSetPower;
	}

	public void setAcSetPower(Float acSetPower) {
		this.acSetPower = acSetPower;
	}

	public Float getAcPf() {
		return acPf;
	}

	public void setAcPf(Float acPf) {
		this.acPf = acPf;
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

	public Float getDcPf() {
		return dcPf;
	}

	public void setDcPf(Float dcPf) {
		this.dcPf = dcPf;
	}

	public Float getDcSetPower() {
		return dcSetPower;
	}

	public void setDcSetPower(Float dcSetPower) {
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

}
