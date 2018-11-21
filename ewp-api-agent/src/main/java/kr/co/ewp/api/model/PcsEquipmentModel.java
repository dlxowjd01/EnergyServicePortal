package kr.co.ewp.api.model;

public class PcsEquipmentModel {
  private Integer resultCnt;//
  private String equipmentId;//
  private String equipmentName;//
  private String retrieveTime;// YYYYMMDDhhmmss
  private String opMode;//
  private String alarmMsg;//
  private String acVoltage;// (V)
  private String acPower;// (kWh)
  private String acCurrent;// (A)
  private String acFreq;// (Hz)
  private String acSetPower;// (kWh)
  private String acPf;//
  private String dcVoltage;// (V)
  private String dcPower;// (kWh)
  private String dcCurrent;// (A)
  private String dcFreq;// (Hz)
  private String dcPf;//
  private String dcSetPower;// (kWh)

  
  private String pcsStatus;//   0:OFF, 1:ON, 2:Fault, 3:Warning
  private String remoteMode;//  0:Local, 1:Remote
  private String pcsCommand;//  0:Stop, 1:Run
  private String todayDEnergy;//  
  private String todayCEnergy;//  
  private String totalDEnergy;//  
  private String totalCEnerge;//  


  

  public String getPcsStatus() {
    return pcsStatus;
  }

  public void setPcsStatus(String pcsStatus) {
    this.pcsStatus = pcsStatus;
  }

  public String getRemoteMode() {
    return remoteMode;
  }

  public void setRemoteMode(String remoteMode) {
    this.remoteMode = remoteMode;
  }

  public String getPcsCommand() {
    return pcsCommand;
  }

  public void setPcsCommand(String pcsCommand) {
    this.pcsCommand = pcsCommand;
  }

  public String getTodayDEnergy() {
    return todayDEnergy;
  }

  public void setTodayDEnergy(String todayDEnergy) {
    this.todayDEnergy = todayDEnergy;
  }

  public String getTodayCEnergy() {
    return todayCEnergy;
  }

  public void setTodayCEnergy(String todayCEnergy) {
    this.todayCEnergy = todayCEnergy;
  }

  public String getTotalDEnergy() {
    return totalDEnergy;
  }

  public void setTotalDEnergy(String totalDEnergy) {
    this.totalDEnergy = totalDEnergy;
  }

  public String getTotalCEnerge() {
    return totalCEnerge;
  }

  public void setTotalCEnerge(String totalCEnerge) {
    this.totalCEnerge = totalCEnerge;
  }

  public Integer getResultCnt() {
    return resultCnt;
  }

  public void setResultCnt(Integer resultCnt) {
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

  public String getOpMode() {
    return opMode;
  }

  public void setOpMode(String opMode) {
    this.opMode = opMode;
  }

  public String getAlarmMsg() {
    return alarmMsg;
  }

  public void setAlarmMsg(String alarmMsg) {
    this.alarmMsg = alarmMsg;
  }

  public String getAcVoltage() {
    return acVoltage;
  }

  public void setAcVoltage(String acVoltage) {
    this.acVoltage = acVoltage;
  }

  public String getAcPower() {
    return acPower;
  }

  public void setAcPower(String acPower) {
    this.acPower = acPower;
  }

  public String getAcCurrent() {
    return acCurrent;
  }

  public void setAcCurrent(String acCurrent) {
    this.acCurrent = acCurrent;
  }

  public String getAcFreq() {
    return acFreq;
  }

  public void setAcFreq(String acFreq) {
    this.acFreq = acFreq;
  }

  public String getAcSetPower() {
    return acSetPower;
  }

  public void setAcSetPower(String acSetPower) {
    this.acSetPower = acSetPower;
  }

  public String getAcPf() {
    return acPf;
  }

  public void setAcPf(String acPf) {
    this.acPf = acPf;
  }

  public String getDcVoltage() {
    return dcVoltage;
  }

  public void setDcVoltage(String dcVoltage) {
    this.dcVoltage = dcVoltage;
  }

  public String getDcPower() {
    return dcPower;
  }

  public void setDcPower(String dcPower) {
    this.dcPower = dcPower;
  }

  public String getDcCurrent() {
    return dcCurrent;
  }

  public void setDcCurrent(String dcCurrent) {
    this.dcCurrent = dcCurrent;
  }

  public String getDcFreq() {
    return dcFreq;
  }

  public void setDcFreq(String dcFreq) {
    this.dcFreq = dcFreq;
  }

  public String getDcPf() {
    return dcPf;
  }

  public void setDcPf(String dcPf) {
    this.dcPf = dcPf;
  }

  public String getDcSetPower() {
    return dcSetPower;
  }

  public void setDcSetPower(String dcSetPower) {
    this.dcSetPower = dcSetPower;
  }

}
