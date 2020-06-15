package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * PCS장치 Class
 */
public class DevicePcs {
  private Long devicePcsIdx;// pcs장치식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private String deviceName;// 장치명
  private String deviceStat;// 운전상태
  private String alarmMsg;// 알람메시지
  private Float acVoltage;// ac출력 - 전압(단위:v)
  private Float acPower;// ac출력 - 전력(단위:kWh -> W)
  private Float acCurrent;// ac출력 - 전류(단위:a)
  private Float acFreq;// ac출력 - 주파수(단위:hz)
  private Float acSetPower;// ac출력 - 전력설정치(단위:kWh -> W)
  private Float acPf;// ac출력 - 역률
  private Float dcVoltage;// dc출력 - 전압(단위:v)
  private Float dcPower;// dc출력 - 전력(단위:kWh -> W)
  private Float dcCurrent;// dc출력 - 전류(단위:a)
  private Float dcFreq;// dc출력 - 주파수(단위:hz)
  private Float dcSetPower;// dc출력 - 전력설정치(단위:kWh -> W)
  private Float dcPf;// dc출력 - 역률
  private Date stdDate;// 기준일시
  private Date regDate;// 등록일시

  private String pcsStatus;// 0:OFF, 1:ON, 2:Fault, 3:Warning
  private String remoteMode;// 0:Local, 1:Remote
  private String pcsCommand;// 0:Stop, 1:Run
  private String todayDEnergy;// (Wh)
  private String todayCEnergy;// (Wh)
  private String totalDEnergy;// (Wh)
  private String totalCEnerge;// (Wh)

  public String getPcsStatus() {
    return pcsStatus;
  }

  public void setPcsStatus(String pcsStatus) {
    this.pcsStatus = pcsStatus;
  }

  public String getRemoteMode() {
    return remoteMode;
  }

  public void setRemoteMode(String remoteMode) {
    this.remoteMode = remoteMode;
  }

  public String getPcsCommand() {
    return pcsCommand;
  }

  public void setPcsCommand(String pcsCommand) {
    this.pcsCommand = pcsCommand;
  }

  public String getTodayDEnergy() {
    return todayDEnergy;
  }

  public void setTodayDEnergy(String todayDEnergy) {
    this.todayDEnergy = todayDEnergy;
  }

  public String getTodayCEnergy() {
    return todayCEnergy;
  }

  public void setTodayCEnergy(String todayCEnergy) {
    this.todayCEnergy = todayCEnergy;
  }

  public String getTotalDEnergy() {
    return totalDEnergy;
  }

  public void setTotalDEnergy(String totalDEnergy) {
    this.totalDEnergy = totalDEnergy;
  }

  public String getTotalCEnerge() {
    return totalCEnerge;
  }

  public void setTotalCEnerge(String totalCEnerge) {
    this.totalCEnerge = totalCEnerge;
  }

  /**
   * pcs장치식별자 조회
   * 
   * @return devicePcsIdx
   */
  public Long getDevicePcsIdx() {
    return this.devicePcsIdx;
  }

  /**
   * pcs장치식별자 설정
   * 
   * @return devicePcsIdx
   */
  public void setDevicePcsIdx(Long devicePcsIdx) {
    this.devicePcsIdx = devicePcsIdx;
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
   * 장치id 조회
   * 
   * @return deviceId
   */
  public String getDeviceId() {
    return this.deviceId;
  }

  /**
   * 장치id 설정
   * 
   * @return deviceId
   */
  public void setDeviceId(String deviceId) {
    this.deviceId = deviceId;
  }

  /**
   * 장치명 조회
   * 
   * @return deviceName
   */
  public String getDeviceName() {
    return this.deviceName;
  }

  /**
   * 장치명 설정
   * 
   * @return deviceName
   */
  public void setDeviceName(String deviceName) {
    this.deviceName = deviceName;
  }

  /**
   * 운전상태 조회
   * 
   * @return deviceStat
   */
  public String getDeviceStat() {
    return this.deviceStat;
  }

  /**
   * 운전상태 설정
   * 
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
   * ac출력 - 전압(단위:v) 조회
   * 
   * @return acVoltage
   */
  public Float getAcVoltage() {
    return this.acVoltage;
  }

  /**
   * ac출력 - 전압(단위:v) 설정
   * 
   * @return acVoltage
   */
  public void setAcVoltage(Float acVoltage) {
    this.acVoltage = acVoltage;
  }

  /**
   * ac출력 - 전력(단위:kWh -> Wh) 조회
   * 
   * @return acPower
   */
  public Float getAcPower() {
    return this.acPower;
  }

  /**
   * ac출력 - 전력(단위:kWh -> Wh) 설정
   * 
   * @return acPower
   */
  public void setAcPower(Float acPower) {
    this.acPower = acPower;
  }

  /**
   * ac출력 - 전류(단위:a) 조회
   * 
   * @return acCurrent
   */
  public Float getAcCurrent() {
    return this.acCurrent;
  }

  /**
   * ac출력 - 전류(단위:a) 설정
   * 
   * @return acCurrent
   */
  public void setAcCurrent(Float acCurrent) {
    this.acCurrent = acCurrent;
  }

  /**
   * ac출력 - 주파수(단위:hz) 조회
   * 
   * @return acFreq
   */
  public Float getAcFreq() {
    return this.acFreq;
  }

  /**
   * ac출력 - 주파수(단위:hz) 설정
   * 
   * @return acFreq
   */
  public void setAcFreq(Float acFreq) {
    this.acFreq = acFreq;
  }

  /**
   * ac출력 - 전력설정치(단위:kWh -> Wh) 조회
   * 
   * @return acSetPower
   */
  public Float getAcSetPower() {
    return this.acSetPower;
  }

  /**
   * ac출력 - 전력설정치(단위:kWh -> Wh) 설정
   * 
   * @return acSetPower
   */
  public void setAcSetPower(Float acSetPower) {
    this.acSetPower = acSetPower;
  }

  /**
   * ac출력 - 역률 조회
   * 
   * @return acPf
   */
  public Float getAcPf() {
    return this.acPf;
  }

  /**
   * ac출력 - 역률 설정
   * 
   * @return acPf
   */
  public void setAcPf(Float acPf) {
    this.acPf = acPf;
  }

  /**
   * dc출력 - 전압(단위:v) 조회
   * 
   * @return dcVoltage
   */
  public Float getDcVoltage() {
    return this.dcVoltage;
  }

  /**
   * dc출력 - 전압(단위:v) 설정
   * 
   * @return dcVoltage
   */
  public void setDcVoltage(Float dcVoltage) {
    this.dcVoltage = dcVoltage;
  }

  /**
   * dc출력 - 전력(단위:kWh -> Wh) 조회
   * 
   * @return dcPower
   */
  public Float getDcPower() {
    return this.dcPower;
  }

  /**
   * dc출력 - 전력(단위:kWh -> Wh) 설정
   * 
   * @return dcPower
   */
  public void setDcPower(Float dcPower) {
    this.dcPower = dcPower;
  }

  /**
   * dc출력 - 전류(단위:a) 조회
   * 
   * @return dcCurrent
   */
  public Float getDcCurrent() {
    return this.dcCurrent;
  }

  /**
   * dc출력 - 전류(단위:a) 설정
   * 
   * @return dcCurrent
   */
  public void setDcCurrent(Float dcCurrent) {
    this.dcCurrent = dcCurrent;
  }

  /**
   * dc출력 - 주파수(단위:hz) 조회
   * 
   * @return dcFreq
   */
  public Float getDcFreq() {
    return this.dcFreq;
  }

  /**
   * dc출력 - 주파수(단위:hz) 설정
   * 
   * @return dcFreq
   */
  public void setDcFreq(Float dcFreq) {
    this.dcFreq = dcFreq;
  }

  /**
   * dc출력 - 전력설정치(단위:kWh -> Wh) 조회
   * 
   * @return dcSetPower
   */
  public Float getDcSetPower() {
    return this.dcSetPower;
  }

  /**
   * dc출력 - 전력설정치(단위:kWh -> Wh) 설정
   * 
   * @return dcSetPower
   */
  public void setDcSetPower(Float dcSetPower) {
    this.dcSetPower = dcSetPower;
  }

  /**
   * dc출력 - 역률 조회
   * 
   * @return dcPf
   */
  public Float getDcPf() {
    return this.dcPf;
  }

  /**
   * dc출력 - 역률 설정
   * 
   * @return dcPf
   */
  public void setDcPf(Float dcPf) {
    this.dcPf = dcPf;
  }

  /**
   * 기준일시 조회
   * 
   * @return stdDate
   */
  public Date getStdDate() {
    return this.stdDate;
  }

  /**
   * 기준일시 설정
   * 
   * @return stdDate
   */
  public void setStdDate(Date stdDate) {
    this.stdDate = stdDate;
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
}