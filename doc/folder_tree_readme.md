**energyServicePortal_ewp_adv**
   |-- .factorypath
   |-- .gitignore
   |-- pom.xml
   └── src
       └── main
           |-- java
           |   |-- egovframework
           |   |   |-- com
           |   |   |   |-- cmm
           |   |   |   |   |-- EgovComCrossSiteHndlr.java
           |   |   |   |   |-- EgovComponentChecker.java
           |   |   |   |   |-- EgovWebUtil.java
           |   |   |   |   |-- LoginVO.java
           |   |   |   |   |-- exception
           |   |   |   |   |   └── EgovXssException.java
           |   |   |   |   |-- service
           |   |   |   |   |   |-- CmmnDetailCode.java
           |   |   |   |   |   |-- EgovUserDetailsService.java
           |   |   |   |   |   |-- FileVO.java
           |   |   |   |   |   └── Globals.java
           |   |   |   |   └── util
           |   |   |   |       |-- EgovBasicLogger.java
           |   |   |   |       |-- EgovDoubleSubmitHelper.java
           |   |   |   |       |-- EgovHttpRequestHelper.java
           |   |   |   |       |-- EgovResourceCloseHelper.java
           |   |   |   |       |-- EgovUrlRewriteFilter.java
           |   |   |   |       |-- EgovUserDetailsHelper.java
           |   |   |   |       └── EgovXssChecker.java
           |   |   |   └── utl
           |   |   |       |-- fcc
           |   |   |       |   |-- service
           |   |   |       |   |   |-- EgovDateFormat.java
           |   |   |       |   |   |-- EgovEhgtCalcUtil.java
           |   |   |       |   |   |-- EgovFileUploadUtil.java
           |   |   |       |   |   |-- EgovFormBasedFileUtil.java
           |   |   |       |   |   |-- EgovFormBasedFileVo.java
           |   |   |       |   |   |-- EgovFormBasedUUID.java
           |   |   |       |   |   |-- EgovFormatCheckUtil.java
           |   |   |       |   |   |-- EgovNumberFormat.java
           |   |   |       |   |   |-- EgovNumberUtil.java
           |   |   |       |   |   |-- EgovStringUtil.java
           |   |   |       └── sim
           |   |   |           └── service
           |   |   |               |-- EgovClntInfo.java
           |   |   |               |-- EgovFileMntrg.java
           |   |   |               |-- EgovFileScrty.java
           |   |   |               |-- EgovNetInfo.java
           |   |   |               |-- EgovNetworkState.java
           |   |   |               └── EgovSysInfo.java
           |   └── kr
           |       └── co
           |           └── esp
           |               |-- common
           |               |   |-- config
           |               |   |   |-- RootContext.java
           |               |   |   |-- SecurityConfig.java
           |               |   |   |-- ServletContext.java
           |               |   |   |-- WebInit.java
           |               |   |-- exception
           |               |   |   |-- ExceptionHandlerController.java
           |               |   |   |-- MsgException.java
           |               |   |-- filter
           |               |   |   |-- CookieLocaleFilter.java
           |               |   |   |-- HTMLTagFilter.java
           |               |   |   |-- HTMLTagFilterRequestWrapper.java
           |               |   |-- interceptor
           |               |   |   |-- AuthenticInterceptor.java
           |               |   |   |-- LocaleInterceptor.java
           |               |   |   |-- PreLoadInterceptor.java
           |               |   |-- listener
           |               |   |   |-- SessionListener.java
           |               |   |-- service
           |               |   |   |-- EgovMessageSource.java
           |               |   |   |-- EgovProperties.java
           |               |   |   |-- impl
           |               |   |   |   |-- CustomAuthenticationProvider.java
           |               |   |-- util
           |               |   |   |-- AES256Util.java
           |               |   |   |-- CommonUtils.java
           |               |   |   |-- ContextPropertiesUtil.java
           |               |   |   |-- DateUtil.java
           |               |   |   |-- EgovWildcardReloadableResourceBundleMessageSource.java
           |               |   |   |-- RestApiUtil.java
           |               |   |   |-- StringUtil.java
           |               |   |   |-- UserUtil.java
           |               |   |-- web
           |               |   |   |-- EgovBindingInitializer.java
           |               |   |   |-- EgovMultipartResolver.java
           |               |-- dashboard
           |               |   |-- web
           |               |   |   |-- DashboardController.java
           |               |-- device
           |               |   |-- web
           |               |   |   |-- DeviceController.java
           |               |-- diagnosis
           |               |   |-- web
           |               |   |   |-- DiagnosisController.java
           |               |-- energy
           |               |   |-- web
           |               |   |   |-- PvGenController.java
           |               |-- history
           |               |   |-- web
           |               |   |   |-- HistoryController.java
           |               |-- login
           |               |   |-- service
           |               |   |   |-- LoginService.java
           |               |   |   |-- impl
           |               |   |   |   |-- LoginServiceImpl.java
           |               |   |-- web
           |               |   |   |-- LoginController.java
           |               |-- report
           |               |   |-- web
           |               |   |   |-- ReportController.java
           |               |-- setting
           |               |   |-- web
           |               |   |   |-- SettingController.java
           |               └── spc
           |                   └── web
           |                      └── SpcController.java
           |-- resources
           |   └── kr
           |       └── co
           |           └── esp
           |               └── egovProps
           |                   |-- conf
           |                   |   |-- format.properties
           |                   |   |-- server.properties
           |                   |-- globals.properties
           |                   └── prg (...)
           |
           └── webapp
               |-- META-INF
               |   |-- MANIFEST.MF
               |-- WEB-INF
               |   |-- decorators.xml
               |   |-- jsp (주로 봐야 할 부분)
               |   |   |-- esp
               |   │   │   |-- code404.jsp
               |   │   │   |-- code500.jsp
               |   │   │   |-- dashboard
               |   │   │   │ 	├── gmain.jsp (통합 대시보드)
               |   │   │   │ 	├── smain.jsp (사이트 대시보드)
               |   │   │   │ 	├── jmain.jsp (중개거래 대시보드)
               |   │   │   │ 	└── dmain.jsp (DR 대시보드 : 아직 준비중???)
               |   │   │   |-- device
               |   │   │   │ 	├── certApplication.jsp
               |   │   │   │ 	├── certManageDetail.jsp
               |   │   │   │ 	├── certManageList.jsp
               |   │   │   │ 	├── collectionState.jsp
               |   │   │   │ 	└── deviceState.jsp
               |   |   |   |-- diagnosis
               |   |   |   |   |-- abnormallyAnalysis.jsp
               |   |   |   |   └── generation.jsp
               |   |   |   |-- energy
               |   |   |   |   └── pvGen.jsp
               |   |   |   |-- history
               |   |   |   |   |-- alarmHistory.jsp
               |   |   |   |   └── operationHistory.jsp
               |   |   |   |-- login
               |   |   |   |   └──login.jsp
               |   |   |   |-- report
               |   |   |   |   |-- maintenanceReport.jsp
               |   |   |   |   |-- maintenanceReportDetails.jsp
               |   |   |   |   |-- maintenanceReportEdit.jsp
               |   |   |   |   |-- maintenanceReportPost.jsp
               |   |   |   |   └── yieldReport.jsp
               |   |   |   |-- setting
               |   |   |   |   |-- alarmSetting.jsp
               |   |   |   |   |-- batchSetting.jsp
               |   |   |   |   |-- comCodeSetting.jsp
               |   |   |   |   |-- groupSetting.jsp
               |   |   |   |   |-- siteSetting.jsp
               |   |   |   |   └── userSetting.jsp
               |   |   |   |-- spc
               |   |   |   |   |-- balanceSheet.jsp
               |   |   |   |   |-- balanceSheetEdit.jsp
               |   |   |   |   |-- balanceSheetPost.jsp
               |   |   |   |   |-- entityDetails.jsp
               |   |   |   |   |-- entityDetails02.jsp
               |   |   |   |   |-- entityDetailsBySPC.jsp
               |   |   |   |   |-- entityDetailsBySite.jsp
               |   |   |   |   |-- entityInformation.jsp
               |   |   |   |   |-- entityInformationEdit.jsp
               |   |   |   |   |-- entityInformationPost.jsp
               |   |   |   |   |-- maintenanceSchedule.jsp
               |   |   |   |   |-- notice.jsp
               |   |   |   |   |-- spcMaintenanceReport.jsp
               |   |   |   |   |-- spcMaintenanceReportDetail.jsp
               |   |   |   |   |-- supplementaryDocuments.jsp
               |   |   |   |   |-- transactionCalendar.jsp
               |   |   |   |   |-- transactionHistory.jsp
               |   |   |   |   |-- withdrawReqEdit.jsp
               |   |   |   |   |-- withdrawReqStatus.jsp
               |   |   |   |   |-- withdrawReqStatusDetail.jsp
               |   |   |   |   └── withdrawReqWrite.jsp
               |   |-- lib (...)
               |   |-- sitemesh.xml
               |   |-- tlds (...)
               |
               |
               |-- **decorators (공통 레이아웃)**
               |   |-- include
               |   |   |-- dashboardSchForm.jsp
               |   |   |-- dashboardTableView.jsp
               |   |   |-- layouts
               |   |   |   |-- footer.jsp
               |   |   |   |-- header.jsp
               |   |   |   |-- nav-kpx.jsp
               |   |   |   |-- nav.jsp
               |   |   |   |-- top-css.jsp
               |   |   |   |-- top.jsp
               |   |   |-- searchRequirement.jsp
               |   |   |-- selectLang.jsp
               |   |   |-- taglibs.jsp
               |   |   |
               |   |-- template
               |   |   |-- dashboard-layout.jsp
               |   |   |-- device-layout.jsp
               |   |   |-- diagnosis-layout.jsp
               |   |   |-- energy-layout.jsp
               |   |   |-- history-layout.jsp
               |   |   |-- layout.jsp
               |   |   |-- report-layout.jsp
               |   |   |-- spc-layout.jsp
               |   |   |-- system-layout.jsp
               |   |   |
               |-- index.jsp
               └── resources
                   |-- css ( TO DO!!! include min.css ONLY in production mode)
                   |   |-- bootstrap.css
                   |   |-- bootstrap.min.css
                   |   |-- custom-grid.css
                   |   |-- custom-grid.min.css
                   |   |-- custom-login.css
                   |   |-- custom-login.min.css
                   |   |-- custom-mquery.css
                   |   |-- custom.css
                   |   |-- data_tables
                   |   |   |-- default.css
                   |   |-- font-awesome.all.css
                   |   |-- font-awesome.min.css
                   |   |-- jquery-ui-1.12.1.min.css
                   |   |-- jquery-ui.css
                   |   |-- jquery-ui.min.css
                   |   |-- wickedpicker.css
                   |   |-- wickedpicker.min.css
                   |-- excel
                   |   |-- alarmSettingTemplate.xlsx
                   |-- favicon.ico
                   |-- favicon_encored.ico
                   |-- favicon_wpsolar.ico
                   |-- font (...)
                   |-- fonts (...)
                   |-- img (...)
                   |
                   └── js
                       |-- bootstrap.js
                       |-- bootstrap.min.js
                       |-- common.js
                       |-- commonDropdown.js
                       |-- custom
                       |   |-- FileSaver.js
                       |   |-- jszip-utils.js
                       |   |-- jszip.js
                       |   |-- lems.js
                       |   |-- numberFormat.js
                       |   |-- searchRequirement.js
                       |   |-- theme.js
                       |   └── utils.js
                       |
                       |-- dashboard-kpx.js
                       |-- dashboard.js
                       |-- dashboard
                       |   |-- dashboardChart.js
                       |   |-- dashboardKpxV2.js
                       |   └── dashboardV2.js
                       |-- data_tables
                       |   |-- default.js
                       |   |-- extensions
                       |   |   |-- buttons.js
                       |   |   |-- col_reorder.js
                       |   |   |-- fixed_header.js
                       |   |   |-- jszip.js
                       |   |   |-- pdf_make.js
                       |   |   |-- responsive.js
                       |   |   |-- rowGroup.js
                       |   |   |-- select.js
                       |   |   |-- vfs_fonts.js
                       |   |   └── vfs_fonts_kr.js
                       |-- fileSaver
                       |   |-- FileSaver.min.js
                       |-- highstock.js
                       |-- html2canvas.js
                       |-- jquery-1.9.1.min.js
                       |-- jquery-ui-1.12.1.min.js
                       |-- jquery-ui.js
                       |-- jquery-ui.min.js
                       |-- jquery.blockUI.js
                       |-- jquery.min.js
                       |-- jquery.nicescroll.js
                       |-- jquery.rwdImageMaps.min.js
                       |-- jspdf.min.js
                       |-- modules
                       |   |-- data.js
                       |   |-- export-data.js
                       |   |-- exporting.js
                       |   |-- highstock-exporting.js
                       |   |-- rounded-corners.js
                       |   └── variwide.js
                       |-- printPreview.js
                       |-- printThis.js
                       |-- sheetJs
                       |   |-- xlsx.full.min.js
                       |   └── xlsx.full.min.map
                       └── weather_station info.js
                       └── wickedpicker.js 