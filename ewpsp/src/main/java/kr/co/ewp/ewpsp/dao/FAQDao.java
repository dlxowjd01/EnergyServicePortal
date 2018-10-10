package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public Map getFAQCateDetail(HashMap param) {
		Map result = sqlSession.selectOne("faq.getFAQCateDetail", param);
		return result;
	}

	public Map getFAQDetail(HashMap param) {
		Map result = sqlSession.selectOne("faq.getFAQDetail", param);
		return result;
	}

	public int insertFAQCate(HashMap param) {
		return sqlSession.insert("faq.insertFAQCate", param);
	}

	public int insertFAQ(HashMap param) {
		return sqlSession.insert("faq.insertFAQ", param);
	}

	public int updateFAQCate(HashMap param) {
		return sqlSession.update("faq.updateFAQCate", param);
	}

	public int updateFAQ(HashMap param) {
		return sqlSession.update("faq.updateFAQ", param);
	}

	public int deleteFAQCate(HashMap param) {
		return sqlSession.delete("faq.deleteFAQCate", param);
	}

	public int deleteFAQ(HashMap param) {
		return sqlSession.update("faq.deleteFAQ", param);
	}
}
