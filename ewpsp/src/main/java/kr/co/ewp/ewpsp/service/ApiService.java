package kr.co.ewp.ewpsp.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.ewp.ewpsp.entity.EssCharge;
import kr.co.ewp.ewpsp.entity.EssUsage;
import kr.co.ewp.ewpsp.entity.Reactive;
import kr.co.ewp.ewpsp.entity.Site;
import kr.co.ewp.ewpsp.entity.SiteSet;
import kr.co.ewp.ewpsp.entity.Usage;

public interface ApiService {

	public SiteSet getSiteSet(String _siteId) throws Exception;

	public List<Usage> getUsageListBySiteId(String _siteId, Date __begin, Date __end) throws Exception;

	public List<Reactive> getReactiveListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

	public List<EssUsage> getEssUsageListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;
	
	public List<EssCharge> getEssChargeListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

	public Site getSite(String siteId) throws Exception;

	public List<Site> getSiteList() throws Exception;
}
