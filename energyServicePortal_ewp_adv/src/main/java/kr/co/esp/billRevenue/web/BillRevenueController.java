package kr.co.esp.billRevenue.web;

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

import kr.co.esp.billRevenue.service.DrRevenueService;
import kr.co.esp.billRevenue.service.EssRevenueService;
import kr.co.esp.billRevenue.service.PvRevenueService;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.energy.PeriodDataSetting;

@Controller
public class BillRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(BillRevenueController.class);
	
	@Resource(name="essRevenueService")
	private EssRevenueService essRevenueService;
	
	@Resource(name="pvRevenueService")
	private PvRevenueService pvRevenueService;
	
	@Resource(name="drRevenueService")
	private DrRevenueService drRevenueService;

	@RequestMapping("/main/getRevenueList.json")
	public @ResponseBody Map<String, Object> getRevenueList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("main/getRevenueList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		// pv 수익 조회
		Date today = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(today.getTime());

		Date end = CommonUtils.getDate(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DATE), 23, 59, 59);
		param.put("selTermTo", CommonUtils.convertDateFormat(end, "yyyyMMddHHmmss"));
		cal.add(Calendar.DATE, -7);
		Date start = CommonUtils.getDate(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DATE), 0, 0, 0);
		param.put("selTermFrom", CommonUtils.convertDateFormat(start, "yyyyMMddHHmmss"));
		param.put("selTerm", "month");
		param.put("selPeriodVal", "day");
		logger.debug("								   param ::::: " + param.toString());
		Map<String, Object> result = pvRevenueService.getPVRevenueList(param, request);
		Map<String, Object> totPriceMap = (Map<String, Object>) result.get("totPriceMap");
		List<Map<String, Object>> totPriceList = (totPriceMap == null) ? null : (List<Map<String, Object>>) totPriceMap.get("chartList");

		// ess 수익 조회
		String siteId = (String) param.get("siteId");
		List<Map<String, Object>> essRevenueList = essRevenueService.getESSRevenueDayList(param); // api로 변경 => db조회로 변경

		// dr 수익 조회
		param.put("siteMainSelTermFrom", param.get("selTermFrom"));
		param.put("siteMainSelTermTo", param.get("selTermTo"));
		param.put("selTermFrom", null);
		param.put("selTermTo", null);
		param.put("selPeriodVal", "day");
		Map<String, Object> drRevenueMap = drRevenueService.getDRRevenueList(param);
		List<Map<String, Object>> drRevenueList = (List<Map<String, Object>>) drRevenueMap.get("chartList");

		List<Map<String, Object>> loopCntList = null;
		String loopGbn = "";
		if (essRevenueList != null && essRevenueList.size() > 0) {
			loopCntList = essRevenueList;
			loopGbn = "ess";
		} else if (totPriceList != null && totPriceList.size() > 0) {
			loopCntList = totPriceList;
			loopGbn = "pv";
		} else if (drRevenueList != null && drRevenueList.size() > 0) {
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
	
}
