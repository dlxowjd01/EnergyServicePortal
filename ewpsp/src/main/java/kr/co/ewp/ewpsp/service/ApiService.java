package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.entity.*;

import java.util.Date;
import java.util.List;

public interface ApiService {

    public SiteSet getSiteSet(String _siteId) throws Exception;

    public List<Usage> getUsageListBySiteId(String _siteId, Date __begin, Date __end) throws Exception;

    public List<Reactive> getReactiveListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

    public List<EssUsage> getEssUsageListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

    public List<EssCharge> getEssChargeListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

    public Site getSite(String siteId) throws Exception;

    public List<Site> getSiteList() throws Exception;
}
