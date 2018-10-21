package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.KepcoMngSetDao;

@Service("kepcoMngSetService")
public class KepcoMngSetServiceImpl implements KepcoMngSetService {

	@Resource(name="kepcoMngSetDao")
	private KepcoMngSetDao kepcoMngSetDao;

	public Map getSiteSetDetail(HashMap param) throws Exception {
		return kepcoMngSetDao.getSiteSetDetail(param);
	}

	public List getPlanType(HashMap param) throws Exception {
		return kepcoMngSetDao.getPlanType(param);
	}
	
	@Transactional
	public int updateSiteSet(HashMap param) throws Exception {
		return kepcoMngSetDao.updateSiteSet(param);
	}
	
}
