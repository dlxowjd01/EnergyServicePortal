package kr.co.esp.diagnosis.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class DiagnosisController {
    private static final Logger logger = LoggerFactory.getLogger(DiagnosisController.class);

    @RequestMapping(value = "/diagnosis/generation.do")
    public String diagnosisGeneration(HttpServletRequest request, HttpSession session, Model model) {
        return "esp/diagnosis/generation";
    }

    @RequestMapping(value = "/diagnosis/abnormallyAnalysis.do")
    public String diagnosisAbnormallyAnalysis(HttpServletRequest request, HttpSession session, Model model) {
        return "esp/diagnosis/abnormallyAnalysis";
    }
}
