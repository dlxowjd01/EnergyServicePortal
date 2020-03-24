
var worker;  // worker
$(function () {
    var workerPath;
    var urlPathName = window.location.pathname;
    if(urlPathName === "/energy/usage.do") workerPath = '/js/custom/worker/usageWorker.js';
    else if(urlPathName === "/energy/peak.do") workerPath = '/js/custom/worker/peakWorker.js';
    else if(urlPathName === "/energy/essCharge.do") workerPath = '/js/custom/worker/essChargeWorker.js';
    else if(urlPathName === "/energy/pvGen.do") workerPath = '/js/custom/worker/pvGenWorker.js';
    else if(urlPathName === "/energy/derUsage.do") workerPath = '/js/custom/worker/derUsageWorker.js';
    worker = new Worker( workerPath );
});

// worker 실행
function startWorker(result, command) {

    // Worker 지원 유무 확인
    if ( window.Worker ) {

        // 실행하고 있는 워커 있으면 중지시키기
        // if ( worker ) stopWorker();

        // 워커에 메시지를 보낸다.
        worker.postMessage({
            command: command,
            config: {
                periodd: $("#selPeriodVal").val(),
                schStartTime: schStartTime,
                schEndTime: schEndTime,
                SelTerm: SelTerm,
                dt_col: dt_col,
                timeOffset: timeOffset,
                contractPower: contractPower,
                chargePower: chargePower
            },
            data: result
        });

        // 메시지는 JSON구조로 직렬화 할 수 있는 값이면 사용할 수 있다. Object등
        // worker.postMessage( { name : '302chanwoo' } );

        // 워커로 부터 메시지를 수신한다.
        worker.onmessage = function( e ) {
            switch(e.data.command){
                case 'pastUsageList':
                    usage_head_pc = e.data.usage_head_pc;
                    real_data_pc = e.data.real_data_pc;
                    pastUsageList = e.data.pastUsageList;
                    pastTotalUsage = e.data.totalUsage;
                    unit_format(String(pastTotalUsage), "pastUseTot", "Wh");
                    break;
                case 'predictUsageList':
                    feture_data_pc = e.data.feture_data_pc;
                    defaultData_pc = e.data.defaultData_pc;
                    fetureUsageList = e.data.fetureUsageList;
                    fetureTotalUsage = e.data.fetureTotalUsage;
                    unit_format(String(fetureTotalUsage), "futureUseTot", "Wh");
                    endWorker();
                    break;
                case 'peakList':
                    peak_head_pc = e.data.peak_head_pc;
                    peak_data_pc = e.data.peak_data_pc;
                    ctpPw_data_pc = e.data.ctpPw_data_pc;
                    cgtPw_data_pc = e.data.cgtPw_data_pc;
                    contractPowerList = e.data.contractPowerList;
                    chargePowerList = e.data.chargePowerList;
                    pastPeakList = e.data.pastPeakList;
                    maxPeakVal = e.data.maxPeakVal;
                    maxPeakTmstp = e.data.maxPeakTmstp;
                    // 피크의 경우 피크 최대 전력을 입력
                    $(".pktime").empty().append($("<span />").append(maxPeakTmstp));
                    unit_format(String(Math.round(Number(maxPeakVal))), "pastPeakListTot", "kW");
                    unit_format(String(Math.round(Number(contractPower))), "contractPowerListTot", "W");
                    unit_format(String(Math.round(Number(chargePower))), "chargePowerListTot", "W");
                    endWorker();
                    break;
                case 'pastEssChargeList':
                    ess_head_pc = e.data.ess_head_pc;
                    realChg_data_pc = e.data.realChg_data_pc;
                    realDischg_data_pc = e.data.realDischg_data_pc;
                    pastChgList = e.data.pastChgList;
                    pastDischgList = e.data.pastDischgList;
                    unit_format(String(e.data.pastEssChgTotalVal), "pastChgTot", "Wh");
                    unit_format(String(e.data.pastEssDischgTotalVal), "pastDischgTot", "Wh");
                    break;
                case 'predictEssChargeList':
                    fetureChg_data_pc = e.data.fetureChg_data_pc;
                    fetureDischg_data_pc = e.data.fetureDischg_data_pc;
                    defaultData_pc = e.data.defaultData_pc;
                    fetureChgList = e.data.fetureChgList;
                    fetureDischgList = e.data.fetureDischgList;
                    unit_format(String(e.data.fetureEssChgTotalVal), "fetureChgTot", "Wh");
                    unit_format(String(e.data.fetureEssChgTotalVal), "fetureDischgTot", "Wh");
                    endWorker();
                    break;
                case 'pastPvGenList':
                    pv_head_pc = e.data.pv_head_pc;
                    real_data_pc = e.data.real_data_pc;
                    pastPVGenList = e.data.pastPVGenList;
                    unit_format(String(e.data.pastPvGenTotalVal), "pastPvGenTot", "Wh");
                    endWorker();
                    break;
                case 'predictPvGenList':
                    feture_data_pc = e.data.feture_data_pc;
                    feturePVGenList = e.data.feturePVGenList;
                    unit_format(String(e.data.feturePvGenTotalVal), "feturePvGenTot", "Wh");
                    break;
                case 'derUsageList':
                    usage_head_pc = e.data.usage_head_pc;
                    real_data_pc = e.data.real_data_pc;
                    ess_data_pc = e.data.ess_data_pc;
                    pv_data_pc = e.data.pv_data_pc;
                    total_data_pc = e.data.total_data_pc;
                    pastUsageList = e.data.pastUsageList;
                    essUsageList = e.data.essUsageList;
                    pvUsageList = e.data.pvUsageList;
                    if (pastUsageList != null && pastUsageList.length > 0) {
                        myChart.addSeries({
                            index: 3,
                            fillOpacity: 0,
                            name: '한전 사용량',
                            color: '#438fd7',
                            lineColor: '#438fd7', /* 한전 사용량 */
                            data: pastUsageList
                        }, false);
                    }
                    if (essUsageList != null && essUsageList.length > 0) {
                        myChart.addSeries({
                            index: 2,
                            fillOpacity: 0.5,
                            name: 'ESS 사용량',
                            color: '#13af67', /* ESS 사용량 */
                            data: essUsageList
                        }, false);
                    }
                    if (pvUsageList != null && pvUsageList.length > 0) {
                        myChart.addSeries({
                            index: 1,
                            fillOpacity: 0.5,
                            name: 'PV 사용량',
                            color: '#f75c4a', /* PV 사용량 */
                            data: pvUsageList
                        }, false);
                    }
                    var kepcoTotalUsage = e.data.kepcoTotalUsage;
                    var essTotalUsage = e.data.essTotalUsage;
                    var pvTotalUsage = e.data.pvTotalUsage;
                    unit_format(String(kepcoTotalUsage), "usageTotal", "Wh");
                    unit_format(String(essTotalUsage), "essUsageTotal", "Wh");
                    unit_format(String(pvTotalUsage), "pvUsageTotal", "Wh");
                    var total = kepcoTotalUsage + essTotalUsage + pvTotalUsage;
                    $("#kepcoPer").empty().append("한전 사용").append($("<span />").append(((kepcoTotalUsage === 0) ? 0 : ((kepcoTotalUsage / total) * 100).toFixed(2)) + "%"));
                    $("#essPer").empty().append("ESS 사용").append($("<span />").append(((essTotalUsage === 0) ? 0 : ((essTotalUsage / total) * 100).toFixed(2)) + "%"));
                    $("#pvPer").empty().append("PV 사용").append($("<span />").append(((pvTotalUsage === 0) ? 0 : ((pvTotalUsage / total) * 100).toFixed(2)) + "%"));
                    endWorker();
                    break;
            }
        };
    }

}

// worker 중지
// 추후에 사용가능성이 있어 우선 지우지 않고 남김
// function stopWorker() {
//     if ( worker ) {
//         worker.terminate();
//         worker = null;
//     }
// }

function endWorker(command) {
//    drawData(); // 표(테이블) 그리기
	drawData_table(); // 표(테이블) 그리기
    drawData_chart(); // 차트 그리기
    $('.loading').hide();
}
