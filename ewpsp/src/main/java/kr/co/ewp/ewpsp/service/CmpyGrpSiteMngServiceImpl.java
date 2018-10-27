package kr.co.ewp.ewpsp.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.dao.CmpyGrpSiteMngDao;
import kr.co.ewp.ewpsp.dao.DeviceGroupDao;
import kr.co.ewp.ewpsp.dao.KepcoMngSetDao;

@Service("cmpyGrpSiteMngService")
public class CmpyGrpSiteMngServiceImpl implements CmpyGrpSiteMngService {

	@Resource(name="cmpyGrpSiteMngDao")
	private CmpyGrpSiteMngDao cmpyGrpSiteMngDao;

	@Resource(name="kepcoMngSetDao")
	private KepcoMngSetDao kepcoMngSetDao;

	@Resource(name="deviceGroupDao")
	private DeviceGroupDao deviceGroupDao;

	public List getCmpyList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getCmpyList(param);
	}

	public int getCmpyListCnt(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getCmpyListCnt(param);
	}
	
	public List getGroupList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGroupList(param);
	}

	public int getGroupListCnt(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGroupListCnt(param);
	}
	
	public List getSiteList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getSiteList(param);
	}

	public int getSiteListCnt(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getSiteListCnt(param);
	}

	public List getGroupPopupList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGroupPopupList(param);
	}
	
	public List getGrpSiteList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGrpSiteList(param);
	}
	
	public List getAllSiteList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getAllSiteList(param);
	}

	public List getUserGroupList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getUserGroupList(param);
	}

	public List getUserSiteList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getUserSiteList(param);
	}

	public List getGMainSiteRankingList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteRankingList(param);
	}

	public int getGMainSiteRankingListCnt(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteRankingListCnt(param);
	}

	public List getGMainSiteList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteList(param);
	}

	public int getGMainSiteListCnt(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteListCnt(param);
	}

	public List getGMainGroupList(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainGroupList(param);
	}

	public Map getCmpyDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getCmpyDetail(param);
	}

	public int getSiteGroupIdChk(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getSiteGroupIdChk(param);
	}
	
	public Map getGroupDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGroupDetail(param);
	}

	public Map getSiteDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getSiteDetail(param);
	}

	public Map getGMainSiteRankingTotalDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteRankingTotalDetail(param);
	}

	public Map getGMainSiteTotalDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getGMainSiteTotalDetail(param);
	}
	
	@Transactional
	public int insertCmpy(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.insertCmpy(param);
	}
	
	@Transactional
	public int insertGroup(HashMap param) throws Exception {
		param.put("userIdx", param.get("userIdx1"));
		param.put("compIdx", param.get("selCompIdx1"));
		return cmpyGrpSiteMngDao.insertGroup(param);
	}
	
	@Transactional
	public int insertSite(HashMap param) throws Exception {
		param.put("userIdx", param.get("userIdx2"));
		param.put("compIdx", param.get("selCompIdx2"));
		param.put("siteGrpIdx", param.get("selSiteGrpIdx2"));
		int cnt = cmpyGrpSiteMngDao.insertSite(param);
		
		HashMap param2 = new HashMap();
		param2.put("siteId", param.get("siteId"));
		param2.put("userIdx", param.get("userIdx"));
		param2.put("contractPower", 0);
		param2.put("meterReadDay", 30);
		param2.put("chargeYearmd", CommonUtils.convertDateFormat(new Date(), "yyyyMMdd"));
		param2.put("chargePower", 0);
		param2.put("chargeRate", 90);
		param2.put("goalPower", 0);
		param2.put("regUid", param.get("regUid"));
		
		int cnt2 = 0;
		if(cnt > 0) cnt2 = kepcoMngSetDao.insertSiteSet(param2);
		
		return cnt;
	}
	
	@Transactional
	public int updateCmpy(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.updateCmpy(param);
	}
	
	@Transactional
	public int updateGroup(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.updateGroup(param);
	}
	
	@Transactional
	public int updateSite(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.updateSite(param);
	}
	
	@Transactional
	public int deleteCmpy(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.deleteCmpy(param);
	}
	
	@Transactional
	public int deleteGroup(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.deleteGroup(param);
	}
	
	@Transactional
	public int deleteSite(HashMap param) throws Exception {
		int delSitecnt = cmpyGrpSiteMngDao.deleteSite(param);
		
		// 장치삭제
		List<HashMap<String, Object>> deviceList = deviceGroupDao.getDvInDeviceGroupList(param);
		int delDvCnt = 0;
		if(delSitecnt > 0) {
			for (HashMap<String, Object> map : deviceList) {
				HashMap<String, Object> param2 = new HashMap<String, Object>();
				param2.put("deviceId", map.get("device_id"));
				param2.put("siteId", map.get("site_id"));
				param2.put("devicetype", map.get("device_type"));
				param2.put("modUid", param.get("modUid"));
				int cnt = deviceGroupDao.deleteDevice(param2);
				delDvCnt = delDvCnt+cnt;
			}
		}
		
		// 장치그룹 삭제
		List<HashMap<String, Object>> deviceGrpList = deviceGroupDao.getDeviceGroupList(param);
		int delDvGrpCnt = 0;
		if(delSitecnt > 0) {
			for (HashMap<String, Object> map : deviceGrpList) {
				HashMap<String, Object> param2 = new HashMap<String, Object>();
				param2.put("deviceGrpIdx", map.get("device_grp_idx"));
				param2.put("modUid", param.get("modUid"));
				int cnt = deviceGroupDao.deleteDevice(param2);
				delDvGrpCnt = delDvGrpCnt+cnt;
			}
		}
		
		int resultCnt = (delDvCnt == deviceList.size() && delDvGrpCnt == deviceGrpList.size()) ? delSitecnt : 0;
		return resultCnt;
	}
	
}
