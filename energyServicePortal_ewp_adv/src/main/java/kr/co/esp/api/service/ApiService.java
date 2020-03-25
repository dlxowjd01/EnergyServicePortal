package kr.co.esp.api.service;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.esp.api.entity.EssCharge;
import kr.co.esp.api.entity.EssUsage;
import kr.co.esp.api.entity.Reactive;
import kr.co.esp.api.entity.Site;
import kr.co.esp.api.entity.SiteSet;
import kr.co.esp.api.entity.Usage;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service
public interface ApiService {

	SiteSet getSiteSet(String _siteId) throws Exception;

	List<Usage> getUsageListBySiteId(String _siteId, Date __begin, Date __end) throws Exception;

	List<Reactive> getReactiveListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

	List<EssUsage> getEssUsageListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

	List<EssCharge> getEssChargeListBySiteId(String _siteId, Date beginDate, Date endDate) throws Exception;

	Site getSite(String siteId) throws Exception;

	List<Site> getSiteList() throws Exception;
	
}
