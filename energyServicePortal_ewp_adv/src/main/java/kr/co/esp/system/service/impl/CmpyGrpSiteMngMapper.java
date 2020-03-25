package kr.co.esp.system.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("cmpyGrpSiteMngMapper")
public interface CmpyGrpSiteMngMapper {

	List<Map<String, Object>> getCmpyList(Map<String, Object> param) throws Exception;

	int getCmpyListCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGroupList(Map<String, Object> param) throws Exception;

	int getGroupListCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getSiteList(Map<String, Object> param) throws Exception;

	int getSiteListCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGroupPopupList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGrpSiteList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getAllSiteList(Map<String, Object> param) throws Exception;

	Map<String, Object> getCmpyDetail(Map<String, Object> param) throws Exception;

	Map<String, Object> getGroupDetail(Map<String, Object> param) throws Exception;

	Map<String, Object> getSiteDetail(Map<String, Object> param) throws Exception;

	int updateSite(Map<String, Object> param) throws Exception;

	int insertCmpy(Map<String, Object> param) throws Exception;

	int getSiteGroupIdChk(Map<String, Object> param) throws Exception;

	int insertGroup(Map<String, Object> param) throws Exception;

	int insertSite(Map<String, Object> param) throws Exception;

	int updateCmpy(Map<String, Object> param) throws Exception;

	int updateGroup(Map<String, Object> param) throws Exception;

	int deleteGroup(Map<String, Object> param) throws Exception;

	int deleteCmpy(Map<String, Object> param) throws Exception;

	int deleteSiteSet(Map<String, Object> param) throws Exception;

	int deleteSite(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getUserGroupList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getUserSiteList(Map<String, Object> param) throws Exception;

	Map<String, Object> getGMainSiteRankingTotalDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainSiteRankingList(Map<String, Object> param) throws Exception;

	int getGMainSiteRankingListCnt(Map<String, Object> param) throws Exception;

	Map<String, Object> getGMainSiteTotalDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainAreaSiteCntList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainSiteList(Map<String, Object> param) throws Exception;

	int getGMainSiteListCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainGroupList(Map<String, Object> param) throws Exception;
	
}
