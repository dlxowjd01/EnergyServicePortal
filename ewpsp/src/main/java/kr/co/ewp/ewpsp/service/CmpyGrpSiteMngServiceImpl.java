package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.CmpyGrpSiteMngDao;

@Service("cmpyGrpSiteMngService")
public class CmpyGrpSiteMngServiceImpl implements CmpyGrpSiteMngService {

	@Resource(name="cmpyGrpSiteMngDao")
	private CmpyGrpSiteMngDao cmpyGrpSiteMngDao;

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

	public Map getCmpyDetail(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.getCmpyDetail(param);
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
		return cmpyGrpSiteMngDao.insertGroup(param);
	}
	
	@Transactional
	public int insertSite(HashMap param) throws Exception {
		return cmpyGrpSiteMngDao.insertSite(param);
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
		return cmpyGrpSiteMngDao.deleteSite(param);
	}
	
}
