package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * ESS방전량  Class
 */
public class EssDischarge {
    private Long essDischgIdx;//ess방전량식별자
    private String siteId;//사이트id
    private String deviceId;//장치id
    private String stdTimestamp;//기준타임스탬프
    private Date stdDate;//기준일시
    private Integer dischgVal;//방전량(단위:kwh)
    private Date regDate;//등록일시
    private Date modDate;//최종수정일시
   /**
    * ess방전량식별자 조회
    * @return essDischgIdx
    */
    public Long getEssDischgIdx() {
        return this.essDischgIdx;
    }
   /**
    * ess방전량식별자 설정
    * @return essDischgIdx
    */
    public void setEssDischgIdx(Long essDischgIdx) {
        this.essDischgIdx = essDischgIdx;
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
    * 장치id 조회
    * @return deviceId
    */
    public String getDeviceId() {
        return this.deviceId;
    }
   /**
    * 장치id 설정
    * @return deviceId
    */
    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }
   /**
    * 기준타임스탬프 조회
    * @return stdTimestamp
    */
    public String getStdTimestamp() {
        return this.stdTimestamp;
    }
   /**
    * 기준타임스탬프 설정
    * @return stdTimestamp
    */
    public void setStdTimestamp(String stdTimestamp) {
        this.stdTimestamp = stdTimestamp;
    }
   /**
    * 기준일시 조회
    * @return stdDate
    */
    public Date getStdDate() {
        return this.stdDate;
    }
   /**
    * 기준일시 설정
    * @return stdDate
    */
    public void setStdDate(Date stdDate) {
        this.stdDate = stdDate;
    }
   /**
    * 방전량(단위:kwh) 조회
    * @return dischgVal
    */
    public Integer getDischgVal() {
        return this.dischgVal;
    }
   /**
    * 방전량(단위:kwh) 설정
    * @return dischgVal
    */
    public void setDischgVal(Integer dischgVal) {
        this.dischgVal = dischgVal;
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