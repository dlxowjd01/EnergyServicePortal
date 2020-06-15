package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * DR실적 Class
 */
public class Cbl {
  private Long cblIdx;// dr실적식별자
  private String siteId;// 사이트id
  private Date startTimestamp;// 시작타임스탬프
  private Date startDate;// 시작일시
  private Date endTimestamp;// 종료타임스탬프
  private Date endDate;// 종료일시
  private Float cbl;// 기준부하
  private Float cml;// 최소부하
  private Date regDate;// 등록일시
  private Date modDate;// 등록일시
  
	public Long getCblIdx() {
		return cblIdx;
	}
	
	public void setCblIdx(Long cblIdx) {
		this.cblIdx = cblIdx;
	}
	
	public String getSiteId() {
		return siteId;
	}
	
	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}
	
	public Date getStartTimestamp() {
		return startTimestamp;
	}
	
	public void setStartTimestamp(Date startTimestamp) {
		this.startTimestamp = startTimestamp;
	}
	
	public Date getStartDate() {
		return startDate;
	}
	
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	public Date getEndTimestamp() {
		return endTimestamp;
	}
	
	public void setEndTimestamp(Date endTimestamp) {
		this.endTimestamp = endTimestamp;
	}
	
	public Date getEndDate() {
		return endDate;
	}
	
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	public Float getCbl() {
		return cbl;
	}
	
	public void setCbl(Float cbl) {
		this.cbl = cbl;
	}
	
	public Float getCml() {
		return cml;
	}
	
	public void setCml(Float cml) {
		this.cml = cml;
	}
	
	public Date getRegDate() {
		return regDate;
	}
	
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public Date getModDate() {
		return modDate;
	}

	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
	

}