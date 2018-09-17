package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.DRResultDao;

@Service("drResultService")
public class DRResultServiceImpl implements DRResultService {

	@Resource(name="drResultDao")
	private DRResultDao drResultDao;

	public List getDRResultList(HashMap param) {
		return drResultDao.getDRResultList(param);
	}
	
	
	
}
