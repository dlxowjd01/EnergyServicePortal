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

	public Map getCmpyDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getCmpyDetail", param);
		return result;
	}
	
	public Map getGroupDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getGroupDetail", param);
		return result;
	}

	public Map getSiteDetail(HashMap param) {
		Map result = sqlSession.selectOne("cmpyGrpSiteMng.getSiteDetail", param);
		return result;
	}
	
	public int insertCmpy(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.insertCmpy", param);
	}
	
	public int insertGroup(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.insertGroup", param);
	}
	
	public int insertSite(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.insertSite", param);
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
	
	public int deleteSite(HashMap param) {
		return sqlSession.update("cmpyGrpSiteMng.deleteSite", param);
	}
	
}
