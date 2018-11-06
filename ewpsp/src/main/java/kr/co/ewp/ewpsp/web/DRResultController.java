/**
 * class name : DRResultController
 * description : DR 실적 조회 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

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
	
	@RequestMapping("/searchDRApi")
	public @ResponseBody Map<String, Object> searchDRApi(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/searchDRApi");
		logger.debug("param ::::: "+param.toString());
		
//		String siteId = (String) request.getSession().getAttribute("selViewSiteId");
//		String selTermFrom = (String) param.get("selTermFrom");
//		String selTermTo = (String) param.get("selTermTo");
//		String startDate = selTermFrom.substring(0, 4)+"-"+selTermFrom.substring(4, 6)+"-"+selTermFrom.substring(6, 8)+" "+selTermFrom.substring(8, 10)+":"+selTermFrom.substring(10, 12)+":"+selTermFrom.substring(12, 14);
//		String endDate = selTermTo.substring(0, 4)+"-"+selTermTo.substring(4, 6)+"-"+selTermTo.substring(6, 8)+" "+selTermTo.substring(8, 10)+":"+selTermTo.substring(10, 12)+":"+selTermTo.substring(12, 14);
//		Date start = new Date((Timestamp.valueOf(startDate)).getTime());
//		Date end = new Date((Timestamp.valueOf(endDate)).getTime());
//		System.out.println("검색일자 : "+new Timestamp(start.getTime())+", "+new Timestamp(end.getTime()));
//		
//		// dr실적 api 조회(표 데이터)
//		String siteId2 = "b910c1ab";
//		Date ed = new Date();
//		Date s = DateUtil.getAfterDays(-30);
//		ApiController api = new ApiController();
//		List<DrRequestTarget> drResultList = api.getDrRequest(siteId2, s, ed);
//		
//		// 기준부하 api 조회
//		CblResponseModel cbl = EnertalkApiUtil.getCBL(siteId, start, end);
//		
////		// 사용량 api 조회
//		UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicBySiteId(siteId, Period._15min, start, end, TimeType.past, UsageType.positiveEnergy);
//		List usageList = new ArrayList();
//		Map<String, Object> usageMap = new HashMap<String, Object>();
//		if(usageModel.getItems() != null) {
//			for (UsageItemModel item : usageModel.getItems()) {
//				Map<String, Object> map = new HashMap<String, Object>();
//				map.put("site_id", siteId);
//				map.put("std_timestamp", new Timestamp(item.getTimestamp().getTime()));
//				map.put("usg_val", item.getUsage().intValue());
//				usageList.add(map);
//			}
//			usageMap = PeriodDataSetting.dataSetting(request, param, usageList, "std_timestamp", "usg_val", 1);
//		}
//		System.out.println("ㅋㅋㅋ  "+drResultList.size()+", "+drResultList.toString());
//		System.out.println("ㅋㅋㅋ  "+cbl);
//		System.out.println("ㅋㅋㅋ  "+usageModel);
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("chartList", usageMap.get("chartList"));
////		resultMap.put("cbl", cbl);
//		resultMap.put("drResultList", drResultList);
		return resultMap;
	}
	
}
