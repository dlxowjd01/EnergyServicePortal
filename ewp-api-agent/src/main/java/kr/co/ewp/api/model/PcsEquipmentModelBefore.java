package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PcsEquipmentModelBefore {
//  private Integer resultCnt;//
	private String pcsId;//
	private String pcsName;//
	private Date timestamp;// YYYYMMDDhhmmss
	private Integer opMode;//
	private String alarmMsg;//
	private Float acVoltage;// (V)
	private Float acPower;// (kWh)
	private Float acCurrent;// (A)
	private Float acFreq;// (Hz)
	private Float acSetPower;// (kWh)
	private Float acPf;//
	private Float dcVoltage;// (V)
	private Float dcPower;// (kWh)
	private Float dcCurrent;// (A)
	private Float dcFreq;// (Hz)
	private Float dcPf;//
	private Float dcSetPower;// (kWh)
	
	
	private Integer pcsStatus;//   0:OFF, 1:ON, 2:Fault, 3:Warning
	private Integer remoteMode;//  0:Local, 1:Remote
	private Integer pcsCommand;//  0:Stop, 1:Run
	private Float todayDEnergy;//  
	private Float todayCEnergy;//  
	private Float totalDEnergy;//  
	private Float totalCEnerge;// 
	
	
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
	
	public Float getTodayDEnergy() {
		return todayDEnergy;
	}
	
	public void setTodayDEnergy(Float todayDEnergy) {
		this.todayDEnergy = todayDEnergy;
	}
	
	public Float getTodayCEnergy() {
		return todayCEnergy;
	}
	
	public void setTodayCEnergy(Float todayCEnergy) {
		this.todayCEnergy = todayCEnergy;
	}
	
	public Float getTotalDEnergy() {
		return totalDEnergy;
	}
	
	public void setTotalDEnergy(Float totalDEnergy) {
		this.totalDEnergy = totalDEnergy;
	}
	
	public Float getTotalCEnerge() {
		return totalCEnerge;
	}
	
	public void setTotalCEnerge(Float totalCEnerge) {
		this.totalCEnerge = totalCEnerge;
	}

}
