package kr.co.esp.billRevenue.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.billRevenue.BillRevenueDataSetting;
import kr.co.esp.billRevenue.service.KepcoBillService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("kepcoBillService")
public class KepcoBillServiceImpl extends EgovAbstractServiceImpl implements KepcoBillService {

	@Resource(name="kepcoBillMapper")
	private KepcoBillMapper kepcoBillMapper;

	@Override
	public Map<String, Object> getKepcoBillList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = kepcoBillMapper.getKepcoBillList(param);
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
	public Map<String, Object> getKepcoTexBillList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = kepcoBillMapper.getKepcoTexBillList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		//resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		resultMap.put("result", list);
		return resultMap;
	}

	@Override
	public Map<String, Object> getKepcoResentBillList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> list = kepcoBillMapper.getKepcoResentBillList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("sheetList", null);
		} else {
			resultMap = BillRevenueDataSetting.dataSetting(param, list, "bill_yearm");
		}

		return resultMap;
	}
	
}
