package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("cmpyGrpSiteMngDao")
public class CmpyGrpSiteMngDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getCmpyList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getCmpyList", param);
		return resultList;
	}

	public int getCmpyListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getCmpyListCnt", param);
	}
	
	public List getGroupList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGroupList", param);
		return resultList;
	}

	public int getGroupListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGroupListCnt", param);
	}
	
	public List getSiteList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getSiteList", param);
		return resultList;
	}

	public int getSiteListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getSiteListCnt", param);
	}

	public List getGroupPopupList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGroupPopupList", param);
		return resultList;
	}
	
	public List getGrpSiteList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGrpSiteList", param);
		return resultList;
	}
	
	public List getAllSiteList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getAllSiteList", param);
		return resultList;
	}

	/**
	 * 화면 상단의 사이트그룹 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getUserGroupList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getUserGroupList", param);
		return resultList;
	}

	/**
	 * 화면 상단의 사이트 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getUserSiteList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getUserSiteList", param);
		return resultList;
	}

	/**
	 * 군관리메인의 사이트 사용량 순위 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainSiteRankingList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGMainSiteRankingList", param);
		return resultList;
	}

	/**
	 * 군관리메인의 사이트 사용량 순위 목록 갯수
	 * @author greatman
	 * @param param
	 * @return
	 */
	public int getGMainSiteRankingListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteRankingListCnt", param);
	}

	/**
	 * 군관리메인의 사이트 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainSiteList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGMainSiteList", param);
		return resultList;
	}

	/**
	 * 군관리메인의 사이트 목록 갯수
	 * @author greatman
	 * @param param
	 * @return
	 */
	public int getGMainSiteListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteListCnt", param);
	}

	/**
	 * 군관리메인의 사이트그룹 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainGroupList(HashMap param) {
		List resultList = sqlSession.selectList("cmpyGrpSiteMng.getGMainGroupList", param);
		return resultList;
	}

	public Map getCmpyDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getCmpyDetail", param);
		return result;
	}

	public int getSiteGroupIdChk(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getSiteGroupIdChk", param);
	}
	
	public Map getGroupDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getGroupDetail", param);
		return result;
	}

	public Map getSiteDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getSiteDetail", param);
		return result;
	}
	
	/**
	 * 군관리메인의 사이트 사용량 순위 누적/예상 총합
	 * @author greatman
	 * @param param
	 * @return
	 */
	public Map getGMainSiteRankingTotalDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteRankingTotalDetail", param);
		return result;
	}

	/**
	 * 군관리메인의 사이트 사용량 총합계 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public Map getGMainSiteTotalDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteTotalDetail", param);
		return result;
	}

	public int insertCmpy(HashMap param) {
		return sqlSession.insert("cmpyGrpSiteMng.insertCmpy", param);
	}
	
	public int insertGroup(HashMap param) {
		return sqlSession.insert("cmpyGrpSiteMng.insertGroup", param);
	}
	
	public int insertSite(HashMap param) {
		return sqlSession.insert("cmpyGrpSiteMng.insertSite", param);
	}
	
	public int updateCmpy(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.updateCmpy", param);
	}
	
	public int updateGroup(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.updateGroup", param);
	}
	
	public int updateSite(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.updateSite", param);
	}
	
	public int deleteCmpy(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.deleteCmpy", param);
	}
	
	public int deleteGroup(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.deleteGroup", param);
	}
	
	public int deleteSiteSet(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.deleteSiteSet", param);
	}
	
	public int deleteSite(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.deleteSite", param);
	}
	
}
