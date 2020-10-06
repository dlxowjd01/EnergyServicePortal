
/**
 * 더 큰 단위를 채크 하기 위한 비교 문
 *
 * @param experimental
 * @param control
 * @returns {*}
 */
const compareUnit = (experimental, control) => {
	let rtnValue = '';
	const whUnit = ['', 'k', 'M', 'G', 'T'];
	const moneyUnit = [
		{ unit: '', chipher: 1 },
		{ unit: '십', chipher: 10 },
		{ unit: '백', chipher: 100 },
		{ unit: '천', chipher: 1000 },
		{ unit: '만', chipher: 10000 },
		{ unit: '십만', chipher: 100000 },
		{ unit: '백만', chipher: 1000000 },
		{ unit: '천만', chipher: 10000000 },
		{ unit: '억', chipher: 100000000 },
	];

	experimental = (experimental.substr(0, 1)).replace(/W/i, '');
	control = (control.substr(0, 1)).replace(/W/i, '');

	const experimentalIndex = whUnit.some((x, i) => {if (x == experimental) return i;});
	const controlIndex = whUnit.some((x, i) => {if (x == control) return i;});

	if (experimentalIndex > controlIndex) {
		rtnValue = experimental;
	} else {
		rtnValue = control;
	}

	return rtnValue;
}

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
	let moneyUnit = [
		{ unit: '', chipher: 1 },
		{ unit: '십', chipher: 10 },
		{ unit: '백', chipher: 100 },
		{ unit: '천', chipher: 1000 },
		{ unit: '만', chipher: 10000 },
		{ unit: '십만', chipher: 100000 },
		{ unit: '백만', chipher: 1000000 },
		{ unit: '천만', chipher: 10000000 },
		{ unit: '억', chipher: 100000000 },
	];
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
			if (!isEmpty(standardUnit)) {
				const findIndex = whUnit.findIndex(targetUnit => targetUnit.match(standardUnit));
				if (findIndex > 0) {
					whUnit = whUnit.splice(findIndex, whUnit.length);
				}
			}

			/* 시작 unit 단위가 w보다 클경우 */

			if (unit.match('h')) {
				suffix = 'h';
			}

			whUnit.some(function(v, k) {
				let str = String(Math.floor(number));
				if(isEmpty(intChipher)) {
					if(str.length > 3 && v != 'T') {
						number = number / 1000;
					} else {
						rtnValue = [numberComma((number).toFixed(decimalChipher)), v + 'W' + suffix];
						return rtnValue;
					}
				} else {
					if(str.length > intChipher && v != 'T') {
						number = number / 1000;
					} else {
						rtnValue = [numberComma((number).toFixed(decimalChipher)), v + 'W' + suffix];
						return rtnValue;
					}
				}
			});
		} else {
			if (isEmpty(intChipher)) {
				intChipher = 3;
			}

			if (isEmpty(decimalChipher)) {
				decimalChipher = 0;
			}

			/* 시작 unit 단위가 w보다 클경우 */
			const standardUnit = (unit.substr(0, 1)).replace('원', '');
			if (!isEmpty(standardUnit)) {
				const findIndex = moneyUnit.findIndex(targetUnit => (targetUnit.unit).match(standardUnit));
				if (findIndex > 0) {
					moneyUnit = moneyUnit.splice(findIndex, moneyUnit.length);
				}
			}
			/* 시작 unit 단위가 w보다 클경우 */

			moneyUnit.some((money, index) => {
				const mUnit = money['unit'];
				const mChipher = money['chipher'];
				if(String(Math.round(number / mChipher)).length <= intChipher || mUnit == '억') {
					rtnValue = [numberComma((number / mChipher).toFixed(decimalChipher)), mUnit + '원'];
					return rtnValue;
				}
			});
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
const displayNumberFixedUnit = function (input_num, input_unit, fixed_unit, num_frac) {
	let rtnValue = []
	let whUnit = ['', 'k', 'M', 'G', 'T'];
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
	let suffix = '';

	if(isEmpty(input_num)) {
		rtnValue = ['-', input_unit];
		return rtnValue;
	} else {
		if (input_unit == fixed_unit) {
			rtnValue = [numberComma((input_num).toFixed(num_frac)), fixed_unit];
			return rtnValue;
		}

		if(input_unit.match('W')) {
			/* 시작 unit 단위가 w보다 클경우 */
			const standardUnit = (input_unit.substr(0, 1)).replace(/W/i, '');
			if (!isEmpty(standardUnit)) {
				const findIndex = whUnit.findIndex(targetUnit => targetUnit.match(standardUnit));
				if (findIndex > 0) {
					whUnit = whUnit.splice(findIndex, whUnit.length);
				}
			}
			/* 시작 unit 단위가 w보다 클경우 */
			if (input_unit.match('h')) {
				suffix = 'h';
			}

			if(isEmpty(num_frac)) {
				num_frac = 2;
			}

			if(isEmpty(fixed_unit)) {
				rtnValue = [input_num, input_unit];
				return rtnValue;
			}

			whUnit.some(function(v, k) {
				let str = String(Math.floor(input_num));
				if(fixed_unit == v + 'W' + suffix) {
					input_num = input_num / Math.pow(1000, k);
					if(Math.floor(input_num * 100) == 0) {
						rtnValue = [0, v + 'W' +  suffix];
					} else {
						rtnValue = [numberComma((input_num).toFixed(num_frac)), v + 'W' +  suffix];
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