/**
 * class name : FaqController
 * description : 자주하는 질문 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.service.FAQService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class FaqController {

    private static final Logger logger = LoggerFactory.getLogger(FaqController.class);

    @Resource(name = "faqService")
    private FAQService faqService;

    @RequestMapping("/faq")
    public String faq(Model model) {
        logger.debug("/faq");

        HashMap param = new HashMap();

        List cateList = faqService.getFAQCateList();
        model.addAttribute("faqCateList", cateList);

        return "ewp/service/faq";
    }


    /**
     * FAQ 카테고리 목록 조회
     *
     * @return
     * @author greatman
     */
    @RequestMapping("/getFAQCateList")
    public @ResponseBody
    Map<String, Object> getFAQCateList() throws Exception {
        logger.debug("/getFAQCateList");

        List list = faqService.getFAQCateList();

        Map resultMap = new HashMap();
        resultMap.put("list", list);
        return resultMap;
    }

    /**
     * FAQ 목록 조회
     *
     * @param param
     * @return
     * @throws Exception
     * @author greatman
     */
    @RequestMapping("/getFAQList")
    public @ResponseBody
    Map<String, Object> getFAQList(@RequestParam HashMap param) throws Exception {
        logger.debug("/getFAQList");
        logger.debug("param : {}", param);

        List list = faqService.getFAQList(param);

        Map resultMap = new HashMap();
        resultMap.put("list", list);
        return resultMap;
    }

    /**
     * FAQ 카테고리 한건 조회
     *
     * @param param
     * @return
     * @throws Exception
     * @author greatman
     */
    @RequestMapping("/getFAQCateDetail")
    public @ResponseBody
    Map<String, Object> getFAQCateDetail(@RequestParam HashMap param) throws Exception {
        logger.debug("/getFAQCateDetail");
        logger.debug("param : {}", param);

        Map result = faqService.getFAQCateDetail(param);

        Map resultMap = new HashMap();
        resultMap.put("detail", result);
        return resultMap;
    }

    /**
     * FAQ 한건 조회
     *
     * @param param
     * @return
     * @throws Exception
     * @author greatman
     */
    @RequestMapping("/getFAQDetail")
    public @ResponseBody
    Map<String, Object> getFAQDetail(@RequestParam HashMap param) throws Exception {
        logger.debug("/getFAQDetail");
        logger.debug("param : {}", param);

        Map result = faqService.getFAQDetail(param);

        Map resultMap = new HashMap();
        resultMap.put("detail", result);
        return resultMap;
    }

    /**
     * FAQ 카테고리 등록
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/insertFAQCate")
    public @ResponseBody
    Map<String, Object> insertFAQCate(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/inserFAQCate");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("regUid", userInfo.get("user_id"));
        }

        int resultCnt = faqService.insertFAQCate(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * FAQ 등록
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/insertFAQ")
    public @ResponseBody
    Map<String, Object> insertFAQ(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/inserFAQ");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("regUid", userInfo.get("user_id"));
        }

        int resultCnt = faqService.insertFAQ(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * FAQ 카테고리 수정
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/updateFAQCate")
    public @ResponseBody
    Map<String, Object> updateFAQCate(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/updateFAQCate");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("modUid", userInfo.get("user_id"));
        }

        int resultCnt = faqService.updateFAQCate(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * FAQ 수정
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/updateFAQ")
    public @ResponseBody
    Map<String, Object> updateFAQ(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/updateFAQ");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("modUid", userInfo.get("user_id"));
        }

        int resultCnt = faqService.updateFAQ(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * FAQ 카테고리 내 게시물 존재 유무 체크
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/getFAQListCnt")
    public @ResponseBody
    Map<String, Object> getFAQListCnt(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/getFAQListCnt");
        logger.debug("param : {}", param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", faqService.getFAQListCnt(param));

        return resultMap;
    }

    /**
     * FAQ 카테고리 삭제
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/deleteFAQCate")
    public @ResponseBody
    Map<String, Object> deleteFAQCate(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/deleteFAQCate");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("modUid", userInfo.get("user_id"));
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        param.put("cateIdx", param.get("faqCateIdx"));
        List list = faqService.getFAQList(param);
        if(!list.isEmpty()) {
            for (int i=0; i<list.size(); i++) {
                HashMap<String, Object> faqMap = new HashMap<String, Object>();
                faqMap.put("faqIdx", ((Map)list.get(i)).get("faq_idx"));
                faqMap.put("modUid", userInfo.get("user_id"));

                faqService.deleteFAQ(faqMap);
            }
        }

        int resultCnt = faqService.deleteFAQCate(param);
        resultMap.put("resultCnt", resultCnt);

        return resultMap;
    }

    /**
     * FAQ 삭제
     *
     * @param session
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/deleteFAQ")
    public @ResponseBody
    Map<String, Object> deleteFAQ(HttpSession session, @RequestParam HashMap param) throws Exception {
        logger.debug("/deleteFAQ");
        logger.debug("param : {}", param);

        Map userInfo = UserUtil.getUserInfo(session);
        if (userInfo != null) {
            param.put("modUid", userInfo.get("user_id"));
        }

        int resultCnt = faqService.deleteFAQ(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }
}
