package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

public class ChargingDischargingBefore {
  private Integer numItems;//
  private String pcsId;//
  private Float totalCEnergy;// (kWh)
  private Float totalDEnergy;//
  private Date startDt;// YYYYMMDD
  private Date endDt;// YYYYMMDD
  private String intervalType;//
  private Integer Interval;//
  private List<ChargingDischargingItemModel> items;
//  private String retrieveTime;// YYYYMMDDhhmmss
//  private String chargeEnergy;// (kWh)
//  private String dischargeEnergy;// (kWh)

  public Integer getNumItems() {
	return numItems;
  }
  
  public void setNumItems(Integer numItems) {
  	this.numItems = numItems;
  }
  
  public String getPcsId() {
  	return pcsId;
  }
  
  public void setPcsId(String pcsId) {
  	this.pcsId = pcsId;
  }
  
  public Float getTotalCEnergy() {
  	return totalCEnergy;
  }
  
  public void setTotalCEnergy(Float totalCEnergy) {
  	this.totalCEnergy = totalCEnergy;
  }
  
  public Float getTotalDEnergy() {
  	return totalDEnergy;
  }
  
  public void setTotalDEnergy(Float totalDEnergy) {
  	this.totalDEnergy = totalDEnergy;
  }
  
  public Date getStartDt() {
  	return startDt;
  }
  
  public void setStartDt(Date startDt) {
  	this.startDt = startDt;
  }
  
  public Date getEndDt() {
  	return endDt;
  }
  
  public void setEndDt(Date endDt) {
  	this.endDt = endDt;
  }
  
  public String getIntervalType() {
  	return intervalType;
  }
  
  public void setIntervalType(String intervalType) {
  	this.intervalType = intervalType;
  }
  
  public Integer getInterval() {
  	return Interval;
  }
  
  public void setInterval(Integer interval) {
  	Interval = interval;
  }
  
  public List<ChargingDischargingItemModel> getItems() {
  	return items;
  }
  
  public void setItems(List<ChargingDischargingItemModel> items) {
  	this.items = items;
  }
}
