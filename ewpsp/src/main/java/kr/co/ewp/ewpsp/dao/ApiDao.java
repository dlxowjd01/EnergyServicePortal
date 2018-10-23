package kr.co.ewp.ewpsp.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.ewp.ewpsp.entity.EssUsage;
import kr.co.ewp.ewpsp.entity.Reactive;
import kr.co.ewp.ewpsp.entity.Site;
import kr.co.ewp.ewpsp.entity.SiteSet;
import kr.co.ewp.ewpsp.entity.Usage;

@Repository
public class ApiDao {

  @Autowired
  private SqlSessionTemplate sqlSession;

	public SiteSet getSiteSet(String siteId) {
		SiteSet result = sqlSession.selectOne("kr.co.ewp.api.dao.SiteSetDao.selectOne", siteId);
		return result;
	}

	public List<Usage> getUsageListBySiteId(String siteId, Date begin, Date end) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("siteId", siteId);
		param.put("begin", begin);
		param.put("end", end);
		List<Usage> resultList = sqlSession.selectList("kr.co.ewp.api.dao.UsageDao.selectListBySiteId", param);
		return resultList;
	}

	public List<Reactive> getReactiveListBySiteId(String siteId, Date begin, Date end) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("siteId", siteId);
		param.put("begin", begin);
		param.put("end", end);
		List<Reactive> resultList = sqlSession.selectList("kr.co.ewp.api.dao.ReactiveDao.selectReactiveListBySiteId", param);
		return resultList;
	}

	public List<EssUsage> getEssUsageListBySiteId(String siteId, Date begin, Date end) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("siteId", siteId);
		param.put("beginDate", begin);
		param.put("endDate", end);
		List<EssUsage> resultList = sqlSession.selectList("kr.co.ewp.api.dao.EssUsageDao.selectEssUsageListBySiteId", param);
		return resultList;
	}

	public Site getSite(String siteId) {
		Site result = sqlSession.selectOne("kr.co.ewp.api.dao.SiteDao.selectOne", siteId);
		return result;
	}

	public List<Site> getSiteList() {
		List<Site> resultList = sqlSession.selectList("kr.co.ewp.api.dao.SiteDao.EssUsageDao.selectList");
		return resultList;
	}

}
