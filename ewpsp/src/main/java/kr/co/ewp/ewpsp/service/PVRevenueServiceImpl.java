package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PVRevenueDao;

@Service("pvRevenueService")
public class PVRevenueServiceImpl implements PVRevenueService {

	@Resource(name="pvRevenueDao")
	private PVRevenueDao pvRevenueDao;

	public Map getPVRevenueList(HashMap param) throws Exception {
		List list = pvRevenueDao.getPVRevenueList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("netGenValMap", null);
			resultMap.put("smpDealMap", null);
			resultMap.put("smpPriceMap", null);
			resultMap.put("recDealMap", null);
			resultMap.put("recPriceMap", null);
			resultMap.put("totPriceMap", null);
			
			return resultMap;
		} else {
			Map<String, Object> map1 = new HashMap<String, Object>();
			Map<String, Object> map2 = new HashMap<String, Object>();
			Map<String, Object> map3 = new HashMap<String, Object>();
			Map<String, Object> map4 = new HashMap<String, Object>();
			Map<String, Object> map5 = new HashMap<String, Object>();
			Map<String, Object> map6 = new HashMap<String, Object>();
			map1 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "net_gen_val", 1); // 총 발전량
			map2 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "smp_deal", 1); // SMP 거래량
			map3 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "smp_price", 1); // SMP 수익
			map4 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "rec_deal", 1); // REC 거래량
			map5 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "rec_price", 1); // REC 수익
			map6 = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "tot_price", 1); //총 수익
			
			resultMap.put("netGenValMap", map1);
			resultMap.put("smpDealMap", map2);
			resultMap.put("smpPriceMap", map3);
			resultMap.put("recDealMap", map4);
			resultMap.put("recPriceMap", map5);
			resultMap.put("totPriceMap", map6);
			
			return resultMap;
		}
		
	}
	
}
