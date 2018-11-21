package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 장치  Class
 */
public class Device {
    private String deviceId;//장치id
    private String siteId;//사이트id
    private Integer userIdx;//사용자식별자
    private String deviceName;//장치명
    private Integer deviceGrpIdx;//장치그룹식별자
    private String deviceType;//장치출처구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv)
    private String instType;//설치구분(1:에너톡,2:로컬ems)
    private String delYn;//삭제여부(y:예,n:아니오)
    private String regUid;//등록자id
    private Date regDate;//등록일시
    private String modUid;//최종수정자id
    private Date modDate;//최종수정일시
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
    * 사용자식별자 조회
    * @return userIdx
    */
    public Integer getUserIdx() {
        return this.userIdx;
    }
   /**
    * 사용자식별자 설정
    * @return userIdx
    */
    public void setUserIdx(Integer userIdx) {
        this.userIdx = userIdx;
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
    * 장치그룹식별자 조회
    * @return deviceGrpIdx
    */
    public Integer getDeviceGrpIdx() {
        return this.deviceGrpIdx;
    }
   /**
    * 장치그룹식별자 설정
    * @return deviceGrpIdx
    */
    public void setDeviceGrpIdx(Integer deviceGrpIdx) {
        this.deviceGrpIdx = deviceGrpIdx;
    }
   /**
    * 장치출처구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv) 조회
    * @return deviceType
    */
    public String getDeviceType() {
        return this.deviceType;
    }
   /**
    * 장치출처구분(1:부하측정기기,2:pv모니터링기기,3:ess모니터링기기,4:pcs,5:bms,6:pv) 설정
    * @return deviceType
    */
    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }
   /**
    * 설치구분(1:에너톡,2:로컬ems) 조회
    * @return instType
    */
    public String getInstType() {
        return this.instType;
    }
   /**
    * 설치구분(1:에너톡,2:로컬ems) 설정
    * @return instType
    */
    public void setInstType(String instType) {
        this.instType = instType;
    }
   /**
    * 삭제여부(y:예,n:아니오) 조회
    * @return delYn
    */
    public String getDelYn() {
        return this.delYn;
    }
   /**
    * 삭제여부(y:예,n:아니오) 설정
    * @return delYn
    */
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
   /**
    * 등록자id 조회
    * @return regUid
    */
    public String getRegUid() {
        return this.regUid;
    }
   /**
    * 등록자id 설정
    * @return regUid
    */
    public void setRegUid(String regUid) {
        this.regUid = regUid;
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
    * 최종수정자id 조회
    * @return modUid
    */
    public String getModUid() {
        return this.modUid;
    }
   /**
    * 최종수정자id 설정
    * @return modUid
    */
    public void setModUid(String modUid) {
        this.modUid = modUid;
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