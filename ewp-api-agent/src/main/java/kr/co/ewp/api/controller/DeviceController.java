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
//        switch (deviceType) {
//        case "4":// 부하측정기기
//        case "6":// ESS모니터링기기
//        case "7":// iSmart
//        case "8":// 총량기기
//          break;
//        default:
//          continue;
//        }
        if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){
        	DeviceModel deviceModel = EnertalkApiUtil.getDevice(device.getDeviceId(), prettyLog);
        	
        	DeviceIoe deviceIoe = new DeviceIoe();
        	if(deviceModel !=null){
        		
        		if (deviceModel.getUploadedAt() == null) {
        			deviceIoe.setDeviceStat("2");
        		} else {
        			deviceIoe.setDeviceStat(new Date().getTime() - deviceModel.getUploadedAt().getTime() > 120000 ? "2" : "1"); // 2분 보다 크면 disconnect
        		}
        		if (deviceModel.getNetworkConfig() != null) {
        			deviceIoe.setNetworkConf(JsonUtil.toJson(deviceModel.getNetworkConfig()));
        		}
        		
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
        		deviceIoe.setInstPurpose(String.valueOf(deviceModel.getInstallPurpose()));
        		deviceIoe.setInstType(String.valueOf(deviceModel.getInstallType()));
        		deviceIoe.setOptions(deviceModel.getOptions());
        		deviceIoe.setProvider(deviceModel.getProvider());
        		deviceIoe.setPwCapacity(deviceModel.getPowerCapacity());
        		deviceIoe.setSerialNo(deviceModel.getSerialNumber());
        		deviceIoe.setSiteId(deviceModel.getSiteId());
        		deviceIoe.setUploadDate(deviceModel.getUploadedAt());
        		deviceIoe.setUploadTimestamp(deviceModel.getUploadedAt());
        		if (deviceModel.getTargetMeter() != null) {
        			deviceIoe.setTmCtRatio(deviceModel.getTargetMeter().getCtRatio());
        			deviceIoe.setTmPtTatio(deviceModel.getTargetMeter().getPtRatio());
        			deviceIoe.setTmPulse(deviceModel.getTargetMeter().getPulse());
        			deviceIoe.setTmVoltage(deviceModel.getTargetMeter().getVoltage());
        		}
        		
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
        	}
        	deviceIoeList.add(deviceIoe);
        }
      } catch (NullPointerException e) {
          logger.error("error is : "+e.toString());  
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
	  System.out.println("pcs 장치");
    prettyLog.title("장치모니터링 > PCS 운전상태 > PCS 장치");
    System.out.println("pcs 장치 111");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    System.out.println("pcs 장치 222   ---> "+deviceList.size());
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    System.out.println("pcs 장치 333");
    List<DevicePcs> deivcePcsList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    System.out.println("pcs 장치 444");
    for (Device device : deviceList) {
    	System.out.println("pcs 장치 555");
      try {
        String deviceType = device.getDeviceType();
        System.out.println("디바이스 타입은? "+deviceType+", "+device.getDeviceId());
//        switch (deviceType) {
//        case "1": // PCS
//          break;
//        default:
//          continue;
//        }
        if("1".equals(deviceType)){
        	System.out.println("pcs 장치 시작");
        	String _siteId = device.getSiteId();
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        	}
        	PcsEquipmentModel pcsEquipmentModel = PMGrowApiUtil.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        	System.out.println(device.getDeviceId()+"pcs 장치 결과        :  "+pcsEquipmentModel.toString());
        	if(pcsEquipmentModel != null){
        		System.out.println("1");
        		prettyLog.append("ITEM_SIZE", pcsEquipmentModel);
//        		for (PcsEquipmentModel pcsEquipmentModel : pcsEquipmentList) {
        			DevicePcs devicePcs = new DevicePcs();
        			devicePcs.setSiteId(device.getSiteId());
        			devicePcs.setDeviceId(device.getDeviceId());
        			if(pcsEquipmentModel.getAcCurrent() != null) devicePcs.setAcCurrent(pcsEquipmentModel.getAcCurrent()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getAcFreq() != null) devicePcs.setAcFreq(pcsEquipmentModel.getAcFreq()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getAcPf() != null) devicePcs.setAcPf(pcsEquipmentModel.getAcPf()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getAcPower() != null) devicePcs.setAcPower(pcsEquipmentModel.getAcPower()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getAcSetPower() != null) devicePcs.setAcSetPower(pcsEquipmentModel.getAcSetPower()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getAcVoltage() != null) devicePcs.setAcVoltage(pcsEquipmentModel.getAcVoltage()); /*** 12.12 이우람 수정 ***/
        			devicePcs.setAlarmMsg(pcsEquipmentModel.getAlarmMsg());
        			if(pcsEquipmentModel.getDcCurrent() != null) devicePcs.setDcCurrent(pcsEquipmentModel.getDcCurrent()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getDcFreq() != null) devicePcs.setDcFreq(pcsEquipmentModel.getDcFreq()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getDcPf() != null) devicePcs.setDcPf(pcsEquipmentModel.getDcPf()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getDcPower() != null) devicePcs.setDcPower(pcsEquipmentModel.getDcPower()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getDcSetPower() != null) devicePcs.setDcSetPower(pcsEquipmentModel.getDcSetPower()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getDcVoltage() != null) devicePcs.setDcVoltage(pcsEquipmentModel.getDcVoltage()); /*** 12.12 이우람 수정 ***/
        			devicePcs.setDeviceName(pcsEquipmentModel.getPcsName()); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getOpMode() != null) devicePcs.setDeviceStat(Integer.toString(pcsEquipmentModel.getOpMode())); /*** 12.12 이우람 수정 ***/
        			devicePcs.setStdDate(pcsEquipmentModel.getTimestamp()); /*** 12.12 이우람 수정 ***/
        			
        			if(pcsEquipmentModel.getPcsStatus() != null) devicePcs.setPcsStatus(Integer.toString(pcsEquipmentModel.getPcsStatus())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getRemoteMode() != null) devicePcs.setRemoteMode(Integer.toString(pcsEquipmentModel.getRemoteMode())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getPcsCommand() != null) devicePcs.setPcsCommand(Integer.toString(pcsEquipmentModel.getPcsCommand())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getTodayDEnergy() != null) devicePcs.setTodayDEnergy(Integer.toString(pcsEquipmentModel.getTodayDEnergy())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getTodayCEnergy() != null) devicePcs.setTodayCEnergy(Integer.toString(pcsEquipmentModel.getTodayCEnergy())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getTotalDEnergy() != null) devicePcs.setTotalDEnergy(Integer.toString(pcsEquipmentModel.getTotalDEnergy())); /*** 12.12 이우람 수정 ***/
        			if(pcsEquipmentModel.getTotalCEnerge() != null) devicePcs.setTotalCEnerge(Integer.toString(pcsEquipmentModel.getTotalCEnerge())); /*** 12.12 이우람 수정 ***/
        			
        			deivcePcsList.add(devicePcs);
        			
        			if (deivcePcsList.size() == 20) {
        				resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
        				deivcePcsList = Lists.newArrayList();
        			}
//        		}
        	}
        }
      } catch (NullPointerException e) {
          logger.error("error is : "+e.toString());
      } catch (Exception e) {
    	  System.out.println("28   "+e.toString());
    	  e.printStackTrace();
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
	  System.out.println("bms 장치");
    prettyLog.title("장치모니터링 > BMS 운전상태 > BMS 장치");
    System.out.println("bms 장치 111");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    System.out.println("bms 장치 222   ---> "+deviceList.size());
    int resultCnt = 0;
    List<DeviceBms> deivceBmsList = Lists.newArrayList();
    System.out.println("bms 장치 333");
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    System.out.println("bms 장치 444");
    for (Device device : deviceList) {
    	System.out.println("bms 장치 555");
      try {
        String deviceType = device.getDeviceType();
        System.out.println("디바이스 타입은? "+deviceType+", "+device.getDeviceId());
//        switch (deviceType) {
//        case "2": // BMS
//          break;
//        default:
//          continue;
//        }
        if("2".equals(deviceType)){
        	System.out.println("bms 장치 시작");
        	String _siteId = device.getSiteId();
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        	}
        	BmsEquipmentModel bmsEquipmentModel = PMGrowApiUtil.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        	if( bmsEquipmentModel != null){
//        		for (BmsEquipmentModel bmsEquipmentModel : bmsEquipmentList) {
        			DeviceBms deviceBms = new DeviceBms();
        			deviceBms.setSiteId(device.getSiteId());
        			deviceBms.setDeviceId(device.getDeviceId());
        			deviceBms.setAlarmMsg(bmsEquipmentModel.getAlarmMsg());
        			deviceBms.setDeviceName(bmsEquipmentModel.getBmsName()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setCurrSoc(bmsEquipmentModel.getCurrSoc()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setDod(bmsEquipmentModel.getDod()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setSysCurrent(bmsEquipmentModel.getSysCurrent()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setSysSoc(bmsEquipmentModel.getSysSoc()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setSysSoh(bmsEquipmentModel.getSysSoh()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setSysVoltage(bmsEquipmentModel.getSysVoltage()); /*** 12.12 이우람 수정 ***/
        			deviceBms.setDeviceStat(Integer.toString(bmsEquipmentModel.getSysMode())); /*** 12.12 이우람 수정 ***/
        			deviceBms.setStdDate(bmsEquipmentModel.getTimestamp()); /*** 12.12 이우람 수정 ***/
        			deivceBmsList.add(deviceBms);
        			
        			if (deivceBmsList.size() == 20) {
        				resultCnt += deviceService.addDeivceBmsList(deivceBmsList, null);
        				deivceBmsList = Lists.newArrayList();
        			}
//        		}
        	}
        
        }
      } catch (NullPointerException e) {
          logger.error("error is : "+e.toString());  
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
	  System.out.println("pv 장치");
    prettyLog.title("장치모니터링 > PV 운전상태 > PV 장치");
    System.out.println("pv 장치 111");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    System.out.println("pv 장치 222   ---> "+deviceList.size());
    int resultCnt = 0;
    List<DevicePv> deivcePvList = Lists.newArrayList();
    System.out.println("pv 장치 333");
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    System.out.println("pv 장치 444");
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
//        switch (deviceType) {
//        case "3":// PV
//        case "5":// PV모니터링기기
//          break;
//        default:
//          continue;
//        }
        if("3".equals(deviceType) || "5".equals(deviceType)){
        	System.out.println("디바이스 타입은? "+deviceType+", "+device.getDeviceId());
        	String _siteId = device.getSiteId();
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        	}
        	PvEquipmentModel pvEquipmentModel = PMGrowApiUtil.getPvEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        	System.out.println(device.getDeviceId()+"pv 장치 결과        :  "+pvEquipmentModel.toString());
        	if(pvEquipmentModel != null){
//        		for (PvEquipmentModel pvEquipmentModel : pvEquipmentList) {
        			DevicePv devicePv = new DevicePv();
        			devicePv.setSiteId(_siteId);
        			devicePv.setDeviceId(device.getDeviceId());
        			devicePv.setAlarmMsg(pvEquipmentModel.getAlarmMsg());
        			devicePv.setTemp(pvEquipmentModel.getTemperature()); /*** 12.12 이우람 수정 ***/
        			devicePv.setTotPower(pvEquipmentModel.getTotalGenPower()); /*** 12.12 이우람 수정 ***/
        			devicePv.setDeviceName(pvEquipmentModel.getIvtName()); /*** 12.12 이우람 수정 ***/
        			devicePv.setDeviceStat(Integer.toString(pvEquipmentModel.getStatus())); /*** 12.12 이우람 수정 ***/
        			devicePv.setStdDate(pvEquipmentModel.getTimestamp()); /*** 12.12 이우람 수정 ***/
        			deivcePvList.add(devicePv);
        			if (deivcePvList.size() == 20) {
        				resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
        				deivcePvList = Lists.newArrayList();
        			}
//        		}
        	}
        
        }
      } catch (NullPointerException e) {
          logger.error("error is : "+e.toString());
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
      if(siteList != null){
    	  for (Site site : siteList) {
    		  deviceList.addAll(deviceService.getDeviceList(site.getSiteId(), null));
    	  }
      }
    }
    return deviceList;
  }
}
