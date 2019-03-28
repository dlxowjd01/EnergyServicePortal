package kr.co.ewp.ewpsp.common;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.ewp.ewpsp.web.UsageController;

public class ExcelDownload {

	private static final Logger logger = LoggerFactory.getLogger(UsageController.class);

	private HttpServletResponse response;
	private SXSSFWorkbook workbook;
	private SXSSFSheet sheet;
	
	private boolean isStarted = false; // 엑셀다운 시작여부
	private int rowNum = 1; // row순서
	private String excel_title = ""; // 엑셀명
	private String col_tb = ""; // 테이블조회컬럼
	private String col_nm = ""; // 엑셀 헤더 제목(한글)
	
	public ExcelDownload(HttpServletResponse response, HashMap param) {
		init();
		this.response = response;
		
		// 메모리에 100개의 행을 누적 후 행의 수가 100개를 넘을 시 디스크에 기록한다.
		workbook = new SXSSFWorkbook(100);
		sheet = workbook.createSheet();
		
		this.excel_title = (String) param.get("excel_title");
		this.col_tb = (String) param.get("COL_TB");
		this.col_nm = (String) param.get("COL_NM");
	}
	
	public void handleRow(Object resultContext) {
		HashMap excelMap = (HashMap) resultContext;
		if(!isStarted) {
			open(excelMap);
			isStarted = true;
		}
		
		// 현재 처리중인 행번호(0부터 시작)
		SXSSFRow row = sheet.createRow(rowNum);
		SXSSFCell cell = null;
		int cellNum = 0; // 몇번째 셀인지
		
		if(rowNum == 1) { // 맨 처음일때
			/*
			 * 현재 데이터를 쓰는 라인이 두번째인지 아닌지를 판단(두번째라인부터 비교시작)
			 * 두번째인 경우 첫번째라인에 헤더를 만들고 두번째라인에 데이터를 쓴다
			 * 세번째라인부터는 데이터만 쓴다
			*/
			writeHeader(cellNum); // 헤더만들기
			cellNum = 0;
		}
		writeCell(excelMap, row, cell, cellNum); // 헤더 바로 아랫줄부터 데이터 쓰기
		
		rowNum++;
	}
	
	// 초기화
	public void init() {
		this.response = null;
		this.workbook = null;
		this.sheet = null;
		this.isStarted = false;
		this.rowNum= 1;
		this.excel_title = "";
		this.col_tb = "";
		this.col_nm = "";
	}

	// 헤더 생성
	public void writeHeader(int cellNum) {
		SXSSFRow header = sheet.createRow(rowNum-1);
		SXSSFCell headerCell = null;
		String [] col_nms = this.col_nm.split("\\|");
		for (int i = 0; i < col_nms.length; i++) {
			String col_nm = col_nms[i];
			headerCell = header.createCell(cellNum);
			headerCell.setCellValue(col_nm);
			cellNum++;
		}
	}
	
	// 데이터라인 생성
	public void writeCell(HashMap excelMap, SXSSFRow row, SXSSFCell cell, int cellNum) {
		Iterator<String> paramKeys = excelMap.keySet().iterator();
		while (paramKeys.hasNext()) {
			String name = paramKeys.next();
//			logger.debug("rownum : "+rowNum+", cell name : "+name+", "+excelMap.get(name)+", "+cellNum);
			if( !(name.contains("_idx") || name.contains("device_type") || name.contains("inst_type") || name.contains("site_id")) ) {
				cell = row.createCell(cellNum);
				if("reg_date".equals(name) || "std_date".equals(name)) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String str = sdf.format( new Date( ((Timestamp)excelMap.get(name)).getTime() ) );
					cell.setCellValue( str );
				} else if("rnum".equals(name)) {
					if(excelMap.get(name) instanceof Double) {
						double val = (Double) excelMap.get(name);
						int reVal = (int) val;
						cell.setCellValue( Integer.toString(reVal) );
					} else if(excelMap.get(name) instanceof Long) {
						long val = (Long) excelMap.get(name);
						int reVal = (int) val;
						cell.setCellValue( Integer.toString(reVal) );
					} else {
						cell.setCellValue((String)excelMap.get(name));
					}
				} else if(name.contains("_timestamp")) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					if(excelMap.get(name) != null && !"".equals(excelMap.get(name))) cell.setCellValue( sdf.format( new Date( ((Timestamp)excelMap.get(name)).getTime() ) ) );
					else cell.setCellValue( "" );
					
				} else {
					if(excelMap.get(name) instanceof BigDecimal) {
						cell.setCellValue( ((BigDecimal)excelMap.get(name)).toString() );
					} else if(excelMap.get(name) instanceof Integer) {
						cell.setCellValue( Integer.toString((Integer) excelMap.get(name)) );
					} else {
						cell.setCellValue((String)excelMap.get(name));
					}
					
				}
				cellNum++;
			}
			
		}
//		logger.debug("==================sdf=======================");
	}
	
	// 헤더 스타일
	public void headerStyle(SXSSFCell cell) {
		CellStyle headerStyle = workbook.createCellStyle();
//		headerStyle.setAlignment();
		
		cell.setCellStyle(headerStyle);
	}

	// 엑셀 다운로드 시작 시 실행함수
	public void open(HashMap resultObject) {
		String excelName = "";
		try {
			excelName = new String ( excel_title.getBytes("KSC5601"), "8859_1");
		} catch (NullPointerException e) {
			logger.error("error is : "+e.toString());
		} catch (Exception e) {
			//e.printStackTrace();
			logger.error("error is : "+e.toString());
		}
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Set-Cookie", "fileDonwload=true; path=/");
		response.setHeader("Content-Disposition",  String.format("attachment; filename=\""+excelName+".xlsx\""));
	}
	
	// 엑셀 다운로드 종료함수
	public void close() {
		try {
//			SXSSFSheet sheet2 = workbook.createSheet();
//			SXSSFSheet sheet3 = workbook.createSheet();
			workbook.write(response.getOutputStream());
			workbook.dispose();
			
			// 엑셀 다운로드 요청을 처리하는 곳에서 응답 헤더에 fileDownloadToken 쿠키를 넣어줌.(로딩바 처리)
//			Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
//			response.addCookie(new Cookie("fileDownloadToken", "TRUE"));
		} catch (NullPointerException e) {
			logger.error("error is : "+e.toString());	
		} catch (Exception e) {
			//e.printStackTrace();
			logger.error("error is : "+e.toString());
			response.setHeader("Content-Type",  "tet/heml; charset=utf-8");
			response.setHeader("Set-Cookie", "fileDonwload=false; path=/");
			response.setHeader("Cache-Control", "no-cache, no-store, nust-revalidate");
			OutputStream out = null;
			try {
				out = response.getOutputStream();
				byte[] data = new String("엑셀 다운로드에 실패했습니다. \n 관리자에게 문의하세요.").getBytes();
				out.write(data, 0, data.length);
			} catch (NullPointerException e1) {
				logger.error("error is : "+e1.toString());
			} catch (Exception e1) {
				//e1.printStackTrace();
				logger.error("error is : "+e1.toString());
			}
		} finally {
			if(workbook != null) {
				try {
					workbook.close();
				} catch (NullPointerException e) {
					logger.error("error is : "+e.toString());
				} catch (Exception e) {
					//e.printStackTrace();
					logger.error("error is : "+e.toString());
				}
			}
		}
	}
	
}
