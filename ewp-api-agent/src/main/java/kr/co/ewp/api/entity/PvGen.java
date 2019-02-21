package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * PV발전량 Class
 */
public class PvGen {
  private Long pvGenIdx;// pv발전량식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private Date stdDate;// 기준일시
  private Integer genVal;// 발전량(단위:kwh)
  private Integer temp;// 온도(단위:℃)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * pv발전량식별자 조회
   * 
   * @return pvGenIdx
   */
  public Long getPvGenIdx() {
    return this.pvGenIdx;
  }

  /**
   * pv발전량식별자 설정
   * 
   * @return pvGenIdx
   */
  public void setPvGenIdx(Long pvGenIdx) {
    this.pvGenIdx = pvGenIdx;
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
   * 발전량(단위:kwh) 조회
   * 
   * @return genVal
   */
  public Integer getGenVal() {
    return this.genVal;
  }

  /**
   * 발전량(단위:kwh) 설정
   * 
   * @return genVal
   */
  public void setGenVal(Integer genVal) {
    this.genVal = genVal;
  }

  /**
   * 온도(단위:℃) 조회
   * 
   * @return temp
   */
  public Integer getTemp() {
    return this.temp;
  }

  /**
   * 온도(단위:℃) 설정
   * 
   * @return temp
   */
  public void setTemp(Integer temp) {
    this.temp = temp;
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

@Override
public String toString() {
	return "PvGen [pvGenIdx=" + pvGenIdx + ", siteId=" + siteId + ", deviceId=" + deviceId + ", stdDate=" + stdDate
			+ ", genVal=" + genVal + ", temp=" + temp + ", regDate=" + regDate + ", modDate=" + modDate + "]";
}
  
  
}