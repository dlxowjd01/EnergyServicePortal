<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	$(function () {
	
		let optionList = [
			{
				url: apiHost + "/config/view/properties?types=site_type,resource",
				type: 'get',
				async: true,
			},
		]
	
	});



	function getPropertyData(option) {

	}

	function getSites (siteId) {
		let option = {
			url: apiHost + "/config/sites",
			type: "get",
			async: true,
			data: {
				oid: siteId,
				filter: { 
					"limit": 200,
					"fields": {

					},
				}
			},
			beforeSend: function (jqXHR, settings) {
				$('#loadingCircle').show();
			},
		}

	}

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공통 코드 관리</h1>
	</div>
</div>

<div class="row">
	<div class="col-3">
		<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
			<div class="panel panel-default">
			  	<div class="panel-heading active" role="tab" id="headingOne">
					<h4 class="panel-heading">
				  		<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne" class="panel-fold"></a>
					</h4>
			  	</div>
			  	<div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
					<div class="panel-body">

					</div>
			  	</div>
			</div>
		  </div>
	</div>
	<div class="col-9">
		<div class="indiv">
			<h2 class="tx-tit"></h2>
			<table id="comCodeTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:16%">
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:12%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>
<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="setting-modal-content modal-content">
			<div class="modal-header"><h1>사업소 추가</h1></div>
			<div class="modal-body">
				
			</div>
		</div>
	</div>
</div>
