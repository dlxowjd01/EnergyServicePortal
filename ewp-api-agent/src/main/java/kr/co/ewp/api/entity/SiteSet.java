package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * 사이트설정 Class
 */
public class SiteSet {
  private Long siteSetIdx;// 사이트설정식별자
  private String siteId;// 사이트id
  private String custNum; // 고객 번호
  private String useElecAddr; // 전기사용 장소
  private String meterNum; // 계량기 번호
  private String meterSf; // 계량기 배수
  private String planType;// 요금제구분(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)
  private String planType2;// 요금제구분2(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)
  private String planType3;// 요금제구분3(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)
  private String planName;// 요금제(일반용 전력 (갑)I 저압전력 외. bill_api.pdf 참조요망)
  private Long contractPower;// 계약전력(단위:kW -> W)
  private Long meterReadDay;// 검침일(단위:일)
  private String chargeYearmd;// 요금적용기준년월(형식:yyyymm)
  private Long chargePower;// 요금적용전력(단위:kW -> W)
  private Long chargeRate;// 요금적용전력대비(단위:%)
  private Long goalPower;// 목표전력(단위:kW -> W)
  private Long reduceAmt;// 감축용량(단위:kW -> W)
  private Double smpRate;// smp단가(system marginal price)(단위:원)
  private Double recRate;// rec단가(단위:원)
  private Double recWeight;// rec가중치
  private Double profitRatio;// 수익배분 비율
  private String delYn;// 삭제여부(y:예,n:아니오)
  private String regUid;// 등록자id
  private Date regDate;// 등록일시
  private String modUid;// 최종수정자id
  private Date modDate;// 최종수정일시

  /**
   * 사이트설정식별자 조회
   * 
   * @return siteSetIdx
   */
  public Long getSiteSetIdx() {
    return this.siteSetIdx;
  }

  /**
   * 사이트설정식별자 설정
   * 
   * @return siteSetIdx
   */
  public void setSiteSetIdx(Long siteSetIdx) {
    this.siteSetIdx = siteSetIdx;
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
   * 계약전력(단위:kw) 조회
   * 
   * @return contractPower
   */
  public Long getContractPower() {
    return this.contractPower;
  }

  /**
   * 계약전력(단위:kw) 설정
   * 
   * @return contractPower
   */
  public void setContractPower(Long contractPower) {
    this.contractPower = contractPower;
  }

  /**
   * 검침일(단위:일) 조회
   * 
   * @return meterReadDay
   */
  public Long getMeterReadDay() {
    return this.meterReadDay;
  }

  /**
   * 검침일(단위:일) 설정
   * 
   * @return meterReadDay
   */
  public void setMeterReadDay(Long meterReadDay) {
    this.meterReadDay = meterReadDay;
  }

  /**
   * 요금적용기준년월(형식:yyyymm) 조회
   * 
   * @return chargeYearmd
   */
  public String getChargeYearmd() {
    return this.chargeYearmd;
  }

  /**
   * 요금적용기준년월(형식:yyyymm) 설정
   * 
   * @return chargeYearm
   */
  public void setChargeYearmd(String chargeYearmd) {
    this.chargeYearmd = chargeYearmd;
  }

  /**
   * 요금적용전력(단위:kw) 조회
   * 
   * @return chargePower
   */
  public Long getChargePower() {
    return this.chargePower;
  }

  /**
   * 요금적용전력(단위:kw) 설정
   * 
   * @return chargePower
   */
  public void setChargePower(Long chargePower) {
    this.chargePower = chargePower;
  }

  /**
   * 요금적용전력대비(단위:%) 조회
   * 
   * @return chargeRate
   */
  public Long getChargeRate() {
    return this.chargeRate;
  }

  /**
   * 요금적용전력대비(단위:%) 설정
   * 
   * @return chargeRate
   */
  public void setChargeRate(Long chargeRate) {
    this.chargeRate = chargeRate;
  }

  /**
   * 목표전력(단위:kw) 조회
   * 
   * @return goalPower
   */
  public Long getGoalPower() {
    return this.goalPower;
  }

  /**
   * 목표전력(단위:kw) 설정
   * 
   * @return goalPower
   */
  public void setGoalPower(Long goalPower) {
    this.goalPower = goalPower;
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
   * 삭제여부(y:예,n:아니오) 조회
   * 
   * @return delYn
   */
  public String getDelYn() {
    return this.delYn;
  }

  /**
   * 삭제여부(y:예,n:아니오) 설정
   * 
   * @return delYn
   */
  public void setDelYn(String delYn) {
    this.delYn = delYn;
  }

  /**
   * 등록자id 조회
   * 
   * @return regUid
   */
  public String getRegUid() {
    return this.regUid;
  }

  /**
   * 등록자id 설정
   * 
   * @return regUid
   */
  public void setRegUid(String regUid) {
    this.regUid = regUid;
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
   * 최종수정자id 조회
   * 
   * @return modUid
   */
  public String getModUid() {
    return this.modUid;
  }

  /**
   * 최종수정자id 설정
   * 
   * @return modUid
   */
  public void setModUid(String modUid) {
    this.modUid = modUid;
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

  public String getPlanType() {
    return planType;
  }

  public void setPlanType(String planType) {
    this.planType = planType;
  }

  public String getPlanName() {
    return planName;
  }

  public void setPlanName(String planName) {
    this.planName = planName;
  }

  public String getCustNum() {
  	return custNum;
  }
  
  public void setCustNum(String custNum) {
  	this.custNum = custNum;
  }
  
  public String getUseElecAddr() {
  	return useElecAddr;
  }
  
  public void setUseElecAddr(String useElecAddr) {
  	this.useElecAddr = useElecAddr;
  }
  
  public String getMeterNum() {
  	return meterNum;
  }
  
  public void setMeterNum(String meterNum) {
  	this.meterNum = meterNum;
  }
  
  public String getMeterSf() {
  	return meterSf;
  }
  
  public void setMeterSf(String meterSf) {
  	this.meterSf = meterSf;
  }
  
  public String getPlanType2() {
  	return planType2;
  }
  
  public void setPlanType2(String planType2) {
  	this.planType2 = planType2;
  }
  
  public String getPlanType3() {
  	return planType3;
  }
  
  public void setPlanType3(String planType3) {
  	this.planType3 = planType3;
  }
  
  public Long getReduceAmt() {
  	return reduceAmt;
  }
  
  public void setReduceAmt(Long reduceAmt) {
  	this.reduceAmt = reduceAmt;
  }
  
  public Double getProfitRatio() {
  	return profitRatio;
  }
  
  public void setProfitRatio(Double profitRatio) {
  	this.profitRatio = profitRatio;
  }
  
}