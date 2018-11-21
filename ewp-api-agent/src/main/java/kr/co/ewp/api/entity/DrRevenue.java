package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * DR수익 Class
 */
public class DrRevenue {
  private Long drRevnIdx;// 발전수익식별자
  private String siteId;// 사이트id
  private String stdYearm;// 기준년월(형식:YYYYMM)
  private Date stdTimestamp;// 기준타임스탬프
  private Date stdDate;// 기준일시
  private Integer reductCap;// 감축용량(단위:kwh)
  private Integer basicPrice;// 기본가격(단위:원/kwh)
  private Float maxReductRatio;// 감축상한비율
  private Float minReductRatio;// 감축하한비율
  private Integer totPay;// 총지급액
  private Integer basicPay;// 기본지급액
  private Date reductStimestamp;// 감축시작타임스탬프
  private Date reductEtimestamp;// 감축종료타임스탬프
  private Date reductSdate;// 감축시작일시
  private Date reductEdate;// 감축종료일시
  private Integer cblAmt;// 평균사용량(단위:kwh)
  private Integer actAmt;// 실제사용량(단위:kwh)
  private Integer reductAmt;// 감축량(단위:kwh)
  private Integer smp;// smp(단위:원)
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * 발전수익식별자 조회
   * 
   * @return drRevnIdx
   */
  public Long getDrRevnIdx() {
    return this.drRevnIdx;
  }

  /**
   * 발전수익식별자 설정
   * 
   * @return drRevnIdx
   */
  public void setDrRevnIdx(Long drRevnIdx) {
    this.drRevnIdx = drRevnIdx;
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
   * 기본가격(단위:원/kwh) 조회
   * 
   * @return basicPrice
   */
  public Integer getBasicPrice() {
    return this.basicPrice;
  }

  /**
   * 기본가격(단위:원/kwh) 설정
   * 
   * @return basicPrice
   */
  public void setBasicPrice(Integer basicPrice) {
    this.basicPrice = basicPrice;
  }

  /**
   * 총지급액 조회
   * 
   * @return totPay
   */
  public Integer getTotPay() {
    return this.totPay;
  }

  /**
   * 총지급액 설정
   * 
   * @return totPay
   */
  public void setTotPay(Integer totPay) {
    this.totPay = totPay;
  }

  /**
   * 기본지급액 조회
   * 
   * @return basicPay
   */
  public Integer getBasicPay() {
    return this.basicPay;
  }

  /**
   * 기본지급액 설정
   * 
   * @return basicPay
   */
  public void setBasicPay(Integer basicPay) {
    this.basicPay = basicPay;
  }

  /**
   * 감축시작타임스탬프 조회
   * 
   * @return reductStimestamp
   */
  public Date getReductStimestamp() {
    return this.reductStimestamp;
  }

  /**
   * 감축시작타임스탬프 설정
   * 
   * @return reductStimestamp
   */
  public void setReductStimestamp(Date reductStimestamp) {
    this.reductStimestamp = reductStimestamp;
  }

  /**
   * 감축종료타임스탬프 조회
   * 
   * @return reductEtimestamp
   */
  public Date getReductEtimestamp() {
    return this.reductEtimestamp;
  }

  /**
   * 감축종료타임스탬프 설정
   * 
   * @return reductEtimestamp
   */
  public void setReductEtimestamp(Date reductEtimestamp) {
    this.reductEtimestamp = reductEtimestamp;
  }

  /**
   * 감축시작일시 조회
   * 
   * @return reductSdate
   */
  public Date getReductSdate() {
    return this.reductSdate;
  }

  /**
   * 감축시작일시 설정
   * 
   * @return reductSdate
   */
  public void setReductSdate(Date reductSdate) {
    this.reductSdate = reductSdate;
  }

  /**
   * 감축종료일시 조회
   * 
   * @return reductEdate
   */
  public Date getReductEdate() {
    return this.reductEdate;
  }

  /**
   * 감축종료일시 설정
   * 
   * @return reductEdate
   */
  public void setReductEdate(Date reductEdate) {
    this.reductEdate = reductEdate;
  }

  /**
   * 평균사용량(단위:kwh) 조회
   * 
   * @return cblAmt
   */
  public Integer getCblAmt() {
    return this.cblAmt;
  }

  /**
   * 평균사용량(단위:kwh) 설정
   * 
   * @return cblAmt
   */
  public void setCblAmt(Integer cblAmt) {
    this.cblAmt = cblAmt;
  }

  /**
   * 실제사용량(단위:kwh) 조회
   * 
   * @return actAmt
   */
  public Integer getActAmt() {
    return this.actAmt;
  }

  /**
   * 실제사용량(단위:kwh) 설정
   * 
   * @return actAmt
   */
  public void setActAmt(Integer actAmt) {
    this.actAmt = actAmt;
  }

  /**
   * 감축량(단위:kwh) 조회
   * 
   * @return reductAmt
   */
  public Integer getReductAmt() {
    return this.reductAmt;
  }

  /**
   * 감축량(단위:kwh) 설정
   * 
   * @return reductAmt
   */
  public void setReductAmt(Integer reductAmt) {
    this.reductAmt = reductAmt;
  }

  /**
   * smp(단위:원) 조회
   * 
   * @return smp
   */
  public Integer getSmp() {
    return this.smp;
  }

  /**
   * smp(단위:원) 설정
   * 
   * @return smp
   */
  public void setSmp(Integer smp) {
    this.smp = smp;
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

  public String getStdYearm() {
    return stdYearm;
  }

  public void setStdYearm(String stdYearm) {
    this.stdYearm = stdYearm;
  }

  public Integer getReductCap() {
    return reductCap;
  }

  public void setReductCap(Integer reductCap) {
    this.reductCap = reductCap;
  }

  public Float getMaxReductRatio() {
    return maxReductRatio;
  }

  public void setMaxReductRatio(Float maxReductRatio) {
    this.maxReductRatio = maxReductRatio;
  }

  public Float getMinReductRatio() {
    return minReductRatio;
  }

  public void setMinReductRatio(Float minReductRatio) {
    this.minReductRatio = minReductRatio;
  }
}