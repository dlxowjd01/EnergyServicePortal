package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.ESSRevenueDao;

@Service("essRevenueService")
public class ESSRevenueServiceImpl implements ESSRevenueService {

	@Resource(name="essRevenueDao")
	private ESSRevenueDao essRevenueDao;

	public List getESSRevenueList(HashMap param) throws Exception {
		return essRevenueDao.getESSRevenueList(param);
	}
	
}
