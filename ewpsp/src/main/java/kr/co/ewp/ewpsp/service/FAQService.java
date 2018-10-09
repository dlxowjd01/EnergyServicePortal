package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface FAQService {

	List getFAQCateList();

	List getFAQList(HashMap param);

	int insertFAQ(HashMap param);

	int updateFAQ(HashMap param);

	int deleteFAQ(HashMap param);
}
