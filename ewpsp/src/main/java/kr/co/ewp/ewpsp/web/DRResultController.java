/**
 * class name : DRResultController
 * description : DR 실적 조회 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.util.DateUtil;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.Period;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.TimeType;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.UsageType;
import kr.co.ewp.ewpsp.model.CblResponseModel;
import kr.co.ewp.ewpsp.model.DrRequestTarget;
import kr.co.ewp.ewpsp.model.UsageItemModel;
import kr.co.ewp.ewpsp.model.UsageModel;
import kr.co.ewp.ewpsp.service.DRResultService;
import kr.co.ewp.ewpsp.service.KepcoMngSetService;

@Controller
public class DRResultController {

	private static final Logger logger = LoggerFactory.getLogger(DRResultController.class);

	@Resource(name="drResultService")
	private DRResultService drResultService;

	@Resource(name="kepcoMngSetService")
	private KepcoMngSetService kepcoMngSetService;

	@RequestMapping("/drResult")
	public String main() {
		logger.debug("/drResult");
		
		return "ewp/energy/drResult";
	}

	@RequestMapping("/getDRResultList")
	public @ResponseBody Map<String, Object> getDRResultList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDRResultList");
		logger.debug("param ::::: "+param.toString());
		
		List list = drResultService.getDRResultList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getCbl")
	public @ResponseBody Map<String, Object> getCbl(@RequestParam HashMap param) throws Exception {
		logger.debug("/getCbl");
		logger.debug("param ::::: "+param.toString());
		
		String cblAmtFrom = (String) param.get("cblAmtFrom");
		String cblAmtTo = (String) param.get("cblAmtTo");
		int cblAmtHourFrom = Integer.parseInt((String) param.get("cblAmtHourFrom"));
		int cblAmtHourTo = Integer.parseInt((String) param.get("cblAmtHourTo"));
		
		List cblList = new ArrayList();
		
		String cblStartFrom = (String) param.get("cblAmtFrom");
		while(cblAmtHourFrom <= cblAmtHourTo) {
			param.put("cblStartFrom", cblStartFrom);
			Map cbl = drResultService.getCbl(param);
			if(cbl != null) {
				cblList.add(cbl);
			}
			
			String startDt = cblStartFrom.substring(0, 4)+"-"+cblStartFrom.substring(4, 6)+"-"+cblStartFrom.substring(6, 8)+" "+cblStartFrom.substring(8, 10)+":"+cblStartFrom.substring(10, 12)+":"+cblStartFrom.substring(12, 14);
			Timestamp tp = Timestamp.valueOf(startDt);
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(   tp.getTime()   );
			cal.add(Calendar.HOUR, 1);
			String yyyy = Integer.toString(cal.get(Calendar.YEAR));
			String MM = ( Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1);
			String dd = ( Integer.toString(cal.get(Calendar.DATE)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE));
			String hh = ( Integer.toString(cal.get(Calendar.HOUR_OF_DAY)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.HOUR_OF_DAY)) : Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
			String mm = ( Integer.toString(cal.get(Calendar.MINUTE)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.MINUTE)) : Integer.toString(cal.get(Calendar.MINUTE));
			String ss = ( Integer.toString(cal.get(Calendar.SECOND)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.SECOND)) : Integer.toString(cal.get(Calendar.SECOND));
			cblStartFrom = yyyy+MM+dd+hh+mm+ss;
			cblAmtHourFrom++;
		}
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", cblList);
		return resultMap;
	}
	
	@RequestMapping("/searchDRApi")
	public @ResponseBody Map<String, Object> searchDRApi(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/searchDRApi");
		logger.debug("param ::::: "+param.toString());
		
		String siteId = (String) request.getSession().getAttribute("selViewSiteId");
		String selTermFrom = (String) param.get("selTermFrom");
		String selTermTo = (String) param.get("selTermTo");
		String startDate = selTermFrom.substring(0, 4)+"-"+selTermFrom.substring(4, 6)+"-"+selTermFrom.substring(6, 8)+" "+selTermFrom.substring(8, 10)+":"+selTermFrom.substring(10, 12)+":"+selTermFrom.substring(12, 14);
		String endDate = selTermTo.substring(0, 4)+"-"+selTermTo.substring(4, 6)+"-"+selTermTo.substring(6, 8)+" "+selTermTo.substring(8, 10)+":"+selTermTo.substring(10, 12)+":"+selTermTo.substring(12, 14);
		Date start = new Date((Timestamp.valueOf(startDate)).getTime());
		Date end = new Date((Timestamp.valueOf(endDate)).getTime());
		
		// dr실적 api 조회(표 데이터)
		ApiController api = new ApiController();
		List<DrRequestTarget> drResultList = api.getDrRequest(siteId, start, end);
		

		// 기준부하 api 조회
		int cblAmtHourFrom = Integer.parseInt((String) param.get("cblAmtHourFrom"));
		int cblAmtHourTo = Integer.parseInt((String) param.get("cblAmtHourTo"));
		List cblList = new ArrayList();
		
		String cblStartFrom = (String) param.get("cblAmtFrom");
		while(cblAmtHourFrom <= cblAmtHourTo) {
			String cblStartDt = cblStartFrom.substring(0, 4)+"-"+cblStartFrom.substring(4, 6)+"-"+cblStartFrom.substring(6, 8)+" "+cblStartFrom.substring(8, 10)+":"+cblStartFrom.substring(10, 12)+":"+cblStartFrom.substring(12, 14);
			Timestamp cblTp = Timestamp.valueOf(cblStartDt);
			Calendar cblCal = Calendar.getInstance();
			cblCal.setTimeInMillis(   cblTp.getTime()   );
			Date cblStart = cblCal.getTime();
//			cblCal.add(Calendar.HOUR, 1);
			cblCal.add(Calendar.MINUTE, 59);
			cblCal.add(Calendar.SECOND, 59);
			Date cblEnd = cblCal.getTime();
			CblResponseModel cbl = EnertalkApiUtil.getCBL(siteId, cblStart, cblEnd);
			if(cbl != null) {
				cblList.add(cbl);
			}
			
			String startDt = cblStartFrom.substring(0, 4)+"-"+cblStartFrom.substring(4, 6)+"-"+cblStartFrom.substring(6, 8)+" "+cblStartFrom.substring(8, 10)+":"+cblStartFrom.substring(10, 12)+":"+cblStartFrom.substring(12, 14);
			Timestamp tp = Timestamp.valueOf(startDt);
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(   tp.getTime()   );
			cal.add(Calendar.HOUR, 1);
			String yyyy = Integer.toString(cal.get(Calendar.YEAR));
			String MM = ( Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1);
			String dd = ( Integer.toString(cal.get(Calendar.DATE)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE));
			String hh = ( Integer.toString(cal.get(Calendar.HOUR_OF_DAY)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.HOUR_OF_DAY)) : Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
			String mm = ( Integer.toString(cal.get(Calendar.MINUTE)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.MINUTE)) : Integer.toString(cal.get(Calendar.MINUTE));
			String ss = ( Integer.toString(cal.get(Calendar.SECOND)).length() == 1 ) ? "0"+Integer.toString(cal.get(Calendar.SECOND)) : Integer.toString(cal.get(Calendar.SECOND));
			cblStartFrom = yyyy+MM+dd+hh+mm+ss;
			cblAmtHourFrom++;
		}
		
		// 사용량 api 조회
//		UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicBySiteId(siteId, Period._15min, start, end, TimeType.past, UsageType.positiveEnergy);
		UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicBySiteId5Min(siteId, start, end);
		List usageList = new ArrayList();
		Map<String, Object> usageMap = new HashMap<String, Object>();
		if(usageModel.getItems() != null) {
			for (UsageItemModel item : usageModel.getItems()) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("site_id", siteId);
				map.put("std_timestamp", new Timestamp(item.getTimestamp().getTime()));
				map.put("usg_val", item.getUsage().intValue());
				usageList.add(map);
			}
			usageMap = PeriodDataSetting.dataSetting(request, param, usageList, "std_timestamp", "usg_val", 1);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chartList", usageMap.get("chartList"));
//		resultMap.put("chartList", usageList);
		resultMap.put("cblList", cblList);
		resultMap.put("drResultList", drResultList);
		return resultMap;
	}
	
}
