package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * PV사용량 Class
 */
public class PvUsage {
  private Long pvUsgIdx;// pv사용량식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Integer usgVal;// 사용량(단위:mwh)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * pv사용량식별자 조회
   * 
   * @return pvUsgIdx
   */
  public Long getPvUsgIdx() {
    return this.pvUsgIdx;
  }

  /**
   * pv사용량식별자 설정
   * 
   * @return pvUsgIdx
   */
  public void setPvUsgIdx(Long pvUsgIdx) {
    this.pvUsgIdx = pvUsgIdx;
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
   * 사용량(단위:mwh) 조회
   * 
   * @return usgVal
   */
  public Integer getUsgVal() {
    return this.usgVal;
  }

  /**
   * 사용량(단위:mwh) 설정
   * 
   * @return usgVal
   */
  public void setUsgVal(Integer usgVal) {
    this.usgVal = usgVal;
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