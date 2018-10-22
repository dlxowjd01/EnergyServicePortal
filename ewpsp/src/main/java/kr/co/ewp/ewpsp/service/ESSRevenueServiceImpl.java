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
		resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		
		return resultMap;
	}
	
}
