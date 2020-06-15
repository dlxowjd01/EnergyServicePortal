package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * ESS사용량  Class
 */
public class EssUsage {
    private Long essUsgIdx;//ess사용량식별자
    private String siteId;//사이트id
    private String deviceId;//장치id
    private Date stdDate;//기준일시
    private Float usgVal;//사용량(단위:kwh)
    private Date regDate;//등록일시
    private Date modDate;//최종수정일시
   /**
    * ess사용량식별자 조회
    * @return essUsgIdx
    */
    public Long getEssUsgIdx() {
        return this.essUsgIdx;
    }
   /**
    * ess사용량식별자 설정
    * @return essUsgIdx
    */
    public void setEssUsgIdx(Long essUsgIdx) {
        this.essUsgIdx = essUsgIdx;
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
    * 사용량(단위:kwh) 조회
    * @return usgVal
    */
    public Float getUsgVal() {
        return this.usgVal;
    }
   /**
    * 사용량(단위:kwh) 설정
    * @return usgVal
    */
    public void setUsgVal(Float usgVal) {
        this.usgVal = usgVal;
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