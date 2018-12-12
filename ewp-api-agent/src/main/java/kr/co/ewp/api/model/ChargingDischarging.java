package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

public class ChargingDischarging {
//  private String resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String pcsId;// /*** 12.12 이우람 수정 ***/
  private Integer totalCEnergy;// (Wh) /*** 12.12 이우람 수정 ***/
  private Integer totalDEnergy;// (Wh) /*** 12.12 이우람 수정 ***/
  private Date startDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
  private Date endDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
  private String intervalType;// /*** 12.12 이우람 수정 ***/
  private Integer Interval;// /*** 12.12 이우람 수정 ***/
  private Integer numItems; /*** 12.12 이우람 추가 ***/
  private List<ChargingDischargingItemModel> items; /*** 12.12 이우람 추가 ***/
//  private String retrieveTime;// YYYYMMDDhhmmss /*** 12.12 이우람 수정-주석 ***/
//  private String chargeEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/
//  private String dischargeEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/

  public String getPcsId() {
		return pcsId;
	}
	
  public void setPcsId(String pcsId) {
		this.pcsId = pcsId;
	}
	
  public Integer getTotalCEnergy() {
		return totalCEnergy;
	}
	
  public void setTotalCEnergy(Integer totalCEnergy) {
		this.totalCEnergy = totalCEnergy;
	}
	
  public Integer getTotalDEnergy() {
		return totalDEnergy;
	}
	
  public void setTotalDEnergy(Integer totalDEnergy) {
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

  public Integer getNumItems() {
  	return numItems;
  }
  
  public void setNumItems(Integer numItems) {
  	this.numItems = numItems;
  }
  

}
