<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
    let costTable = null;
    let reportType = new Object();

    $(function() {
        costTable = $('#costTable').DataTable({
            autoWidth: true,
            fixedHeader: true,
            'table-layout': 'fixed',
            scrollY: '720px',
            scrollCollapse: true,
            sortable: true,
            paging: true,
            pageLength: 15,
            columns: [
                {
                    title: '<input type="checkbox" id="check" name="table_checkbox" onclick="checkAll();"><label for="check"></label>',
                    data: null,
                    mRender: function ( data, type, full, rowIndex ) {
                        return '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox"><label for="check' + rowIndex.row + '"></label>';
                    },
                    className: 'dt-center no-sorting'
                },
                {
                    title: '순번',
                    data: null,
                    render: function (data, type, full, rowIndex) {
                        return rowIndex.row + 1;
                    },
                    className: 'dt-center fixed'
                },
                {
                    title: 'SPC명',
                    data: 'spc_name',
                    render: function (data, type, full, rowIndex) {
                        if (isEmpty(data)) {
                            return '-';
                        } else {
                            return data;
                        }
                    },
                    className: 'dt-center'
                },
                {
                    title: '발전소명',
                    data: 'site_name',
                    render: function (data, type, full, rowIndex) {
                        if (isEmpty(data)) {
                            return '-';
                        } else {
                            return data;
                        }
                    },
                    className: 'dt-center'
                },
                {
                    title: '보고서 유형',
                    data: 'reportTypeName',
                    render: function (data, type, full, rowIndex) {
                        if (isEmpty(data)) {
                            return '-';
                        } else {
                            return data;
                        }
                    },
                    className: 'dt-center'
                },
                {
                    title: '적용기간',
                    data: 'report_date',
                    className: 'dt-center'
                },
                {
                    title: '다운로드',
                    data: 'file_link',
                    render: function (data, type, full, rowIndex) {
                        return '<button type="button" class="btn-type-sm btn-type03" onclick="' + data + '">EXCEL</button>';
                    },
                    sortable: false,
                    className: 'dt-center'
                },
                {
                    title: '보고서 생성 시간',
                    data: 'generated_at',
                    render: function (data, type, full, rowIndex) {
                        if (data === null) {
                            return '-';
                        } else {
                            return (new Date(data)).format('yyyy-MM-dd HH:mm:ss');
                        }
                    },
                    className: 'dt-center'
                }
            ],
            select: {
                style: 'multi',
                selector: 'td:first-child > :checkbox, tr > td:not(:has(button))'
            },
            language: {
                emptyTable: '<fmt:message key="yieldReport.noData.1" />',
                zeroRecords: '<fmt:message key="yieldReport.noData.2" />',
                infoEmpty: "",
                paginate: {
                    previous: "",
                    next: "",
                },
                info: "_PAGE_ - _PAGES_ " + " / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />",
            },
            dom: 'tip',
        }).on('select', function(e, dt, type, indexes) {
            costTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
        }).on('deselect', function(e, dt, type, indexes) {
            costTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
        }).columns.adjust().draw();


        $('.btn-caret').on('click', function () {
            $('.table-fold-container').slideToggle();
            $(this).text($(this).text() == '내용접기' ? '펼치기' : '내용접기').toggleClass('on');;
        });

        $('#application').on('click', function() {
            let start_yyyymm = $('#fromDate').val().replace(/[^0-9]/g, '');
            let end_yyyymm = $('#toDate').val().replace(/[^0-9]/g, '');

            $('#margin').text('');
            $('#profit').text('');
            $('#incomSum').text('');
            $('#expenseSum').text('');

            if (isEmpty(start_yyyymm) || isEmpty(end_yyyymm)) {
                errorMsg('적용기간을 선택해주세요.');
                return false;
            } else {
                $.ajax({
                    url: apiHost + '/spcs/balance/monthly_summary',
                    type: 'GET',
                    data: {
                        oid: oid,
                        start_yyyymm: start_yyyymm,
                        end_yyyymm: end_yyyymm
                    },
                    success: (result) => {
                        let incomSum = 0
                          , expenseSum = 0;

                        if (!isEmpty(result) && !isEmpty(result.data)) {
                            (result.data).forEach(rst => {
                                incomSum += isNaN(rst.income) ? 0 : rst.income;
                                expenseSum += isNaN(rst.expense) ? 0 : rst.expense;
                            });

                            if (incomSum != 0) {
                                $('#margin').text(numberComma((incomSum / expenseSum) * 100) + ' %');
                            } else {
                                $('#margin').text('-');
                            }

                            $('#profit').text(numberComma(incomSum - expenseSum) + ' 원');
                            $('#incomSum').text(numberComma(incomSum) + ' 원');
                            $('#expenseSum').text(numberComma(expenseSum) + ' 원');
                        }
                    },
                    error: (request, status, error) => {
                        console.error(error);
                        errorMsg('<fmt:message key="yieldReport.error.20" />');
                    }
                });
            }
        });

        var currentYear = (new Date()).getFullYear();
        var startYear = currentYear-10;
        var options = {
            startYear: startYear,
            finalYear: currentYear,
            pattern: 'yyyy-mm',
            monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
        };
        $('.month-pick').monthpicker(options);

        getProperties();
        getDataList();
    });

    /**
     * 원가관리보고서
     */
    const getDataList = () => {
        new Promise(resolve => {
            $.ajax({
                url: apiHost + '/reports/cost',
                type: 'GET',
                data: { oid: oid },
                success: (result) => {
                    if (!isEmpty(result) && !isEmpty(result['data'])) {
                        resolve(result['data']);
                    } else {
                        throw Error('<fmt:message key="yieldReport.error.19" />');
                    }
                },
                error: (request, status, error) => {
                    console.error(error);
                    throw Error('<fmt:message key="yieldReport.error.20" />');
                }
            });
        }).then(resultData => {
            resultData.forEach(data => {
                const reportDataStart = (new Date(data['report_data_start'])).format('yyyy-MM-dd')
                    , reportDataEnd = (new Date(data['report_data_end'])).format('yyyy-MM-dd');

                data['reportTypeName'] = reportType[data['report_type']];
                data['report_date'] = reportDataStart + ' ~ ' + reportDataEnd;

                if (isEmpty(data['generated_file_link'])) {
                    data['file_link'] = '-';
                } else {
                    const linkData = JSON.parse(data['generated_file_link']);
                    data['file_link'] = 'location.href=\'' + apiHost + '/files/download/' + linkData.fileKey + '?oid=' + oid + '&orgFilename=' + linkData.orgFileName + '\'';
                }
            });

            //작성일 기준 역순 정렬
            resultData.sort((a, b) => {
                return a['generated_at'] < b['generated_at'] ? 1 : a['generated_at'] > b['generated_at'] ? -1 : 0;
            });

            costTable.clear();
            costTable.rows.add(resultData).draw();
        }).catch(error => {
            costTable.clear().draw();
            errorMsg(error);
        });
    }

    const getProperties = () => {
        $.ajax({
            url: apiHost + '/config/view/properties2',
            type: 'GET',
            data: { oid: oid, types: 'cost_report_type' },
            success: (data, textStatus, jqXHR) => {
                const costTemplate = data.cost_report_type;

                // reportType = new Object();
                Object.entries(costTemplate).forEach(([index, cost]) => {
                    const code = cost['code'];
                    const name = (langStatus == 'KO') ? cost['name']['kr'] : cost['name']['en'];
                    reportType[code] = name;

                    $('#reportClass ul').append(`<li data-value="${'${code}'}"><a href="javascript:void(0);">${'${name}'}</a></li>`);
                });
            },
            error: (jqXHR, textStatus, errorThrown) => {
                console.error(textStatus);
                errorMsg('<fmt:message key="yieldReport.error.1" />');
            }
        });
    }

    const checkAll = () => {
        if ($('#check').is(':checked')) {
            $(':checkbox[name="table_checkbox"]').prop('checked', true);
            $(':checkbox[name="table_checkbox"]').parents('tr').addClass('selected');
        } else {
            $(':checkbox[name="table_checkbox"]').prop('checked', false);
            $(':checkbox[name="table_checkbox"]').parents('tr').removeClass('selected');
        }
    }

    /**
     * 등록 팝업
     */
    const modalInit = () => {
        const spcs = $.ajax({
            url: apiHost + '/spcs',
            type: 'GET',
            data: { oid: oid }
        });

        const props = $.ajax({
            url: apiHost + '/config/view/properties2',
            type: 'GET',
            data: { oid: oid, types: 'cost_report_type' }
        });

        Promise.all([spcs, props]).then(response => {
            const resolveData = new Object();
            response.forEach((result, index) => {
                if (index === 0) {
                    if (!isEmpty(result) && !isEmpty(result['data'])) {
                        resolveData['spcs'] = result['data'];
                    } else {
                        resolveData['spcs'] = null;
                    }
                } else {
                    resolveData['cost_report_type'] = result['cost_report_type'];
                }
            });

            return resolveData;
        }).then(data => {
            const spcData = data['spcs']
                , costTemplate = data['cost_report_type'];

            $('#spc_id ul').empty(); //SPCID 초기화
            $('#report_type ul').empty(); //보고서타입 초기화
            $('#yieldList').empty(); // 적용변수 초기화

            if (isEmpty(spcData)) {
                $('#spc_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
            } else {
                spcData.forEach(spc => {
                    $('#spc_id ul').append(`<li data-value="${'${spc[\'spc_id\']}'}"><a href="javascript:void(0);">${'${spc[\'name\']}'}</a></li>`);
                });
            }

            if (isEmpty(costTemplate)) {
                $('#report_type ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
            } else {
                Object.entries(costTemplate).forEach(([index, cost]) => {
                    const name = (langStatus == 'KO') ? cost['name']['kr'] : cost['name']['en'];
                    $('#report_type ul').append(`<li data-value="${'${cost[\'code\']}'}" data-options="${'${cost[\'option\']}'}" data-range="${'${cost[\'range\']}'}" data-interval="${'${cost[\'interval\']}'}"><a href="javascript:void(0);">${'${name}'}</a></li>`);
                });
            }

            $('#reportModal input').each(function () {
                $(this).val('');
            });

            $('#reportModal .dropdown-toggle').each(function () {
                $(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
            });

            $('#reportModal').modal();
        }).catch(error => {
            console.error(error);
            errorMsg('<fmt:message key="yieldReport.error.3" />');
        });
    }

    /**
     * 드롭다운 선택
     */
    const rtnDropdown = ($selector) => {
        if ($selector === 'report_type') {
            const dropdownValue = $('#' + $selector + ' button').data('value');
            if (dropdownValue !== $('#yieldList').data('value')) {
                $('#yieldList').empty(); // 적용변수 초기화
            }

            setSpcGenReport();
        } else if ($selector === 'spc_id') {
            const dropdownValue = $('#' + $selector + ' button').data('value');
            $('#site_id ul').empty();

            $.ajax({
                url: apiHost + '/spcs/' + dropdownValue,
                type: 'GET',
                data: {
                    oid: oid,
                    includeGens: true
                },
                success: (data) => {
                    const siteList = data.data[0]['spcGens'];
                    if (!isEmpty(data) && !isEmpty(data.data[0]['spcGens'])) {
                        siteList.forEach(gen => {
                            let liStr = `<li data-value="${'${gen[\'gen_id\']}'}"><a href="javascript:void(0);">${'${gen[\'name\']}'}</a></li>`;
                            $('#site_id ul').append(liStr);
                        });
                    } else {
                        $('#site_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
                    }
                },
                fail: function(){
                    errorMsg('<fmt:message key="yieldReport.error.6" />');
                    $('#site_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
                }
            });
        } else if ($selector === 'site_id') {
            setSpcGenReport();
        }
    }

    /**
     *
     */
    const setSpcGenReport = () => {
        const siteId = $('#site_id button').data('value')
            , spcId = $('#spc_id button').data('value')
            , reportType = $('#report_type button').data('value')
            , dataRange = $('#report_type button').data('range')
            , dataInterval = $('#report_type button').data('interval')
            , today = new Date();

        let month = 1;
        if (dataInterval === 'year') {
            month += 12;
        } else {
            month += Number(dataRange);
        }

        $('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - month, 1));
        $('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 1, 0));
    }

    //보고서 생성
    const reportCreate = function () {
        const today = new Date();
        let data = setAreaParamData('reportModal', 'dropdown'),
            report_variable = new Array();

        if (isEmpty($('#spc_id button').data('value'))) {
            errorMsg('<fmt:message key="yieldReport.error.7" />');
            return;
        }

        if (isEmpty($('#report_type button').data('value'))) {
            errorMsg('<fmt:message key="yieldReport.error.8" />');
            return;
        }

        if (!($('#report_type button').data('value')).match('quaterly')) {
            if (isEmpty($('#site_id button').data('value'))) {
                errorMsg('<fmt:message key="yieldReport.error.9" />');
                return;
            }
        }

        if ($('#report_data_start').monthpicker('getDate') === null || $('#report_data_end').monthpicker('getDate') === null) {
            errorMsg('<fmt:message key="yieldReport.error.10" />');
            return;
        }

        data['generated_by'] = loginId;
        data['updated_by'] = loginId;
        data['generated_at'] = today.toISOString();

        $.ajax({
            url: apiHost + '/reports/cost?oid=' + oid,
            method: 'post',
            dataType: 'json',
            contentType: 'application/json',
            traditional: true,
            data: JSON.stringify(data),
            success: () => {
                $('#reportModal').modal('hide');
                errorMsg('<fmt:message key="yieldReport.error.11" />');
                getDataList();
            },
            fail: () => {
                errorMsg('<fmt:message key="yieldReport.error.12" />');
                return false;
            }
        });
    }

    /**
     * 파일 다운로드
     *
     * @param fileKey
     * @param orgFilename
     */
    const downloadFile = (fileKey, orgFilename) => {
        let url = apiHost + '/files/download/' + fileKey + '?oid=' + oid + '&orgFilename' + orgFilename;
        $.ajax({
            url: url,
            method: 'GET',
            xhrFields: {
                responseType: 'blob'
            },
            success: function(data) {
                let name = orgFilename
                    , a = document.createElement('a')
                    , url = window.URL.createObjectURL(data);

                a.href = url;
                a.download = name;
                document.body.append(a);
                a.click();
                setTimeout(function(){
                    a.remove();
                    window.URL.revokeObjectURL(url);
                }, 200);
            },
            fail: function(){
                errorMsg('<fmt:message key="yieldReport.error.2" />');
            }
        });
    }

    const setCheckedDataExcelDown = () => {
        const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');

        let zipArr = new Array()
        if (checkedArray.length === 0) {
            errorMsg('<fmt:message key="yieldReport.error.17" />');
        } else {
            checkedArray.forEach(checkBox => {
                const chkIndex = Number((checkBox.getAttribute('id')).replace(/[^0-9]/g, ''))
                    , rowData = yieldTable.row(chkIndex).data()
                    , fileLink = (rowData.file_link.substring(15)).substring(0, rowData.file_link.substring(15).length - 1)
                    , orgFileName = JSON.parse(rowData.generated_file_link).orgFileName;

                if (zipArr.some(e => e.fileName === orgFileName)) {
                    let tempName = orgFileName.split('.');
                    zipArr.push({
                        fileLink: fileLink,
                        fileName: tempName[0] + '_' + i + '.' + tempName[1]
                    });
                } else {
                    zipArr.push({
                        fileLink: fileLink,
                        fileName: orgFileName
                    });
                }
            });

            getZip(zipArr);
            getDataList();
        }
    }

    //압축
    const getZip = function (zipArr) {
        let Promise = window.Promise;
        if (!Promise) {
            Promise = JSZip.external.Promise;
        }
        //압축하기
        let zip = new JSZip();
        zipArr.forEach(rowData => {
            zip.file(rowData.fileName, urlToPromise(rowData.fileLink), { binary: true });
        });

        zip.generateAsync({ type: 'blob' })
            .then(function (blob) {
                saveAs(blob, '엑셀_다운로드.zip');
            });
    }

    //바이너리
    const urlToPromise = function (url) {
        return new Promise(function (resolve, reject) {
            JSZipUtils.getBinaryContent(url, function (err, data) {
                if (err) {
                    reject(err);
                } else {
                    resolve(data);
                }
            });
        });
    }

    function setCheckedDataRemove() {
        const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');

        if (checkedArray.length === 0) {
            errorMsg('<fmt:message key="yieldReport.error.18" />');
        } else {
            let modal = $("#comDeleteModal");
            let deleteBtn = $("#comDeleteBtn");
            let confirmTitle = $("#confirmTitle");

            $("#comDeleteSuccessMsg span").text('<fmt:message key="yieldReport.delete" />');
            modal.find(".modal-body").removeClass("hidden");
            modal.modal("show");

            confirmTitle.on("input keyp", function() {
                if($(this).val() !== '삭제') {
                    deleteBtn.prop("disabled", true);
                    return false
                } else {
                    deleteBtn.prop("disabled", false);
                }
            });
        }
    }

    $(document).on('click', '#comDeleteBtn', function() {
        $('#comDeleteModal').modal('hide');
        $('#confirmTitle').val('');

        const deleteArray = new Array();
        const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
        checkedArray.forEach(checkBox => {
            const chkIndex = Number((checkBox.getAttribute('id')).replace(/[^0-9]/g, ''))
                , rowData = costTable.row(chkIndex).data();

            deleteArray.push($.ajax({
                url: apiHost + '/reports/cost/' + rowData.id + '?oid=' + oid,
                type: 'delete'
            }));
        });

        Promise.all(deleteArray).then(response => {
            let totalDelete = 0;
            response.forEach(result => {
                const data = result['data']
                    , count = data['count'];

                totalDelete += Number(count);
            });

            errorMsg(totalDelete + '<fmt:message key="yieldReport.countDelete" />');
            getDataList();
        }).catch(error => {
            errorMsg(error);
        });
    });

    /**
     * 에러 처리
     *
     * @param msg
     */
    const errorMsg = msg => {
        $('#errMsg').text(msg);
        $('#errorModal').modal('show');
        setTimeout(function(){
            $('#errorModal').modal('hide');
        }, 1800);
    }
</script>

<!-- 모달 -->
<div id="reportModal" class="modal fade" role="dialog">
    <div class="modal-dialog spc-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h2>원가관리 보고서</h2>
            </div>
            <div class="modal-body">
                <div class="report-modal-content container-fluid">
                    <div class="row">
                        <div class="col-lg-6 col-sm-12">
                            <div class="flex-start">
                                <span class="input-label">SPC</span>
                                <div id="spc_id" class="dropdown placeholder">
                                    <button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
                                        선택<span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu"></ul>
                                </div>
                            </div>
                            <div class="flex-start">
                                <span class="input-label">보고서 유형</span>
                                <div id="report_type" class="dropdown placeholder">
                                    <button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
                                        선택<span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li data-value="cost_gen">
                                           <a href="javascript:void(0);">cost gen</a>
                                        </li>
                                        <li data-value="cost_spc">
                                            <a href="javascript:void(0);">cost spc</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6 col-sm-12">
                            <div class="flex-start">
                                <span class="input-label">발전소</span>
                                <div id="site_id" class="dropdown placeholder">
                                    <button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
                                        선택<span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu"></ul>
                                </div>
                            </div>
                            <div class="flex-start dateField">
                                <span class="input-label">적용기간</span>
                                <div class="sel-calendar">
                                    <input type="text" id="report_data_start" name="report_data_start" value="" class="sel month-pick" autocomplete="off" readonly="" placeholder="날짜 선택">
                                </div>
                                <div class="sel-calendar ml-22">
                                    <input type="text" id="report_data_end" name="report_data_end" value="" class="sel month-pick" autocomplete="off" readonly="" placeholder="날짜 선택">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="btn-wrap-type02">
                        <button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
                        <button style="padding: 0px;" type="button" class="btn-type" onclick="reportCreate();">생성</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row header-wrapper">
    <div class="col-12">
        <h1 class="page-header fl">원가관리 보고서</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-3 col-md-4 col-sm-12 search-left">
        <div class="indiv">
            <div class="flex-wrapper">
                <h2 class="ntit">전체 통합 원가관리 요약</h2>
            </div>
            <div class="value-wrapper">
                <h3 class="value-title">이익률</h3>
                <p class="value-num" id="margin"></p>
            </div>
            <div class="value-wrapper">
                <h3 class="value-title">이익금</h3>
                <p class="value-num" id="profit"></p>
            </div>
            <div class="value-wrapper">
                <h3 class="value-title">수입총계</h3>
                <p class="value-num" id="incomSum"></p>
            </div>
            <div class="value-wrapper">
                <h3 class="value-title">지출총계</h3>
                <p class="value-num" id="expenseSum"></p>
            </div>
            <div class="toggle-box">
                <div class="table-area clear">
                    <p class="table-text fl">기간설정</p>
                    <button type="button" class="btn-caret fr">펼치기</button>
                </div>
                <div class="table-fold-container">
                    <p class="table-text">적용기간</p>
                    <div class="flex-wrapper">
                        <div class="sel-calendar text-input-type unit w-100">
                            <input type="text" id="fromDate" class="sel month-pick" value="" autocomplete="off" readonly placeholder="시작일 선택">
                            <img class="ui-datepicker-trigger" src="" alt="..." title="...">
                        </div>
                        <div class="sel-calendar text-input-type unit t1 w-100">
                            <input type="text" id="toDate" class="sel month-pick" value="" autocomplete="off" readonly placeholder="종료일 선택">
                            <img class="ui-datepicker-trigger" src="" alt="..." title="...">
                        </div>
                    </div>
                    <button type="button" class="btn-type" id="application">적용</button>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-9 col-md-8 col-sm-12">
        <div class="indiv">
            <div class="flex-wrapper mb-20">
                <div><!--
					--><button type="button" class="btn-type03 big" onclick="setCheckedDataExcelDown();">선택 다운로드</button><!--
					--><button type="button" class="btn-type03 big" onclick="setCheckedDataRemove();">선택 삭제</button><!--
				--></div>
                <div><button type="button" class="btn-type" onclick="modalInit();">신규 생성</button></div>
            </div>
            <table id="costTable" class="chk-type">
                <colgroup>
                   <col style="width:5%" /> <%-- 체크박스 --%>
                   <col style="width:5%" /> <%-- 순번 --%>
                   <col style="width:15%" /> <%-- SPC명 --%>
                   <col style="width:15%" /> <%-- 발전소명 --%>
                   <col style="width:10%" /> <%-- 보고서 유형 --%>
                   <col style="width:20%" /> <%-- 적용기간 --%>
                   <col style="width:10%" /> <%-- 다운로드 --%>
                   <col style="width:20%" /> <%-- 보고서 생성시간 --%>
                </colgroup>
            </table>
        </div>
    </div>
</div>