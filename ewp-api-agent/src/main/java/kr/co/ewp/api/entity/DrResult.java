package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * DR실적 Class
 */
public class DrResult {
  private Long drRstIdx;// dr실적식별자
  private String siteId;// 사이트id
  private Date startTimestamp;// 감축시작타임스탬프
  private Date startDate;// 감축시작일시
  private Date endTimestamp;// 감축종료타임스탬프
  private Date endDate;// 감축종료일시
  private Long cblAmt;// 기준부하(cbl)(단위:mwh)
  private Long actAmt;// 실제사용량(단위:mwh)
  private Long contractPower;// 계약전력(단위:kw)
  private Long goalPower;// 목표전력(단위:kw)
  private Long rewardAmt;// 감축정산금
  private Date regDate;// 등록일시
  private Date modDate;// 최종수정일시

  /**
   * dr실적식별자 조회
   * 
   * @return drRstIdx
   */
  public Long getDrRstIdx() {
    return this.drRstIdx;
  }

  /**
   * dr실적식별자 설정
   * 
   * @return drRstIdx
   */
  public void setDrRstIdx(Long drRstIdx) {
    this.drRstIdx = drRstIdx;
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
   * 감축시작타임스탬프 조회
   * 
   * @return startTimestamp
   */
  public Date getStartTimestamp() {
    return this.startTimestamp;
  }

  /**
   * 감축시작타임스탬프 설정
   * 
   * @return startTimestamp
   */
  public void setStartTimestamp(Date startTimestamp) {
    this.startTimestamp = startTimestamp;
  }

  /**
   * 감축시작일시 조회
   * 
   * @return startDate
   */
  public Date getStartDate() {
    return this.startDate;
  }

  /**
   * 감축시작일시 설정
   * 
   * @return startDate
   */
  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  /**
   * 감축종료타임스탬프 조회
   * 
   * @return endTimestamp
   */
  public Date getEndTimestamp() {
    return this.endTimestamp;
  }

  /**
   * 감축종료타임스탬프 설정
   * 
   * @return endTimestamp
   */
  public void setEndTimestamp(Date endTimestamp) {
    this.endTimestamp = endTimestamp;
  }

  /**
   * 감축종료일시 조회
   * 
   * @return endDate
   */
  public Date getEndDate() {
    return this.endDate;
  }

  /**
   * 감축종료일시 설정
   * 
   * @return endDate
   */
  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  /**
   * 기준부하(cbl)(단위:mwh) 조회
   * 
   * @return cblAmt
   */
  public Long getCblAmt() {
    return this.cblAmt;
  }

  /**
   * 기준부하(cbl)(단위:mwh) 설정
   * 
   * @return cblAmt
   */
  public void setCblAmt(Long cblAmt) {
    this.cblAmt = cblAmt;
  }

  /**
   * 실제사용량(단위:mwh) 조회
   * 
   * @return actAmt
   */
  public Long getActAmt() {
    return this.actAmt;
  }

  /**
   * 실제사용량(단위:mwh) 설정
   * 
   * @return actAmt
   */
  public void setActAmt(Long actAmt) {
    this.actAmt = actAmt;
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
   * 감축정산금 조회
   * 
   * @return rewardAmt
   */
  public Long getRewardAmt() {
    return this.rewardAmt;
  }

  /**
   * 감축정산금 설정
   * 
   * @return rewardAmt
   */
  public void setRewardAmt(Long rewardAmt) {
    this.rewardAmt = rewardAmt;
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