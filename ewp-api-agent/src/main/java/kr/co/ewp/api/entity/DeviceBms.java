package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * BMS장치  Class
 */
public class DeviceBms {
    private Long deviceBmsIdx;//bms장치식별자
    private String siteId;//사이트id
    private String deviceId;//장치id
    private String deviceName;//장치명
    private String deviceStat;//충방전상태
    private String alarmMsg;// 알람메시지
    private Float sysSoc;//soc(단위:%)
    private Float currSoc;//soc현재(단위:kWh -> Wh)
    private Float sysSoh;//soh(단위:%)
    private Float sysVoltage;//출력전압(단위:v)
    private Float sysCurrent;//출력전류(단위:a)
    private Float dod;//dod(단위:%)
    private Date stdDate;//기준일시
    private Date regDate;//등록일시
   /**
    * bms장치식별자 조회
    * @return deviceBmsIdx
    */
    public Long getDeviceBmsIdx() {
        return this.deviceBmsIdx;
    }
   /**
    * bms장치식별자 설정
    * @return deviceBmsIdx
    */
    public void setDeviceBmsIdx(Long deviceBmsIdx) {
        this.deviceBmsIdx = deviceBmsIdx;
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
    * 충방전상태 조회
    * @return deviceStat
    */
    public String getDeviceStat() {
        return this.deviceStat;
    }
   /**
    * 충방전상태 설정
    * @return deviceStat
    */
    public void setDeviceStat(String deviceStat) {
        this.deviceStat = deviceStat;
    }
    /**
     * 알람메시지 조회
     * 
     * @return alarmMsg
     */
    public String getAlarmMsg() {
      return this.alarmMsg;
    }
    /**
     * 알람메시지 설정
     * 
     * @return alarmMsg
     */
    public void setAlarmMsg(String alarmMsg) {
      this.alarmMsg = alarmMsg;
    }
   /**
    * soc(단위:%) 조회
    * @return sysSoc
    */
    public Float getSysSoc() {
        return this.sysSoc;
    }
   /**
    * soc(단위:%) 설정
    * @return sysSoc
    */
    public void setSysSoc(Float sysSoc) {
        this.sysSoc = sysSoc;
    }
   /**
    * soc현재(단위:kWh -> Wh) 조회
    * @return currSoc
    */
    public Float getCurrSoc() {
        return this.currSoc;
    }
   /**
    * soc현재(단위:kWh -> Wh) 설정
    * @return currSoc
    */
    public void setCurrSoc(Float currSoc) {
        this.currSoc = currSoc;
    }
   /**
    * soh(단위:%) 조회
    * @return sysSoh
    */
    public Float getSysSoh() {
        return this.sysSoh;
    }
   /**
    * soh(단위:%) 설정
    * @return sysSoh
    */
    public void setSysSoh(Float sysSoh) {
        this.sysSoh = sysSoh;
    }
   /**
    * 출력전압(단위:v) 조회
    * @return sysVoltage
    */
    public Float getSysVoltage() {
        return this.sysVoltage;
    }
   /**
    * 출력전압(단위:v) 설정
    * @return sysVoltage
    */
    public void setSysVoltage(Float sysVoltage) {
        this.sysVoltage = sysVoltage;
    }
   /**
    * 출력전류(단위:a) 조회
    * @return sysCurrent
    */
    public Float getSysCurrent() {
        return this.sysCurrent;
    }
   /**
    * 출력전류(단위:a) 설정
    * @return sysCurrent
    */
    public void setSysCurrent(Float sysCurrent) {
        this.sysCurrent = sysCurrent;
    }
   /**
    * dod(단위:%) 조회
    * @return dod
    */
    public Float getDod() {
        return this.dod;
    }
   /**
    * dod(단위:%) 설정
    * @return dod
    */
    public void setDod(Float dod) {
        this.dod = dod;
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