package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CmpyGrpSiteMngService {
	
	List getCmpyList(HashMap param) throws Exception;
	
	List getGroupList(HashMap param) throws Exception;

	int getGroupListCnt(HashMap param) throws Exception;
	
	List getSiteList(HashMap param) throws Exception;

	int getSiteListCnt(HashMap param) throws Exception;

	List getGroupPopupList(HashMap param) throws Exception;
	
	List getGrpSiteList(HashMap param) throws Exception;
	
	List getAllSiteList(HashMap param) throws Exception;

	Map getGroupDetail(HashMap param) throws Exception;

	Map getSiteDetail(HashMap param) throws Exception;
	
	int insertGroup(HashMap param) throws Exception;
	
	int insertSite(HashMap param) throws Exception;
	
	int updateGroup(HashMap param) throws Exception;
	
	int updateSite(HashMap param) throws Exception;
	
	int deleteGroup(HashMap param) throws Exception;
	
	int deleteSite(HashMap param) throws Exception;

}
