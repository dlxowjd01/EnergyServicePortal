package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 요금적용전력  Class
 */
public class ChargePower {
    private Integer chgPwrIdx;//요금적용전력식별자
    private String siteId;//사이트id
    private String stdDate;//기준일자(형식:yyyymmdd)
    private Integer chargePower;//요금적용전력(단위:kw)
    private Date regDate;//등록일시
   /**
    * 요금적용전력식별자 조회
    * @return chgPwrIdx
    */
    public Integer getChgPwrIdx() {
        return this.chgPwrIdx;
    }
   /**
    * 요금적용전력식별자 설정
    * @return chgPwrIdx
    */
    public void setChgPwrIdx(Integer chgPwrIdx) {
        this.chgPwrIdx = chgPwrIdx;
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
    * 기준일자(형식:yyyymmdd) 조회
    * @return stdDate
    */
    public String getStdDate() {
        return this.stdDate;
    }
   /**
    * 기준일자(형식:yyyymmdd) 설정
    * @return stdDate
    */
    public void setStdDate(String stdDate) {
        this.stdDate = stdDate;
    }
   /**
    * 요금적용전력(단위:kw) 조회
    * @return chargePower
    */
    public Integer getChargePower() {
        return this.chargePower;
    }
   /**
    * 요금적용전력(단위:kw) 설정
    * @return chargePower
    */
    public void setChargePower(Integer chargePower) {
        this.chargePower = chargePower;
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
}