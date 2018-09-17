package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.ESSChrgDischrgDao;

@Service("essChrgDischrgService")
public class ESSChrgDischrgServiceImpl implements UsageService {

	@Resource(name="essChrgDischrgDao")
	private ESSChrgDischrgDao essChrgDischrgDao;

	public List getUsageRealList(HashMap param) throws Exception {
		return essChrgDischrgDao.getUsageRealList();
	}

	public List getUsageFutureList(HashMap param) throws Exception {
		return essChrgDischrgDao.getUsageFutureList();
	}
	
	
	
}
