package kr.co.ewp.api.controller;

import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import kr.co.ewp.api.entity.Cbl;
import kr.co.ewp.api.entity.Device;
import kr.co.ewp.api.entity.DrResult;
import kr.co.ewp.api.entity.EssCharge;
import kr.co.ewp.api.entity.EssChargePlan;
import kr.co.ewp.api.entity.EssUsage;
import kr.co.ewp.api.entity.Peak;
import kr.co.ewp.api.entity.PredictPeak;
import kr.co.ewp.api.entity.PredictUsage;
import kr.co.ewp.api.entity.PvGen;
import kr.co.ewp.api.entity.PvUsage;
import kr.co.ewp.api.entity.Reactive;
import kr.co.ewp.api.entity.Site;
import kr.co.ewp.api.entity.SiteSet;
import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.model.CblResponseModel;
import kr.co.ewp.api.model.ChargingDischarging;
import kr.co.ewp.api.model.ChargingDischargingBefore;
import kr.co.ewp.api.model.ChargingDischargingItemModel;
import kr.co.ewp.api.model.ChargingDischargingSchedule;
import kr.co.ewp.api.model.ChargingDischargingScheduleBefore;
import kr.co.ewp.api.model.ChargingDischargingScheduleItemModel;
import kr.co.ewp.api.model.DrRequestTarget;
import kr.co.ewp.api.model.EnergyModel;
import kr.co.ewp.api.model.EssUsageModel;
import kr.co.ewp.api.model.PeakRequestModel;
import kr.co.ewp.api.model.PeakResponseModel;
import kr.co.ewp.api.model.PvPowerGenModel;
import kr.co.ewp.api.model.PvPowerGenModelBefore;
import kr.co.ewp.api.model.PvPowerGenModelItemModel;
import kr.co.ewp.api.model.UsageItemModel;
import kr.co.ewp.api.model.UsageModel;
import kr.co.ewp.api.service.DeviceService;
import kr.co.ewp.api.service.DrService;
import kr.co.ewp.api.service.EssService;
import kr.co.ewp.api.service.PvService;
import kr.co.ewp.api.service.SiteService;
import kr.co.ewp.api.service.UsageService;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EncoredApiUtil;
import kr.co.ewp.api.util.EnertalkApiUtil;
import kr.co.ewp.api.util.EnertalkApiUtil.Period;
import kr.co.ewp.api.util.EnertalkApiUtil.TimeType;
import kr.co.ewp.api.util.EnertalkApiUtil.UsageType;
import kr.co.ewp.api.util.PMGrowApiUtil;
import kr.co.ewp.api.util.PMGrowApiUtilBefore;
import kr.co.ewp.api.util.PMGrowApiUtil_omni;
import kr.co.ewp.api.util.PrettyLog;
import kr.co.ewp.api.util.ValidateUtil;

@Component
public class EnergyController {
  private Logger logger = LoggerFactory.getLogger(EnergyController.class);
  @Autowired
  private UsageService usageService;
  @Autowired
  private DeviceService deviceService;
  @Autowired
  private SiteService siteService;
  @Autowired
  private EssService essService;
  @Autowired
  private PvService pvService;
  @Autowired
  private DrService drService;

  /**
   * 에너지모니터링 > 사용량 현황 > 사용량
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
  public void energy01(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > 사용량 현황 > 사용량"); 
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
      Calendar cal = Calendar.getInstance();
      cal.setTimeInMillis(end.getTime());
      DateUtil.setHms(cal, -1, 0, 0, 000);
      end = cal.getTime();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    Period period = Period._15min;
    int resultCnt = 0;
    for (Device device : deviceList) {
      Date _begin = null;
      if (begin == null) {
//        _begin = new Date(end.getTime());
//        _begin = DateUtil.getAfterMinute(_begin, -60);
         Usage usage = usageService.getLastUage(device.getSiteId(), device.getDeviceId(), null);
         if (usage == null) {
         _begin = DateUtil.getAfterDays(-1);
         } else {
         _begin = new Date(usage.getStdTimestamp().getTime() + 1);
         }
      } else {
        _begin = begin;
      }
      if (_begin.getTime() > end.getTime()) {
        prettyLog.append("WARN", device.getDeviceId() + ":" + _begin + ">" + end);
        continue;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if(beginDate != null){
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMddHHmmss");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy01,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        List<Usage> usageList = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("1".equals(device.getInstType())) { // 에너톡
        			if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
        				UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(device.getDeviceId(), period, beginDate, endDate, TimeType.past, UsageType.positiveEnergy, prettyLog);
        				if(usageModel != null){
        					prettyLog.append("ITEM_SIZE", usageModel.getItems().size());
        				}
        				for (UsageItemModel item : usageModel.getItems()) {
        					Usage usage = new Usage();
        					usage.setDeviceId(device.getDeviceId());
        					usage.setSiteId(device.getSiteId());
        					usage.setStdDate(item.getTimestamp());
        					usage.setStdTimestamp(item.getTimestamp());
        					usage.setUsgVal(  item.getUsage() / 1000f  ); // mWh ->Wh (2019.04.10)
        					usageList.add(usage);
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy01-ERROR", e);
        }

        resultCnt += usageService.addOrModUsageList(usageList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > 사용량 현황 > 예측사용량
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
  public void energy02(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > 사용량 현황 > 예측사용량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = DateUtil.getAfterDays(1);
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    Period period = Period.hour;// 예측은 시간단위만 가능
    int resultCnt = 0;
    for (Device device : deviceList) {
      Date _begin = null;
      if (begin == null) {
        PredictUsage usage = usageService.getLastPredictUage(device.getSiteId(), device.getDeviceId(), null);
        if (usage == null) {
          _begin = new Date();
        } else {
          _begin = new Date(usage.getStdTimestamp().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      if (_begin.getTime() > end.getTime()) {
        prettyLog.append("WARN", device.getDeviceId() + ":" + _begin + ">" + end);
        continue;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy02,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        List<PredictUsage> usageList = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("1".equals(device.getInstType())) { // 에너톡
        			if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
        				UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(device.getDeviceId(), period, beginDate, endDate, TimeType.future, UsageType.positiveEnergy, prettyLog);
        				if(usageModel != null){
        					prettyLog.append("ITEM_SIZE", usageModel.getItems().size());
        					for (UsageItemModel item : usageModel.getItems()) {
        						PredictUsage predictUsage = new PredictUsage();
        						predictUsage.setDeviceId(device.getDeviceId());
        						predictUsage.setSiteId(device.getSiteId());
        						predictUsage.setStdDate(item.getTimestamp());
        						predictUsage.setStdTimestamp(item.getTimestamp());
        						predictUsage.setPreUsgVal(  item.getUsage() / 1000f  ); // mWh ->Wh (2019.04.10)
        						usageList.add(predictUsage);
        					}
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy02-ERROR", e);
        }

        resultCnt += usageService.addOrModPredictUsageList(usageList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > 사용량 현황 > 무효전력
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
  public void energy03(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > 사용량 현황 > 무효전력");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
      Calendar cal = Calendar.getInstance();
      cal.setTimeInMillis(end.getTime());
      DateUtil.setHms(cal, -1, 0, 0, 000);
      end = cal.getTime();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    Period period = Period._15min;
    int resultCnt = 0;
    for (Device device : deviceList) {
      Date _begin = null;
      if (begin == null) {
//        _begin = new Date(end.getTime());
//        _begin = DateUtil.getAfterMinute(_begin, -60);
         Reactive usage = usageService.getLastReactive(device.getSiteId(), device.getDeviceId(), null);
         if (usage == null) {
         _begin = DateUtil.getAfterDays(-1);
         } else {
         _begin = new Date(usage.getStdTimestamp().getTime() + 1);
         }
      } else {
        _begin = begin;
      }
      if (_begin.getTime() > end.getTime()) {
        prettyLog.append("WARN", device.getDeviceId() + ":" + _begin + ">" + end);
        continue;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if (beginDate != null) {
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy03,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        List<Reactive> reactiveList = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("1".equals(device.getInstType())) { // 에너톡
        			if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
        				UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(device.getDeviceId(), period, beginDate, endDate, TimeType.past, UsageType.positiveEnergyReactive, prettyLog);
        				UsageModel usageModel2 = EnertalkApiUtil.getUsagePeriodicByDeviceId(device.getDeviceId(), period, beginDate, endDate, TimeType.past, UsageType.negativeEnergyReactive, prettyLog);
        				if(usageModel != null){
        					prettyLog.append("ITEM_SIZE", usageModel.getItems().size());
        					for (UsageItemModel item : usageModel.getItems()) {
        						Reactive reactive = new Reactive();
        						reactive.setDeviceId(device.getDeviceId());
        						reactive.setSiteId(device.getSiteId());
        						reactive.setStdDate(item.getTimestamp());
        						reactive.setStdTimestamp(item.getTimestamp());
        						reactive.setRctvVal(item.getUsage() / 1000f  ); // mVarh -> Varh (2019.04.10)
        						for (UsageItemModel item2 : usageModel2.getItems()) {
        							if (item.getTimestamp().compareTo(item2.getTimestamp()) == 0) {
        								reactive.setNegRctvVal(item2.getUsage() / 1000f  ); // mVarh -> Varh (2019.04.10)
        							}
        						}
        						reactiveList.add(reactive);
        					}
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy03-ERROR", e);
        }

        resultCnt += usageService.addOrModReactiveList(reactiveList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > 피크 전력 현황 > 피크
   * 
   * @param siteId
   *          사이트아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void energy04(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > 피크 전력 현황 > 피크");
    List<Device> deviceList = getDeviceList(siteId, null, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    EncoredApiUtil.Period period = EncoredApiUtil.Period._15min;
    Map<String/* siteId */, Date/* begin */> beginMap = Maps.newHashMap();
    LinkedHashMap<String/* siteId */, LinkedHashMap<String/* 월별 */, LinkedHashMap<Long/* std_timestamp */, Float/* usg_val */>>> usageMap = Maps.newLinkedHashMap();
    int resultCnt = 0;
    for (Device device : deviceList) {
      String _siteId = device.getSiteId();
      if (!beginMap.containsKey(_siteId)) {
        Date _begin = null;
        if (begin == null) {
          Peak peak = usageService.getLastPeak(_siteId, null);
          if (peak == null) {
            _begin = DateUtil.getAfterDays(-1);
          } else {
            _begin = new Date(peak.getStdTimestamp().getTime() + 1);
          }
        } else {
          _begin = begin;
        }
        beginMap.put(_siteId, _begin);
      }

      String deviceType = device.getDeviceType();
  	  if(deviceType != null) {
  		if ("1".equals(device.getInstType())) { // 에너톡
  			if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
  				List<Usage> usageList = usageService.getUsageList(device.getDeviceId(), beginMap.get(_siteId), end, null);
  				if (usageList.size() > 0) {
  					if (!usageMap.containsKey(_siteId)) {
  						usageMap.put(_siteId, Maps.newLinkedHashMap());
  					}
  					for (Usage usage : usageList) {
  						long stdTime = usage.getStdTimestamp().getTime();
  						
  						LinkedHashMap<String, LinkedHashMap<Long, Float>> usageSiteMap = usageMap.get(_siteId);
  						String month = DateUtil.dateToString(usage.getStdDate(), "yyyyMM");
  						if (!usageSiteMap.containsKey(month)) {
  							usageSiteMap.put(month, Maps.newLinkedHashMap());
  						}
  						if (usageSiteMap.get(month).containsKey(stdTime)) {
  							usageSiteMap.get(month).put(stdTime, usageSiteMap.get(month).get(stdTime) + usage.getUsgVal());
  						} else {
  							usageSiteMap.get(month).put(stdTime, usage.getUsgVal());
  						}
  					}
  				} else {
  					prettyLog.append("WARN",
  							"usageList is empty, " + device.getDeviceId() + ", " + DateUtil.dateToString(beginMap.get(_siteId), "yyyy-MM-dd HH:mm:ss") + "~" + DateUtil.dateToString(end, "yyyy-MM-dd HH:mm:ss"));
  				}
  			}
  		}
  	  }
    }
    List<Peak> peakList = Lists.newArrayList();
    for (String _siteId : usageMap.keySet()) {
      SiteSet siteSet = siteService.getSiteSet(_siteId, null);
      long meterDay = siteSet == null ? 30 : siteSet.getMeterReadDay();
      for (String month : usageMap.get(_siteId).keySet()) {
        PeakRequestModel peakRequest = new PeakRequestModel();
        peakRequest.setMeterDay(meterDay);
        peakRequest.setPeriod(period);
        EnergyModel energy = new EnergyModel();
        List<Long> timestamp = Lists.newArrayList();
        List<Float> kWh = Lists.newArrayList();
        LinkedHashMap<Long, Float> usageSiteMap = usageMap.get(_siteId).get(month);
        for (Long stdtime : usageSiteMap.keySet()) {
          timestamp.add(stdtime);
          kWh.add(usageSiteMap.get(stdtime) / 1000f); // Wh -> kWh
        }

        energy.setTimestamp(timestamp);
        energy.setkWh(kWh);
        peakRequest.setEnergy(energy);
        try {
          PeakResponseModel peakResponse = EncoredApiUtil.getPeak(peakRequest, prettyLog);
          List<Long> basetime = peakResponse.getBasetime();
          List<Float> kW = peakResponse.getkW();
          List<Long> occured = peakResponse.getOccured();
          for (int i = 0; i < basetime.size(); i++) {
            Peak peak = new Peak();
            peak.setSiteId(_siteId);
            peak.setPeakVal(  kW.get(i)*1000f  ); // kW -> W
            peak.setStdDate(new Date(basetime.get(i)));
            peak.setStdTimestamp(new Date(basetime.get(i)));
            if(occured.get(i) != null) peak.setPeakDate(new Date(occured.get(i)));
            else peak.setPeakDate( null );
            if(occured.get(i) != null) peak.setPeakTimestamp(new Date(occured.get(i)));
            else peak.setPeakTimestamp( null );
            peakList.add(peak);
          }
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy04-ERROR", e);
        }

      }
    }
    resultCnt += usageService.addOrModPeakList(peakList, null);
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > 피크 전력 현황 > 예측피크
   * 
   * @param siteId
   *          사이트아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   */
  public void energy05(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > 피크 전력 현황 > 예측피크");
    List<Device> deviceList = getDeviceList(siteId, null, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    EncoredApiUtil.Period period = EncoredApiUtil.Period.hour;
    Map<String/* siteId */, Date/* begin */> beginMap = Maps.newHashMap();
    LinkedHashMap<String/* siteId */, LinkedHashMap<String/* 월별 */, LinkedHashMap<Long/* std_timestamp */, Float/* usg_val */>>> usageMap = Maps.newLinkedHashMap();
    for (Device device : deviceList) {
      String _siteId = device.getSiteId();
      if (!beginMap.containsKey(_siteId)) {
        Date _begin = null;
        if (begin == null) {
          PredictPeak predictPeak = usageService.getLastPredictPeak(_siteId, null);
          if (predictPeak == null) {
            _begin = DateUtil.getAfterDays(-1);
          } else {
            _begin = new Date(predictPeak.getStdTimestamp().getTime() + 1);
          }
        } else {
          _begin = begin;
        }
        beginMap.put(_siteId, _begin);
      }
      
      String deviceType = device.getDeviceType();
  	  if(deviceType != null) {
  		if ("1".equals(device.getInstType())) { // 에너톡
  			if("4".equals(deviceType) || "6".equals(deviceType) || "7".equals(deviceType) || "8".equals(deviceType)){ // 4 : 부하측정기기, 6 : ESS모니터링기기, 7 : iSmart, 8 :총량기기
  				List<PredictUsage> predictUsageList = usageService.getPredictUsageList(device.getDeviceId(), beginMap.get(_siteId), end, null);
  				if (predictUsageList.size() > 0) {
  					if (!usageMap.containsKey(_siteId)) {
  						usageMap.put(_siteId, Maps.newLinkedHashMap());
  					}
  					for (PredictUsage predictUsage : predictUsageList) {
  						long stdTime = predictUsage.getStdTimestamp().getTime();
  						LinkedHashMap<String, LinkedHashMap<Long, Float>> usageSiteMap = usageMap.get(_siteId);
  						String month = DateUtil.dateToString(predictUsage.getStdDate(), "yyyyMM");
  						if (!usageSiteMap.containsKey(month)) {
  							usageSiteMap.put(month, Maps.newLinkedHashMap());
  						}
  						if (usageSiteMap.get(month).containsKey(stdTime)) {
  							usageSiteMap.get(month).put(stdTime, usageSiteMap.get(month).get(stdTime) + predictUsage.getPreUsgVal());
  						} else {
  							usageSiteMap.get(month).put(stdTime, predictUsage.getPreUsgVal());
  						}
  					}
  				} else {
  					prettyLog.append("WARN", "preidctUsageList is empty, " + device.getDeviceId() + ", " + DateUtil.dateToString(beginMap.get(_siteId), "yyyy-MM-dd HH:mm:ss") + "~"
  							+ DateUtil.dateToString(end, "yyyy-MM-dd HH:mm:ss"));
  				}
  			}
  		}
  	  }
    }
    List<PredictPeak> predictPeakList = Lists.newArrayList();
    for (String _siteId : usageMap.keySet()) {
      SiteSet siteSet = siteService.getSiteSet(_siteId, null);
      long meterDay = siteSet == null ? 30 : siteSet.getMeterReadDay();
      for (String month : usageMap.get(_siteId).keySet()) {
        PeakRequestModel peakRequest = new PeakRequestModel();
        peakRequest.setMeterDay(meterDay);
        peakRequest.setPeriod(period);
        EnergyModel energy = new EnergyModel();
        List<Long> timestamp = Lists.newArrayList();
        List<Float> kWh = Lists.newArrayList();
        LinkedHashMap<Long, Float> usageSiteMap = usageMap.get(_siteId).get(month);
        for (Long stdtime : usageSiteMap.keySet()) {
          timestamp.add(stdtime);
          kWh.add(usageSiteMap.get(stdtime) / 1000f); // Wh -> kWh
        }

        energy.setTimestamp(timestamp);
        energy.setkWh(kWh);
        peakRequest.setEnergy(energy);
        logger.info("energy05,{},{}", new Object[] { _siteId, month });
        try {
          PeakResponseModel peakResponse = EncoredApiUtil.getPeak(peakRequest, prettyLog);
          List<Long> basetime = peakResponse.getBasetime();
          List<Float> kW = peakResponse.getkW();
          List<Long> occured = peakResponse.getOccured();
          for (int i = 0; i < basetime.size(); i++) {
            PredictPeak predictPeak = new PredictPeak();
            predictPeak.setSiteId(_siteId);
            predictPeak.setPeakVal(  kW.get(i)*1000f  ); // kW -> W
            predictPeak.setStdDate(new Date(basetime.get(i)));
            predictPeak.setStdTimestamp(new Date(basetime.get(i)));
            predictPeak.setPeakDate(new Date(occured.get(i)));
            predictPeak.setPeakTimestamp(new Date(occured.get(i)));
            predictPeakList.add(predictPeak);
          }
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy05-ERROR", e);
        }

      }
    }

    int resultCnt = usageService.addOrModPredictPeakList(predictPeakList, null);
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > ESS 충방전량 조회 > ESS충방전량
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
  public void energy06(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > ESS 충방전량 조회 > ESS충방전량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    Map<String, String> localEmsApiVerMap = Maps.newHashMap();
    for (Device device : deviceList) {
      Date _begin = null;
      String _siteId = device.getSiteId();
      if (begin == null) {
        EssCharge chargingDischarging = essService.getLastEssCharge(_siteId, device.getDeviceId(), null);
        if (chargingDischarging == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(chargingDischarging.getStdTimestamp().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if(beginDate != null){
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy06,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        if (!localEmsAddrMap.containsKey(_siteId)) {
          Site site = siteService.getSite(_siteId, prettyLog);
          if (site == null) {
            prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
            continue;
          }
          localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
          localEmsApiVerMap.put(_siteId, site.getLocalEmsApiVer());
        }
        List<EssCharge> essChargeList = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("2".equals(device.getInstType())) { // Local EMS
        			if("1".equals(deviceType) || "2".equals(deviceType)){ // 1: PCS, 2: BMS
        				if("1.1".equals(localEmsApiVerMap.get(_siteId))) { // 기존
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 ess충방전량조회 api를 조회합니다..");
        					System.out.println("                                                                    endDate4   "+endDate);
        					ChargingDischargingBefore cdList = PMGrowApiUtilBefore.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate,
        							endDate, "MI", "15", prettyLog);
        					if(cdList !=null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingItemModel item : cdList.getItems()) {
        							EssCharge essCharge = new EssCharge();
        							essCharge.setDeviceId(device.getDeviceId());
        							essCharge.setSiteId(_siteId);
        							essCharge.setStdDate(item.getTimestamp());
        							essCharge.setStdTimestamp(item.getTimestamp());
        							essCharge.setChgVal(item.getChargeEnergy());
        							essCharge.setDischgVal(item.getDischargeEnergy());
        							
        							essChargeList.add(essCharge);
        						}
        					}
//        					List<ChargingDischargingBefore_bak> cdList = PMGrowApiUtilBefore.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), DateUtil.dateToString(beginDate, "yyyyMMdd"),
//        							DateUtil.dateToString(endDate, "yyyyMMdd"), "1", "15", prettyLog);
//        					if(cdList !=null){
//        						prettyLog.append("ITEM_SIZE", cdList.size());
//        						for (ChargingDischargingBefore_bak item : cdList) {
//        							EssCharge essCharge = new EssCharge();
//        							essCharge.setDeviceId(device.getDeviceId());
//        							essCharge.setSiteId(_siteId);
//        							essCharge.setStdDate(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							essCharge.setStdTimestamp(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							essCharge.setChgVal(Integer.parseInt(item.getChargeEnergy()));
//        							essCharge.setDischgVal(Integer.parseInt(item.getDischargeEnergy()));
//        							
//        							essChargeList.add(essCharge);
//        						}
//        					}
        				} else if("1.2".equals(localEmsApiVerMap.get(_siteId))) { // api url 변경후(옴니시스템)
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 옴니시스템 새로운 ess충방전량조회 api를 조회합니다..");
        					ChargingDischarging cdList = PMGrowApiUtil_omni.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate, endDate, "MI", "15", prettyLog);
        					if(cdList !=null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingItemModel item : cdList.getItems()) {
        							EssCharge essCharge = new EssCharge();
        							essCharge.setDeviceId(device.getDeviceId());
        							essCharge.setSiteId(_siteId);
        							essCharge.setStdDate(item.getTimestamp());
        							essCharge.setStdTimestamp(item.getTimestamp());
        							essCharge.setChgVal(item.getChargeEnergy());
        							essCharge.setDischgVal(item.getDischargeEnergy());
        							
        							essChargeList.add(essCharge);
        						}
        					}
        				} else { // api url 변경후
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 ess충방전량조회 api를 조회합니다..");
        					ChargingDischarging cdList = PMGrowApiUtil.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate, endDate, "MI", "15", prettyLog);
        					if(cdList !=null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingItemModel item : cdList.getItems()) {
        							EssCharge essCharge = new EssCharge();
        							essCharge.setDeviceId(device.getDeviceId());
        							essCharge.setSiteId(_siteId);
        							essCharge.setStdDate(item.getTimestamp());
        							essCharge.setStdTimestamp(item.getTimestamp());
        							essCharge.setChgVal(item.getChargeEnergy());
        							essCharge.setDischgVal(item.getDischargeEnergy());
        							
        							essChargeList.add(essCharge);
        						}
        					}
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy06-ERROR", e);
        }
        resultCnt += essService.addOrModEssChargeList(essChargeList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > ESS 충방전량 조회 > ESS충방전계획량
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
  public void energy07(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > ESS 충방전량 조회 > ESS충방전계획량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    Map<String, String> localEmsApiVerMap = Maps.newHashMap();
    for (Device device : deviceList) {
      Date _begin = null;
      String _siteId = device.getSiteId();
      if (begin == null) {
        EssChargePlan essChargePlan = essService.getLastEssChargePlan(_siteId, device.getDeviceId(), null);
        if (essChargePlan == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(essChargePlan.getStdTimestamp().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if (beginDate != null) {
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy07,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        if (!localEmsAddrMap.containsKey(_siteId)) {
          Site site = siteService.getSite(_siteId, prettyLog);
          if (site == null) {
            prettyLog.append("WARN", _siteId + "(SITE_ID) is null");
            continue;
          }
          localEmsAddrMap.put(_siteId, site.getLocalEmsAddr());
          localEmsApiVerMap.put(_siteId, site.getLocalEmsApiVer());
        }
        List<EssChargePlan> essChargePlanList = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("2".equals(device.getInstType())) { // Local EMS
        			if("1".equals(deviceType) || "2".equals(deviceType)){ // 1: PCS, 2: BMS
        				if("1.1".equals(localEmsApiVerMap.get(_siteId))) { // 기존
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 ess충방전계획량조회 api를 조회합니다..");
        					ChargingDischargingScheduleBefore cdList = PMGrowApiUtilBefore.getEssChargePlan(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate,
        							endDate, "MI", "15", prettyLog);
        					if(cdList != null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingScheduleItemModel item : cdList.getItems()) {
        							EssChargePlan essChargePlan = new EssChargePlan();
        							essChargePlan.setDeviceId(device.getDeviceId());
        							essChargePlan.setSiteId(_siteId);
        							essChargePlan.setStdDate(item.getTimestamp());
        							essChargePlan.setStdTimestamp(item.getTimestamp());
        							essChargePlan.setChgVal(item.getScheduledCEnergy());
        							essChargePlan.setDischgVal(item.getScheduledDEnergy());
        							
        							essChargePlanList.add(essChargePlan);
        						}
        					}
//        					List<ChargingDischargingBefore> cdList = PMGrowApiUtilBefore.getEssChargePlan(localEmsAddrMap.get(_siteId), device.getDeviceId(), DateUtil.dateToString(beginDate, "yyyyMMdd"),
//        							DateUtil.dateToString(endDate, "yyyyMMdd"), "1", "15", prettyLog);
//        					if(cdList != null){
//        						prettyLog.append("ITEM_SIZE", cdList.size());
//        						for (ChargingDischargingBefore item : cdList) {
//        							EssChargePlan essChargePlan = new EssChargePlan();
//        							essChargePlan.setDeviceId(device.getDeviceId());
//        							essChargePlan.setSiteId(_siteId);
//        							essChargePlan.setStdDate(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							essChargePlan.setStdTimestamp(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							essChargePlan.setChgVal(Integer.parseInt(item.getChargeEnergy()));
//        							essChargePlan.setDischgVal(Integer.parseInt(item.getDischargeEnergy()));
//        							
//        							essChargePlanList.add(essChargePlan);
//        						}
//        					}
        				} else if("1.2".equals(localEmsApiVerMap.get(_siteId))) { // api url 변경후(옴니시스템)
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 옴니시스템 새로운 ess충방전계획량조회 api를 조회합니다..");
        					ChargingDischargingSchedule cdList = PMGrowApiUtil_omni.getEssChargePlan(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate, endDate, "MI", "15", prettyLog);
        					if(cdList != null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingScheduleItemModel item : cdList.getItems()) {
        							EssChargePlan essChargePlan = new EssChargePlan();
        							essChargePlan.setDeviceId(device.getDeviceId());
        							essChargePlan.setSiteId(_siteId);
        							essChargePlan.setStdDate(item.getTimestamp());
        							essChargePlan.setStdTimestamp(item.getTimestamp());
        							essChargePlan.setChgVal(item.getScheduledCEnergy());
        							essChargePlan.setDischgVal(item.getScheduledDEnergy());
        							
        							essChargePlanList.add(essChargePlan);
        						}
        					}
        				} else { // api url 변경후
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 ess충방전계획량조회 api를 조회합니다..");
        					ChargingDischargingSchedule cdList = PMGrowApiUtil.getEssChargePlan(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate, endDate, "MI", "15", prettyLog);
        					if(cdList != null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingScheduleItemModel item : cdList.getItems()) {
        							EssChargePlan essChargePlan = new EssChargePlan();
        							essChargePlan.setDeviceId(device.getDeviceId());
        							essChargePlan.setSiteId(_siteId);
        							essChargePlan.setStdDate(item.getTimestamp());
        							essChargePlan.setStdTimestamp(item.getTimestamp());
        							essChargePlan.setChgVal(item.getScheduledCEnergy());
        							essChargePlan.setDischgVal(item.getScheduledDEnergy());
        							
        							essChargePlanList.add(essChargePlan);
        						}
        					}
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy07-ERROR", e);
        }
        resultCnt += essService.addOrModEssChargePlanList(essChargePlanList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > PV 발전량 조회 > PV 발전량
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
  public void energy08(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
	  prettyLog.title("에너지모니터링 > PV 발전량 조회 > PV 발전량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    Map<String, String> localEmsApiVerMap = Maps.newHashMap();
    int resultCnt = 0;
    for (Device device : deviceList) {
      Date _begin = null;
      String _deviceId = device.getDeviceId();
      String _siteId = device.getSiteId();
      if (begin == null) {
        PvGen pvGen = pvService.getLastPvGen(_siteId, _deviceId, null);
        System.out.println("====    "+device.getDeviceId()+", "+pvGen);
        if (pvGen == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(pvGen.getStdDate().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if (beginDate != null) {
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy08,{},{},{}", _deviceId, strBeginDate, strEndDate);
        List<PvGen> pvGentList = Lists.newArrayList();
        try {
          String deviceType = device.getDeviceType();
          if(deviceType != null) {
        	  if ("1".equals(device.getInstType())) { // 에너톡
//        		  switch (deviceType) {
////              case "3":// PV
//        		  case "5":// PV모니터링기기
//        			  break;
//        		  default:
//        			  continue;
//        		  }
        		  if("5".equals(deviceType)){
        			  System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 에너톡 pv발전량조회 api를 조회합니다..");
        			  UsageModel usagePeriodic = EnertalkApiUtil.getUsagePeriodicByDeviceId(_deviceId, Period._15min, beginDate, endDate, TimeType.past, UsageType.positiveEnergy, prettyLog);
        			  if(usagePeriodic !=null){
        				  List<UsageItemModel> items = usagePeriodic.getItems();
        				  
        				  prettyLog.append("ITEM_SIZE", items.size());
        				  for (UsageItemModel item : items) {
        					  PvGen pvGen = new PvGen();
        					  pvGen.setDeviceId(_deviceId);
        					  pvGen.setSiteId(_siteId);
        					  pvGen.setStdDate(item.getTimestamp());
//        					  pvGen.setGenVal((float) (item.getUsage().floatValue() / 1000000.0));
        					  pvGen.setGenVal(  item.getUsage() / 1000f  ); // mWh ->Wh (2019.04.10)
        					  pvGen.setTemp(0);
        					  
        					  pvGentList.add(pvGen);
        					  System.out.println("  pvGen    "+pvGen.toString());
        				  }
        			  }
        		  }
        	  } else { // localems
        		  if("3".equals(deviceType)){
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
        				  System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 pv발전량조회 api를 조회합니다..");
        				  	PvPowerGenModelBefore resultList = PMGrowApiUtilBefore.getPvPowerGenList(localEmsAddrMap.get(_siteId), _deviceId, beginDate,
        				  				endDate, "MI", "15", prettyLog);
        				  if(resultList != null){
        					  prettyLog.append("ITEM_SIZE", resultList.getItems().size());
        					  for (PvPowerGenModelItemModel item : resultList.getItems()) {
        						  PvGen pvGen = new PvGen();
        						  pvGen.setDeviceId(_deviceId);
        						  pvGen.setSiteId(_siteId);
        						  pvGen.setStdDate(item.getTimestamp());
        						  pvGen.setGenVal(item.getGenEnergy().floatValue());
        						  pvGen.setTemp(item.getTemperature());
        						  
        						  pvGentList.add(pvGen);
        					  }
//        					  List<PvPowerGenModelBefore> resultList = PMGrowApiUtilBefore.getPvPowerGenList(localEmsAddrMap.get(_siteId), _deviceId, beginDate,
//        							  endDate, "1", "15", prettyLog);
//        					  if(resultList != null){
//        						  prettyLog.append("ITEM_SIZE", resultList.size());
//        						  for (PvPowerGenModelBefore item : resultList) {
//        							  PvGen pvGen = new PvGen();
//        							  pvGen.setDeviceId(_deviceId);
//        							  pvGen.setSiteId(_siteId);
//        							  pvGen.setStdDate(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							  pvGen.setGenVal(Integer.parseInt(item.getGenEnergy()));
//        							  pvGen.setTemp(Integer.parseInt(item.getTemperature()));
//        							  
//        							  pvGentList.add(pvGen);
//        						  }
        				  }//
        			  } else if("1.2".equals(localEmsApiVerMap.get(_siteId))) { // api url 변경후(옴니시스템)
      					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 옴니시스템 새로운 pv발전량조회 api를 조회합니다..");
      					PvPowerGenModel resultList = PMGrowApiUtil_omni.getPvPowerGenList(localEmsAddrMap.get(_siteId), _deviceId, beginDate, endDate, "MI", "15", prettyLog);
	      				  if(resultList != null){
	      					  prettyLog.append("ITEM_SIZE", resultList.getItems().size());
	      					  for (PvPowerGenModelItemModel item : resultList.getItems()) {
	      						  PvGen pvGen = new PvGen();
	      						  pvGen.setDeviceId(_deviceId);
	      						  pvGen.setSiteId(_siteId);
	      						  pvGen.setStdDate(item.getTimestamp());
	      						  pvGen.setGenVal(item.getGenEnergy().floatValue());
	      						  pvGen.setTemp(item.getTemperature());
	      						  
	      						  pvGentList.add(pvGen);
	      					  }
	      				  }//
        			  } else { // api url 변경후
        				  System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 pv발전량조회 api를 조회합니다..");
        				  PvPowerGenModel resultList = PMGrowApiUtil.getPvPowerGenList(localEmsAddrMap.get(_siteId), _deviceId, beginDate, endDate, "MI", "15", prettyLog);
        				  if(resultList != null){
        					  prettyLog.append("ITEM_SIZE", resultList.getItems().size());
        					  for (PvPowerGenModelItemModel item : resultList.getItems()) {
        						  PvGen pvGen = new PvGen();
        						  pvGen.setDeviceId(_deviceId);
        						  pvGen.setSiteId(_siteId);
        						  pvGen.setStdDate(item.getTimestamp());
        						  pvGen.setGenVal(item.getGenEnergy().floatValue());
        						  pvGen.setTemp(item.getTemperature());
        						  
        						  pvGentList.add(pvGen);
        					  }
        				  }//
        			  }
        		  }
    		  }
          }
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy08-ERROR", e);
        }
        resultCnt += pvService.addOrModPvGenList(pvGentList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > DR 실적조회 > DR 실적(감축이력)
   * 
   * @param siteId
   *          사이트아이디
   * @param prettyLog
   */
  public void energy09(String siteId, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > DR 실적조회 > DR 실적(감축이력)");
    List<Site> siteList = getSiteList(siteId, prettyLog);
    int resultCnt = 0;
    int offset = 0;
    int limit = 50;
    for (Site site : siteList) {
      String _siteId = site.getSiteId();
      List<DrResult> drResultList = Lists.newArrayList();
      try {
        List<DrRequestTarget> resultList = EnertalkApiUtil.getDrRequest(_siteId, offset, limit, prettyLog);
        SiteSet siteSet = siteService.getSiteSet(_siteId, prettyLog);
        if(resultList !=null){
        	
        	for (DrRequestTarget item : resultList) {
        		DrResult drResult = new DrResult();
        		drResult.setActAmt(  item.getActualAmount() / 1000f  ); // mWh ->Wh (2019.04.10)
        		drResult.setCblAmt(  item.getCblAmount() / 1000f  ); // mWh ->Wh (2019.04.10)
        		if (siteSet == null) {
        			drResult.setContractPower(0L);
        			drResult.setGoalPower(0L);
        		} else {
        			drResult.setContractPower(siteSet.getContractPower());
        			drResult.setGoalPower(siteSet.getGoalPower());
        		}
        		drResult.setEndDate(item.getRequest().getEnd());
        		drResult.setEndTimestamp(item.getRequest().getEnd());
        		drResult.setRewardAmt(item.getRewardAmount());
        		drResult.setSiteId(siteId);
        		drResult.setStartDate(item.getRequest().getStart());
        		drResult.setStartTimestamp(item.getRequest().getStart());
        		drResultList.add(drResult);
        	}
        }
      } catch (NullPointerException e) {
      	logger.error("error is : "+e.toString());
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("energy09-ERROR", e);
      }
      resultCnt += drService.addOrModDrReusltList(drResultList, null);
    }

    
    Date today = new Date();
    for (Site site : siteList) {
      String _siteId = site.getSiteId();
      Calendar cal = Calendar.getInstance();
      cal.setTimeInMillis(today.getTime());
      Calendar cal2 = Calendar.getInstance();
      cal2.setTimeInMillis(today.getTime());

      DateUtil.setHms(cal, -1, 0, 0, 000);
      cal.add(Calendar.HOUR, -1);
      DateUtil.setHms(cal2, -1, 59, 59, 999);
      cal2.add(Calendar.HOUR, -1);
      
      try {
		for(int i=0; i<7; i++) {
			  Date start = new Date(cal.getTime().getTime());
			  Date end = new Date(cal2.getTime().getTime());
			  CblResponseModel cblModel = EnertalkApiUtil.getCBL(_siteId, start, end, prettyLog);
			  if (cblModel != null) {
		        Cbl cbl = new Cbl();
		        cbl.setSiteId(_siteId);
		        cbl.setStartTimestamp(cblModel.getStart());
		        cbl.setStartDate(cblModel.getStart());
		        cbl.setEndTimestamp(cblModel.getEnd());
		        cbl.setEndDate(cblModel.getEnd());
		        cbl.setCbl(  cblModel.getCbl().intValue() / 1000f  ); // mWh ->Wh (2019.04.10)
		        cbl.setCml(  cblModel.getCml().intValue() / 1000f  ); // mWh ->Wh (2019.04.10)
		        drService.addOrModCbl(cbl, null);
		      }
			  cal.add(Calendar.HOUR, 1);
			  cal2.add(Calendar.HOUR, 1);
		  }
	    } catch (NullPointerException e) {
	      	logger.error("error is : "+e.toString());
		} catch (Exception e) {
			prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
	        logger.error("energy09-ERROR", e);
		}
    }

    prettyLog.append("SITE_CNT", siteList.size());
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > ESS/PV 사용량 구성 > ESS 사용량(현재 미사용, 스케줄러 주석처리함)
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
  public void energy10(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > ESS/PV 사용량 구성 > ESS 사용량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    int resultCnt = 0;
    Map<String, String> localEmsAddrMap = Maps.newHashMap();
    for (Device device : deviceList) {
      Date _begin = null;
      String _siteId = device.getSiteId();
      if (begin == null) {
        EssUsage essUsage = essService.getLastEssUsage(_siteId, device.getDeviceId(), prettyLog);
        if (essUsage == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(essUsage.getStdDate().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if(beginDate != null){
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy10,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
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
        List<EssUsage> essUsageModel = Lists.newArrayList();
        try {
        	String deviceType = device.getDeviceType();
        	if(deviceType != null) {
        		if ("2".equals(device.getInstType())) { // Local EMS
        			if("1".equals(deviceType) || "2".equals(deviceType)){ // 1: PCS, 2: BMS
        				if("1.1".equals(apiVer)) { // 기존
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 기존 ess사용량조회 api를 조회합니다..");
        					ChargingDischargingBefore cdList = PMGrowApiUtilBefore.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate,
        							endDate, "MI", "15", prettyLog);
        					if(cdList != null){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingItemModel item : cdList.getItems()) {
        							EssUsage essUsage = new EssUsage();
        							essUsage.setDeviceId(device.getDeviceId());
        							essUsage.setSiteId(_siteId);
        							essUsage.setStdDate(item.getTimestamp());
        							essUsage.setUsgVal(item.getDischargeEnergy());
        							
        							essUsageModel.add(essUsage);
        						}
        					}
//        					List<EssUsageModel> resultList = PMGrowApiUtilBefore.getEssUsageList(localEmsAddrMap.get(_siteId), device.getDeviceId(), DateUtil.dateToString(beginDate, "yyyyMMdd"),
//        							DateUtil.dateToString(endDate, "yyyyMMdd"), "1", "15", prettyLog);
//        					if( resultList != null ){
//        						prettyLog.append("ITEM_SIZE", resultList.size());
//        						for (EssUsageModel item : resultList) {
//        							EssUsage essUsage = new EssUsage();
//        							essUsage.setDeviceId(device.getDeviceId());
//        							essUsage.setSiteId(_siteId);
//        							essUsage.setStdDate(DateUtil.stringToDate(item.getRetrieveTime(), "yyyyMMddHHmmss"));
//        							essUsage.setUsgVal(Float.parseFloat(item.getPowerUsage()));
//        							
//        							essUsageModel.add(essUsage);
//        						}
//        					}
        				} else { // api url 변경후
        					System.out.println("  siteId : "+_siteId+", deviceId : "+device.getDeviceId()+", deviceType : "+device.getDeviceType()+" - 새로운 ess사용량조회 api를 조회합니다..");
        					ChargingDischarging cdList = PMGrowApiUtil.getEssCharge(localEmsAddrMap.get(_siteId), device.getDeviceId(), beginDate, endDate, "MI", "15", prettyLog);
        					if( cdList != null ){
        						prettyLog.append("ITEM_SIZE", cdList.getItems().size());
        						for (ChargingDischargingItemModel item : cdList.getItems()) { /*** 12.13 이우람 수정(ess방전량을 ess사용량으로 합의함) ***/
        							EssUsage essUsage = new EssUsage();
        							essUsage.setDeviceId(device.getDeviceId());
        							essUsage.setSiteId(_siteId);
        							essUsage.setStdDate(item.getTimestamp());
        							essUsage.setUsgVal(item.getDischargeEnergy());
        							
        							essUsageModel.add(essUsage);
        						}
        					}
        				}
        			}
        		}
        	}
        } catch (NullPointerException e) {
        	logger.error("error is : "+e.toString());
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy11-ERROR", e);
        }
        resultCnt += essService.addOrModEssUsageList(essUsageModel, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * 에너지모니터링 > ESS/PV 사용량 구성 > PV 사용량(현재 미사용, 스케줄러 미존재)
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
  public void energy11(String siteId, String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("에너지모니터링 > ESS/PV 사용량 구성 > PV 사용량");
    List<Device> deviceList = getDeviceList(siteId, deviceId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    Period period = Period._15min;
    int resultCnt = 0;
    for (Device device : deviceList) {
      Date _begin = null;
      if (begin == null) {
        PvUsage pvUsage = pvService.getLastPvUsage(device.getSiteId(), device.getDeviceId(), null);
        if (pvUsage == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(pvUsage.getStdTimestamp().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = "";
        if(beginDate != null){
        	strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        }
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("energy11,{},{},{}", device.getDeviceId(), strBeginDate, strEndDate);
        UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(device.getDeviceId(), period, beginDate, endDate, TimeType.past, UsageType.negativeEnergy, prettyLog);
        List<PvUsage> pvUsageList = Lists.newArrayList();
        for (UsageItemModel item : usageModel.getItems()) {
          PvUsage pvUsage = new PvUsage();
          pvUsage.setDeviceId(device.getDeviceId());
          pvUsage.setSiteId(device.getSiteId());
          pvUsage.setStdDate(item.getTimestamp());
          pvUsage.setStdTimestamp(item.getTimestamp());
          pvUsage.setUsgVal(item.getUsage().intValue());
          pvUsageList.add(pvUsage);
        }
        resultCnt += pvService.addOrModPvUsageList(pvUsageList, null);
      }
    }
    prettyLog.append("DEVICE_CNT", deviceList.size());
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  private List<Device> getDeviceList(String siteId, String deviceId, PrettyLog prettyLog) {
    List<Device> deviceList = null;
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

  private List<Site> getSiteList(String siteId, PrettyLog prettyLog) {
    List<Site> siteList = null;
    if (siteId != null) {
      siteList = Lists.newArrayList();
      siteList.add(siteService.getSite(siteId, prettyLog));
    } else {
      siteList = siteService.getSiteList(prettyLog);
      ValidateUtil.notEmpty(siteList, "사이트 목록을 찾을 수 없습니다");
    }
    return siteList;
  }
}
