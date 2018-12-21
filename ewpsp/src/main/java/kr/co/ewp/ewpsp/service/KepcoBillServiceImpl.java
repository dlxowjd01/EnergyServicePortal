package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.billRevenue.BillRevenueDataSetting;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.KepcoBillDao;

@Service("kepcoBillService")
public class KepcoBillServiceImpl implements KepcoBillService {

	@Resource(name="kepcoBillDao")
	private KepcoBillDao kepcoBillDao;

	public Map getKepcoBillList(HashMap param) throws Exception {
		List list = kepcoBillDao.getKepcoBillList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		}
		
		return resultMap;
	}
	
	public Map getKepcoTexBillList(HashMap param) throws Exception {
		List list = kepcoBillDao.getKepcoTexBillList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		resultMap.put("result", list);
		return resultMap;
	}
	
	public Map getKepcoResentBillList(HashMap param) throws Exception {
		List list = kepcoBillDao.getKepcoResentBillList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		}
		
		return resultMap;
	}
	
}
