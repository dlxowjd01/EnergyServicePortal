package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * PV장치  Class
 */
public class DevicePv {
    private Long devicePvIdx;//pv장치식별자
    private String siteId;//사이트id
    private String deviceId;//장치id
    private String deviceName;//장치명
    private String deviceStat;//pv상태
    private String alarmMsg;//알람메시지
    private Integer temp;//온도(단위:℃)
    private Float totPower;//금일누적발전량(단위:kwh)
    private Date stdDate;//기준일시
    private Date regDate;//등록일시
   /**
    * pv장치식별자 조회
    * @return devicePvIdx
    */
    public Long getDevicePvIdx() {
        return this.devicePvIdx;
    }
   /**
    * pv장치식별자 설정
    * @return devicePvIdx
    */
    public void setDevicePvIdx(Long devicePvIdx) {
        this.devicePvIdx = devicePvIdx;
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
    * 장치명 조회
    * @return deviceName
    */
    public String getDeviceName() {
        return this.deviceName;
    }
   /**
    * 장치명 설정
    * @return deviceName
    */
    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }
   /**
    * pv상태 조회
    * @return deviceStat
    */
    public String getDeviceStat() {
        return this.deviceStat;
    }
   /**
    * pv상태 설정
    * @return deviceStat
    */
    public void setDeviceStat(String deviceStat) {
        this.deviceStat = deviceStat;
    }
   /**
    * 알람메시지 조회
    * @return alarmMsg
    */
    public String getAlarmMsg() {
        return this.alarmMsg;
    }
   /**
    * 알람메시지 설정
    * @return alarmMsg
    */
    public void setAlarmMsg(String alarmMsg) {
        this.alarmMsg = alarmMsg;
    }
   /**
    * 온도(단위:℃) 조회
    * @return temp
    */
    public Integer getTemp() {
        return this.temp;
    }
   /**
    * 온도(단위:℃) 설정
    * @return temp
    */
    public void setTemp(Integer temp) {
        this.temp = temp;
    }
   /**
    * 금일누적발전량(단위:kwh) 조회
    * @return totPower
    */
    public Float getTotPower() {
        return this.totPower;
    }
   /**
    * 금일누적발전량(단위:kwh) 설정
    * @return totPower
    */
    public void setTotPower(Float totPower) {
        this.totPower = totPower;
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