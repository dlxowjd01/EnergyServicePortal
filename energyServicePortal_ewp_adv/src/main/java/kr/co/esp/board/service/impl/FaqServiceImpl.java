package kr.co.esp.board.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.board.service.FaqService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("faqService")
public class FaqServiceImpl extends EgovAbstractServiceImpl implements FaqService {

	@Resource(name="faqMapper")
	private FaqMapper faqMapper;

	@Override
	public List<Map<String, Object>> getFAQCateList() throws Exception {
		return faqMapper.getFAQCateList();
	}

	@Override
	public List<Map<String, Object>> getFAQList(Map<String, Object> param) throws Exception {
		return faqMapper.getFAQList(param);
	}

	@Override
	public Map<String, Object> getFAQCateDetail(Map<String, Object> param) throws Exception {
		return faqMapper.getFAQCateDetail(param);
	}

	@Override
	public Map<String, Object> getFAQDetail(Map<String, Object> param) throws Exception {
		return faqMapper.getFAQDetail(param);
	}

	@Override
	public int insertFAQCate(Map<String, Object> param) throws Exception {
		return faqMapper.insertFAQCate(param);
	}

	@Override
	public int insertFAQ(Map<String, Object> param) throws Exception {
		return faqMapper.insertFAQ(param);
	}

	@Override
	public int updateFAQCate(Map<String, Object> param) throws Exception {
		return faqMapper.updateFAQCate(param);
	}

	@Override
	public int updateFAQ(Map<String, Object> param) throws Exception {
		return faqMapper.updateFAQ(param);
	}

	@Override
	public Object getFAQListCnt(Map<String, Object> param) throws Exception {
		return faqMapper.getFAQListCnt(param);
	}

	@Override
	public int deleteFAQ(Map<String, Object> param) throws Exception {
		return faqMapper.deleteFAQ(param);
	}

	@Override
	public int deleteFAQCate(Map<String, Object> param) throws Exception {
		return faqMapper.deleteFAQCate(param);
	}

	//임시
	@Override
	public List<Map<String, Object>> getReferCateList() throws Exception {
		return faqMapper.getReferCateList();
	}
	@Override
	public List<Map<String, Object>> getReferList(Map<String, Object> param) throws Exception {
		return faqMapper.getReferList(param);
	}
	@Override
	public List<Map<String, Object>> getFileList(Map<String, Object> param) throws Exception {
		return faqMapper.getFileList(param);
	}
	@Override
	public int insertRefer(Map<String, Object> param) throws Exception {
		return faqMapper.insertRefer(param);
	}
	@Override
	public int insertFileCnt(Map<String, Object> param) throws Exception {
		return faqMapper.insertFileCnt(param);
	}
	@Override
	public int insertReferCate(Map<String, Object> param) throws Exception {
		return faqMapper.insertReferCate(param);
	}
	@Override
	public int getReferListCnt(Map<String, Object> param) throws Exception {
		return faqMapper.getReferListCnt(param);
	}
	@Override
	public int deleteRefer(Map<String, Object> param) throws Exception {
		return faqMapper.deleteRefer(param);
	}
	@Override
	public int deleteFiles(Map<String, Object> param) throws Exception {
		return faqMapper.deleteFiles(param);
	}
	@Override
	public int deleteReferCate(Map<String, Object> param) throws Exception {
		return faqMapper.deleteReferCate(param);
	}
	@Override
	public Map<String, Object> getReferCateDetail(Map<String, Object> param) throws Exception {
		return faqMapper.getReferCateDetail(param);
	}
	@Override
	public int updateReferCate(Map<String, Object> param) throws Exception {
		return faqMapper.updateReferCate(param);
	}
	@Override
	public Map<String, Object> getReferDetail(Map<String, Object> param) throws Exception {
		return faqMapper.getReferDetail(param);
	}
	@Override
	public List<Map<String, Object>> getReferFiles(Map<String, Object> param) throws Exception {
		return faqMapper.getReferFiles(param);
	}
	@Override
	public int updateRefer(Map<String, Object> param) throws Exception {
		return faqMapper.updateRefer(param);
	}
	@Override
	public Map<String, Object> getReferFileState(Map<String, Object> param) throws Exception {
		return faqMapper.getReferFileState(param);
	}
	@Override
	public int deleteOneFile(Map<String, Object> param) throws Exception {
		return faqMapper.deleteOneFile(param);
	}
	
}
