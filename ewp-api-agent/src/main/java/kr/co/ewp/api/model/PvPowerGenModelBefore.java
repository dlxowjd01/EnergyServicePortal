package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvPowerGenModelBefore {
//  private Integer resultCnt;//
	private String ivtId;//
	private Integer totalGenEnergy;
	private Date startDt;// YYYYMMDD
	private Date endDt;// YYYYMMDD
	private String intervalType;//
	private Integer Interval;//
	private Integer numItems;
	private List<PvPowerGenModelItemModel> items;
//  private String retrieveTime;// YYYYMMDDhhmmss
//  private String genEnergy;// (kWh)
//  private String predictedGenEnergy;// (kWh)
//  private String temperature;// (℃)
	
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
