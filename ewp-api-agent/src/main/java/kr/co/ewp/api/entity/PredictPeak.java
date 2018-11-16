package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * 예측피크 Class
 */
public class PredictPeak {
  private Long prePeakIdx;// 예측피크식별자
  private String siteId;// 사이트id
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Float peakVal;// 최대수요(단위:kw)
  private Date peakTimestamp;// 최대수요발생타임스탬프
  private Date peakDate;// 최대수요발생일시
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * 예측피크식별자 조회
   * 
   * @return prePeakIdx
   */
  public Long getPrePeakIdx() {
    return this.prePeakIdx;
  }

  /**
   * 예측피크식별자 설정
   * 
   * @return prePeakIdx
   */
  public void setPrePeakIdx(Long prePeakIdx) {
    this.prePeakIdx = prePeakIdx;
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
   * 최대수요(단위:kw) 조회
   * 
   * @return peakVal
   */
  public Float getPeakVal() {
    return this.peakVal;
  }

  /**
   * 최대수요(단위:kw) 설정
   * 
   * @return peakVal
   */
  public void setPeakVal(Float peakVal) {
    this.peakVal = peakVal;
  }

  /**
   * 최대수요발생타임스탬프 조회
   * 
   * @return peakTimestamp
   */
  public Date getPeakTimestamp() {
    return this.peakTimestamp;
  }

  /**
   * 최대수요발생타임스탬프 설정
   * 
   * @return peakTimestamp
   */
  public void setPeakTimestamp(Date peakTimestamp) {
    this.peakTimestamp = peakTimestamp;
  }

  /**
   * 최대수요발생일시 조회
   * 
   * @return peakDate
   */
  public Date getPeakDate() {
    return this.peakDate;
  }

  /**
   * 최대수요발생일시 설정
   * 
   * @return peakDate
   */
  public void setPeakDate(Date peakDate) {
    this.peakDate = peakDate;
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