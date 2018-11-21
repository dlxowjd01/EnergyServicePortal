package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.billRevenue.BillRevenueDataSetting;
import kr.co.ewp.ewpsp.dao.DRRevenueDao;

@Service("drRevenueService")
public class DRRevenueServiceImpl implements DRRevenueService {

	@Resource(name="drRevenueDao")
	private DRRevenueDao drRevenueDao;

	public Map getDRRevenueList(HashMap param) throws Exception {
		List list = drRevenueDao.getDRRevenueList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			if("day".equals((String) param.get("selPeriodVal"))) {
				resultMap = BillRevenueDataSetting.dataSetting(param, list, "reduct_sdate");
			} else {
				resultMap = BillRevenueDataSetting.dataSetting(param, list, "std_yearm");
			}
			
		}
		
		return resultMap;
	}
	
	public Map getDRRevenueTexList(HashMap param) throws Exception {
		List list = drRevenueDao.getDRRevenueTexList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", list);
		
		return resultMap;
	}
	
	public Map getDRRevenueChartList(HashMap param) throws Exception {
		List list = drRevenueDao.getDRRevenueChartList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = BillRevenueDataSetting.dataSetting(param, list, "std_yearm");
		
		return resultMap;
	}
	
}
