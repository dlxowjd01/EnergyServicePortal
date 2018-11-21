package kr.co.ewp.api.entity;

import java.util.Date;

/**
 * IOE장치 Class
 */
public class DeviceIoe {
  private Long deviceIoeIdx;// ioe장치식별자
  private String siteId;// 사이트id
  private String deviceId;// 장치id
  private String deviceName;// 장치명
  private String deviceRegId;// 장치등록id(uuid)
  private String serialNo;// 시리얼번호
  private String instType;// 설치구분(1:single-phase two-wires,2:single-phase three-wires,3:poly-phase three-wires,4:poly-phase four-wires,5:multi-channel,6:modem,7:plug,8:virtual device)
  private String instPurpose;// 설치목적(1:site consumption,2:appliance consumption,3:site generation,4:standalone consumption)
  private Integer dataPeriod;// 데이터업로드주기(단위:초)
  private Integer dataCnt;// 데이터업로드개수(단위:hz)
  private Integer ctCapacity;// ct용량합계(단위:a)
  private String ctCapacityList;// ct용량리스트(여러개인 경우 콤마로 구분)
  private Integer pwCapacity;// 전력용량(단위:w)
  private Integer chCnt;// 채널수
  private String chPurpose;// 채널목적(여러개인 경우 콤마로 구분)
  private String provider;// 장치공급자
  private String vrDeviceId;// 가상장치id
  private String vrDeviceGrpId;// 가상장치그룹id
  private String vrOwnerId;// 가상장치소유자id
  private String vrAction;// 가상장치액션
  private String vrStat;// 가상장치상태
  private Date vrModDate;// 가상장치업데이트일시
  private String vrError;// 가상장치에러(json형태)
  private Integer tmVoltage;// targetmeter 전압(단위:mv)
  private Integer tmPulse;// targetmeter 펄스(단위:pulse/kwh)
  private Integer tmCtRatio;// targetmeter current transformation ratio
  private Integer tmPtTatio;// targetmeter power transformation ratio
  private String networkConf;// 채널목적(json형태)
  private String options;// 사용자정의데이터
  private Date createTimestamp;// 생성타임스탬프
  private Date createDate;// 생성일시
  private Date uploadTimestamp;// 업로드타임스탬프
  private Date uploadDate;// 업로드일시
  private String deviceStat;// 장치상태(1:connect,2:disconnect)
  private Date regDate;// 등록일시

  /**
   * ioe장치식별자 조회
   * 
   * @return deviceIoeIdx
   */
  public Long getDeviceIoeIdx() {
    return this.deviceIoeIdx;
  }

  /**
   * ioe장치식별자 설정
   * 
   * @return deviceIoeIdx
   */
  public void setDeviceIoeIdx(Long deviceIoeIdx) {
    this.deviceIoeIdx = deviceIoeIdx;
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
   * 장치등록id(uuid) 조회
   * 
   * @return deviceRegId
   */
  public String getDeviceRegId() {
    return this.deviceRegId;
  }

  /**
   * 장치등록id(uuid) 설정
   * 
   * @return deviceRegId
   */
  public void setDeviceRegId(String deviceRegId) {
    this.deviceRegId = deviceRegId;
  }

  /**
   * 시리얼번호 조회
   * 
   * @return serialNo
   */
  public String getSerialNo() {
    return this.serialNo;
  }

  /**
   * 시리얼번호 설정
   * 
   * @return serialNo
   */
  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  /**
   * 설치구분(1:single-phase two-wires,2:single-phase three-wires,3:poly-phase three-wires,4:poly-phase four-wires,5:multi-channel,6:modem,7:plug,8:virtual device) 조회
   * 
   * @return instType
   */
  public String getInstType() {
    return this.instType;
  }

  /**
   * 설치구분(1:single-phase two-wires,2:single-phase three-wires,3:poly-phase three-wires,4:poly-phase four-wires,5:multi-channel,6:modem,7:plug,8:virtual device) 설정
   * 
   * @return instType
   */
  public void setInstType(String instType) {
    this.instType = instType;
  }

  /**
   * 설치목적(1:site consumption,2:appliance consumption,3:site generation,4:standalone consumption) 조회
   * 
   * @return instPurpose
   */
  public String getInstPurpose() {
    return this.instPurpose;
  }

  /**
   * 설치목적(1:site consumption,2:appliance consumption,3:site generation,4:standalone consumption) 설정
   * 
   * @return instPurpose
   */
  public void setInstPurpose(String instPurpose) {
    this.instPurpose = instPurpose;
  }

  /**
   * 데이터업로드주기(단위:초) 조회
   * 
   * @return dataPeriod
   */
  public Integer getDataPeriod() {
    return this.dataPeriod;
  }

  /**
   * 데이터업로드주기(단위:초) 설정
   * 
   * @return dataPeriod
   */
  public void setDataPeriod(Integer dataPeriod) {
    this.dataPeriod = dataPeriod;
  }

  /**
   * 데이터업로드개수(단위:hz) 조회
   * 
   * @return dataCnt
   */
  public Integer getDataCnt() {
    return this.dataCnt;
  }

  /**
   * 데이터업로드개수(단위:hz) 설정
   * 
   * @return dataCnt
   */
  public void setDataCnt(Integer dataCnt) {
    this.dataCnt = dataCnt;
  }

  /**
   * ct용량합계(단위:a) 조회
   * 
   * @return ctCapacity
   */
  public Integer getCtCapacity() {
    return this.ctCapacity;
  }

  /**
   * ct용량합계(단위:a) 설정
   * 
   * @return ctCapacity
   */
  public void setCtCapacity(Integer ctCapacity) {
    this.ctCapacity = ctCapacity;
  }

  /**
   * ct용량리스트(여러개인 경우 콤마로 구분) 조회
   * 
   * @return ctCapacityList
   */
  public String getCtCapacityList() {
    return this.ctCapacityList;
  }

  /**
   * ct용량리스트(여러개인 경우 콤마로 구분) 설정
   * 
   * @return ctCapacityList
   */
  public void setCtCapacityList(String ctCapacityList) {
    this.ctCapacityList = ctCapacityList;
  }

  /**
   * 전력용량(단위:w) 조회
   * 
   * @return pwCapacity
   */
  public Integer getPwCapacity() {
    return this.pwCapacity;
  }

  /**
   * 전력용량(단위:w) 설정
   * 
   * @return pwCapacity
   */
  public void setPwCapacity(Integer pwCapacity) {
    this.pwCapacity = pwCapacity;
  }

  /**
   * 채널수 조회
   * 
   * @return chCnt
   */
  public Integer getChCnt() {
    return this.chCnt;
  }

  /**
   * 채널수 설정
   * 
   * @return chCnt
   */
  public void setChCnt(Integer chCnt) {
    this.chCnt = chCnt;
  }

  /**
   * 채널목적(여러개인 경우 콤마로 구분) 조회
   * 
   * @return chPurpose
   */
  public String getChPurpose() {
    return this.chPurpose;
  }

  /**
   * 채널목적(여러개인 경우 콤마로 구분) 설정
   * 
   * @return chPurpose
   */
  public void setChPurpose(String chPurpose) {
    this.chPurpose = chPurpose;
  }

  /**
   * 장치공급자 조회
   * 
   * @return provider
   */
  public String getProvider() {
    return this.provider;
  }

  /**
   * 장치공급자 설정
   * 
   * @return provider
   */
  public void setProvider(String provider) {
    this.provider = provider;
  }

  /**
   * 가상장치id 조회
   * 
   * @return vrDeviceId
   */
  public String getVrDeviceId() {
    return this.vrDeviceId;
  }

  /**
   * 가상장치id 설정
   * 
   * @return vrDeviceId
   */
  public void setVrDeviceId(String vrDeviceId) {
    this.vrDeviceId = vrDeviceId;
  }

  /**
   * 가상장치그룹id 조회
   * 
   * @return vrDeviceGrpId
   */
  public String getVrDeviceGrpId() {
    return this.vrDeviceGrpId;
  }

  /**
   * 가상장치그룹id 설정
   * 
   * @return vrDeviceGrpId
   */
  public void setVrDeviceGrpId(String vrDeviceGrpId) {
    this.vrDeviceGrpId = vrDeviceGrpId;
  }

  /**
   * 가상장치소유자id 조회
   * 
   * @return vrOwnerId
   */
  public String getVrOwnerId() {
    return this.vrOwnerId;
  }

  /**
   * 가상장치소유자id 설정
   * 
   * @return vrOwnerId
   */
  public void setVrOwnerId(String vrOwnerId) {
    this.vrOwnerId = vrOwnerId;
  }

  /**
   * 가상장치액션 조회
   * 
   * @return vrAction
   */
  public String getVrAction() {
    return this.vrAction;
  }

  /**
   * 가상장치액션 설정
   * 
   * @return vrAction
   */
  public void setVrAction(String vrAction) {
    this.vrAction = vrAction;
  }

  /**
   * 가상장치상태 조회
   * 
   * @return vrStat
   */
  public String getVrStat() {
    return this.vrStat;
  }

  /**
   * 가상장치상태 설정
   * 
   * @return vrStat
   */
  public void setVrStat(String vrStat) {
    this.vrStat = vrStat;
  }

  /**
   * 가상장치업데이트일시 조회
   * 
   * @return vrModDate
   */
  public Date getVrModDate() {
    return this.vrModDate;
  }

  /**
   * 가상장치업데이트일시 설정
   * 
   * @return vrModDate
   */
  public void setVrModDate(Date vrModDate) {
    this.vrModDate = vrModDate;
  }

  /**
   * 가상장치에러(json형태) 조회
   * 
   * @return vrError
   */
  public String getVrError() {
    return this.vrError;
  }

  /**
   * 가상장치에러(json형태) 설정
   * 
   * @return vrError
   */
  public void setVrError(String vrError) {
    this.vrError = vrError;
  }

  /**
   * targetmeter 전압(단위:mv) 조회
   * 
   * @return tmVoltage
   */
  public Integer getTmVoltage() {
    return this.tmVoltage;
  }

  /**
   * targetmeter 전압(단위:mv) 설정
   * 
   * @return tmVoltage
   */
  public void setTmVoltage(Integer tmVoltage) {
    this.tmVoltage = tmVoltage;
  }

  /**
   * targetmeter 펄스(단위:pulse/kwh) 조회
   * 
   * @return tmPulse
   */
  public Integer getTmPulse() {
    return this.tmPulse;
  }

  /**
   * targetmeter 펄스(단위:pulse/kwh) 설정
   * 
   * @return tmPulse
   */
  public void setTmPulse(Integer tmPulse) {
    this.tmPulse = tmPulse;
  }

  /**
   * targetmeter current transformation ratio 조회
   * 
   * @return tmCtRatio
   */
  public Integer getTmCtRatio() {
    return this.tmCtRatio;
  }

  /**
   * targetmeter current transformation ratio 설정
   * 
   * @return tmCtRatio
   */
  public void setTmCtRatio(Integer tmCtRatio) {
    this.tmCtRatio = tmCtRatio;
  }

  /**
   * targetmeter power transformation ratio 조회
   * 
   * @return tmPtTatio
   */
  public Integer getTmPtTatio() {
    return this.tmPtTatio;
  }

  /**
   * targetmeter power transformation ratio 설정
   * 
   * @return tmPtTatio
   */
  public void setTmPtTatio(Integer tmPtTatio) {
    this.tmPtTatio = tmPtTatio;
  }

  /**
   * 채널목적(json형태) 조회
   * 
   * @return networkConf
   */
  public String getNetworkConf() {
    return this.networkConf;
  }

  /**
   * 채널목적(json형태) 설정
   * 
   * @return networkConf
   */
  public void setNetworkConf(String networkConf) {
    this.networkConf = networkConf;
  }

  /**
   * 사용자정의데이터 조회
   * 
   * @return options
   */
  public String getOptions() {
    return this.options;
  }

  /**
   * 사용자정의데이터 설정
   * 
   * @return options
   */
  public void setOptions(String options) {
    this.options = options;
  }

  /**
   * 생성타임스탬프 조회
   * 
   * @return createTimestamp
   */
  public Date getCreateTimestamp() {
    return this.createTimestamp;
  }

  /**
   * 생성타임스탬프 설정
   * 
   * @return createTimestamp
   */
  public void setCreateTimestamp(Date createTimestamp) {
    this.createTimestamp = createTimestamp;
  }

  /**
   * 생성일시 조회
   * 
   * @return createDate
   */
  public Date getCreateDate() {
    return this.createDate;
  }

  /**
   * 생성일시 설정
   * 
   * @return createDate
   */
  public void setCreateDate(Date createDate) {
    this.createDate = createDate;
  }

  /**
   * 업로드타임스탬프 조회
   * 
   * @return uploadTimestamp
   */
  public Date getUploadTimestamp() {
    return this.uploadTimestamp;
  }

  /**
   * 업로드타임스탬프 설정
   * 
   * @return uploadTimestamp
   */
  public void setUploadTimestamp(Date uploadTimestamp) {
    this.uploadTimestamp = uploadTimestamp;
  }

  /**
   * 업로드일시 조회
   * 
   * @return uploadDate
   */
  public Date getUploadDate() {
    return this.uploadDate;
  }

  /**
   * 업로드일시 설정
   * 
   * @return uploadDate
   */
  public void setUploadDate(Date uploadDate) {
    this.uploadDate = uploadDate;
  }

  /**
   * 장치상태(1:connect,2:disconnect) 조회
   * 
   * @return deviceStat
   */
  public String getDeviceStat() {
    return this.deviceStat;
  }

  /**
   * 장치상태(1:connect,2:disconnect) 설정
   * 
   * @return deviceStat
   */
  public void setDeviceStat(String deviceStat) {
    this.deviceStat = deviceStat;
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