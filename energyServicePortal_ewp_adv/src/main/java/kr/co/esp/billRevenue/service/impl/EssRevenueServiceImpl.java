package kr.co.esp.billRevenue.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.billRevenue.BillRevenueDataSetting;
import kr.co.esp.billRevenue.service.EssRevenueService;

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
@Service("essRevenueService")
public class EssRevenueServiceImpl extends EgovAbstractServiceImpl implements EssRevenueService {

	@Resource(name="essRevenueMapper")
	private EssRevenueMapper essRevenueMapper;

	@Override
	public Map<String, Object> getESSRevenueList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = essRevenueMapper.getESSRevenueList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		}

		return resultMap;
	}

	@Override
	public Map<String, Object> getESSRevenueTexList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = essRevenueMapper.getESSRevenueTexList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", list);

		return resultMap;
	}

	@Override
	public List<Map<String, Object>> getESSRevenueDayList(Map<String, Object> param) throws Exception {
		return essRevenueMapper.getESSRevenueDayList(param);
	}
	
}
