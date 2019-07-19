package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * AMI장치 Class
 */
public class DeviceAmi {
  private Long deviceAmiIdx; // ami장치식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private String deviceName;// 장치명
  private Integer deviceStat;// 운전상태
  private String alarmMsg;// 알람메시지
  private Float voltageR; // (V)
  private Float voltageS; // (V)
  private Float voltageT; // (V)
  private Float currentR; // (A)
  private Float currentS; // (A)
  private Float currentT; // (A)
  private Float frequency; // (Hz)
  private Float accumActvPwrR; // 총 누적 유효전력량 R상 (Wh)
  private Float accumActvPwrS; // (Wh)
  private Float accumActvPwrT; // (Wh)
  private Float accumRctvPwrLaggingR; // 총 누적 무효전력량 지상 R상 (Varh)
  private Float accumRctvPwrLaggingS; // (Varh)
  private Float accumRctvPwrLaggingT; // (Varh)
  private Float accumRctvPwrLeadingR; // 총 누적 무효전력량 진상 R상 (Varh)
  private Float accumRctvPwrLeadingS; // (Varh)
  private Float accumRctvPwrLeadingT; // (Varh)
  private Date stdDate;// 기준일시
  private Date regDate;// 등록일시

  public Long getDeviceAmiIdx() {
    return deviceAmiIdx;
  }

  public void setDeviceAmiIdx(Long deviceAmiIdx) {
    this.deviceAmiIdx = deviceAmiIdx;
  }

  public String getSiteId() {
    return siteId;
  }

  public void setSiteId(String siteId) {
    this.siteId = siteId;
  }

  public String getDeviceId() {
    return deviceId;
  }

  public void setDeviceId(String deviceId) {
    this.deviceId = deviceId;
  }

  public String getDeviceName() {
    return deviceName;
  }

  public void setDeviceName(String deviceName) {
    this.deviceName = deviceName;
  }

  public Integer getDeviceStat() {
    return deviceStat;
  }

  public void setDeviceStat(Integer deviceStat) {
    this.deviceStat = deviceStat;
  }

  public String getAlarmMsg() {
    return alarmMsg;
  }

  public void setAlarmMsg(String alarmMsg) {
    this.alarmMsg = alarmMsg;
  }

  public Float getVoltageR() {
    return voltageR;
  }

  public void setVoltageR(Float voltageR) {
    this.voltageR = voltageR;
  }

  public Float getVoltageS() {
    return voltageS;
  }

  public void setVoltageS(Float voltageS) {
    this.voltageS = voltageS;
  }

  public Float getVoltageT() {
    return voltageT;
  }

  public void setVoltageT(Float voltageT) {
    this.voltageT = voltageT;
  }

  public Float getCurrentR() {
    return currentR;
  }

  public void setCurrentR(Float currentR) {
    this.currentR = currentR;
  }

  public Float getCurrentS() {
    return currentS;
  }

  public void setCurrentS(Float currentS) {
    this.currentS = currentS;
  }

  public Float getCurrentT() {
    return currentT;
  }

  public void setCurrentT(Float currentT) {
    this.currentT = currentT;
  }

  public Float getFrequency() {
    return frequency;
  }

  public void setFrequency(Float frequency) {
    this.frequency = frequency;
  }

  public Float getAccumActvPwrR() {
    return accumActvPwrR;
  }

  public void setAccumActvPwrR(Float accumActvPwrR) {
    this.accumActvPwrR = accumActvPwrR;
  }

  public Float getAccumActvPwrS() {
    return accumActvPwrS;
  }

  public void setAccumActvPwrS(Float accumActvPwrS) {
    this.accumActvPwrS = accumActvPwrS;
  }

  public Float getAccumActvPwrT() {
    return accumActvPwrT;
  }

  public void setAccumActvPwrT(Float accumActvPwrT) {
    this.accumActvPwrT = accumActvPwrT;
  }

  public Float getAccumRctvPwrLaggingR() {
    return accumRctvPwrLaggingR;
  }

  public void setAccumRctvPwrLaggingR(Float accumRctvPwrLaggingR) {
    this.accumRctvPwrLaggingR = accumRctvPwrLaggingR;
  }

  public Float getAccumRctvPwrLaggingS() {
    return accumRctvPwrLaggingS;
  }

  public void setAccumRctvPwrLaggingS(Float accumRctvPwrLaggingS) {
    this.accumRctvPwrLaggingS = accumRctvPwrLaggingS;
  }

  public Float getAccumRctvPwrLaggingT() {
    return accumRctvPwrLaggingT;
  }

  public void setAccumRctvPwrLaggingT(Float accumRctvPwrLaggingT) {
    this.accumRctvPwrLaggingT = accumRctvPwrLaggingT;
  }

  public Float getAccumRctvPwrLeadingR() {
    return accumRctvPwrLeadingR;
  }

  public void setAccumRctvPwrLeadingR(Float accumRctvPwrLeadingR) {
    this.accumRctvPwrLeadingR = accumRctvPwrLeadingR;
  }

  public Float getAccumRctvPwrLeadingS() {
    return accumRctvPwrLeadingS;
  }

  public void setAccumRctvPwrLeadingS(Float accumRctvPwrLeadingS) {
    this.accumRctvPwrLeadingS = accumRctvPwrLeadingS;
  }

  public Float getAccumRctvPwrLeadingT() {
    return accumRctvPwrLeadingT;
  }

  public void setAccumRctvPwrLeadingT(Float accumRctvPwrLeadingT) {
    this.accumRctvPwrLeadingT = accumRctvPwrLeadingT;
  }

  public Date getStdDate() {
    return stdDate;
  }

  public void setStdDate(Date stdDate) {
    this.stdDate = stdDate;
  }

  public Date getRegDate() {
    return regDate;
  }

  public void setRegDate(Date regDate) {
    this.regDate = regDate;
  }

  @Override
  public String toString() {
    return "DeviceAmi{" +
            "deviceAmiIdx=" + deviceAmiIdx +
            ", siteId='" + siteId + '\'' +
            ", deviceId='" + deviceId + '\'' +
            ", deviceName='" + deviceName + '\'' +
            ", deviceStat='" + deviceStat + '\'' +
            ", alarmMsg='" + alarmMsg + '\'' +
            ", voltageR=" + voltageR +
            ", voltageS=" + voltageS +
            ", voltageT=" + voltageT +
            ", currentR=" + currentR +
            ", currentS=" + currentS +
            ", currentT=" + currentT +
            ", frequency=" + frequency +
            ", accumActvPwrR=" + accumActvPwrR +
            ", accumActvPwrS=" + accumActvPwrS +
            ", accumActvPwrT=" + accumActvPwrT +
            ", accumRctvPwrLaggingR=" + accumRctvPwrLaggingR +
            ", accumRctvPwrLaggingS=" + accumRctvPwrLaggingS +
            ", accumRctvPwrLaggingT=" + accumRctvPwrLaggingT +
            ", accumRctvPwrLeadingR=" + accumRctvPwrLeadingR +
            ", accumRctvPwrLeadingS=" + accumRctvPwrLeadingS +
            ", accumRctvPwrLeadingT=" + accumRctvPwrLeadingT +
            ", stdDate=" + stdDate +
            ", regDate=" + regDate +
            '}';
  }
}