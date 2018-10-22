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
		resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
//		resultMap.put("chartList", list);
		
		return resultMap;
	}
	
}
