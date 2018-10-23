package kr.co.ewp.ewpsp.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.ApiDao;
import kr.co.ewp.ewpsp.entity.EssUsage;
import kr.co.ewp.ewpsp.entity.Reactive;
import kr.co.ewp.ewpsp.entity.Site;
import kr.co.ewp.ewpsp.entity.SiteSet;
import kr.co.ewp.ewpsp.entity.Usage;

@Service
public class ApiServiceImpl implements ApiService {
  @Autowired
  private ApiDao apiDao;

	@Override
	public SiteSet getSiteSet(String siteId) throws Exception {
		return apiDao.getSiteSet(siteId);
	}

	@Override
	public List<Usage> getUsageListBySiteId(String siteId, Date begin, Date end) throws Exception {
		return apiDao.getUsageListBySiteId(siteId, begin, end);
	}

	@Override
	public List<Reactive> getReactiveListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception {
		return apiDao.getReactiveListBySiteId(siteId, beginDate, endDate);
	}

	@Override
	public List<EssUsage> getEssUsageListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception {
		return apiDao.getEssUsageListBySiteId(siteId, beginDate, endDate);
	}

	@Override
	public Site getSite(String siteId) throws Exception {
		return apiDao.getSite(siteId);
	}

	@Override
	public List<Site> getSiteList() throws Exception {
		return apiDao.getSiteList();
	}
}
