/**
 * class name : FaqController
 * description : 자주하는 질문 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.ewp.ewpsp.service.FAQService;

@Controller
public class FaqController {

	private static final Logger logger = LoggerFactory.getLogger(FaqController.class);

	@Resource(name="faqService")
	private FAQService faqService;

	@RequestMapping("/faq")
	public String faq(Model model) {
		logger.debug("/faq");

		HashMap param = new HashMap();

		List cateList = faqService.getFAQCateList();
		List list = faqService.getFAQList(param);
		model.addAttribute("faqCateList", cateList);
		model.addAttribute("faqList", list);

		return "ewp/service/faq";
	}
}
