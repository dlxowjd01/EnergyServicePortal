package kr.co.esp.system.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.device.service.impl.DeviceGroupMapper;
import kr.co.esp.system.service.CmpyGrpSiteMngService;

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
@Service("cmpyGrpSiteMngService")
public class CmpyGrpSiteMngServiceImpl extends EgovAbstractServiceImpl implements CmpyGrpSiteMngService {

	@Resource(name="cmpyGrpSiteMngMapper")
	private CmpyGrpSiteMngMapper cmpyGrpSiteMngMapper;
	
	@Resource(name="kepcoMngMapper")
	private KepcoMngMapper kepcoMngMapper;
	
	@Resource(name="deviceGroupMapper")
	private DeviceGroupMapper deviceGroupMapper;
	
	@Override
	public List<Map<String, Object>> getCmpyList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getCmpyList(param);
	}
	
	@Override
	public int getCmpyListCnt(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getCmpyListCnt(param);
	}
	
	@Override
	public List<Map<String, Object>> getGroupList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGroupList(param);
	}
	
	@Override
	public int getGroupListCnt(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGroupListCnt(param);
	}
	
	@Override
	public List<Map<String, Object>> getSiteList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getSiteList(param);
	}
	
	@Override
	public int getSiteListCnt(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getSiteListCnt(param);
	}
	
	@Override
	public List<Map<String, Object>> getGroupPopupList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGroupPopupList(param);
	}
	
	@Override
	public List<Map<String, Object>> getGrpSiteList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGrpSiteList(param);
	}
	
	@Override
	public List<Map<String, Object>> getAllSiteList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getAllSiteList(param);
	}
	
	@Override
	public Map<String, Object> getCmpyDetail(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getCmpyDetail(param);
	}
	
	@Override
	public Map<String, Object> getGroupDetail(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGroupDetail(param);
	}
	
	@Override
	public Map<String, Object> getSiteDetail(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getSiteDetail(param);
	}
	
	@Override
	public int updateSite(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.updateSite(param);
	}
	
	@Override
	public int insertCmpy(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.insertCmpy(param);
	}
	
	@Override
	public int getSiteGroupIdChk(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getSiteGroupIdChk(param);
	}
	
	@Override
	public int insertGroup(Map<String, Object> param) throws Exception {
		param.put("userIdx", param.get("userIdx1"));
		param.put("compIdx", param.get("selCompIdx1"));
		return cmpyGrpSiteMngMapper.insertGroup(param);
	}
	
	@Override
	public int insertSite(Map<String, Object> param) throws Exception {
		param.put("userIdx", param.get("userIdx2"));
		param.put("compIdx", param.get("selCompIdx2"));
		param.put("siteGrpIdx", param.get("selSiteGrpIdx2"));
		int cnt = cmpyGrpSiteMngMapper.insertSite(param);
		
		Map<String, Object> param2 = new HashMap<String,Object>();
		param2.put("siteId", param.get("siteId"));
		param2.put("userIdx", param.get("userIdx"));
		param2.put("contractPower", 0);
		param2.put("meterReadDay", 30);
		param2.put("chargeYearmd", CommonUtils.convertDateFormat(new Date(), "yyyyMMdd"));
		param2.put("chargePower", 0);
		param2.put("chargeRate", 90);
		param2.put("goalPower", 0);
		param2.put("regUid", param.get("regUid"));
		param2.put("meterClaimDay", 10);
		param2.put("recRateDate", CommonUtils.convertDateFormat(new Date(), "yyyyMMdd"));
		param2.put("smpRateDate", CommonUtils.convertDateFormat(new Date(), "yyyyMMdd"));
		
		int cnt2 = 0;
		if(cnt > 0) cnt2 = kepcoMngMapper.insertSiteSet(param2);
		
		return cnt;
	}
	
	@Override
	public int updateCmpy(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.updateCmpy(param);
	}
	
	@Override
	public int updateGroup(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.updateGroup(param);
	}
	
	@Override
	public int deleteGroup(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.deleteGroup(param);
	}
	
	@Override
	public int deleteCmpy(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.deleteCmpy(param);
	}
	
	@Override
	public int deleteSite(Map<String, Object> param) throws Exception {
		// 장치삭제
		List<Map<String, Object>> deviceList = deviceGroupMapper.getDvInDeviceGroupList(param);
		int delDvCnt = 0;
		if(deviceList.size() > 0) {
			for (Map<String, Object> map : deviceList) {
				Map<String, Object> param2 = new HashMap<String, Object>();
				param2.put("deviceId", map.get("device_id"));
				param2.put("siteId", map.get("site_id"));
				param2.put("deviceType", map.get("device_type"));
				param2.put("modUid", param.get("modUid"));
				int cnt = deviceGroupMapper.deleteDevice(param2);
				delDvCnt = delDvCnt+cnt;
			}
		}
		
		// 장치그룹 삭제
		List<Map<String, Object>> deviceGrpList = deviceGroupMapper.getDeviceGroupList(param);
		int delDvGrpCnt = 0;
		if(deviceGrpList.size() > 0) {
			for (Map<String, Object> map : deviceGrpList) {
				Map<String, Object> param2 = new HashMap<String, Object>();
				param2.put("deviceGrpIdx", map.get("device_grp_idx"));
				param2.put("modUid", param.get("modUid"));
				int cnt = deviceGroupMapper.deleteDeviceGroup(param2);
				delDvGrpCnt = delDvGrpCnt+cnt;
			}
		}
		
		int delSiteSetCnt = cmpyGrpSiteMngMapper.deleteSiteSet(param);
		int delSiteCnt = cmpyGrpSiteMngMapper.deleteSite(param);
		
		int resultCnt = (delDvCnt == deviceList.size() && delDvGrpCnt == deviceGrpList.size()) ? delSiteCnt : 0;
		return resultCnt;
	}

	@Override
	public List<Map<String, Object>> getUserGroupList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getUserGroupList(param);
	}

	@Override
	public List<Map<String, Object>> getUserSiteList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getUserSiteList(param);
	}

	@Override
	public Map<String, Object> getGMainSiteRankingTotalDetail(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteRankingTotalDetail(param);
	}

	@Override
	public List<Map<String, Object>> getGMainSiteRankingList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteRankingList(param);
	}

	@Override
	public int getGMainSiteRankingListCnt(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteRankingListCnt(param);
	}

	@Override
	public Map<String, Object> getGMainSiteTotalDetail(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteTotalDetail(param);
	}

	@Override
	public List<Map<String, Object>> getGMainAreaSiteCntList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainAreaSiteCntList(param);
	}

	@Override
	public List<Map<String, Object>> getGMainSiteList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteList(param);
	}

	@Override
	public int getGMainSiteListCnt(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainSiteListCnt(param);
	}

	@Override
	public List<Map<String, Object>> getGMainGroupList(Map<String, Object> param) throws Exception {
		return cmpyGrpSiteMngMapper.getGMainGroupList(param);
	}
	
}
