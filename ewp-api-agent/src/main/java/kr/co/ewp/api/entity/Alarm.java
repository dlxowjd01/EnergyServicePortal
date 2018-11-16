package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 알람  Class
 */
public class Alarm {
    private Long alarmIdx;//알람식별자
    private String siteId;//사이트id
    private String deviceId;//장치id
    private String deviceType;//장치구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv)
    private String stdTimestamp;//기준타임스탬프
    private Date stdDate;//기준일시
    private String alarmType;//알람구분(1:비상,2:주의)
    private String alarmCfmYn;//알람확인여부(y:예,n:아니오)
    private Date alarmCfmDate;//알람확인일시
    private String alarmCfmUid;//알람확인자id
    private String alarmNote;//알람조치내역
    private Date regDate;//등록일시
   /**
    * 알람식별자 조회
    * @return alarmIdx
    */
    public Long getAlarmIdx() {
        return this.alarmIdx;
    }
   /**
    * 알람식별자 설정
    * @return alarmIdx
    */
    public void setAlarmIdx(Long alarmIdx) {
        this.alarmIdx = alarmIdx;
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
    * 장치구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv) 조회
    * @return deviceType
    */
    public String getDeviceType() {
        return this.deviceType;
    }
   /**
    * 장치구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv) 설정
    * @return deviceType
    */
    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
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
    * 알람구분(1:비상,2:주의) 조회
    * @return alarmType
    */
    public String getAlarmType() {
        return this.alarmType;
    }
   /**
    * 알람구분(1:비상,2:주의) 설정
    * @return alarmType
    */
    public void setAlarmType(String alarmType) {
        this.alarmType = alarmType;
    }
   /**
    * 알람확인여부(y:예,n:아니오) 조회
    * @return alarmCfmYn
    */
    public String getAlarmCfmYn() {
        return this.alarmCfmYn;
    }
   /**
    * 알람확인여부(y:예,n:아니오) 설정
    * @return alarmCfmYn
    */
    public void setAlarmCfmYn(String alarmCfmYn) {
        this.alarmCfmYn = alarmCfmYn;
    }
   /**
    * 알람확인일시 조회
    * @return alarmCfmDate
    */
    public Date getAlarmCfmDate() {
        return this.alarmCfmDate;
    }
   /**
    * 알람확인일시 설정
    * @return alarmCfmDate
    */
    public void setAlarmCfmDate(Date alarmCfmDate) {
        this.alarmCfmDate = alarmCfmDate;
    }
   /**
    * 알람확인자id 조회
    * @return alarmCfmUid
    */
    public String getAlarmCfmUid() {
        return this.alarmCfmUid;
    }
   /**
    * 알람확인자id 설정
    * @return alarmCfmUid
    */
    public void setAlarmCfmUid(String alarmCfmUid) {
        this.alarmCfmUid = alarmCfmUid;
    }
   /**
    * 알람조치내역 조회
    * @return alarmNote
    */
    public String getAlarmNote() {
        return this.alarmNote;
    }
   /**
    * 알람조치내역 설정
    * @return alarmNote
    */
    public void setAlarmNote(String alarmNote) {
        this.alarmNote = alarmNote;
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