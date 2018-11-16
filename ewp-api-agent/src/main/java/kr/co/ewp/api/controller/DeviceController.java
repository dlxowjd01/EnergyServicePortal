package kr.co.ewp.api.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import kr.co.ewp.api.entity.Device;
import kr.co.ewp.api.entity.DeviceBms;
import kr.co.ewp.api.entity.DeviceIoe;
import kr.co.ewp.api.entity.DevicePcs;
import kr.co.ewp.api.entity.DevicePv;
import kr.co.ewp.api.entity.Site;
import kr.co.ewp.api.model.BmsEquipmentModel;
import kr.co.ewp.api.model.DeviceModel;
import kr.co.ewp.api.model.PcsEquipmentModel;
import kr.co.ewp.api.model.PvEquipmentModel;
import kr.co.ewp.api.service.DeviceService;
import kr.co.ewp.api.service.SiteService;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EnertalkApiUtil;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PMGrowApiUtil;
import kr.co.ewp.api.util.PrettyLog;
import kr.co.ewp.api.util.StringUtil;
import kr.co.ewp.api.util.ValidateUtil;

@Component
public class DeviceController {
  private Logger logger = LoggerFactory.getLogger(DeviceController.class);
  @Autowired
  private DeviceService deviceService;
  @Autowired
  private SiteService siteService;

  /**
   * 장치모니터링 > IOE 통신상태
   * 
   * @param siteId
   *          사이트아이디
   * @param deviceId
   *          장치아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void device01(String siteId, String deviceId, PrettyLog prettyLog) {
    prettyLog.title("장치모니터링 > IOE 통신상태");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    List<DeviceIoe> deviceIoeList = Lists.newArrayList();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
        switch (deviceType) {
        case "4":// 부하측정기기
        case "6":// ESS모니터링기기
        case "7":// iSmart
        case "8":// 총량기기
          break;
        default:
          continue;
        }
        DeviceModel deviceModel = EnertalkApiUtil.getDevice(device.getDeviceId(), prettyLog);

        DeviceIoe deviceIoe = new DeviceIoe();
        deviceIoe.setChCnt(deviceModel.getChannelCount());
        deviceIoe.setChPurpose(StringUtil.join(",", deviceModel.getChannelPurposes()));
        deviceIoe.setCreateDate(deviceModel.getCreatedAt());
        deviceIoe.setCreateTimestamp(deviceModel.getCreatedAt());
        deviceIoe.setCtCapacity(deviceModel.getCtCapacity());
        deviceIoe.setCtCapacityList(StringUtil.join(",", deviceModel.getCtCapacities()));
        deviceIoe.setDataCnt(deviceModel.getDataCount());
        deviceIoe.setDataPeriod(deviceModel.getDataPeriod());
        deviceIoe.setDeviceId(deviceModel.getId());
        deviceIoe.setDeviceName(deviceModel.getName());
        deviceIoe.setDeviceRegId(deviceModel.getRegistrationId());
        if (deviceModel.getUploadedAt() == null) {
          deviceIoe.setDeviceStat("2");
        } else {
          deviceIoe.setDeviceStat(new Date().getTime() - deviceModel.getUploadedAt().getTime() > 120000 ? "2" : "1"); // 2분 보다 크면 disconnect
        }
        deviceIoe.setInstPurpose(String.valueOf(deviceModel.getInstallPurpose()));
        deviceIoe.setInstType(String.valueOf(deviceModel.getInstallType()));
        if (deviceModel.getNetworkConfig() != null) {
          deviceIoe.setNetworkConf(JsonUtil.toJson(deviceModel.getNetworkConfig()));
        }
        deviceIoe.setOptions(deviceModel.getOptions());
        deviceIoe.setProvider(deviceModel.getProvider());
        deviceIoe.setPwCapacity(deviceModel.getPowerCapacity());
        deviceIoe.setSerialNo(deviceModel.getSerialNumber());
        deviceIoe.setSiteId(deviceModel.getSiteId());
        if (deviceModel.getTargetMeter() != null) {
          deviceIoe.setTmCtRatio(deviceModel.getTargetMeter().getCtRatio());
          deviceIoe.setTmPtTatio(deviceModel.getTargetMeter().getPtRatio());
          deviceIoe.setTmPulse(deviceModel.getTargetMeter().getPulse());
          deviceIoe.setTmVoltage(deviceModel.getTargetMeter().getVoltage());
        }
        deviceIoe.setUploadDate(deviceModel.getUploadedAt());
        deviceIoe.setUploadTimestamp(deviceModel.getUploadedAt());
        if (deviceModel.getVirtualDevice() != null) {
          deviceIoe.setVrAction(deviceModel.getVirtualDevice().getAction());
          deviceIoe.setVrDeviceGrpId(deviceModel.getVirtualDevice().getVirtualDeviceGroupId());
          deviceIoe.setVrDeviceId(deviceModel.getVirtualDevice().getVirtualDeviceId());
          if (deviceModel.getVirtualDevice().getError() != null) {
            deviceIoe.setVrError(JsonUtil.toJson(deviceModel.getVirtualDevice().getError()));
          }
          deviceIoe.setVrModDate(deviceModel.getVirtualDevice().getUpdatedAt());
          deviceIoe.setVrOwnerId(deviceModel.getVirtualDevice().getOwnerId());
          deviceIoe.setVrStat(deviceModel.getVirtualDevice().getStatus());
        }
        deviceIoeList.add(deviceIoe);
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("DEVICE01-ERROR", e);
      }
      // prettyLog.append("ITEM_SIZE", deviceModel.getItems().size());
      if (deviceIoeList.size() == 20) {
        resultCnt += deviceService.addDeivceIoeList(deviceIoeList, null);
        deviceIoeList = Lists.newArrayList();
      }
    }
    if (deviceIoeList.size() > 0) {
      resultCnt += deviceService.addDeivceIoeList(deviceIoeList, null);
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 장치모니터링 > PCS 운전상태 > PCS 장치
   * 
   * @param siteId
   *          사이트아이디
   * @param deviceId
   *          장치아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void device02(String siteId, String deviceId, PrettyLog prettyLog) {
    prettyLog.title("장치모니터링 > PCS 운전상태 > PCS 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    List<DevicePcs> deivcePcsList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
        switch (deviceType) {
        case "1": // PCS
          break;
        default:
          continue;
        }
        String _siteId = device.getSiteId();
        if (!localEmsAddrMap.containsKey(_siteId)) {
          Site site = siteService.getSite(_siteId, prettyLog);
          if (site == null) {
            prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
            continue;
          }
          localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        }
        List<PcsEquipmentModel> pcsEquipmentList = PMGrowApiUtil.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        prettyLog.append("ITEM_SIZE", pcsEquipmentList.size());
        for (PcsEquipmentModel pcsEquipmentModel : pcsEquipmentList) {
          DevicePcs devicePcs = new DevicePcs();
          devicePcs.setSiteId(device.getSiteId());
          devicePcs.setDeviceId(device.getDeviceId());
          devicePcs.setAcCurrent(Integer.parseInt(pcsEquipmentModel.getAcCurrent()));
          devicePcs.setAcFreq(Integer.parseInt(pcsEquipmentModel.getAcFreq()));
          devicePcs.setAcPf(Integer.parseInt(pcsEquipmentModel.getAcPf()));
          devicePcs.setAcPower(Integer.parseInt(pcsEquipmentModel.getAcPower()));
          devicePcs.setAcSetPower(Integer.parseInt(pcsEquipmentModel.getAcSetPower()));
          devicePcs.setAcVoltage(Integer.parseInt(pcsEquipmentModel.getAcVoltage()));
          devicePcs.setAlarmMsg(pcsEquipmentModel.getAlarmMsg());
          devicePcs.setDcCurrent(Integer.parseInt(pcsEquipmentModel.getDcCurrent()));
          devicePcs.setDcFreq(Integer.parseInt(pcsEquipmentModel.getDcFreq()));
          devicePcs.setDcPf(Integer.parseInt(pcsEquipmentModel.getDcPf()));
          devicePcs.setDcPower(Integer.parseInt(pcsEquipmentModel.getDcPower()));
          devicePcs.setDcSetPower(Integer.parseInt(pcsEquipmentModel.getDcSetPower()));
          devicePcs.setDcVoltage(Integer.parseInt(pcsEquipmentModel.getDcVoltage()));
          devicePcs.setDeviceName(pcsEquipmentModel.getEquipmentName());
          devicePcs.setDeviceStat(pcsEquipmentModel.getOpMode());
          devicePcs.setStdDate(DateUtil.stringToDate(pcsEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));

          devicePcs.setPcsStatus(pcsEquipmentModel.getPcsStatus());
          devicePcs.setRemoteMode(pcsEquipmentModel.getRemoteMode());
          devicePcs.setPcsCommand(pcsEquipmentModel.getPcsCommand());
          devicePcs.setTodayDEnergy(pcsEquipmentModel.getTodayDEnergy());
          devicePcs.setTodayCEnergy(pcsEquipmentModel.getTodayCEnergy());
          devicePcs.setTotalDEnergy(pcsEquipmentModel.getTotalDEnergy());
          devicePcs.setTotalCEnerge(pcsEquipmentModel.getTotalCEnerge());

          deivcePcsList.add(devicePcs);

          if (deivcePcsList.size() == 20) {
            resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
            deivcePcsList = Lists.newArrayList();
          }
        }
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("DEVICE02-ERROR", e);
      }
    }
    if (deivcePcsList.size() > 0) {
      resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 장치모니터링 > BMS 운전상태 > BMS 장치
   * 
   * @param siteId
   *          사이트아이디
   * @param deviceId
   *          장치아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void device03(String siteId, String deviceId, PrettyLog prettyLog) {
    prettyLog.title("장치모니터링 > BMS 운전상태 > BMS 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    int resultCnt = 0;
    List<DeviceBms> deivceBmsList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
        switch (deviceType) {
        case "2": // BMS
          break;
        default:
          continue;
        }
        String _siteId = device.getSiteId();
        if (!localEmsAddrMap.containsKey(_siteId)) {
          Site site = siteService.getSite(_siteId, prettyLog);
          if (site == null) {
            prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
            continue;
          }
          localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        }
        List<BmsEquipmentModel> bmsEquipmentList = PMGrowApiUtil.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        for (BmsEquipmentModel bmsEquipmentModel : bmsEquipmentList) {
          DeviceBms deviceBms = new DeviceBms();
          deviceBms.setSiteId(device.getSiteId());
          deviceBms.setDeviceId(device.getDeviceId());
          deviceBms.setDeviceName(bmsEquipmentModel.getEquipmentName());
          deviceBms.setCurrSoc(Integer.parseInt(bmsEquipmentModel.getCurrSoc()));
          deviceBms.setDod(Integer.parseInt(bmsEquipmentModel.getDod()));
          deviceBms.setSysCurrent(Integer.parseInt(bmsEquipmentModel.getSysCurrent()));
          deviceBms.setSysSoc(Integer.parseInt(bmsEquipmentModel.getSysSoc()));
          deviceBms.setSysSoh(Integer.parseInt(bmsEquipmentModel.getSysSoh()));
          deviceBms.setSysVoltage(Integer.parseInt(bmsEquipmentModel.getSysVoltage()));
          deviceBms.setDeviceStat(bmsEquipmentModel.getSysMode());
          deviceBms.setStdDate(DateUtil.stringToDate(bmsEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));
          deivceBmsList.add(deviceBms);

          if (deivceBmsList.size() == 20) {
            resultCnt += deviceService.addDeivceBmsList(deivceBmsList, null);
            deivceBmsList = Lists.newArrayList();
          }
        }
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("DEVICE03-ERROR", e);
      }
    }

    if (deivceBmsList.size() > 0) {
      resultCnt += deviceService.addDeivceBmsList(deivceBmsList, null);
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 장치모니터링 > PV 운전상태 > PV 장치
   * 
   * @param siteId
   *          사이트아이디
   * @param deviceId
   *          장치아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void device04(String siteId, String deviceId, PrettyLog prettyLog) {
    prettyLog.title("장치모니터링 > PV 운전상태 > PV 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    int resultCnt = 0;
    List<DevicePv> deivcePvList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
        switch (deviceType) {
        case "3":// PV
        case "5":// PV모니터링기기
          break;
        default:
          continue;
        }
        String _siteId = device.getSiteId();
        if (!localEmsAddrMap.containsKey(_siteId)) {
          Site site = siteService.getSite(_siteId, prettyLog);
          if (site == null) {
            prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
            continue;
          }
          localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        }
        List<PvEquipmentModel> pvEquipmentList = PMGrowApiUtil.getPvEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        for (PvEquipmentModel pcsEquipmentModel : pvEquipmentList) {
          DevicePv devicePv = new DevicePv();
          devicePv.setSiteId(_siteId);
          devicePv.setDeviceId(device.getDeviceId());
          devicePv.setAlarmMsg(pcsEquipmentModel.getAlarmMsg());
          devicePv.setTemp(Integer.parseInt(pcsEquipmentModel.getTemperature()));
          devicePv.setTotPower(Integer.parseInt(pcsEquipmentModel.getTotalPower()));
          devicePv.setDeviceName(pcsEquipmentModel.getEquipmentName());
          devicePv.setDeviceStat(pcsEquipmentModel.getStatus());
          devicePv.setStdDate(DateUtil.stringToDate(pcsEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));
          deivcePvList.add(devicePv);
          if (deivcePvList.size() == 20) {
            resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
            deivcePvList = Lists.newArrayList();
          }
        }
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("DEVICE04-ERROR", e);
      }
    }
    if (deivcePvList.size() > 0) {
      resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  private List<Device> getDeviceList(String siteId, String deviceId, PrettyLog prettyLog) {
    List<Device> deviceList;
    if (deviceId != null) {
      Device device = deviceService.getDevice(deviceId, prettyLog);
      deviceList = Lists.newArrayList();
      deviceList.add(device);
      ValidateUtil.notNull(device, "디바이스를 찾을 수 없습니다");
    } else if (siteId != null) {
      deviceList = deviceService.getDeviceList(siteId, prettyLog);
      ValidateUtil.notEmpty(deviceList, "해당 사이트 아이디의 디바이스를 찾을 수 없습니다");
    } else {
      deviceList = Lists.newArrayList();
      List<Site> siteList = siteService.getSiteList(prettyLog);
      ValidateUtil.notEmpty(siteList, "사이트 목록을 찾을 수 없습니다");
      for (Site site : siteList) {
        deviceList.addAll(deviceService.getDeviceList(site.getSiteId(), null));
      }
    }
    return deviceList;
  }
}
