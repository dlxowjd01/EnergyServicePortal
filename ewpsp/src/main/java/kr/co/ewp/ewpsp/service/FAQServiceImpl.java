package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.FAQDao;

@Service("faqService")
public class FAQServiceImpl implements FAQService{

	@Resource(name="faqDao")
	private FAQDao faqDao;

	public List getFAQCateList() {
		return faqDao.getFAQCateList();
	}
	
	public List getFAQList(HashMap param) {
		return faqDao.getFAQList(param);
	}

	public int insertFAQ(HashMap param) {
		return faqDao.insertFAQ(param);
	}

	public int updateFAQ(HashMap param) {
		return faqDao.updateFAQ(param);
	}

	public int deleteFAQ(HashMap param) {
		return faqDao.deleteFAQ(param);
	}
}
