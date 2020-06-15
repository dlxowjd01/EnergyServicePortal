package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;


public class ChargingDischargingSchedule {
//  private String resultCnt;// /*** 12.12 이우람 수정-주석 ***/
	private String pcsId;// /*** 12.12 이우람 수정 ***/
	private Integer totalScheduledCEnergy;// (Wh) /*** 12.12 이우람 추가 ***/
	private Integer totalScheduledDEnergy;// (Wh) /*** 12.12 이우람 추가 ***/
	private Date startDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
	private Date endDt;// YYYYMMDD /*** 12.12 이우람 수정 ***/
	private String intervalType;// /*** 12.12 이우람 수정 ***/
	private Integer Interval;// /*** 12.12 이우람 수정 ***/
	private Integer itemsCnt; /*** 12.12 이우람 추가 ***/
	private List<ChargingDischargingScheduleItemModel> items; /*** 12.12 이우람 추가 ***/
//  private String retrieveTime;// YYYYMMDDhhmmss /*** 12.12 이우람 수정-주석 ***/
//  private String chargingScheduleEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/
//  private String dischargingScheduleEnergy;// (kWh) /*** 12.12 이우람 수정-주석 ***/
	
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
	
	public Integer getItemsCnt() {
		return itemsCnt;
	}
	
	public void setItemsCnt(Integer itemsCnt) {
		this.itemsCnt = itemsCnt;
	}
	
	public List<ChargingDischargingScheduleItemModel> getItems() {
		return items;
	}
	
	public void setItems(List<ChargingDischargingScheduleItemModel> items) {
		this.items = items;
	}

}
