package kr.co.ewp.api.model;

public class BmsEquipmentModel {
  private Integer resultCnt;//
  private String equipmentId;//
  private String equipmentName;//
  private String retrieveTime;// YYYYMMDDhhmmss
  private String sysMode;//
  private String socMax;//
  private String socMin;//
  private String sysSoc;// (%)
  private String currSoc;// (kWh)
  private String sysSoh;// (%)
  private String sysVoltage;// (V)
  private String sysCurrent;// (kWh)
  private String dod;// (%)

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

  public String getSysMode() {
    return sysMode;
  }

  public void setSysMode(String sysMode) {
    this.sysMode = sysMode;
  }

  public String getSysSoc() {
    return sysSoc;
  }

  public void setSysSoc(String sysSoc) {
    this.sysSoc = sysSoc;
  }

  public String getCurrSoc() {
    return currSoc;
  }

  public void setCurrSoc(String currSoc) {
    this.currSoc = currSoc;
  }

  public String getSysSoh() {
    return sysSoh;
  }

  public void setSysSoh(String sysSoh) {
    this.sysSoh = sysSoh;
  }

  public String getSysVoltage() {
    return sysVoltage;
  }

  public void setSysVoltage(String sysVoltage) {
    this.sysVoltage = sysVoltage;
  }

  public String getSysCurrent() {
    return sysCurrent;
  }

  public void setSysCurrent(String sysCurrent) {
    this.sysCurrent = sysCurrent;
  }

  public String getDod() {
    return dod;
  }

  public void setDod(String dod) {
    this.dod = dod;
  }

  public String getSocMax() {
    return socMax;
  }

  public void setSocMax(String socMax) {
    this.socMax = socMax;
  }

  public String getSocMin() {
    return socMin;
  }

  public void setSocMin(String socMin) {
    this.socMin = socMin;
  }
}
