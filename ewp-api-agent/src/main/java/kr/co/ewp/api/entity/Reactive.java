package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * 무효전력 Class
 */
public class Reactive {
  private Long rctvIdx;// 무효전력식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Integer rctvVal;// positive 방향 무효전력량(단위:mvarh)
  private Integer negRctvVal;// negative 방향 무효전력량(단위:mvarh)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * 무효전력식별자 조회
   * 
   * @return rctvIdx
   */
  public Long getRctvIdx() {
    return this.rctvIdx;
  }

  /**
   * 무효전력식별자 설정
   * 
   * @return rctvIdx
   */
  public void setRctvIdx(Long rctvIdx) {
    this.rctvIdx = rctvIdx;
  }

  /**
   * 사이트id 조회
   * 
   * @return siteId
   */
  public String getSiteId() {
    return this.siteId;
  }

  /**
   * 사이트id 설정
   * 
   * @return siteId
   */
  public void setSiteId(String siteId) {
    this.siteId = siteId;
  }

  /**
   * 장치id 조회
   * 
   * @return deviceId
   */
  public String getDeviceId() {
    return this.deviceId;
  }

  /**
   * 장치id 설정
   * 
   * @return deviceId
   */
  public void setDeviceId(String deviceId) {
    this.deviceId = deviceId;
  }

  /**
   * 기준타임스탬프 조회
   * 
   * @return stdTimestamp
   */
  public Date getStdTimestamp() {
    return this.stdTimestamp;
  }

  /**
   * 기준타임스탬프 설정
   * 
   * @return stdTimestamp
   */
  public void setStdTimestamp(Date stdTimestamp) {
    this.stdTimestamp = stdTimestamp;
  }

  /**
   * 기준일시 조회
   * 
   * @return stdDate
   */
  public Date getStdDate() {
    return this.stdDate;
  }

  /**
   * 기준일시 설정
   * 
   * @return stdDate
   */
  public void setStdDate(Date stdDate) {
    this.stdDate = stdDate;
  }

  /**
   * positive 방향 무효전력량(단위:mvarh) 조회
   * 
   * @return rctvVal
   */
  public Integer getRctvVal() {
    return this.rctvVal;
  }

  /**
   * positive 방향 무효전력량(단위:mvarh) 설정
   * 
   * @return rctvVal
   */
  public void setRctvVal(Integer rctvVal) {
    this.rctvVal = rctvVal;
  }

  /**
   * negative 방향 무효전력량(단위:mvarh) 조회
   * 
 * @return the negRctvVal
 */
public Integer getNegRctvVal() {
	return negRctvVal;
}

/**
 * negative 방향 무효전력량(단위:mvarh) 설정
 * 
 * @param negRctvVal the negRctvVal to set
 */
public void setNegRctvVal(Integer negRctvVal) {
	this.negRctvVal = negRctvVal;
}

/**
   * 등록일시 조회
   * 
   * @return regDate
   */
  public Date getRegDate() {
    return this.regDate;
  }

  /**
   * 등록일시 설정
   * 
   * @return regDate
   */
  public void setRegDate(Date regDate) {
    this.regDate = regDate;
  }

  /**
   * 최종수정일시 조회
   * 
   * @return modDate
   */
  public Date getModDate() {
    return this.modDate;
  }

  /**
   * 최종수정일시 설정
   * 
   * @return modDate
   */
  public void setModDate(Date modDate) {
    this.modDate = modDate;
  }
}