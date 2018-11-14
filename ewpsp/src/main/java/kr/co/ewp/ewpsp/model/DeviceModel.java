package kr.co.ewp.ewpsp.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DeviceModel {
  private String id;
  private String siteId;
  private String serialNumber;
  private String name;
  private String registrationId;
  private Integer installType;
  private Integer installPurpose;
  private Integer dataPeriod;
  private Integer dataCount;
  private Integer ctCapacity;
  private List<Integer> ctCapacities;
  private Integer powerCapacity;
  private Integer channelCount;
  private List<Integer> channelPurposes;
  private String provider;
  private VirtualDeviceModel virtualDevice;
  private TargetMeterModel targetMeter;
  private NetworkConfigModel networkConfig;
  private String options;
  private Date createdAt;
  private Date uploadedAt;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getSiteId() {
    return siteId;
  }

  public void setSiteId(String siteId) {
    this.siteId = siteId;
  }

  public String getSerialNumber() {
    return serialNumber;
  }

  public void setSerialNumber(String serialNumber) {
    this.serialNumber = serialNumber;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getRegistrationId() {
    return registrationId;
  }

  public void setRegistrationId(String registrationId) {
    this.registrationId = registrationId;
  }

  public Integer getInstallType() {
    return installType;
  }

  public void setInstallType(Integer installType) {
    this.installType = installType;
  }

  public Integer getInstallPurpose() {
    return installPurpose;
  }

  public void setInstallPurpose(Integer installPurpose) {
    this.installPurpose = installPurpose;
  }

  public Integer getDataPeriod() {
    return dataPeriod;
  }

  public void setDataPeriod(Integer dataPeriod) {
    this.dataPeriod = dataPeriod;
  }

  public Integer getDataCount() {
    return dataCount;
  }

  public void setDataCount(Integer dataCount) {
    this.dataCount = dataCount;
  }

  public List<Integer> getCtCapacities() {
    return ctCapacities;
  }

  public void setCtCapacities(List<Integer> ctCapacities) {
    this.ctCapacities = ctCapacities;
  }

  public Integer getPowerCapacity() {
    return powerCapacity;
  }

  public void setPowerCapacity(Integer powerCapacity) {
    this.powerCapacity = powerCapacity;
  }

  public Integer getChannelCount() {
    return channelCount;
  }

  public void setChannelCount(Integer channelCount) {
    this.channelCount = channelCount;
  }

  public List<Integer> getChannelPurposes() {
    return channelPurposes;
  }

  public void setChannelPurposes(List<Integer> channelPurposes) {
    this.channelPurposes = channelPurposes;
  }

  public String getProvider() {
    return provider;
  }

  public void setProvider(String provider) {
    this.provider = provider;
  }

  public VirtualDeviceModel getVirtualDevice() {
    return virtualDevice;
  }

  public void setVirtualDevice(VirtualDeviceModel virtualDevice) {
    this.virtualDevice = virtualDevice;
  }

  public TargetMeterModel getTargetMeter() {
    return targetMeter;
  }

  public void setTargetMeter(TargetMeterModel targetMeter) {
    this.targetMeter = targetMeter;
  }

  public NetworkConfigModel getNetworkConfig() {
    return networkConfig;
  }

  public void setNetworkConfig(NetworkConfigModel networkConfig) {
    this.networkConfig = networkConfig;
  }

  public String getOptions() {
    return options;
  }

  public void setOptions(String options) {
    this.options = options;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public Date getUploadedAt() {
    return uploadedAt;
  }

  public void setUploadedAt(Date uploadedAt) {
    this.uploadedAt = uploadedAt;
  }

  public Integer getCtCapacity() {
    return ctCapacity;
  }

  public void setCtCapacity(Integer ctCapacity) {
    this.ctCapacity = ctCapacity;
  }
}
