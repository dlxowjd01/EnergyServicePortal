package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.KepcoBillDao;

@Service("kepcoBillService")
public class KepcoBillServiceImpl implements KepcoBillService {

	@Resource(name="kepcoBillDao")
	private KepcoBillDao kepcoBillDao;

	public List getKepcoBillList(HashMap param) throws Exception {
		return kepcoBillDao.getKepcoBillList(param);
	}
	
}
