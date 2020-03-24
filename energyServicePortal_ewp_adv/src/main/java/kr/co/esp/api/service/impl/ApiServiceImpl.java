package kr.co.esp.api.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.alarm.service.AlarmService;
import kr.co.esp.api.service.ApiService;
import kr.co.esp.api.entity.EssCharge;
import kr.co.esp.api.entity.EssUsage;
import kr.co.esp.api.entity.Reactive;
import kr.co.esp.api.entity.Site;
import kr.co.esp.api.entity.SiteSet;
import kr.co.esp.api.entity.Usage;
import kr.co.esp.login.service.LoginService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
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
@Service("apiService")
public class ApiServiceImpl extends EgovAbstractServiceImpl implements ApiService {

	@Resource(name="apiMapper")
	private ApiMapper apiMapper;

	@Override
	public SiteSet getSiteSet(String siteId) throws Exception {
		return apiMapper.getSiteSet(siteId);
	}

	@Override
	public List<Usage> getUsageListBySiteId(String siteId, Date begin, Date end) throws Exception {
		return apiMapper.getUsageListBySiteId(siteId, begin, end);
	}

	@Override
	public List<Reactive> getReactiveListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception {
		return apiMapper.getReactiveListBySiteId(siteId, beginDate, endDate);
	}

	@Override
	public List<EssUsage> getEssUsageListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception {
		return apiMapper.getEssUsageListBySiteId(siteId, beginDate, endDate);
	}

	@Override
	public List<EssCharge> getEssChargeListBySiteId(String siteId, Date beginDate, Date endDate) throws Exception {
		return apiMapper.getEssChargeListBySiteId(siteId, beginDate, endDate);
	}

	@Override
	public Site getSite(String siteId) throws Exception {
		return apiMapper.getSite(siteId);
	}

	@Override
	public List<Site> getSiteList() throws Exception {
		return apiMapper.getSiteList();
	}
	
}
