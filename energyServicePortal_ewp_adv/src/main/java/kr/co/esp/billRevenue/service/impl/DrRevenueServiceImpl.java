package kr.co.esp.billRevenue.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.billRevenue.BillRevenueDataSetting;
import kr.co.esp.billRevenue.service.DrRevenueService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("drRevenueService")
public class DrRevenueServiceImpl extends EgovAbstractServiceImpl implements DrRevenueService {

	@Resource(name="drRevenueMapper")
	private DrRevenueMapper drRevenueMapper;

	@Override
	public Map<String, Object> getDRRevenueList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = drRevenueMapper.getDRRevenueList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("chartList", null);
			resultMap.put("sheetList", null);
		} else {
			if ("day".equals((String) param.get("selPeriodVal"))) {
				resultMap = BillRevenueDataSetting.dataSetting(param, list, "reduct_sdate");
			} else {
				resultMap = BillRevenueDataSetting.dataSetting(param, list, "std_yearm");
			}
		}

		return resultMap;
	}

	@Override
	public Map<String, Object> getDRRevenueTexList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = drRevenueMapper.getDRRevenueTexList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", list);

		return resultMap;
	}

	@Override
	public Map<String, Object> getDRRevenueChartList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = drRevenueMapper.getDRRevenueChartList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "std_yearm");
		}

		return resultMap;
	}
	
}
