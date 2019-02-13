package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

public class PvPowerGenModel {
//  private String resultCnt;// /*** 12.12 이우람 수정-주석 ***/
  private String ivtId;// /*** 12.12 이우람 수정 ***/
  private Integer totalGenEnergy; /*** 12.12 이우람 추가 ***/
  private Date startDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
  private Date endDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
  private String intervalType;// /*** 12.12 이우람 수정 ***/
  private Integer Interval;// /*** 12.12 이우람 수정 ***/
  private Integer numItems; /*** 12.12 이우람 추가 ***/
  private List<PvPowerGenModelItemModel> items; /*** 12.12 이우람 추가 ***/
//  private String retrieveTime;// YYYYMMDDhhmmss /*** 12.12 이우람 수정-주석 ***/
//  private String genEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/
//  private String predictedGenEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/
//  private String temperature;// (℃) /*** 12.12 이우람 수정-주석 ***/

  public String getIvtId() {
		return ivtId;
	}
	
  public void setIvtId(String ivtId) {
		this.ivtId = ivtId;
	}
	
  public Integer getTotalGenEnergy() {
		return totalGenEnergy;
	}
	
  public void setTotalGenEnergy(Integer totalGenEnergy) {
		this.totalGenEnergy = totalGenEnergy;
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
	
  public Integer getNumItems() {
		return numItems;
	}
	
  public void setNumItems(Integer numItems) {
		this.numItems = numItems;
	}
	
  public List<PvPowerGenModelItemModel> getItems() {
		return items;
	}
	
  public void setItems(List<PvPowerGenModelItemModel> items) {
		this.items = items;
	}

}
