package kr.co.ewp.api.model;

public class ChargingDischarging {
  private Integer resultCnt;//
  private String equipmentId;//
  private String totalCEnergy;// (kWh)
  private String totalDEnergy;//
  private String startDt;// YYYYMMDD
  private String endDt;// YYYYMMDD
  private Integer intervalType;//
  private String Interval;//
  private String retrieveTime;// YYYYMMDDhhmmss
  private String chargeEnergy;// (kWh)
  private String dischargeEnergy;// (kWh)

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

  public String getTotalCEnergy() {
    return totalCEnergy;
  }

  public void setTotalCEnergy(String totalCEnergy) {
    this.totalCEnergy = totalCEnergy;
  }

  public String getStartDt() {
    return startDt;
  }

  public void setStartDt(String startDt) {
    this.startDt = startDt;
  }

  public String getEndDt() {
    return endDt;
  }

  public void setEndDt(String endDt) {
    this.endDt = endDt;
  }

  public Integer getIntervalType() {
    return intervalType;
  }

  public void setIntervalType(Integer intervalType) {
    this.intervalType = intervalType;
  }

  public String getInterval() {
    return Interval;
  }

  public void setInterval(String interval) {
    Interval = interval;
  }

  public String getRetrieveTime() {
    return retrieveTime;
  }

  public void setRetrieveTime(String retrieveTime) {
    this.retrieveTime = retrieveTime;
  }

  public String getChargeEnergy() {
    return chargeEnergy;
  }

  public void setChargeEnergy(String chargeEnergy) {
    this.chargeEnergy = chargeEnergy;
  }

  public String getDischargeEnergy() {
    return dischargeEnergy;
  }

  public void setDischargeEnergy(String dischargeEnergy) {
    this.dischargeEnergy = dischargeEnergy;
  }

  public String getTotalDEnergy() {
    return totalDEnergy;
  }

  public void setTotalDEnergy(String totalDEnergy) {
    this.totalDEnergy = totalDEnergy;
  }

}
