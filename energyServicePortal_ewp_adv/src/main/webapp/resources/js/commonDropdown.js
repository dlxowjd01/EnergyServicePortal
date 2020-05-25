/**
 * dropDown 사용시 공통 처리를 위한 로직
 * 아직 모든화면에서 공통 작동하는지 확인 필요함으로
 * 따로 분리해놈 확인후 common.js 에 통합 예정.
 *
 */
//드롭 다운 공통 동작 작업 -- 디스에이블이 아닌 항목에 대해서 작동함.
$(document).on('click', '.dropdown-menu li:not(.disabled, .dropdown_cov)', function (e) {
	e.preventDefault(); //다른 드롭 다운 동작 막기
	let $selecter = $(this),
		$dropdown = $selecter.closest('.dropdown'),
		$dropdownId = $dropdown.prop('id'),
		$displayButton = $dropdown.find('button'),
		$displayData = '',
		$displayText = '';

	if ($selecter.find(':radio').length > 0) {
		let $radio = $(this).find(':radio');
		$radio.prop('checked', true);
		$displayText = $dropdown.find('input[type="radio"]:checked').next().text();
	} else if ($selecter.find(':checkbox').length > 0) {
		let $checkbox = $(this).find(':checkbox');
		if($checkbox.prop('checked')) {
			$checkbox.prop('checked', false);
		} else {
			$checkbox.prop('checked', true);
		}

		let checkboxLength = $dropdown.find('input[type="checkbox"]:checked').length;
		if(checkboxLength > 1) {
			$displayText = $dropdown.find('input[type="checkbox"]:checked:eq(0)').next().text() + '외 ' + checkboxLength + '개';
		} else if(checkboxLength == 0) {
			$displayText = $displayButton.data('name');
		} else {
			$displayText = $dropdown.find('input[type="checkbox"]:checked:eq(0)').next().text();
		}
	} else {
		$displayData = $selecter.data();
		$displayText = $selecter.text();
	}

	$displayButton.eq(0).html($displayText + '<span class="caret"></span>').data('value', $displayData);

	//data Setting
	if(!isEmpty($displayData)) {
		$.map($displayData, function(val, key) {
			$displayButton.data(key, val);
		});
	}


	if(typeof(rtnDropdown) == 'function') {
		rtnDropdown($dropdownId);
	}
});