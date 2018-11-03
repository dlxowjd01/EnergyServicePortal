/**
 * class name : SiteMainController
 * description : 사이트메인 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.inject.internal.util.Lists;

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.DateUtil;
import kr.co.ewp.ewpsp.common.util.EncoredApiUtil;
import kr.co.ewp.ewpsp.common.util.EncoredApiUtil.Period;
import kr.co.ewp.ewpsp.common.util.ValidateUtil;
import kr.co.ewp.ewpsp.entity.Bill;
import kr.co.ewp.ewpsp.entity.EssCharge;
import kr.co.ewp.ewpsp.entity.EssUsage;
import kr.co.ewp.ewpsp.entity.Reactive;
import kr.co.ewp.ewpsp.entity.Site;
import kr.co.ewp.ewpsp.entity.SiteSet;
import kr.co.ewp.ewpsp.entity.Usage;
import kr.co.ewp.ewpsp.model.BillItemModel;
import kr.co.ewp.ewpsp.model.BillRequestModel;
import kr.co.ewp.ewpsp.model.BillResponseModel;
import kr.co.ewp.ewpsp.model.EnergyModel;
import kr.co.ewp.ewpsp.model.EssModel;
import kr.co.ewp.ewpsp.model.PeakHistoryModel;
import kr.co.ewp.ewpsp.model.PeakRequestModel;
import kr.co.ewp.ewpsp.model.PeakResponseModel;
import kr.co.ewp.ewpsp.model.ReactiveModel;
import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.ApiService;
import kr.co.ewp.ewpsp.service.ControlService;
import kr.co.ewp.ewpsp.service.DRRevenueService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.ESSChargeService;
import kr.co.ewp.ewpsp.service.ESSRevenueService;
import kr.co.ewp.ewpsp.service.PVRevenueService;

@Controller
public class SiteMainController {

	private static final Logger logger = LoggerFactory.getLogger(SiteMainController.class);

	@Resource(name="controlService")
	private ControlService controlService;

	@Resource(name="essChargeService")
	private ESSChargeService essChargeService;

	@Resource(name="essRevenueService")
	private ESSRevenueService essRevenueService;

	@Resource(name="pvRevenueService")
	private PVRevenueService pvRevenueService;

	@Resource(name="drRevenueService")
	private DRRevenueService drRevenueService;

	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;
	
	@Autowired
	private ApiService apiService;
	
	@Autowired
	private AlarmService alarmService;

	@RequestMapping("/siteMain")
	public String siteMain(@RequestParam HashMap param, HttpSession session, Model model) {
		logger.debug("/siteMain + "+param.get("siteId"));
		
		return "ewp/main/siteMain";
	}

	@RequestMapping("/getAlarmList")
	public @ResponseBody Map<String, Object> getAlarmList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getAlarmList");
		logger.debug("param ::::: "+param.toString());
//		param.put("alarmCfmYn", "N");
		
		Map result = controlService.getDeviceAlarmCnt(param); // 장치별 알람건수
		List alarmList = alarmService.getMainAlarmList(param); // 최근 알람 목록 조회(3건)
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}
	
	@RequestMapping("/getESSChargeSum")
	public @ResponseBody Map<String, Object> getESSChargeSum(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSChargeSum");
		logger.debug("param ::::: "+param.toString());
		
		Map result = essChargeService.getESSChargeSum(param); // ess 충방전량 합계 조회
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultListMap", result);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceList")
	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 8;
		int startNum = pageRowCnt*(selPageNum-1);
		
//		param.put("siteId", "");
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List deviceList = deviceMonitoringService.getDeviceList(param);
		int listCnt = deviceMonitoringService.getDeviceListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("deviceList", deviceList);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}
	
	@RequestMapping("/getRevenueList")
	public @ResponseBody Map<String, Object> getRevenueList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		String selTermFrom = (String) param.get("selTermFrom");
		String selTermTo = (String) param.get("selTermTo");
		
		// pv 수익 조회
		Date today = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(   today.getTime()   );
		cal.set(Calendar.DATE, 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		Date start = new Timestamp(cal.getTime().getTime());
		param.put("selTermFrom", CommonUtils.convertDateFormat(start, "yyyyMMddHHmmss"));
		
		Calendar cal2 = Calendar.getInstance();
		cal2.setTimeInMillis(   today.getTime()   );
		cal2.set(Calendar.DATE, cal2.getActualMaximum(Calendar.DAY_OF_MONTH));
		cal2.set(Calendar.HOUR_OF_DAY, 23);
		cal2.set(Calendar.MINUTE, 59);
		cal2.set(Calendar.SECOND, 59);
		Date end = new Timestamp(cal2.getTime().getTime());
		param.put("selTermTo", CommonUtils.convertDateFormat(end, "yyyyMMddHHmmss"));
		
		param.put("selTerm", "month");
		param.put("selPeriodVal", "day");
		logger.debug("                                   param ::::: "+param.toString());
		Map result = pvRevenueService.getPVRevenueList(param, request);
		Map totPriceMap = (Map) result.get("totPriceMap");
		List totPriceList = (totPriceMap == null) ? null : (List) totPriceMap.get("chartList");
		
		// ess 수익 조회
		String siteId = (String) param.get("siteId");
//		List essRevenueList = null;//essRevenueService.getESSRevenueList(param); // api로 변경
		List<List<Bill>> essRevenueLists = bill01(siteId, start, end);
		List<Bill> essRevenueList = null;
		if(essRevenueLists != null && essRevenueLists.size() > 0) {
			essRevenueList = (List<Bill>) essRevenueLists.get(0);
			if(essRevenueList == null || essRevenueList.size() < 1) {
				essRevenueList = null;
			}
		}
		
		// dr 수익 조회
		param.put("selTermFrom", selTermFrom.substring(0, 6));
		param.put("selTermTo", selTermTo.substring(0, 6));
		param.put("selPeriodVal", "day");
		Map drRevenueMap = drRevenueService.getDRRevenueList(param);
		List drRevenueList = (List) drRevenueMap.get("chartList");

		List loopCntList = null;
		String loopGbn = "";
		if(essRevenueList != null && essRevenueList.size() > 0) {
			loopCntList = essRevenueList;
			loopGbn = "ess";
		} else if(totPriceList != null && totPriceList.size() > 0) {
			loopCntList = totPriceList;
			loopGbn = "pv";
		} else if(drRevenueList != null && drRevenueList.size() > 0) {
			loopCntList = drRevenueList;
			loopGbn = "dr";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("essRevenueList", essRevenueList);
		resultMap.put("pvRevenueList", totPriceList);
		resultMap.put("drRevenueList", drRevenueList);
		resultMap.put("loopCntList", loopCntList);
		resultMap.put("loopGbn", loopGbn);
		return resultMap;
	}

	  /**
	   * 요금/수익 > 한전요금조회 > 요금(api 사용)
	   * 
	   * @param siteId
	   *          사이트아이디
	   * @param begin
	   *          시작일 yyyyMMdd
	   * @param end
	   *          종료일 yyyyMMdd
	   * @param prettyLog
	   * @throws ParseException
	   */
	  public List<List<Bill>> bill01(String siteId, Date begin, Date end) throws Exception {
		  logger.debug("요금/수익 > 한전요금조회 > 요금");
		List<List<Bill>> resultList = Lists.newArrayList();
	    List<Site> siteList = getSiteList(siteId);
	    if (end == null) {
	      end = new Date();
	    } 
	    logger.debug("SITE_CNT", siteList.size());
//	    Period period = Period.billingMonth;
	    Period period = Period.day; // 10.23 변경중
	    int resultCnt = 0;
	    for (Site site : siteList) {
	      String _siteId = site.getSiteId();
	      SiteSet siteSet = apiService.getSiteSet(_siteId); // 10.23 변경중
	      if (siteSet == null) {
	        logger.debug("WARN  ///  "+ _siteId + " SiteSet is null");
	        continue;
	      }

	      Long meterDay = siteSet.getMeterReadDay();

	      Date _begin = null;
	      Date _end = null;
	      Integer lastDate = null;
	      if (begin == null) {
	  		Calendar cal = Calendar.getInstance();
	  		cal.setTimeInMillis(   (new Date()).getTime()   );
//	  		cal.set(2018, 8-1, 1, 0, 0, 0);
	  		cal.set(Calendar.DATE, 1);
	  		DateUtil.truncateHms(cal);
	  		_begin = cal.getTime();
	      } else {
	    	  Calendar cal = Calendar.getInstance();
		  		cal.setTimeInMillis(   begin.getTime()   );
//		  		cal.set(2018, 8-1, 1, 0, 0, 0);
		  		cal.set(Calendar.DATE, 1);
		  		DateUtil.truncateHms(cal);
		  		_begin = cal.getTime();
	      }
	      if (end == null) {
	    	Calendar cal2 = Calendar.getInstance();
	  		cal2.setTimeInMillis(   (new Date()).getTime()   );
//	  		cal2.set(2018, 8-1, 31, 23, 59, 59);
	  		cal2.set(Calendar.DATE, cal2.getActualMaximum(Calendar.DAY_OF_MONTH));
	  		cal2.set(Calendar.HOUR, 23);
	  	    cal2.set(Calendar.MINUTE, 45);
	  	    cal2.set(Calendar.SECOND, 00);
	  		_end = cal2.getTime();
	      } else {
	    	  Calendar cal2 = Calendar.getInstance();
		  		cal2.setTimeInMillis(   end.getTime()   );
//		  		cal2.set(2018, 8-1, 31, 23, 59, 59);
		  		cal2.set(Calendar.DATE, cal2.getActualMaximum(Calendar.DAY_OF_MONTH));
		  		cal2.set(Calendar.HOUR, 23);
		  	    cal2.set(Calendar.MINUTE, 45);
		  	    cal2.set(Calendar.SECOND, 00);
		  		_end = cal2.getTime();
	      }

	      Date beginDate = _begin;
	      Date endDate = _end;
	      List<Bill> billList = Lists.newArrayList();
//	      while (true) {
//	        if (beginDate == null) {
//	          beginDate = _begin;
//	        } else {
//	          Calendar calendar = DateUtil.getCalendar(beginDate);
//	          calendar.add(Calendar.MONTH, 1);
//	          calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));//
//	          lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
//	          calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
//	          calendar.add(Calendar.DATE, 1);
//	          DateUtil.truncateHms(calendar);
//	          beginDate = calendar.getTime();// 다음달 검침일 다음날
//	        }
//	        {
//	          Calendar calendar = DateUtil.getCalendar(beginDate);
//	          calendar.add(Calendar.MONTH, 1);
//	          calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));//
//	          lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
//	          calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
//	          DateUtil.truncateHms(calendar);
//	          endDate = calendar.getTime();// 다다음달 검침날
//
//	          if (_end.getTime() < endDate.getTime()) {
//	            break;
//	          }
//	        }

	        BillRequestModel billRequest = new BillRequestModel();
	        billRequest.setMeterDay(meterDay);
	        billRequest.setContElec(siteSet.getContractPower());
	        billRequest.setPeriod(period);
//	        billRequest.setPlanName(siteSet.getPlanType());
	        billRequest.setPlanName("industrial_B_high_voltage_A_option1"); // 10.23 변경중
	        {// peakHistory
	          List<PeakHistoryModel> peakHistory = Lists.newArrayList();
	          Calendar calendar = DateUtil.getCalendar(beginDate);
	          calendar.add(Calendar.MONTH, -1);
	          calendar.set(Calendar.DATE, 1);
	          calendar.add(Calendar.YEAR, -11);
	          DateUtil.truncateHms(calendar);
	          Date __begin = calendar.getTime();
	          Calendar eCal = DateUtil.getCalendar(endDate);
	          eCal.add(Calendar.MONTH, -1);
	          eCal.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
	          DateUtil.fullHms(eCal);
	          Date __end = eCal.getTime();
	          String strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
	          String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
	          logger.debug("BEGIN = "+ strBeginDate);
	          logger.debug("END = "+ strEndDate);
	          logger.info("bill01,{},{},{}", _siteId, strBeginDate, strEndDate);
	          List<Usage> usageList = apiService.getUsageListBySiteId(_siteId, __begin, __end); // 10.23 변경중
	          if (usageList.size() > 0) {
	            PeakRequestModel peakRequest = new PeakRequestModel();
	            peakRequest.setMeterDay(meterDay);
	            peakRequest.setPeriod(Period.day); // 10.23 변경중
	            EnergyModel energy = new EnergyModel();
	            List<Long> timestamp = Lists.newArrayList();
	            List<Float> kWh = Lists.newArrayList();
	            long preTime = 0;
	            for (Usage usage : usageList) {
	              long time = usage.getStdTimestamp().getTime();
	              timestamp.add(time);
	              if (preTime != 0 && time - preTime != 900000) {
	                logger.debug("TIME-ERROR  "+ preTime + "," + time);
	              }
	              kWh.add(usage.getUsgVal() / 1000000f);
	            }
	            energy.setTimestamp(timestamp);
	            energy.setkWh(kWh);
	            peakRequest.setEnergy(energy);
	            PeakResponseModel peak = EncoredApiUtil.getPeak(peakRequest);
	            for (int i = 0; i < peak.getBasetime().size(); i++) {
	              peakHistory.add(new PeakHistoryModel(DateUtil.dateToString(new Date(peak.getBasetime().get(i)), "yyyy-MM"), peak.getkW().get(i)));
	            }
	            peakHistory.sort(new Comparator<PeakHistoryModel>() {
	              public int compare(PeakHistoryModel o1, PeakHistoryModel o2) {
	                return o1.getMonth().compareTo(o2.getMonth());
	              }
	            });
	            billRequest.setPeakHistory(peakHistory);
	          }
	        }

	        {// energy
	          EnergyModel energy = new EnergyModel();
	          List<Long> timestamp = Lists.newArrayList();
	          List<Float> kWh = Lists.newArrayList();
	          List<Usage> usageList = apiService.getUsageListBySiteId(_siteId, beginDate, endDate); // 10.23 변경중
	          for (Usage usage : usageList) {
	            timestamp.add(usage.getStdTimestamp().getTime());
	            kWh.add(usage.getUsgVal() / 1000000f);
	          }
	          energy.setTimestamp(timestamp);
	          energy.setkWh(kWh);
	          billRequest.setEnergy(energy);
	        }
	        {// reactive
	          ReactiveModel posReactive = new ReactiveModel();
	          ReactiveModel negReactive = new ReactiveModel();
	          List<Long> timestamp = Lists.newArrayList();
	          List<Float> poskWh = Lists.newArrayList();
	          List<Float> negkWh = Lists.newArrayList();
	          List<Reactive> reactiveList = apiService.getReactiveListBySiteId(_siteId, beginDate, endDate); // 10.23 변경중
	          for (Reactive re : reactiveList) {
	            timestamp.add(re.getStdTimestamp().getTime());
	            poskWh.add(re.getRctvVal() / 1000000f);
	            negkWh.add(re.getNegRctvVal() / 1000000f);
	          }
	          posReactive.setkVarh(poskWh);
	          posReactive.setTimestamp(timestamp);
	          billRequest.setReactivePos(posReactive);
	          negReactive.setkVarh(negkWh);
	          negReactive.setTimestamp(timestamp);
	          billRequest.setReactiveNeg(negReactive);
	        }
	        {// ess
	          EssModel ess = new EssModel();
	          List<Long> timestamp = Lists.newArrayList();
	          List<Float> kWh = Lists.newArrayList();
	          EssModel ess2 = new EssModel();
	          List<Float> kWh2 = Lists.newArrayList();
	          List<EssCharge> esschargeList = apiService.getEssChargeListBySiteId(_siteId, beginDate, endDate); // 10.23 변경중
//	          List<Usage> usageList = apiService.getUsageListBySiteId(_siteId, beginDate, endDate); // 10.23 변경중
	          for (EssCharge essCharge : esschargeList) {
	        	  timestamp.add(essCharge.getStdDate().getTime());
	        	  kWh.add(new Float(essCharge.getChgVal()));
	        	  kWh2.add(new Float(essCharge.getDischgVal()));
	          }
//	          for (Usage usage : usageList) {
//	            timestamp.add(usage.getStdTimestamp().getTime());
//	            kWh.add(usage.getUsgVal() / 1000000f);
//	            kWh2.add(new Float(usage.getUsgVal()));
//	          }
	          ess.setkWh(kWh);
	          ess.setTimestamp(timestamp);
	          billRequest.setEss(ess);
	          ess2.setkWh(kWh2);
	          ess2.setTimestamp(timestamp);
	          billRequest.setEssDischarging(ess2);
	        }
	        if (billRequest.getEnergy().getTimestamp().size() == 0 && billRequest.getReactivePos().getTimestamp().size() == 0 && billRequest.getReactiveNeg().getTimestamp().size() == 0 && billRequest.getEss().getTimestamp().size() == 0) {
	          continue;
	        }
	        BillResponseModel response = EncoredApiUtil.getBill(billRequest);
	        logger.debug("ITEM_SIZE "+ ((response == null) ? null : response.getItems().size()));
	        if(response != null) {
	        	for (BillItemModel item : response.getItems()) {
	        		Bill bill = new Bill();
	        		bill.setBaseRate(item.getBaseRate().intValue());
	        		bill.setBillYearm(item.getBillOfTheMonth().replaceAll("-", ""));
//	        		bill.setConsumeRate(item.getElectricityConsumptionRate().intValue());
	        		bill.setContractPower(siteSet.getContractPower().intValue());
//	        		bill.setDemandChgReduct(item.getDemandChargeReduction().intValue());
//	        		bill.setElecFund(item.getElectricityFund().intValue());
//	        		bill.setEnergyChgReduct(item.getEnergyChargeReduction().intValue());
	        		bill.setEssChgIncen(item.getEssChargingIncentive().intValue()); // ESS충전요금할인
//	        		bill.setEssChgMaxPeak(item.getEssChargingingInMaxPeak().floatValue());
//	        		bill.setEssChgMidPeak(item.getEssChargingingInMidPeak().floatValue());
//	        		bill.setEssChgOffPeak(item.getEssChargingingInOffPeak().floatValue());
	        		bill.setEssDischgIncen(item.getEssDischargingIncentive().intValue()); // ESS방전요금할인
//	        		bill.setEssDischgMaxPeak(item.getEssDischargingInMaxPeak().floatValue());
//	        		bill.setEssDischgMidPeak(item.getEssDischargingInMidPeak().floatValue());
//	        		bill.setEssDischgOffPeak(item.getEssDischargingInOffPeak().floatValue());
//	        		bill.setLagPwrFactor(item.getLaggingPowerFactor().intValue());
//	        		bill.setLeadPwrFactor(item.getLeadingPowerFactor().intValue());
//	        		bill.setMaxPeakRate(item.getOnPeakRate().intValue());
//	        		bill.setMaxPeakUsg(item.getOnPeakEnergyUsage().floatValue());
//	        		bill.setMeterReadDay(meterDay.intValue());
//	        		bill.setMidPeakRate(item.getMidPeakRate().intValue());
//	        		bill.setOffPeakRate(item.getOffPeakRate().intValue());
//	        		bill.setOffPeakUsg(item.getOffPeakEnergyUsage().floatValue());
//	        		bill.setPeakPwrDemand(item.getPeakPowerDemand().floatValue());
	        		bill.setPlanName(siteSet.getPlanName());
	        		bill.setPlanType(siteSet.getPlanType());
//	        		bill.setPwrFactorRate(item.getPowerFactorRate().intValue());
	        		bill.setSiteId(_siteId);
	        		bill.setSvcEdate(CommonUtils.convertDateFormat(new Date(item.getServicePeriodTo()), "yyyyMMdd"));
	        		bill.setSvcSdate(CommonUtils.convertDateFormat(new Date(item.getServicePeriodFrom()), "yyyyMMdd"));
//	        		bill.setSvcEdate(DateUtil.longToString(item.getServicePeriodTo(), "yyyyMMdd"));
//	        		bill.setSvcSdate(DateUtil.longToString(item.getServicePeriodFrom(), "yyyyMMdd"));
//	        		bill.setTotAmtBill(item.getTotalAmountBilled().intValue());
//	        		bill.setTotElecRate(item.getTotalElectricityRate().intValue());
//	        		bill.setUsg(item.getEnergyUsage().floatValue());
//	        		bill.setValAddTax(item.getValueAddedTax().intValue());
	        		billList.add(bill);
	        	}
	        }
//	      }
//	      resultCnt += billService.addOrModBillList(billList, null);
	      resultList.add(billList); // 10.23 변경중
	      resultCnt++;
	    }
	    logger.debug("RESULT_CNT  "+ resultCnt);
	    
	    return resultList;
	  }
	
	  private List<Site> getSiteList(String siteId) throws Exception {
	    List<Site> siteList = null;
	    if (siteId != null) {
	      siteList = Lists.newArrayList();
//	      siteList.add(siteService.getSite(siteId));
	      siteList.add(apiService.getSite(siteId)); // 10.23 변경중
	    } else {
//	      siteList = siteService.getSiteList();
	      siteList = apiService.getSiteList(); // 10.23 변경중
	      ValidateUtil.notEmpty(siteList, "사이트 목록을 찾을 수 없습니다");
	    }
	    return siteList;
	  }
	
}
