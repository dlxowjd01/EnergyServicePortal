
/*
메인function을 위한 function
*/

function setHms(start, end) {
    if (SelTerm !== '30min' && SelTerm !== 'hour') start.setHours(0);
    start.setMinutes(0);
    start.setSeconds(0);
    start.setMilliseconds(0);
    if (SelTerm !== '30min' && SelTerm !== 'hour') end.setHours(23);
    end.setMinutes(59);
    end.setSeconds(59);
    end.setMilliseconds(999);
}

//표 영역의 헤더 날짜형식 변환
function convertDataTableHeaderDate(_convertDt, type) {
    var convertDt = _convertDt instanceof Date ? _convertDt : new Date(_convertDt);
    var headerDate = "";

    if (type === 1) {
        if (SelTerm === '30min' || SelTerm === 'hour' || SelTerm === 'day') {
            headerDate = convertDt.format("yyyy-MM-dd");
        } else if (SelTerm === 'week' || SelTerm === 'month') {
            if (periodd === 'day') headerDate = convertDt.format("yyyy-MM");
            else headerDate = convertDt.format("yyyy-MM-dd");
        } else if (SelTerm === 'year') {
            if (periodd === 'day') headerDate = convertDt.format("yyyy");
            else if (periodd !== 'month') headerDate = convertDt.format("yyyy-MM-dd");
        } else if (SelTerm === "other") {
            headerDate = convertDt.format("yyyy-MM-dd");
        }
    } else if (type === 2) {
        if (SelTerm === '30min' || SelTerm === 'hour' || SelTerm === 'day') {
            headerDate = convertDt.format("HH:mm");
        } else if (SelTerm === 'week' || SelTerm === 'month') {
            if (periodd === 'day') headerDate = convertDt.format("MM-dd");
            else headerDate = convertDt.format("HH:mm");
        } else if (SelTerm === 'year') {
            if (periodd === 'day') headerDate = convertDt.format("yyyy-MM-dd");
            else if (periodd === 'month') headerDate = convertDt.format("yyyy-MM");
            else headerDate = convertDt.format("HH:mm");
        } else if (SelTerm === "other") {
            headerDate = convertDt.format("HH:mm");
        }
    }

    return headerDate;
}

//날짜포멧 변경
Date.prototype.format = function (f) {
    if (!this.valueOf()) return " ";

    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy":
                return d.getFullYear();
            case "yy":
                return (d.getFullYear() % 1000).zf(2);
            case "MM":
                return (d.getMonth() + 1).zf(2);
            case "dd":
                return d.getDate().zf(2);
            case "E":
                return weekName[d.getDay()];
            case "HH":
                return d.getHours().zf(2);
            case "hh":
                return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm":
                return d.getMinutes().zf(2);
            case "ss":
                return d.getSeconds().zf(2);
            case "a/p":
                return d.getHours() < 12 ? '<spring:message code="ewp.utils.am" />' : '<spring:message code="ewp.utils.pm" />';
            default:
                return $1;
        }
    });
};
String.prototype.string = function (len) {
    var s = '', i = 0;
    while (i++ < len) {
        s += this;
    }
    return s;
};
String.prototype.zf = function (len) {
    return "0".string(len - this.length) + this;
};
Number.prototype.zf = function (len) {
    return this.toString().zf(len);
};

//넘어온 값이 빈값인지 체크
//!value 하면 생기는 논리적 오류를 제거하기 위해 명시적으로 value == 사용
//[], {} 도 빈값으로 처리
var isEmpty = function (value) {
    if (value === "" || value === null || value === undefined || (value !== null && typeof value === "object" && !Object.keys(value).length)) {
        return true;
    } else {
        return false;
    }
};

function incrementTime(_time) {
    if (periodd === 'month') {
        _time.setDate(1);
        _time.setHours(0);
        _time.setMinutes(0);
        _time.setSeconds(0);

        _time = new Date(_time.setMonth(_time.getMonth() + 1));
        return _time;
    } else {
        var loopSumCnt = calculateCnt();
        var plusMinute = 15 * loopSumCnt;
        var __time = new Date(_time.setMinutes(_time.getMinutes() + plusMinute));
        return __time;
    }
}

function calculateCnt() {
    var cnt = 0;
    if (periodd === '15min') {
        cnt = 1;
    } else if (periodd === '30min') {
        cnt = 2;
    } else if (periodd === 'hour') {
        cnt = 4;
    } else if (periodd === 'day') {
        cnt = 96;
    } else if (periodd === 'month') {
        cnt = 96 * 30;
    }

    return cnt;
}

//숫자 단위 변경
function convertUnitFormat(num, unitGbn, len) {
    var formatNum;
    var unit;
    var divNum = 0;

    if (len === null) {
        var str = Math.abs(num).toString();
        len = str.length;
    }

    if (unitGbn === "KRW") {
        formatNum = numberComma(num);
        unit = "KRW";
    } else {
        if (len <= 3) {
            if (unitGbn === "mWh") unit = "mWh";
            if (unitGbn === "Wh") unit = "Wh";
            if (unitGbn === "kWh") unit = "kWh";
            if (unitGbn === "W") unit = "W";
            if (unitGbn === "kW") unit = "kW";
        } else if (len <= 6) {
            divNum = 1000;
            if (unitGbn === "mWh") unit = "Wh";
            if (unitGbn === "Wh") unit = "kWh";
            if (unitGbn === "kWh") unit = "MWh";
            if (unitGbn === "W") unit = "kW";
            if (unitGbn === "kW") unit = "MW";
        } else if (len <= 9) {
            divNum = 1000 * 1000;
            if (unitGbn === "mWh") unit = "kWh";
            if (unitGbn === "Wh") unit = "MWh";
            if (unitGbn === "kWh") unit = "GWh";
            if (unitGbn === "W") unit = "MW";
            if (unitGbn === "kW") unit = "GW";
        } else if (len <= 12) {
            divNum = 1000 * 1000 * 1000;
            if (unitGbn === "mWh") unit = "MWh";
            if (unitGbn === "Wh") unit = "GWh";
            if (unitGbn === "kWh") unit = "TWh";
            if (unitGbn === "W") unit = "GW";
            if (unitGbn === "kW") unit = "TW";
        } else {
            divNum = 1000 * 1000 * 1000 * 1000;
            if (unitGbn === "mWh") unit = "GWh";
            if (unitGbn === "Wh") unit = "TWh";
            if (unitGbn === "kWh") unit = "PWh";
            if (unitGbn === "W") unit = "TW";
            if (unitGbn === "kW") unit = "PW";
        }

        if (len <= 3) {
            formatNum = num;
        } else {
            formatNum = Number(num) / divNum;
        }

    }

    if (formatNum === "NaN") formatNum = "0";

    var map = new _Map();
    map.put("formatNum", formatNum);
    map.put("unit", unit);

    return map;
}

//============ Map 구조 구현============
//var map = new _Map();
//map.put("name","사과");
//map.get("name");
function _Map() {
    this.elements = {};
    this.length = 0;
}
_Map.prototype.put = function (key, value) {
    this.length++;
    this.elements[key] = value;
};
_Map.prototype.get = function (key) {
    return this.elements[key];
};
_Map.prototype.remove = function (key) {
    this.elements[key] = undefined;
};


//소수점 fix자리 반올림
function toFixedNum(num, fix) {
    var no = Number(num);
    return Number(no.toFixed(fix));
}

//그래프에 대입할 날짜(x축) 세팅
function setChartDateUTC(_dateTimestamp) {
    var localYn = "N"; // 개발서버인 경우 N으로 변경
    var tm = new Date(_dateTimestamp);
    if (localYn === "Y") {
        var offset = timeOffset * 2 * (-1);
        var date = new Date(tm.setMinutes(tm.getMinutes() + offset));
        return date.getTime();
    } else if (localYn === "N") {
        return new Date(Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())).getTime();
    }
}


// 표에 대입할 날짜 세팅
function setSheetDateUTC(_dateTimestamp) {
    var localYn = "N"; // 개발서버인 경우 N으로 변경
    if (localYn === "Y") {
        var tm = new Date(_dateTimestamp);
        var offset = timeOffset * (-1);
        var date = new Date(tm.setMinutes(tm.getMinutes() + offset));
        return date.getTime();
    } else if (localYn === "N") {
        return new Date(_dateTimestamp).getTime();
    }
}

//숫자 콤마 붙이기
function numberComma(num) {
	var parts = num.toString().split(".");
	return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : "");
//    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}