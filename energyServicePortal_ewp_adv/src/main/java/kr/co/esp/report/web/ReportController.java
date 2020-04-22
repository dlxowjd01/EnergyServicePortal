package kr.co.esp.report.web;

import kr.co.esp.diagnosis.web.DiagnosisController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class ReportController {
    private static final Logger logger = LoggerFactory.getLogger(ReportController.class);

    @RequestMapping(value = "/report/yieldReport.do")
    public String reportYieldReport(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/report/yieldReport.do");
        return "esp/report/yieldReport";
    }

    @RequestMapping(value = "/report/maintenanceReport.do")
    public String reportMaintenanceReport(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/report/maintenanceReport.do");
        return "esp/report/maintenanceReport";
    }

    @RequestMapping(value = "/report/maintenanceReportDetails.do")
    public String reportMaintenanceReportDetails(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("/report/maintenanceReportDetails.do");
        return "esp/report/maintenanceReportDetails";
    }
}
