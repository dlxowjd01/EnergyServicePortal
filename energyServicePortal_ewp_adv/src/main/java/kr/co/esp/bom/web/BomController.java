package kr.co.esp.bom.web;

import kr.co.esp.diagnosis.web.DiagnosisController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class BomController {
    private static final Logger logger = LoggerFactory.getLogger(BomController.class);

    @RequestMapping(value = "/bom/faultHistory.do")
    public String bomFaultHistory(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/bom/faultHistory.do");
        return "esp/bom/faultHistory";
    }

    @RequestMapping(value = "/bom/replacement.do")
    public String bomReplacement(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/bom/replacement.do");
        return "esp/bom/replacement";
    }

    @RequestMapping(value = "/bom/partManagement.do")
    public String bomPartManagement(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/bom/partManagement.do");
        return "esp/bom/partManagement";
    }
}
