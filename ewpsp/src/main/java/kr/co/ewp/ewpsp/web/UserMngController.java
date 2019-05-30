/**
 * class name : SetupController
 * description : 설정 메뉴 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.service.UserMngService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class UserMngController {

    private static final Logger logger = LoggerFactory.getLogger(UserMngController.class);

    @Resource(name = "userMngService")
    private UserMngService userMngService;

    @RequestMapping("/userMng")
    public String userMng(Model model) {
        logger.debug("/userMng");

        return "ewp/setup/userMng";
    }

    /**
     * 사용자 목록 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/getUserList")
    public @ResponseBody
    Map<String, Object> getUserList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/getUserList");
        logger.debug("param ::::: " + param.toString());

        Map userInfo = UserUtil.getUserInfo(request);
        String authType = (String) userInfo.get("auth_type");
        if ("2".equals(authType)) { // 고객사관리자
            param.put("compIdx", userInfo.get("comp_idx"));
        } else if ("3".equals(authType)) { // 그룹관리자
            param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
        } else if ("4".equals(authType)) { // 사이트관리자
            param.put("siteId", userInfo.get("site_id"));
        } else if ("5".equals(authType)) { // 사이트이용자
            param.put("userIdx", userInfo.get("user_idx"));
        }

        int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
        int pageRowCnt = 5;
        int startNum = pageRowCnt * (selPageNum - 1);

        param.put("startNum", startNum);
        param.put("pageRowCnt", pageRowCnt);

        List list = userMngService.getUserList(param);
        int listCnt = userMngService.getUserListCnt(param);
        int totalPageCnt = 0;
        if (listCnt > 0) {
            totalPageCnt = listCnt / pageRowCnt;
            if (listCnt % pageRowCnt > 0) {
                totalPageCnt++;
            }
        }

        Map<String, Object> pagingMap = new HashMap<String, Object>();
        pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
        pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
        pagingMap.put("listCnt", listCnt); // 전체 데이터 수
        pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("list", list);
        resultMap.put("pagingMap", pagingMap);
        return resultMap;
    }

    /**
     * 사용자 한건 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/getUserDetail")
    public @ResponseBody
    Map<String, Object> getUserDetail(@RequestParam Map<String, Object> param) throws Exception {
        logger.debug("/getUserDetail");
        logger.debug("param ::::: " + param.toString());

        Map result = userMngService.getUserDetail(param);
        logger.debug("result.toString() : " + result.toString());

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        return resultMap;
    }

    /**
     * 마지막에 추가한 사용자 한건 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/getLastUserDetail")
    public @ResponseBody
    Map<String, Object> getLastUserDetail(@RequestParam Map<String, Object> param) throws Exception {
        logger.debug("/getUserDetail");
        logger.debug("param ::::: " + param.toString());

        Map result = userMngService.getLastUserDetail(param);
        logger.debug("result.toString() : " + result.toString());

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        return resultMap;
    }

    /**
     * 사용자 등록
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/insertUser")
    public @ResponseBody
    Map<String, Object> insertUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/insertUser");
        logger.debug("param ::::: " + param.toString());

        Map userInfo = UserUtil.getUserInfo(request);
        param.put("regUid", userInfo.get("user_id"));
        param.put("userPw", param.get("userId"));

        int resultCnt = userMngService.insertUser(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * 사용자 수정
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/updateUser")
    public @ResponseBody
    Map<String, Object> updateUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/updateUser");
        logger.debug("param ::::: " + param.toString());

        Map userInfo = UserUtil.getUserInfo(request);
        param.put("modUid", userInfo.get("user_id"));

        int resultCnt = userMngService.updateUser(param);
        int resultAuthCnt = userMngService.updateUserAuth(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

    /**
     * 사용자 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping("/deleteUser")
    public @ResponseBody
    Map<String, Object> deleteUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/deleteUser");
        logger.debug("param ::::: " + param.toString());

        Map userInfo = UserUtil.getUserInfo(request);
        param.put("modUid", userInfo.get("user_id"));

        int resultCnt = userMngService.deleteUser(param);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultCnt", resultCnt);
        return resultMap;
    }

}
