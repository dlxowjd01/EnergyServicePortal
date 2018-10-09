package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("faqDao")
public class FAQDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List getFAQCateList() {
		List resultList = sqlSession.selectList("faq.getFAQCateList");
		return resultList;
	}
	
	public List getFAQList(HashMap param) {
		List resultList = sqlSession.selectList("faq.getFAQList", param);
		return resultList;
	}

	public int insertFAQ(HashMap param) {
		return sqlSession.insert("faq.insertFAQ", param);
	}

	public int updateFAQ(HashMap param) {
		return sqlSession.update("faq.updateFAQ", param);
	}

	public int deleteFAQ(HashMap param) {
		return sqlSession.update("faq.deleteFAQ", param);
	}
	
}
