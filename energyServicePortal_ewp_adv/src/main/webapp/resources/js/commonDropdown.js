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
		if ($selector.find(':checkbox').prop('checked')) {
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
		if (!isEmpty($displayData)) {
			$.map($displayData, function (val, key) {
				$displayButton.data(key, val);
			});
		}
	}

	if (typeof (rtnDropdown) == 'function') {
		rtnDropdown($dropdownId);
	}
});

/**
 * 선택된 값 표시
 *
 * @param $selector
 */
const displayDropdown = ($selector) => {
	let $displayButton = $selector.find('button'),
		$displayData = '',
		$displayText = '';

	if ($selector.find(':radio').length > 0) {
		$displayText = $selector.find('input[type="radio"]:checked').next().text();
	} else if ($selector.find(':checkbox').length > 0) {
		let checkedboxLength = $selector.find('input[type="checkbox"]:checked').length;
		let checkboxLength = $selector.find('input[type="checkbox"]').length;

		if(checkedboxLength == checkboxLength){
			$displayText = '전체';
		} else {
			if (checkedboxLength == 0){
				$displayText = $displayButton.data('name');
			} else if (checkedboxLength > 1) {
				$displayText = $selector.find('input[type="checkbox"]:checked:eq(0)').next().text() + ' 외 ' + (checkedboxLength - 1) + '개';
			} else {
				$displayText = $selector.find('input[type="checkbox"]:checked:eq(0)').next().text();
			}
		}
	}
	$displayButton.eq(0).html($displayText + '<span class="caret"></span>');

	//data Setting
	if (!isEmpty($displayData)) {
		$.map($displayData, function (val, key) {
			$displayButton.data(key, val);
		});
	}
}

/**
 * dropDown selectAll
 *
 * @param $selector
 */
const selectAll = ($selector) => {
	let itemGroup = $selector.find('li');
	let item = itemGroup.find('input[type="checkbox"]');
	let firstCheckbox = itemGroup.first();
	let firstInput = firstCheckbox.find('input[type="checkbox"]');

	firstCheckbox.on('click', function() {
		$(this).toggleClass('active');
		if( $(this).hasClass('active') ) {
			item.prop("checked", false);
			firstInput.prop('checked', true);
		} else {
			item.prop("checked", true);
			firstInput.prop('checked', false);
		}
	});

}

/**
 * dropDown 초기화 함수
 *
 * @param $selector
 */
const dropDownInit = ($selector) => {
	let button = $selector.find('button'),
		buttonNm = $selector.find('button').data('name'),
		ul = $selector.find('ul');
	button.html(buttonNm + '<span class="caret"></span>').data('value', '');

	//데이터에 저장된 정보가 있으면 동적 항목이라 보고 초기화
	if ($.data(document, ul.prop('id'))) {
		setMakeList(new Array(), ul.prop('id'), {'dataFunction': {}});
	} else { //동적 생성된 항목이 아니고. 다중선택형일경우 선택 초기화
		if (ul.find('input').length > 0) {
			let inputType = ul.find('input').eq(0).prop('type');
			if (inputType == 'checkbox' || inputType == 'radio') {
				ul.find('input').prop('checked', false);
			}
		}
	}
}

/**
 * dropDown toggle init
 *
 * @param $selector
 */
const initDropdownValue = ($selector) => {
	$selector.each(function(index, element) {
		$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
	});
}

/**
 * dropDown value change
 *
 * @param $selector
 */
const setDropdownValue = ($selector) => {
	$selector.each(function(index, element) {
		$(this).on("click", function() {
			let val = $(this).data('value');
			$(this).parent().prev(".dropdown-toggle").attr('value', val);
		});
	});
}