package kr.co.esp.api.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.esp.api.entity.EssCharge;
import kr.co.esp.api.entity.EssUsage;
import kr.co.esp.api.entity.Reactive;
import kr.co.esp.api.entity.Site;
import kr.co.esp.api.entity.SiteSet;
import kr.co.esp.api.entity.Usage;

@Mapper("apiMapper")
public interface ApiMapper {

	SiteSet getSiteSet(String siteId) throws Exception;

	List<Usage> getUsageListBySiteId(String siteId, Date begin, Date end) throws Exception;

	List<Reactive> getReactiveListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception;

	List<EssUsage> getEssUsageListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception;

	List<EssCharge> getEssChargeListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception;

	Site getSite(String siteId) throws Exception;

	List<Site> getSiteList() throws Exception;
	
}
