package kr.co.ewp.ewpsp.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ESSChrgDischrgController {

	private static final Logger logger = LoggerFactory.getLogger(ESSChrgDischrgController.class);

	@RequestMapping("/essChrgDischrg")
	public String main() {
		logger.debug("/essChrgDischrg");
		
		return "ewp/energy/essChrgDischrg";
	}
	
}
