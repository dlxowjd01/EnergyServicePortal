package kr.co.esp.spc.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class SpcController {
    private static final Logger logger = LoggerFactory.getLogger(SpcController.class);

    @RequestMapping(value = "/spc/entityInformation.do")
    public String spcEntityInformation(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityInformation.do");
        return "esp/spc/entityInformation";
    }

    @RequestMapping(value = "/spc/entityInformationPost.do")
    public String spcEntityInformationPost(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityInformationPost.do");
        return "esp/spc/entityInformationPost";
    }

    @RequestMapping(value = "/spc/entityInformationEdit.do")
    public String spcEntityInformationEdit(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityInformationEdit.do");
        return "esp/spc/entityInformationEdit";
    }

    @RequestMapping(value = "/spc/balanceSheet.do")
    public String spcBalanceSheet(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/balanceSheet.do");
        return "esp/spc/balanceSheet";
    }

    @RequestMapping(value = "/spc/balanceSheetEdit.do")
    public String spcBalanceSheetEdit(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/balanceSheetEdit.do");
        return "esp/spc/balanceSheetEdit";
    }

    @RequestMapping(value = "/spc/balanceSheetPost.do")
    public String spcBalanceSheetPost(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/balanceSheetPost.do");
        return "esp/spc/balanceSheetPost";
    }

    @RequestMapping(value = "/spc/transactionSheet.do")
    public String spcTransactionSheet(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/transactionSheet.do");
        return "esp/spc/transactionSheet";
    }

   @RequestMapping(value = "/spc/transactionSheet2.do")
    public String spcTransactionSheet2(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/transactionSheet2.do");
        return "esp/spc/transactionSheet2";
    }
	
    @RequestMapping(value = "/spc/transactionHistory.do")
    public String spcTransactionHistory(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/transactionHistory.do");
        return "esp/spc/transactionHistory";
    }

  	@RequestMapping(value = "/spc/withdrawReqWrite.do")
    public String spcWithdrawReqWrite(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/withdrawReqWrite.do");
        return "esp/spc/withdrawReqWrite";
    }

	@RequestMapping(value = "/spc/withdrawReqEdit.do")
    public String spcWithdrawReqEdit(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/withdrawReqEdit.do");
        return "esp/spc/withdrawReqEdit";
    }

	@RequestMapping(value = "/spc/withdrawReqStatus.do")
    public String spcWithdrawReqStatus(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/withdrawReqStatus.do");
        return "esp/spc/withdrawReqStatus";
    }

	@RequestMapping(value = "/spc/withdrawReqDetail.do")
		public String spcWithdrawReqDetail(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/spc/withdrawReqDetail.do");
		return "esp/spc/withdrawReqDetail";
    }

    @RequestMapping(value = "/spc/maintenanceSchedule.do")
    public String spcMaintenanceSchedule(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/maintenanceSchedule.do");
        return "esp/spc/maintenanceSchedule";
    }

    @RequestMapping(value = "/spc/maintenanceSchedulePost.do")
    public String spcMaintenanceSchedulePost(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/maintenanceSchedulePost.do");
        return "esp/spc/maintenanceSchedulePost";
    }

    @RequestMapping(value = "/spc/supplementaryDocuments.do")
    public String spcSupplementaryDocuments(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/supplementaryDocuments.do");
        return "esp/spc/supplementaryDocuments";
    }

    @RequestMapping(value = "/spc/entityDetails.do")
    public String spcEntityDetails(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityDetails.do");
        return "esp/spc/entityDetails";
    }

    @RequestMapping(value = "/spc/entityDetails02.do")
    public String spcEntityDetails02(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityDetails02.do");
        return "esp/spc/entityDetails02";
    }

    @RequestMapping(value = "/spc/entityDetailsBySPC.do")
    public String spcEntityDetailsBySPC(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityDetailsBySPC.do");
        return "esp/spc/entityDetailsBySPC";
    }

    @RequestMapping(value = "/spc/entityDetailsBySite.do")
    public String spcEntityDetailsBySite(HttpServletRequest request, HttpSession session, Model model) {
        logger.debug("/spc/entityDetailsBySite.do");
        return "esp/spc/entityDetailsBySite";
    }

	@RequestMapping(value = "/spc/notice.do")
	public String spcNotice(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/spc/notice.do");
		return "esp/spc/notice";
	}
}
