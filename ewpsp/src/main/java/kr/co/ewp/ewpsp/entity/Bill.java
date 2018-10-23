package kr.co.ewp.ewpsp.entity;
import java.util.Date;
/**
 * 요금  Class
 */
public class Bill {
    private Long billIdx;//요금식별자
    private String siteId;//사이트id
    private String billYearm;//청구년월(형식:yyyymm)
    private Integer meterReadDay;//검침일(단위:일)
    private String planType;//요금제구분
    private String planName;//요금제
    private Integer contractPower;//계약전력(단위:kw)
    private String svcSdate;//사용시작일(형식:yyyymmdd)
    private String svcEdate;//사용종료일(형식:yyyymmdd)
    private Integer baseRate;//기본요금
    private Integer consumeRate;//전력량요금
    private Integer offPeakRate;//경부하요금
    private Integer midPeakRate;//중부하요금
    private Integer maxPeakRate;//최대부하요금
    private Integer pwrFactorRate;//역률요금
    private Integer totElecRate;//전기요금계
    private Integer elecFund;//전력기금
    private Integer valAddTax;//부가가치세
    private Integer totAmtBill;//당월요금계
    private Float peakPwrDemand;//요금적용전력(단위:kw)
    private Float usg;//전체전력사용량(단위:kwh)
    private Float offPeakUsg;//경부하전력사용량(단위:kwh)
    private Float midPeakUsg;//중부하전력사용량(단위:kwh)
    private Float maxPeakUsg;//최대부하전력사용량(단위:kwh)
    private Integer leadPwrFactor;//진상역률(단위:%)
    private Integer lagPwrFactor;//지상역률(단위:%)
    private Integer essChgIncen;//ess충전요금할인
    private Integer essDischgIncen;//ess방전요금할인
    private Integer demandChgReduct;//기본요금절감금액
    private Integer energyChgReduct;//전력량요금절감금액
    private Float essChgOffPeak;//경부하시간대방전량(단위:kwh)
    private Float essChgMidPeak;//중부하시간대방전량(단위:kwh)
    private Float essChgMaxPeak;//최대부하시간대방전량(단위:kwh)
    private Float essDischgOffPeak;//경부하시간대충전량(단위:kwh)
    private Float essDischgMidPeak;//중부하시간대충전량(단위:kwh)
    private Float essDischgMaxPeak;//최대부하시간대충전량(단위:kwh)
    private Date regDate;//등록일시
    private Date modDate;//최종수정일시
   /**
    * 요금식별자 조회
    * @return billIdx
    */
    public Long getBillIdx() {
        return this.billIdx;
    }
   /**
    * 요금식별자 설정
    * @return billIdx
    */
    public void setBillIdx(Long billIdx) {
        this.billIdx = billIdx;
    }
   /**
    * 사이트id 조회
    * @return siteId
    */
    public String getSiteId() {
        return this.siteId;
    }
   /**
    * 사이트id 설정
    * @return siteId
    */
    public void setSiteId(String siteId) {
        this.siteId = siteId;
    }
   /**
    * 청구년월(형식:yyyymm) 조회
    * @return billYearm
    */
    public String getBillYearm() {
        return this.billYearm;
    }
   /**
    * 청구년월(형식:yyyymm) 설정
    * @return billYearm
    */
    public void setBillYearm(String billYearm) {
        this.billYearm = billYearm;
    }
   /**
    * 검침일(단위:일) 조회
    * @return meterReadDay
    */
    public Integer getMeterReadDay() {
        return this.meterReadDay;
    }
   /**
    * 검침일(단위:일) 설정
    * @return meterReadDay
    */
    public void setMeterReadDay(Integer meterReadDay) {
        this.meterReadDay = meterReadDay;
    }
   /**
    * 요금제구분 조회
    * @return planType
    */
    public String getPlanType() {
        return this.planType;
    }
   /**
    * 요금제구분 설정
    * @return planType
    */
    public void setPlanType(String planType) {
        this.planType = planType;
    }
   /**
    * 요금제 조회
    * @return planName
    */
    public String getPlanName() {
        return this.planName;
    }
   /**
    * 요금제 설정
    * @return planName
    */
    public void setPlanName(String planName) {
        this.planName = planName;
    }
   /**
    * 계약전력(단위:kw) 조회
    * @return contractPower
    */
    public Integer getContractPower() {
        return this.contractPower;
    }
   /**
    * 계약전력(단위:kw) 설정
    * @return contractPower
    */
    public void setContractPower(Integer contractPower) {
        this.contractPower = contractPower;
    }
   /**
    * 사용시작일(형식:yyyymmdd) 조회
    * @return svcSdate
    */
    public String getSvcSdate() {
        return this.svcSdate;
    }
   /**
    * 사용시작일(형식:yyyymmdd) 설정
    * @return svcSdate
    */
    public void setSvcSdate(String svcSdate) {
        this.svcSdate = svcSdate;
    }
   /**
    * 사용종료일(형식:yyyymmdd) 조회
    * @return svcEdate
    */
    public String getSvcEdate() {
        return this.svcEdate;
    }
   /**
    * 사용종료일(형식:yyyymmdd) 설정
    * @return svcEdate
    */
    public void setSvcEdate(String svcEdate) {
        this.svcEdate = svcEdate;
    }
   /**
    * 기본요금 조회
    * @return baseRate
    */
    public Integer getBaseRate() {
        return this.baseRate;
    }
   /**
    * 기본요금 설정
    * @return baseRate
    */
    public void setBaseRate(Integer baseRate) {
        this.baseRate = baseRate;
    }
   /**
    * 전력량요금 조회
    * @return consumeRate
    */
    public Integer getConsumeRate() {
        return this.consumeRate;
    }
   /**
    * 전력량요금 설정
    * @return consumeRate
    */
    public void setConsumeRate(Integer consumeRate) {
        this.consumeRate = consumeRate;
    }
   /**
    * 경부하요금 조회
    * @return offPeakRate
    */
    public Integer getOffPeakRate() {
        return this.offPeakRate;
    }
   /**
    * 경부하요금 설정
    * @return offPeakRate
    */
    public void setOffPeakRate(Integer offPeakRate) {
        this.offPeakRate = offPeakRate;
    }
   /**
    * 중부하요금 조회
    * @return midPeakRate
    */
    public Integer getMidPeakRate() {
        return this.midPeakRate;
    }
   /**
    * 중부하요금 설정
    * @return midPeakRate
    */
    public void setMidPeakRate(Integer midPeakRate) {
        this.midPeakRate = midPeakRate;
    }
   /**
    * 최대부하요금 조회
    * @return maxPeakRate
    */
    public Integer getMaxPeakRate() {
        return this.maxPeakRate;
    }
   /**
    * 최대부하요금 설정
    * @return maxPeakRate
    */
    public void setMaxPeakRate(Integer maxPeakRate) {
        this.maxPeakRate = maxPeakRate;
    }
   /**
    * 역률요금 조회
    * @return pwrFactorRate
    */
    public Integer getPwrFactorRate() {
        return this.pwrFactorRate;
    }
   /**
    * 역률요금 설정
    * @return pwrFactorRate
    */
    public void setPwrFactorRate(Integer pwrFactorRate) {
        this.pwrFactorRate = pwrFactorRate;
    }
   /**
    * 전기요금계 조회
    * @return totElecRate
    */
    public Integer getTotElecRate() {
        return this.totElecRate;
    }
   /**
    * 전기요금계 설정
    * @return totElecRate
    */
    public void setTotElecRate(Integer totElecRate) {
        this.totElecRate = totElecRate;
    }
   /**
    * 전력기금 조회
    * @return elecFund
    */
    public Integer getElecFund() {
        return this.elecFund;
    }
   /**
    * 전력기금 설정
    * @return elecFund
    */
    public void setElecFund(Integer elecFund) {
        this.elecFund = elecFund;
    }
   /**
    * 부가가치세 조회
    * @return valAddTax
    */
    public Integer getValAddTax() {
        return this.valAddTax;
    }
   /**
    * 부가가치세 설정
    * @return valAddTax
    */
    public void setValAddTax(Integer valAddTax) {
        this.valAddTax = valAddTax;
    }
   /**
    * 당월요금계 조회
    * @return totAmtBill
    */
    public Integer getTotAmtBill() {
        return this.totAmtBill;
    }
   /**
    * 당월요금계 설정
    * @return totAmtBill
    */
    public void setTotAmtBill(Integer totAmtBill) {
        this.totAmtBill = totAmtBill;
    }
   /**
    * 요금적용전력(단위:kw) 조회
    * @return peakPwrDemand
    */
    public Float getPeakPwrDemand() {
        return this.peakPwrDemand;
    }
   /**
    * 요금적용전력(단위:kw) 설정
    * @return peakPwrDemand
    */
    public void setPeakPwrDemand(Float peakPwrDemand) {
        this.peakPwrDemand = peakPwrDemand;
    }
   /**
    * 전체전력사용량(단위:kwh) 조회
    * @return usg
    */
    public Float getUsg() {
        return this.usg;
    }
   /**
    * 전체전력사용량(단위:kwh) 설정
    * @return usg
    */
    public void setUsg(Float usg) {
        this.usg = usg;
    }
   /**
    * 경부하전력사용량(단위:kwh) 조회
    * @return offPeakUsg
    */
    public Float getOffPeakUsg() {
        return this.offPeakUsg;
    }
   /**
    * 경부하전력사용량(단위:kwh) 설정
    * @return offPeakUsg
    */
    public void setOffPeakUsg(Float offPeakUsg) {
        this.offPeakUsg = offPeakUsg;
    }
   /**
    * 중부하전력사용량(단위:kwh) 조회
    * @return midPeakUsg
    */
    public Float getMidPeakUsg() {
        return this.midPeakUsg;
    }
   /**
    * 중부하전력사용량(단위:kwh) 설정
    * @return midPeakUsg
    */
    public void setMidPeakUsg(Float midPeakUsg) {
        this.midPeakUsg = midPeakUsg;
    }
   /**
    * 최대부하전력사용량(단위:kwh) 조회
    * @return maxPeakUsg
    */
    public Float getMaxPeakUsg() {
        return this.maxPeakUsg;
    }
   /**
    * 최대부하전력사용량(단위:kwh) 설정
    * @return maxPeakUsg
    */
    public void setMaxPeakUsg(Float maxPeakUsg) {
        this.maxPeakUsg = maxPeakUsg;
    }
   /**
    * 진상역률(단위:%) 조회
    * @return leadPwrFactor
    */
    public Integer getLeadPwrFactor() {
        return this.leadPwrFactor;
    }
   /**
    * 진상역률(단위:%) 설정
    * @return leadPwrFactor
    */
    public void setLeadPwrFactor(Integer leadPwrFactor) {
        this.leadPwrFactor = leadPwrFactor;
    }
   /**
    * 지상역률(단위:%) 조회
    * @return lagPwrFactor
    */
    public Integer getLagPwrFactor() {
        return this.lagPwrFactor;
    }
   /**
    * 지상역률(단위:%) 설정
    * @return lagPwrFactor
    */
    public void setLagPwrFactor(Integer lagPwrFactor) {
        this.lagPwrFactor = lagPwrFactor;
    }
   /**
    * ess충전요금할인 조회
    * @return essChgIncen
    */
    public Integer getEssChgIncen() {
        return this.essChgIncen;
    }
   /**
    * ess충전요금할인 설정
    * @return essChgIncen
    */
    public void setEssChgIncen(Integer essChgIncen) {
        this.essChgIncen = essChgIncen;
    }
   /**
    * ess방전요금할인 조회
    * @return essDischgIncen
    */
    public Integer getEssDischgIncen() {
        return this.essDischgIncen;
    }
   /**
    * ess방전요금할인 설정
    * @return essDischgIncen
    */
    public void setEssDischgIncen(Integer essDischgIncen) {
        this.essDischgIncen = essDischgIncen;
    }
   /**
    * 기본요금절감금액 조회
    * @return demandChgReduct
    */
    public Integer getDemandChgReduct() {
        return this.demandChgReduct;
    }
   /**
    * 기본요금절감금액 설정
    * @return demandChgReduct
    */
    public void setDemandChgReduct(Integer demandChgReduct) {
        this.demandChgReduct = demandChgReduct;
    }
   /**
    * 전력량요금절감금액 조회
    * @return energyChgReduct
    */
    public Integer getEnergyChgReduct() {
        return this.energyChgReduct;
    }
   /**
    * 전력량요금절감금액 설정
    * @return energyChgReduct
    */
    public void setEnergyChgReduct(Integer energyChgReduct) {
        this.energyChgReduct = energyChgReduct;
    }
   /**
    * 경부하시간대방전량(단위:kwh) 조회
    * @return essChgOffPeak
    */
    public Float getEssChgOffPeak() {
        return this.essChgOffPeak;
    }
   /**
    * 경부하시간대방전량(단위:kwh) 설정
    * @return essChgOffPeak
    */
    public void setEssChgOffPeak(Float essChgOffPeak) {
        this.essChgOffPeak = essChgOffPeak;
    }
   /**
    * 중부하시간대방전량(단위:kwh) 조회
    * @return essChgMidPeak
    */
    public Float getEssChgMidPeak() {
        return this.essChgMidPeak;
    }
   /**
    * 중부하시간대방전량(단위:kwh) 설정
    * @return essChgMidPeak
    */
    public void setEssChgMidPeak(Float essChgMidPeak) {
        this.essChgMidPeak = essChgMidPeak;
    }
   /**
    * 최대부하시간대방전량(단위:kwh) 조회
    * @return essChgMaxPeak
    */
    public Float getEssChgMaxPeak() {
        return this.essChgMaxPeak;
    }
   /**
    * 최대부하시간대방전량(단위:kwh) 설정
    * @return essChgMaxPeak
    */
    public void setEssChgMaxPeak(Float essChgMaxPeak) {
        this.essChgMaxPeak = essChgMaxPeak;
    }
   /**
    * 경부하시간대충전량(단위:kwh) 조회
    * @return essDischgOffPeak
    */
    public Float getEssDischgOffPeak() {
        return this.essDischgOffPeak;
    }
   /**
    * 경부하시간대충전량(단위:kwh) 설정
    * @return essDischgOffPeak
    */
    public void setEssDischgOffPeak(Float essDischgOffPeak) {
        this.essDischgOffPeak = essDischgOffPeak;
    }
   /**
    * 중부하시간대충전량(단위:kwh) 조회
    * @return essDischgMidPeak
    */
    public Float getEssDischgMidPeak() {
        return this.essDischgMidPeak;
    }
   /**
    * 중부하시간대충전량(단위:kwh) 설정
    * @return essDischgMidPeak
    */
    public void setEssDischgMidPeak(Float essDischgMidPeak) {
        this.essDischgMidPeak = essDischgMidPeak;
    }
   /**
    * 최대부하시간대충전량(단위:kwh) 조회
    * @return essDischgMaxPeak
    */
    public Float getEssDischgMaxPeak() {
        return this.essDischgMaxPeak;
    }
   /**
    * 최대부하시간대충전량(단위:kwh) 설정
    * @return essDischgMaxPeak
    */
    public void setEssDischgMaxPeak(Float essDischgMaxPeak) {
        this.essDischgMaxPeak = essDischgMaxPeak;
    }
   /**
    * 등록일시 조회
    * @return regDate
    */
    public Date getRegDate() {
        return this.regDate;
    }
   /**
    * 등록일시 설정
    * @return regDate
    */
    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }
   /**
    * 최종수정일시 조회
    * @return modDate
    */
    public Date getModDate() {
        return this.modDate;
    }
   /**
    * 최종수정일시 설정
    * @return modDate
    */
    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }
}