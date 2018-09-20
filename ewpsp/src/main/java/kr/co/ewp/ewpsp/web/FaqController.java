/**
 * class name : FaqController
 * description : 자주하는 질문 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.ewp.ewpsp.service.UserMngService;

@Controller
public class FaqController {

	private static final Logger logger = LoggerFactory.getLogger(FaqController.class);
	
//	@Resource(name="userMngService")
//	private UserMngService userMngService;
	
	@RequestMapping("/faq")
	public String userMng(Model model) {
		logger.debug("/faq");
		
		return "ewp/service/faq";
	}
	
}
