<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!-- ###### 상세보기 Popup Start ###### -->
    <!-- IOE -->
    <div id="layerbox" class="dview dview_ioe">
        <div class="ltit">
        	<h2>
        		<span class="ioe"></span>
        		<p></p>
        	</h2>        	
			<a href="#;" id="closeIOEDetailBtnX">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd></dd>
        	</dl>
        </div>
        <div class="lbody">
        	<div class="lstat mt20">
	        	<div class="dt">장치타입</div>
	        	<div class="dd"></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">연결상태</div>
	        	<div class="dd"><span class="run"></span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
	        	</div>
	        </div>        
	        <div class="ltbl mt30">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>전압(v)</th>
	        				<th>전력(kW)</th>
	        				<th>유효전력(kW)</th>
	        				<th>무효전력(kW)</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
        </div>
    </div>

    <!-- PCS -->
    <div id="layerbox" class="dview dview_pcs">
        <div class="ltit">
        	<h2>
        		<span class="pcs"></span>
        		<p></p>
        	</h2>        	
			<a href="#;" id="closePCSDetailBtnX">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd></dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">장치타입</div>
	        	<div class="dd">test</div>
	        </div>        	
	        <div class="lstat">
	        	<div class="dt">운전상태</div>
	        	<div class="dd"><span class="run"></span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
	        	</div>
	        </div>	        
	        <h2 class="tbl_tit">AC 출력</h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>전압(V)</th>
	        				<th>전력(kW)</th>
	        				<th>주파수(Hz)</th>
	        				<th>전류(A)</th>
	        				<th>역률(PF)</th>
	        				<th>전력설정치(kWh)</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
	        <h2 class="tbl_tit">DC 출력</h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>전압(V)</th>
	        				<th>전류(A)</th>
	        				<th>운전상태</th>
	        				<th>운전모드</th>	        				
	        				<th>충전량</th>
	        				<th>방전량</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
	    </div>
    </div>

    <!-- BMS -->
    <div id="layerbox" class="dview dview_bms">
        <div class="ltit">
        	<h2>
        		<span class="bms"></span>
        		<p></p>
        	</h2>        	
			<a href="#;" id="closeBMSDetailBtnX">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd></dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">장치타입</div>
	        	<div class="dd">test</div>
	        </div>        	
	        <div class="lstat">
	        	<div class="dt">운전상태</div>
	        	<div class="dd"><span class="run"></span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
	        	</div>
	        </div>		        
	        <h2 class="tbl_tit">충/방전 상태: <span style="color:#438fd7;font-weight:normal;"></span></h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>SOC(%)</th>	        				
	        				<th>SOH(%)</th>
	        				<th>SOC 현재(kWh)</th>	        				
	        				<th>출력 전압(V)</th>
	        				<th>출력 전류(V)</th>
	        				<th>Dod(%)</th>	        				
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
        </div>
    </div>  

    <!-- PV -->
    <div id="layerbox" class="dview dview_pv">
        <div class="ltit">
        	<h2>
        		<span class="bms"></span>
        		<p></p>
        	</h2>        	
			<a href="#;" id="closePVDetailBtnX">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd></dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd></dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">장치타입</div>
	        	<div class="dd">test</div>
	        </div>        	
	        <div class="lstat">
	        	<div class="dt">PV 상태</div>
	        	<div class="dd"><span class="run"></span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
	        	</div>
	        </div>		        
	        <div class="ltbl mt30">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>온도</th>
	        				<th>오늘 예측 발전량</th>
	        				<th>실제 발전량</th>
	        				<th>오늘 누적 발전량</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        				<td></td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
        </div>
    </div>       
    <!-- ###### Popup End ###### -->