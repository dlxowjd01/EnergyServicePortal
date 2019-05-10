package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FAQService {

	List getFAQCateList();

	List getFAQList(HashMap param);
	
	int getFAQListCnt(HashMap param);

	Map getFAQCateDetail(HashMap param);

	Map getFAQDetail(HashMap param);

	int insertFAQCate(HashMap param);

	int insertFAQ(HashMap param);

	int updateFAQCate(HashMap param);

	int updateFAQ(HashMap param);

	int deleteFAQCate(HashMap param);

	int deleteFAQ(HashMap param);
}
