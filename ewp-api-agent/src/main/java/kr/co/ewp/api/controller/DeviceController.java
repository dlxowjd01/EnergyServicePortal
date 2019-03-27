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
import kr.co.ewp.api.model.BmsEquipmentModelBefore;
import kr.co.ewp.api.model.DeviceModel;
import kr.co.ewp.api.model.PcsEquipmentModel;
import kr.co.ewp.api.model.PcsEquipmentModelBefore;
import kr.co.ewp.api.model.PvEquipmentModel;
import kr.co.ewp.api.model.PvEquipmentModelBefore;
import kr.co.ewp.api.service.DeviceService;
import kr.co.ewp.api.service.SiteService;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EnertalkApiUtil;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PMGrowApiUtil;
import kr.co.ewp.api.util.PMGrowApiUtilBefore;
import kr.co.ewp.api.util.PMGrowApiUtil_omni;
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
        if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
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
    prettyLog.title("장치모니터링 > PCS 운전상태 > PCS 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    List<DevicePcs> deivcePcsList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    Map<String, String> localEmsApiVerMap = Maps.newHashMap();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
//        switch (deviceType) {
//        case "1": // PCS
//          break;
//        default:
//          continue;
//        }
        if("1".equals(deviceType)){
        	String _siteId = device.getSiteId();
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        		localEmsApiVerMap.put(_siteId, site.getLocalEmsApiVer());
        	}
    		if("1.1".equals(localEmsApiVerMap.get(_siteId))) { // 기존
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 pcs장치 api를 조회합니다..");
    			List<PcsEquipmentModelBefore> pcsEquipmentList = PMGrowApiUtilBefore.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"pcs 장치 1.1 결과        :  "+pcsEquipmentList.toString());
    			if(pcsEquipmentList != null){
    				System.out.println("1.1 1");
    				prettyLog.append("ITEM_SIZE", pcsEquipmentList.size());
    				for (PcsEquipmentModelBefore pcsEquipmentModel : pcsEquipmentList) {
    					DevicePcs devicePcs = new DevicePcs();
    					devicePcs.setSiteId(device.getSiteId());
    					devicePcs.setDeviceId(device.getDeviceId());
    					if(pcsEquipmentModel.getAcCurrent() != null && !"".equals(pcsEquipmentModel.getAcCurrent())) devicePcs.setAcCurrent(pcsEquipmentModel.getAcCurrent());
    					if(pcsEquipmentModel.getAcFreq() != null && !"".equals(pcsEquipmentModel.getAcFreq())) devicePcs.setAcFreq(pcsEquipmentModel.getAcFreq());
    					if(pcsEquipmentModel.getAcPf() != null && !"".equals(pcsEquipmentModel.getAcPf())) devicePcs.setAcPf(pcsEquipmentModel.getAcPf());
    					if(pcsEquipmentModel.getAcPower() != null && !"".equals(pcsEquipmentModel.getAcPower())) devicePcs.setAcPower(pcsEquipmentModel.getAcPower());
    					if(pcsEquipmentModel.getAcSetPower() != null && !"".equals(pcsEquipmentModel.getAcSetPower())) devicePcs.setAcSetPower(pcsEquipmentModel.getAcSetPower());
    					if(pcsEquipmentModel.getAcVoltage() != null && !"".equals(pcsEquipmentModel.getAcVoltage())) devicePcs.setAcVoltage(pcsEquipmentModel.getAcVoltage());
    					devicePcs.setAlarmMsg(pcsEquipmentModel.getAlarmMsg());
    					if(pcsEquipmentModel.getDcCurrent() != null && !"".equals(pcsEquipmentModel.getDcCurrent())) devicePcs.setDcCurrent(pcsEquipmentModel.getDcCurrent());
    					if(pcsEquipmentModel.getDcFreq() != null && !"".equals(pcsEquipmentModel.getDcFreq())) devicePcs.setDcFreq(pcsEquipmentModel.getDcFreq());
    					if(pcsEquipmentModel.getDcPf() != null && !"".equals(pcsEquipmentModel.getDcPf()))  devicePcs.setDcPf(pcsEquipmentModel.getDcPf());
    					if(pcsEquipmentModel.getDcPower() != null && !"".equals(pcsEquipmentModel.getDcPower())) devicePcs.setDcPower(pcsEquipmentModel.getDcPower());
    					if(pcsEquipmentModel.getDcSetPower() != null && !"".equals(pcsEquipmentModel.getDcSetPower()))  devicePcs.setDcSetPower(pcsEquipmentModel.getDcSetPower());
    					if(pcsEquipmentModel.getDcVoltage() != null && !"".equals(pcsEquipmentModel.getDcVoltage())) devicePcs.setDcVoltage(pcsEquipmentModel.getDcVoltage());
    					devicePcs.setDeviceName(pcsEquipmentModel.getPcsName());
    					if(pcsEquipmentModel.getOpMode() != null && !"".equals(pcsEquipmentModel.getOpMode())) devicePcs.setDeviceStat(String.valueOf(pcsEquipmentModel.getOpMode()));
    					devicePcs.setStdDate(pcsEquipmentModel.getTimestamp());
    					
    					if(pcsEquipmentModel.getPcsStatus() != null && !"".equals(pcsEquipmentModel.getPcsStatus())) devicePcs.setPcsStatus(String.valueOf(pcsEquipmentModel.getPcsStatus()));
    					if(pcsEquipmentModel.getRemoteMode() != null && !"".equals(pcsEquipmentModel.getRemoteMode())) devicePcs.setRemoteMode(String.valueOf(pcsEquipmentModel.getRemoteMode()));
    					if(pcsEquipmentModel.getPcsCommand() != null && !"".equals(pcsEquipmentModel.getPcsCommand())) devicePcs.setPcsCommand(String.valueOf(pcsEquipmentModel.getPcsCommand()));
    					if(pcsEquipmentModel.getTodayDEnergy() != null && !"".equals(pcsEquipmentModel.getTodayDEnergy())) devicePcs.setTodayDEnergy(String.valueOf(pcsEquipmentModel.getTodayDEnergy()));
    					if(pcsEquipmentModel.getTodayCEnergy() != null && !"".equals(pcsEquipmentModel.getTodayCEnergy())) devicePcs.setTodayCEnergy(String.valueOf(pcsEquipmentModel.getTodayCEnergy()));
    					if(pcsEquipmentModel.getTotalDEnergy() != null && !"".equals(pcsEquipmentModel.getTotalDEnergy())) devicePcs.setTotalDEnergy(String.valueOf(pcsEquipmentModel.getTotalDEnergy()));
    					if(pcsEquipmentModel.getTotalCEnerge() != null && !"".equals(pcsEquipmentModel.getTotalCEnerge())) devicePcs.setTotalCEnerge(String.valueOf(pcsEquipmentModel.getTotalCEnerge()));
    					
    					deivcePcsList.add(devicePcs);
    					
    					if (deivcePcsList.size() == 20) {
    						resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
    						deivcePcsList = Lists.newArrayList();
    					}
    				}
    			}
//    			List<PcsEquipmentModelBefore> pcsEquipmentList = PMGrowApiUtilBefore.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
//    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"pcs 장치 1.1 결과        :  "+pcsEquipmentList.toString());
//    			if(pcsEquipmentList != null){
//    				System.out.println("1.1 1");
//    				prettyLog.append("ITEM_SIZE", pcsEquipmentList.size());
//    				for (PcsEquipmentModelBefore pcsEquipmentModel : pcsEquipmentList) {
//    					DevicePcs devicePcs = new DevicePcs();
//    					devicePcs.setSiteId(device.getSiteId());
//    					devicePcs.setDeviceId(device.getDeviceId());
//    					if(pcsEquipmentModel.getAcCurrent() != null && !"".equals(pcsEquipmentModel.getAcCurrent())) devicePcs.setAcCurrent(Integer.parseInt(pcsEquipmentModel.getAcCurrent()));
//    					if(pcsEquipmentModel.getAcFreq() != null && !"".equals(pcsEquipmentModel.getAcFreq())) devicePcs.setAcFreq(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(pcsEquipmentModel.getAcFreq())))    ));
//    					if(pcsEquipmentModel.getAcPf() != null && !"".equals(pcsEquipmentModel.getAcPf())) devicePcs.setAcPf(Integer.parseInt(    String.valueOf(Math.round(Double.parseDouble(pcsEquipmentModel.getAcPf())))     ));
//    					if(pcsEquipmentModel.getAcPower() != null && !"".equals(pcsEquipmentModel.getAcPower())) devicePcs.setAcPower(Integer.parseInt(pcsEquipmentModel.getAcPower()));
//    					if(pcsEquipmentModel.getAcSetPower() != null && !"".equals(pcsEquipmentModel.getAcSetPower())) devicePcs.setAcSetPower(Integer.parseInt(pcsEquipmentModel.getAcSetPower()));
//    					if(pcsEquipmentModel.getAcVoltage() != null && !"".equals(pcsEquipmentModel.getAcVoltage())) devicePcs.setAcVoltage(Integer.parseInt(  String.valueOf(Math.round(Double.parseDouble(pcsEquipmentModel.getAcVoltage())))  ));
//    					devicePcs.setAlarmMsg(pcsEquipmentModel.getAlarmMsg());
//    					if(pcsEquipmentModel.getDcCurrent() != null && !"".equals(pcsEquipmentModel.getDcCurrent())) devicePcs.setDcCurrent(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(pcsEquipmentModel.getDcCurrent())))   ));
//    					if(pcsEquipmentModel.getDcFreq() != null && !"".equals(pcsEquipmentModel.getDcFreq())) devicePcs.setDcFreq(Integer.parseInt(pcsEquipmentModel.getDcFreq()));
//    					if(pcsEquipmentModel.getDcPf() != null && !"".equals(pcsEquipmentModel.getDcPf()))  devicePcs.setDcPf(Integer.parseInt(pcsEquipmentModel.getDcPf()));
//    					if(pcsEquipmentModel.getDcPower() != null && !"".equals(pcsEquipmentModel.getDcPower())) devicePcs.setDcPower(Integer.parseInt(pcsEquipmentModel.getDcPower()));
//    					if(pcsEquipmentModel.getDcSetPower() != null && !"".equals(pcsEquipmentModel.getDcSetPower()))  devicePcs.setDcSetPower(Integer.parseInt(pcsEquipmentModel.getDcSetPower()));
//    					if(pcsEquipmentModel.getDcVoltage() != null && !"".equals(pcsEquipmentModel.getDcVoltage())) devicePcs.setDcVoltage(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(pcsEquipmentModel.getDcVoltage())))   ));
//    					devicePcs.setDeviceName(pcsEquipmentModel.getEquipmentName());
//    					if(pcsEquipmentModel.getOpMode() != null && !"".equals(pcsEquipmentModel.getOpMode())) devicePcs.setDeviceStat(pcsEquipmentModel.getOpMode());
//    					devicePcs.setStdDate(DateUtil.stringToDate(pcsEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));
//    					
//    					if(pcsEquipmentModel.getPcsStatus() != null && !"".equals(pcsEquipmentModel.getPcsStatus())) devicePcs.setPcsStatus(pcsEquipmentModel.getPcsStatus());
//    					if(pcsEquipmentModel.getRemoteMode() != null && !"".equals(pcsEquipmentModel.getRemoteMode())) devicePcs.setRemoteMode(pcsEquipmentModel.getRemoteMode());
//    					if(pcsEquipmentModel.getPcsCommand() != null && !"".equals(pcsEquipmentModel.getPcsCommand())) devicePcs.setPcsCommand(pcsEquipmentModel.getPcsCommand());
//    					if(pcsEquipmentModel.getTodayDEnergy() != null && !"".equals(pcsEquipmentModel.getTodayDEnergy())) devicePcs.setTodayDEnergy(pcsEquipmentModel.getTodayDEnergy());
//    					if(pcsEquipmentModel.getTodayCEnergy() != null && !"".equals(pcsEquipmentModel.getTodayCEnergy())) devicePcs.setTodayCEnergy(pcsEquipmentModel.getTodayCEnergy());
//    					if(pcsEquipmentModel.getTotalDEnergy() != null && !"".equals(pcsEquipmentModel.getTotalDEnergy())) devicePcs.setTotalDEnergy(pcsEquipmentModel.getTotalDEnergy());
//    					if(pcsEquipmentModel.getTotalCEnerge() != null && !"".equals(pcsEquipmentModel.getTotalCEnerge())) devicePcs.setTotalCEnerge(pcsEquipmentModel.getTotalCEnerge());
//    					
//    					deivcePcsList.add(devicePcs);
//    					
//    					if (deivcePcsList.size() == 20) {
//    						resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
//    						deivcePcsList = Lists.newArrayList();
//    					}
//    				}
//    			}
    		} else if("1.2".equals(localEmsApiVerMap.get(_siteId))) { // api url 변경후(옴니시스템)
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 옴니시스템 pcs장치 api를 조회합니다..");
    			PcsEquipmentModel pcsEquipmentModel = PMGrowApiUtil_omni.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"  옴니시스템 pcs 장치 결과        :  "+pcsEquipmentModel.toString());
    			if(pcsEquipmentModel != null){
    				System.out.println("1");
    				prettyLog.append("ITEM_SIZE", pcsEquipmentModel);
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
    				if(pcsEquipmentModel.getTodayDEnergy() != null) devicePcs.setTodayDEnergy(Float.toString(pcsEquipmentModel.getTodayDEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTodayCEnergy() != null) devicePcs.setTodayCEnergy(Float.toString(pcsEquipmentModel.getTodayCEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTotalDEnergy() != null) devicePcs.setTotalDEnergy(Float.toString(pcsEquipmentModel.getTotalDEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTotalCEnerge() != null) devicePcs.setTotalCEnerge(Float.toString(pcsEquipmentModel.getTotalCEnerge())); /*** 12.12 이우람 수정 ***/
    				
    				deivcePcsList.add(devicePcs);
    				
    				if (deivcePcsList.size() == 20) {
    					resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
    					deivcePcsList = Lists.newArrayList();
    				}
    			}
    		
    		} else { // api url 변경후
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 pcs장치 api를 조회합니다..");
    			PcsEquipmentModel pcsEquipmentModel = PMGrowApiUtil.getPcsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
    			System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"pcs 장치 결과        :  "+pcsEquipmentModel.toString());
    			if(pcsEquipmentModel != null){
    				System.out.println("1");
    				prettyLog.append("ITEM_SIZE", pcsEquipmentModel);
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
    				if(pcsEquipmentModel.getTodayDEnergy() != null) devicePcs.setTodayDEnergy(Float.toString(pcsEquipmentModel.getTodayDEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTodayCEnergy() != null) devicePcs.setTodayCEnergy(Float.toString(pcsEquipmentModel.getTodayCEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTotalDEnergy() != null) devicePcs.setTotalDEnergy(Float.toString(pcsEquipmentModel.getTotalDEnergy())); /*** 12.12 이우람 수정 ***/
    				if(pcsEquipmentModel.getTotalCEnerge() != null) devicePcs.setTotalCEnerge(Float.toString(pcsEquipmentModel.getTotalCEnerge())); /*** 12.12 이우람 수정 ***/
    				
    				deivcePcsList.add(devicePcs);
    				
    				if (deivcePcsList.size() == 20) {
    					resultCnt += deviceService.addDeivcePcsList(deivcePcsList, null);
    					deivcePcsList = Lists.newArrayList();
    				}
    			}
    		}
        }
      } catch (NullPointerException e) {
          logger.error("error is : "+e.toString());
      } catch (Exception e) {
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
    prettyLog.title("장치모니터링 > BMS 운전상태 > BMS 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    int resultCnt = 0;
    List<DeviceBms> deivceBmsList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    Map<String, String> localEmsApiVerMap = Maps.newHashMap();
    for (Device device : deviceList) {
      try {
        String deviceType = device.getDeviceType();
//        switch (deviceType) {
//        case "2": // BMS
//          break;
//        default:
//          continue;
//        }
        if("2".equals(deviceType)){
        	String _siteId = device.getSiteId();
        	String apiVer = "";
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        		localEmsApiVerMap.put(_siteId, site.getLocalEmsApiVer());
        		apiVer = site.getLocalEmsApiVer();
        	}
        	if("1.1".equals(localEmsApiVerMap.get(_siteId))) { // 기존
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 bms장치 api를 조회합니다..");
        		List<BmsEquipmentModelBefore> bmsEquipmentList = PMGrowApiUtilBefore.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        		if( bmsEquipmentList != null){
        			prettyLog.append("ITEM_SIZE", bmsEquipmentList.size());
	        		for (BmsEquipmentModelBefore bmsEquipmentModel : bmsEquipmentList) {
	        			DeviceBms deviceBms = new DeviceBms();
	        			deviceBms.setSiteId(device.getSiteId());
	        			deviceBms.setDeviceId(device.getDeviceId());
	        			deviceBms.setDeviceName(bmsEquipmentModel.getBmsName());
	        			if(bmsEquipmentModel.getCurrSoc() != null && !"".equals(bmsEquipmentModel.getCurrSoc())) deviceBms.setCurrSoc(bmsEquipmentModel.getCurrSoc());
	        			if(bmsEquipmentModel.getDod() != null && !"".equals(bmsEquipmentModel.getDod())) deviceBms.setDod(Integer.parseInt(bmsEquipmentModel.getDod()));
	        			if(bmsEquipmentModel.getSysCurrent() != null && !"".equals(bmsEquipmentModel.getSysCurrent())) deviceBms.setSysCurrent(bmsEquipmentModel.getSysCurrent());
	        			if(bmsEquipmentModel.getSysSoc() != null && !"".equals(bmsEquipmentModel.getSysSoc())) deviceBms.setSysSoc(bmsEquipmentModel.getSysSoc());
	        			if(bmsEquipmentModel.getSysSoc() != null && !"".equals(bmsEquipmentModel.getSysSoc())) deviceBms.setSysSoh(bmsEquipmentModel.getSysSoc());
	        			if(bmsEquipmentModel.getSysVoltage() != null && !"".equals(bmsEquipmentModel.getSysVoltage())) deviceBms.setSysVoltage(bmsEquipmentModel.getSysVoltage());
	        			if(bmsEquipmentModel.getSysMode() != null && !"".equals(bmsEquipmentModel.getSysMode())) deviceBms.setDeviceStat(String.valueOf(bmsEquipmentModel.getSysMode()));
	        	        deviceBms.setStdDate(bmsEquipmentModel.getTimestamp());
	        			deivceBmsList.add(deviceBms);
	        			
	        			if (deivceBmsList.size() == 20) {
	        				resultCnt += deviceService.addDeivceBmsList(deivceBmsList, null);
	        				deivceBmsList = Lists.newArrayList();
	        			}
	        		}
        		}
//        		List<BmsEquipmentModelBefore> bmsEquipmentList = PMGrowApiUtilBefore.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
//        		if( bmsEquipmentList != null){
//        			prettyLog.append("ITEM_SIZE", bmsEquipmentList.size());
//        			for (BmsEquipmentModelBefore bmsEquipmentModel : bmsEquipmentList) {
//        				DeviceBms deviceBms = new DeviceBms();
//        				deviceBms.setSiteId(device.getSiteId());
//        				deviceBms.setDeviceId(device.getDeviceId());
//        				deviceBms.setDeviceName(bmsEquipmentModel.getEquipmentName());
//        				if(bmsEquipmentModel.getCurrSoc() != null && !"".equals(bmsEquipmentModel.getCurrSoc())) deviceBms.setCurrSoc(Integer.parseInt(bmsEquipmentModel.getCurrSoc()));
//        				if(bmsEquipmentModel.getDod() != null && !"".equals(bmsEquipmentModel.getDod())) deviceBms.setDod(Integer.parseInt(bmsEquipmentModel.getDod()));
//        				if(bmsEquipmentModel.getSysCurrent() != null && !"".equals(bmsEquipmentModel.getSysCurrent())) deviceBms.setSysCurrent(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(bmsEquipmentModel.getSysCurrent())))   ));
//        				if(bmsEquipmentModel.getSysSoc() != null && !"".equals(bmsEquipmentModel.getSysSoc())) deviceBms.setSysSoc(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(bmsEquipmentModel.getSysSoc())))   ));
//        				if(bmsEquipmentModel.getSysSoc() != null && !"".equals(bmsEquipmentModel.getSysSoc())) deviceBms.setSysSoh(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(bmsEquipmentModel.getSysSoc())))   ));
//        				if(bmsEquipmentModel.getSysVoltage() != null && !"".equals(bmsEquipmentModel.getSysVoltage())) deviceBms.setSysVoltage(Integer.parseInt(   String.valueOf(Math.round(Double.parseDouble(bmsEquipmentModel.getSysVoltage())))   ));
//        				if(bmsEquipmentModel.getSysMode() != null && !"".equals(bmsEquipmentModel.getSysMode())) deviceBms.setDeviceStat(bmsEquipmentModel.getSysMode());
//        				deviceBms.setStdDate(DateUtil.stringToDate(bmsEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));
//        				deivceBmsList.add(deviceBms);
//        				
//        				if (deivceBmsList.size() == 20) {
//	        				resultCnt += deviceService.addDeivceBmsList(deivceBmsList, null);
//        					deivceBmsList = Lists.newArrayList();
//        				}
//        			}
//        		}
        	} else if("1.2".equals(localEmsApiVerMap.get(_siteId))) { // api url 변경후(옴니시스템)
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 옴니시스템 새로운 bms장치 api를 조회합니다..");
        		BmsEquipmentModel bmsEquipmentModel = PMGrowApiUtil_omni.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        		if( bmsEquipmentModel != null){
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
        		}
        	
        	} else { // api url 변경후
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 bms장치 api를 조회합니다..");
        		BmsEquipmentModel bmsEquipmentModel = PMGrowApiUtil.getBmsEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        		if( bmsEquipmentModel != null){
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
        		}
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
    prettyLog.title("장치모니터링 > PV 운전상태 > PV 장치");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    int resultCnt = 0;
    List<DevicePv> deivcePvList = Lists.newArrayList();
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
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
        	String _siteId = device.getSiteId();
        	String apiVer = "";
        	if (!localEmsAddrMap.containsKey(_siteId)) {
        		Site site = siteService.getSite(_siteId, prettyLog);
        		if (site == null) {
        			prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
        			continue;
        		}
        		localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
        		apiVer = site.getLocalEmsApiVer();
        	}
        	if("1.1".equals(apiVer)) { // 기존
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 pv장치 api를 조회합니다..");
        		PvEquipmentModelBefore pvEquipmentModel = PMGrowApiUtilBefore.getPvEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"  1.1pv 장치 결과        :  "+pvEquipmentModel.toString());
        		if(pvEquipmentModel != null){
        			prettyLog.append("ITEM_SIZE", pvEquipmentModel);
//	        		for (PvEquipmentModelBefore pvEquipmentModel : pvEquipmentList) {
	        			DevicePv devicePv = new DevicePv();
	        			devicePv.setSiteId(_siteId);
	        			devicePv.setDeviceId(device.getDeviceId());
	        			devicePv.setAlarmMsg(pvEquipmentModel.getAlarmMsg());
	        			if(pvEquipmentModel.getTemperature() != null) devicePv.setTemp(pvEquipmentModel.getTemperature());
	        			devicePv.setTotPower(pvEquipmentModel.getTotalGenPower());
	        			devicePv.setDeviceName(pvEquipmentModel.getIvtName());
	        			if(pvEquipmentModel.getStatus() != null) devicePv.setDeviceStat(Integer.toString(pvEquipmentModel.getStatus()));
	        			devicePv.setStdDate(pvEquipmentModel.getTimestamp());
	        			deivcePvList.add(devicePv);
	        			if (deivcePvList.size() == 20) {
	        				resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
	        				deivcePvList = Lists.newArrayList();
	        			}
//	        		}
        		}
//        		List<PvEquipmentModelBefore> pvEquipmentList = PMGrowApiUtilBefore.getPvEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
//        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"  1.1pv 장치 결과        :  "+pvEquipmentList.toString());
//        		if(pvEquipmentList != null){
//        			prettyLog.append("ITEM_SIZE", pvEquipmentList.size());
//        			for (PvEquipmentModelBefore pvEquipmentModel : pvEquipmentList) {
//        				DevicePv devicePv = new DevicePv();
//        				devicePv.setSiteId(_siteId);
//        				devicePv.setDeviceId(device.getDeviceId());
//        				devicePv.setAlarmMsg(pvEquipmentModel.getAlarmMsg());
//        				devicePv.setTemp(Integer.parseInt(pvEquipmentModel.getTemperature()));
//        				devicePv.setTotPower(Integer.parseInt(pvEquipmentModel.getTotalPower()));
//        				devicePv.setDeviceName(pvEquipmentModel.getEquipmentName());
//        				devicePv.setDeviceStat(pvEquipmentModel.getStatus());
//        				devicePv.setStdDate(DateUtil.stringToDate(pvEquipmentModel.getRetrieveTime(), "yyyyMMddHHmmss"));
//        				deivcePvList.add(devicePv);
//        				if (deivcePvList.size() == 20) {
//        					resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
//        					deivcePvList = Lists.newArrayList();
//        				}
//        			}
//        		}
        	} else { // api url 변경후
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 pv장치 api를 조회합니다..");
        		PvEquipmentModel pvEquipmentModel = PMGrowApiUtil.getPvEquipmentList(localEmsAddrMap.get(_siteId), device.getDeviceId(), prettyLog);
        		System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+"pv 장치 결과        :  "+pvEquipmentModel.toString());
        		if(pvEquipmentModel != null){
        			DevicePv devicePv = new DevicePv();
        			devicePv.setSiteId(_siteId);
        			devicePv.setDeviceId(device.getDeviceId());
        			devicePv.setAlarmMsg(pvEquipmentModel.getAlarmMsg());
        			devicePv.setTemp(pvEquipmentModel.getTemperature()); /*** 12.12 이우람 수정 ***/
        			devicePv.setTotPower((float) pvEquipmentModel.getTotalGenPower()); /*** 12.12 이우람 수정 ***/
        			devicePv.setDeviceName(pvEquipmentModel.getIvtName()); /*** 12.12 이우람 수정 ***/
        			devicePv.setDeviceStat(Integer.toString(pvEquipmentModel.getStatus())); /*** 12.12 이우람 수정 ***/
        			devicePv.setStdDate(pvEquipmentModel.getTimestamp()); /*** 12.12 이우람 수정 ***/
        			deivcePvList.add(devicePv);
        			if (deivcePvList.size() == 20) {
        				resultCnt += deviceService.addDeivcePvList(deivcePvList, null);
        				deivcePvList = Lists.newArrayList();
        			}
        		}
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
