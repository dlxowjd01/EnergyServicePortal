package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

public class ChargingDischargingScheduleBefore {
  private Integer itemsCnt;//
  private String pcsId;//
  private Integer totalScheduledCEnergy;// (kWh)
  private Integer totalScheduledDEnergy;//
  private Date startDt;// YYYYMMDD
  private Date endDt;// YYYYMMDD
  private String intervalType;//
  private Integer Interval;//
  private List<ChargingDischargingScheduleItemModel> items;
//  private String retrieveTime;// YYYYMMDDhhmmss
//  private String chargingScheduleEnergy;// (kWh)
//  private String dischargingScheduleEnergy;// (kWh)
	
	public Integer getItemsCnt() {
		return itemsCnt;
	}
	
	public void setItemsCnt(Integer itemsCnt) {
		this.itemsCnt = itemsCnt;
	}
	
	public String getPcsId() {
		return pcsId;
	}
	
	public void setPcsId(String pcsId) {
		this.pcsId = pcsId;
	}
	
	public Integer getTotalScheduledCEnergy() {
		return totalScheduledCEnergy;
	}
	
	public void setTotalScheduledCEnergy(Integer totalScheduledCEnergy) {
		this.totalScheduledCEnergy = totalScheduledCEnergy;
	}
	
	public Integer getTotalScheduledDEnergy() {
		return totalScheduledDEnergy;
	}
	
	public void setTotalScheduledDEnergy(Integer totalScheduledDEnergy) {
		this.totalScheduledDEnergy = totalScheduledDEnergy;
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
	
	public List<ChargingDischargingScheduleItemModel> getItems() {
		return items;
	}
	
	public void setItems(List<ChargingDischargingScheduleItemModel> items) {
		this.items = items;
	}
}
