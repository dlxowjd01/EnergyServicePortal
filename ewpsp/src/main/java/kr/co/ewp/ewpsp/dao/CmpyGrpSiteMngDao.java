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
		return sqlSession.selectList("cmpyGrpSiteMng.getCmpyList", param);
	}

	public int getCmpyListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getCmpyListCnt", param);
	}
	
	public List getGroupList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGroupList", param);
	}

	public int getGroupListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGroupListCnt", param);
	}
	
	public List getSiteList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getSiteList", param);
	}

	public int getSiteListCnt(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getSiteListCnt", param);
	}

	public List getGroupPopupList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGroupPopupList", param);
	}
	
	public List getGrpSiteList(Map<String, Object> param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGrpSiteList", param);
	}
	
	public List getAllSiteList(Map<String, Object> param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getAllSiteList", param);
	}

	/**
	 * 화면 상단의 사이트그룹 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getUserGroupList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getUserGroupList", param);
	}

	/**
	 * 화면 상단의 사이트 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getUserSiteList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getUserSiteList", param);
	}

	/**
	 * 군관리메인의 사이트 사용량 순위 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainSiteRankingList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGMainSiteRankingList", param);
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
	 * 군관리메인 지역별 사이트 건수 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainAreaSiteCntList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGMainAreaSiteCntList", param);
	}

	/**
	 * 군관리메인의 사이트 목록 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public List getGMainSiteList(HashMap param) {
		return sqlSession.selectList("cmpyGrpSiteMng.getGMainSiteList", param);
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
		return sqlSession.selectList("cmpyGrpSiteMng.getGMainGroupList", param);
	}

	public Map getCmpyDetail(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getCmpyDetail", param);
	}

	public int getSiteGroupIdChk(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getSiteGroupIdChk", param);
	}
	
	public Map getGroupDetail(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGroupDetail", param);
	}

	public Map getSiteDetail(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getSiteDetail", param);
	}
	
	/**
	 * 군관리메인의 사이트 사용량 순위 누적/예상 총합
	 * @author greatman
	 * @param param
	 * @return
	 */
	public Map getGMainSiteRankingTotalDetail(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteRankingTotalDetail", param);
	}

	/**
	 * 군관리메인의 사이트 사용량 총합계 조회
	 * @author greatman
	 * @param param
	 * @return
	 */
	public Map getGMainSiteTotalDetail(HashMap param) {
		return sqlSession.selectOne("cmpyGrpSiteMng.getGMainSiteTotalDetail", param);
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
