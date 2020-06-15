package kr.co.ewp.api.model;

public class EssUsageModel {
  private Integer resultCnt;//
  private String equipmentId;//
  private String startDt;// YYYYMMDD
  private String endDt;// YYYYMMDD
  private Integer intervalType;//
  private String Interval;//
  private String retrieveTime;// YYYYMMDDhhmmss
  private String totalPowerUsage;// (kWh)
  private String powerUsage;// (kWh)

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

  public String getPowerUsage() {
    return powerUsage;
  }

  public void setPowerUsage(String powerUsage) {
    this.powerUsage = powerUsage;
  }

  public String getTotalPowerUsage() {
    return totalPowerUsage;
  }

  public void setTotalPowerUsage(String totalPowerUsage) {
    this.totalPowerUsage = totalPowerUsage;
  }

}
