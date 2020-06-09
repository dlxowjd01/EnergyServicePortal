/**
 * dropDown 사용시 공통 처리를 위한 로직
 * 아직 모든화면에서 공통 작동하는지 확인 필요함으로
 * 따로 분리해놈 확인후 common.js 에 통합 예정.
 *
 */
//드롭 다운 공통 동작 작업 -- 디스에이블이 아닌 항목에 대해서 작동함.
$(document).on('click', '.dropdown-menu:not(.unused) li:not(.disabled, .dropdown_cov)', function (e) {
	e.preventDefault(); //다른 드롭 다운 동작 막기
	let $selector = $(this),
		$dropdown = $selector.closest('.dropdown'),
		$dropdownId = $dropdown.prop('id'),
		$displayButton = $dropdown.find('button');

	if ($selector.find(':radio').length > 0) {
		$selector.find(':radio').prop('checked', true);
	} else if ($selector.find(':checkbox').length > 0) {
		if($selector.find(':checkbox').prop('checked')) {
			$selector.find(':checkbox').prop('checked', false);
		} else {
			$selector.find(':checkbox').prop('checked', true);
		}
	}

	if ($selector.find(':radio').length > 0 || $selector.find(':checkbox').length > 0) {
		displayDropdown($dropdown);
	} else {
		let $displayData = $selector.data();
		let $displayText = $selector.text();

		$displayButton.eq(0).html($displayText + '<span class="caret"></span>');

		//data Setting
		if(!isEmpty($displayData)) {
			$.map($displayData, function(val, key) {
				$displayButton.data(key, val);
			});
		}
	}


	if(typeof(rtnDropdown) == 'function') {
		rtnDropdown($dropdownId);
	}
});

const displayDropdown = ($selector) => {
	let $displayButton = $selector.find('button'),
		$displayData = '',
		$displayText = '';

	if ($selector.find(':radio').length > 0) {
		$displayText = $selector.find('input[type="radio"]:checked').next().text();
	} else if ($selector.find(':checkbox').length > 0) {
		let checkedboxLength = $selector.find('input[type="checkbox"]:checked').length;
		let checkboxLength = $selector.find('input[type="checkbox"]').length;

		if(checkedboxLength == checkboxLength) {
			$displayText = '전체';
		} else {
			if(checkedboxLength > 1) {
				$displayText = $selector.find('input[type="checkbox"]:checked:eq(0)').next().text() + '외 ' + (checkedboxLength - 1) + '개';
			} else if(checkedboxLength == 0) {
				$displayText = $displayButton.data('name');
			} else {
				$displayText = $selector.find('input[type="checkbox"]:checked:eq(0)').next().text();
			}
		}
	}

	$displayButton.eq(0).html($displayText + '<span class="caret"></span>');

	//data Setting
	if(!isEmpty($displayData)) {
		$.map($displayData, function(val, key) {
			$displayButton.data(key, val);
		});
	}
}