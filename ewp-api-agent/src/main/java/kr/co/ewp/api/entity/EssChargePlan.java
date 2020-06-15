package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * ESS충방전량계획 Class
 */
public class EssChargePlan {
  private Long essChgPlanIdx;// ess충방전량계획식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Float chgVal;// 충전계획량(단위:kWh -> Wh)
  private Float dischgVal;// 방전계획량(단위:kWh -> Wh)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * ess충방전량계획식별자 조회
   * 
   * @return essChgPlanIdx
   */
  public Long getEssChgPlanIdx() {
    return this.essChgPlanIdx;
  }

  /**
   * ess충방전량계획식별자 설정
   * 
   * @return essChgPlanIdx
   */
  public void setEssChgPlanIdx(Long essChgPlanIdx) {
    this.essChgPlanIdx = essChgPlanIdx;
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
   * 충전계획량(단위:kwh) 조회
   * 
   * @return chgVal
   */
  public Float getChgVal() {
    return this.chgVal;
  }

  /**
   * 충전계획량(단위:kwh) 설정
   * 
   * @return chgVal
   */
  public void setChgVal(Float chgVal) {
    this.chgVal = chgVal;
  }

  /**
   * 방전계획량(단위:kwh) 조회
   * 
   * @return dischgVal
   */
  public Float getDischgVal() {
    return this.dischgVal;
  }

  /**
   * 방전계획량(단위:kwh) 설정
   * 
   * @return dischgVal
   */
  public void setDischgVal(Float dischgVal) {
    this.dischgVal = dischgVal;
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