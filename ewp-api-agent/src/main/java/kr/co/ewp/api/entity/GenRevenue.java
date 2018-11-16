package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * 발전수익 Class
 */
public class GenRevenue {
  private Long genRevnIdx;// 발전수익식별자
  private String siteId;// 사이트id
  private String genType;// 발전구분(1:pv,2:ess)
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Integer meterReadDay;// 검침일(단위:일)
  private Double smpRate;// smp단가(system marginal price)(단위:원)
  private Double recRate;// rec단가(단위:원)
  private Double recWeight;// rec가중치
  private Double produceVal;// 생산량(단위:kwh)
  private Double consumeVal;// 소비량(단위:kwh)
  private Double netGenVal;// 순발전량(단위:kwh)
  private Double smpPrice;// smp수익(단위:원)
  private Double recPrice;// rec수익(단위:원)
  private Double totPrice;// 총수익(단위:원)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * 발전수익식별자 조회
   * 
   * @return genRevnIdx
   */
  public Long getGenRevnIdx() {
    return this.genRevnIdx;
  }

  /**
   * 발전수익식별자 설정
   * 
   * @return genRevnIdx
   */
  public void setGenRevnIdx(Long genRevnIdx) {
    this.genRevnIdx = genRevnIdx;
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
   * 발전구분(1:pv,2:ess) 조회
   * 
   * @return genType
   */
  public String getGenType() {
    return this.genType;
  }

  /**
   * 발전구분(1:pv,2:ess) 설정
   * 
   * @return genType
   */
  public void setGenType(String genType) {
    this.genType = genType;
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
   * 검침일(단위:일) 조회
   * 
   * @return meterReadDay
   */
  public Integer getMeterReadDay() {
    return this.meterReadDay;
  }

  /**
   * 검침일(단위:일) 설정
   * 
   * @return meterReadDay
   */
  public void setMeterReadDay(Integer meterReadDay) {
    this.meterReadDay = meterReadDay;
  }

  /**
   * smp단가(system marginal price)(단위:원) 조회
   * 
   * @return smpRate
   */
  public Double getSmpRate() {
    return this.smpRate;
  }

  /**
   * smp단가(system marginal price)(단위:원) 설정
   * 
   * @return smpRate
   */
  public void setSmpRate(Double smpRate) {
    this.smpRate = smpRate;
  }

  /**
   * rec단가(단위:원) 조회
   * 
   * @return recRate
   */
  public Double getRecRate() {
    return this.recRate;
  }

  /**
   * rec단가(단위:원) 설정
   * 
   * @return recRate
   */
  public void setRecRate(Double recRate) {
    this.recRate = recRate;
  }

  /**
   * rec가중치 조회
   * 
   * @return recWeight
   */
  public Double getRecWeight() {
    return this.recWeight;
  }

  /**
   * rec가중치 설정
   * 
   * @return recWeight
   */
  public void setRecWeight(Double recWeight) {
    this.recWeight = recWeight;
  }

  /**
   * 생산량(단위:kwh) 조회
   * 
   * @return produceVal
   */
  public Double getProduceVal() {
    return this.produceVal;
  }

  /**
   * 생산량(단위:kwh) 설정
   * 
   * @return produceVal
   */
  public void setProduceVal(Double produceVal) {
    this.produceVal = produceVal;
  }

  /**
   * 소비량(단위:kwh) 조회
   * 
   * @return consumeVal
   */
  public Double getConsumeVal() {
    return this.consumeVal;
  }

  /**
   * 소비량(단위:kwh) 설정
   * 
   * @return consumeVal
   */
  public void setConsumeVal(Double consumeVal) {
    this.consumeVal = consumeVal;
  }

  /**
   * 순발전량(단위:kwh) 조회
   * 
   * @return netGenVal
   */
  public Double getNetGenVal() {
    return this.netGenVal;
  }

  /**
   * 순발전량(단위:kwh) 설정
   * 
   * @return netGenVal
   */
  public void setNetGenVal(Double netGenVal) {
    this.netGenVal = netGenVal;
  }

  /**
   * smp수익(단위:원) 조회
   * 
   * @return smpPrice
   */
  public Double getSmpPrice() {
    return this.smpPrice;
  }

  /**
   * smp수익(단위:원) 설정
   * 
   * @return smpPrice
   */
  public void setSmpPrice(Double smpPrice) {
    this.smpPrice = smpPrice;
  }

  /**
   * rec수익(단위:원) 조회
   * 
   * @return recPrice
   */
  public Double getRecPrice() {
    return this.recPrice;
  }

  /**
   * rec수익(단위:원) 설정
   * 
   * @return recPrice
   */
  public void setRecPrice(Double recPrice) {
    this.recPrice = recPrice;
  }

  /**
   * 총수익(단위:원) 조회
   * 
   * @return totPrice
   */
  public Double getTotPrice() {
    return this.totPrice;
  }

  /**
   * 총수익(단위:원) 설정
   * 
   * @return totPrice
   */
  public void setTotPrice(Double totPrice) {
    this.totPrice = totPrice;
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