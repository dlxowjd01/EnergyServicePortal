package kr.co.esp.system.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
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
@Service
public interface CmpyGrpSiteMngService {

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
