package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.DRRevenueDao;

@Service("drRevenueService")
public class DRRevenueServiceImpl implements DRRevenueService {

	@Resource(name="drRevenueDao")
	private DRRevenueDao drRevenueDao;

	public List getDRRevenueList(HashMap param) throws Exception {
		return drRevenueDao.getDRRevenueList(param);
	}

	public List getUsageFutureList() throws Exception {
		return drRevenueDao.getUsageFutureList();
	}
	
	
	
}
