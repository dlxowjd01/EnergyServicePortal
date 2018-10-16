package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
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
			resultMap.put("netGenValList", null);
			resultMap.put("smpDealList", null);
			resultMap.put("smpPriceList", null);
			resultMap.put("recDealList", null);
			resultMap.put("recPriceList", null);
			resultMap.put("totPriceList", null);
			
			return resultMap;
		} else {
			List netGenValList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "net_gen_val", 1); // 총 발전량
			List smpDealList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "smp_deal", 1); // SMP 거래량
			List smpPriceList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "smp_price", 1); // SMP 수익
			List recDealList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "rec_deal", 1); // REC 거래량
			List recPriceList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "rec_price", 1); // REC 수익
			List totPriceList = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "tot_price", 1); //총 수익
			
			resultMap.put("netGenValList", netGenValList);
			resultMap.put("smpDealList", smpDealList);
			resultMap.put("smpPriceList", smpPriceList);
			resultMap.put("recDealList", recDealList);
			resultMap.put("recPriceList", recPriceList);
			resultMap.put("totPriceList", totPriceList);
			
			return resultMap;
		}
		
	}

	public List getPVRevenueList_test(HashMap param) throws Exception {
		return pvRevenueDao.getPVRevenueList_test(param);
	}
	
	
	
}
