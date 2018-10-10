package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public Map getFAQCateDetail(HashMap param) {
		return faqDao.getFAQCateDetail(param);
	}

	public Map getFAQDetail(HashMap param) {
		return faqDao.getFAQDetail(param);
	}

	public int insertFAQCate(HashMap param) {
		return faqDao.insertFAQCate(param);
	}

	public int insertFAQ(HashMap param) {
		return faqDao.insertFAQ(param);
	}

	public int updateFAQCate(HashMap param) {
		return faqDao.updateFAQCate(param);
	}

	public int updateFAQ(HashMap param) {
		return faqDao.updateFAQ(param);
	}

	public int deleteFAQCate(HashMap param) {
		return faqDao.deleteFAQCate(param);
	}

	public int deleteFAQ(HashMap param) {
		return faqDao.deleteFAQ(param);
	}
}
