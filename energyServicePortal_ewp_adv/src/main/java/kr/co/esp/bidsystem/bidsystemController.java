package kr.co.esp.bidsystem;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * @package: kr.co.esp.bidsystem
 * @name: bidsystemController
 * @date: 2021.04.26
 * @author: Jung Jaekeun
 * @version: 1.0.0
 * @description: 입찰제도 컨트롤러
 * </pre>
 *
 * @modifyed:
 * ==================================================
 * DATE             AUTHOR              NOTE
 * --------------------------------------------------
 * 2021.04.26       Jung Jaekeun        최초생성
 *
 */
@Controller
@RequestMapping(value = "/bidsystem")
public class bidsystemController {
	private static final Logger logger = LoggerFactory.getLogger(bidsystemController.class);

	/**
	 * 예측입찰
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/predictedBid")
	public String predictedBid(HttpServletRequest request, HttpSession session, Model model) {
		String vgid = (String) request.getAttribute("vgid");
		String siteName = (String) request.getAttribute("vgid");

		if (vgid == null || "".equals(vgid)) {
			List<Map<String, Object>> vppList = (List<Map<String, Object>>) request.getAttribute("vpp_group");
			if (vppList != null && vppList.size() > 0) {
				vgid = (String) vppList.get(0).get("vgid");
				siteName = (String) vppList.get(0).get("name");
			}
		}

		request.setAttribute("vgid", vgid);
		request.setAttribute("siteName", siteName);
		return "esp/bidsystem/predictedBid";
	}
}
