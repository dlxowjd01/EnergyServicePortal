package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.billRevenue.BillRevenueDataSetting;
import kr.co.ewp.ewpsp.dao.ESSRevenueDao;

@Service("essRevenueService")
public class ESSRevenueServiceImpl implements ESSRevenueService {

	@Resource(name="essRevenueDao")
	private ESSRevenueDao essRevenueDao;

	public Map getESSRevenueList(HashMap param) throws Exception {
		List list = essRevenueDao.getESSRevenueList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		}
		
		return resultMap;
	}
	
	public Map getESSRevenueTexList(HashMap param) throws Exception {
		List list = essRevenueDao.getESSRevenueTexList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",list);
		
		return resultMap;
	}

	public List getESSRevenueDayList(HashMap param) throws Exception {
		List list = essRevenueDao.getESSRevenueDayList(param);
		return list;
	}
	
}
