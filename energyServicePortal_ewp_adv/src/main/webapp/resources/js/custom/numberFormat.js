/**
 * 숫자표현 함수
 *
 * @param int -- 변환할 숫자 값
 * @param unit -- 단위 ('WH', '원')
 * @param intChipher -- 정수 자릿수
 * @param decimalChipher -- 소수 자릿수
 * @returns {[string, *]|[]}
 */
const displayNumberFixedDecimal = function(number, unit, intChipher, decimalChipher) {
	let rtnValue = []
	let whUnit = ['', 'k', 'M', 'G', 'T'];
	let suffix = '';

	if(isEmpty(number)) {
		return ['-', unit];
	} else {
		if(unit.match('W')) {

			if(isEmpty(decimalChipher)) {
				decimalChipher = 2;
			}

			/* 시작 unit 단위가 w보다 클경우 */
			const standardUnit = (unit.substr(0, 1)).replace(/W/i, '');
			const findIndex = whUnit.findIndex(targetUnit => targetUnit.match(standardUnit));
			if (findIndex > 0) {
				whUnit = whUnit.splice(findIndex, whUnit.length);
			}
			/* 시작 unit 단위가 w보다 클경우 */

			if (unit.match('h')) {
				suffix = 'h';
			}

			whUnit.some(function(v, k) {
				let str = String(Math.floor(number));
				if(isEmpty(intChipher)) {
					if(str.length > 3 && v != 'GW') {
						number = number / 1000;
					} else {
						rtnValue = [numberComma((number).toFixed(decimalChipher)), v + 'W' + suffix];
						return rtnValue;
					}
				} else {
					if(str.length > intChipher && v != 'GW') {
						number = number / 1000;
					} else {
						rtnValue = [numberComma((number).toFixed(decimalChipher)), v + 'W' + suffix];
						return rtnValue;
					}
				}
			});
		} else {
			if(isEmpty(decimalChipher)) {
				decimalChipher = 0;
			}

			let str = String(Math.floor(number));
			if(isEmpty(intChipher)) {
				if(str.length > 4) {
					number = number / 10000;
					rtnValue = [numberComma((number).toFixed(decimalChipher)), '만원'];
				} else if(str.length > 3) {
					number = number / 1000;
					rtnValue = [numberComma((number).toFixed(decimalChipher)), '천원'];
				} else {
					rtnValue = [numberComma((number).toFixed(decimalChipher)), '원'];
				}
			} else {
				let str = String(Math.floor(number));
				if (str.length > intChipher) {
					if (str.length - 3 <= intChipher) {
						number = number / 1000;
						rtnValue = [numberComma((number).toFixed(decimalChipher)), '천원'];
					} else {
						number = number / 10000;
						rtnValue = [numberComma((number).toFixed(decimalChipher)), '만원'];
					}
					number = number / 1000;
				} else {
					rtnValue = [numberComma((number).toFixed(decimalChipher)), '원'];
					return rtnValue;
				}
			}
		}
		return rtnValue;
	}
}

/**
 * 단위형 고정.
 *
 * @param number
 * @param unit
 * @param fixedUnit
 * @param decimalChipher
 * @returns {[string, *]|[]}
 */
const displayNumberFixedUnit = function(input_num, input_unit, fixed_unit, num_frac) {
	let rtnValue = []
	let whUnit = ['W', 'kW', 'MW', 'GW'];
	let moneyUnit = [
		{ unit: '원', chipher: 1 },
		{ unit: '십원', chipher: 10 },
		{ unit: '백원', chipher: 100 },
		{ unit: '천원', chipher: 1000 },
		{ unit: '만원', chipher: 10000 },
		{ unit: '십만원', chipher: 100000 },
		{ unit: '백만원', chipher: 1000000 },
		{ unit: '천만원', chipher: 10000000 },
		{ unit: '억원', chipher: 100000000 },
	];

	if(isEmpty(input_num)) {
		rtnValue = ['-', input_unit];
		return rtnValue;
	} else {
		if (input_unit == fixed_unit) {
			rtnValue = [numberComma((input_num).toFixed(num_frac)), fixed_unit];
			return rtnValue;
		}

		if(input_unit == 'Wh' || input_unit == 'W') {

			if(isEmpty(num_frac)) {
				num_frac = 2;
			}

			if(isEmpty(fixed_unit)) {
				rtnValue = [input_num, input_unit];
				return rtnValue;
			}

			whUnit.some(function(v, k) {
				let str = String(Math.floor(input_num));
				if(fixed_unit.startsWith(v)) {
					input_num = input_num / Math.pow(1000, k);
					if(input_unit.endsWith('h')) {
						if(Math.floor(input_num * 100) == 0) {
							rtnValue = [0, v + 'h'];
						} else {
							rtnValue = [numberComma((input_num).toFixed(num_frac)), v + 'h'];
						}
					} else {
						if(Math.floor(input_num * 100) == 0) {
							rtnValue = [0, v + 'h'];
						} else {
							rtnValue = [numberComma((input_num).toFixed(num_frac)), v];
						}
					}
					return rtnValue;
				}
			});
		} else {
			$.each(moneyUnit, function(i, el) {
				if(fixed_unit == el.unit) {
					input_num = input_num / el.chipher;
					if(Math.floor(input_num * 100) == 0) {
						rtnValue = [0, el.unit];
					} else {
						rtnValue = [numberComma((input_num).toFixed(num_frac)), el.unit];
					}
					return false;
				}
			});
		}
		return rtnValue;
	}
}