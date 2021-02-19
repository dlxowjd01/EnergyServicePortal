/**
 * dropDown 사용시 공통 처리를 위한 로직
 * 아직 모든화면에서 공통 작동하는지 확인 필요함으로
 * 따로 분리해놈 확인후 common.js 에 통합 예정.
 *
 */
//드롭 다운 공통 동작 작업 -- 디스에이블이 아닌 항목에 대해서 작동함.
$(document)
	.on('click', '.dropdown-menu:not(.unused) li:not(.disabled, .dropdown-cov .sec-li-box, .btn-wrap-type03, .lang, .no-data, .dropdown-search, .list-search)', function (e) {
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

		if ($selector.find(':checkbox').length > 0) {
			let $selectorName = $selector.find(':checkbox').prop('name');
			if ($selector.find(':checkbox').val() === 'all') {
				let checked = true;
				if (!$selector.find(':checkbox').is(':checked')) {
					checked = false;
				}
				$(':checkbox[name="' + $selectorName + '"]').each(function() {
					if ($(this).val() !== 'all') {
						$(this).prop('checked', checked);
					}
				});
			} else {
				$(':checkbox[name="' + $selectorName + '"]').each(function() {
					if ($(this).val() === 'all') {
						$(this).prop('checked', false);
					}
				});
			}

			displayDropdown($dropdown);
		} else if ($selector.find(':radio').length > 0) {
			displayDropdown($dropdown);
		} else {
			let $displayData = $selector.data();
			let $displayText = $selector.text();
			$displayButton.eq(0).html($displayText + '<span class="caret"></span>').addClass("active");
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

		if ($displayButton.hasClass('no-close')) {
			return false;
		}
	})

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
		let checkedItems = $selector.find('input[type="checkbox"]:checked');
		let checkedboxLength = checkedItems.length;
		let checkboxLength = $selector.find('input[type="checkbox"]').length;

		if(checkedboxLength == checkboxLength){
			$displayText = i18nManager.tr('commonDropdown.total');
			if( $selector.data("function", "concat") ){
				let concatArr = [];
				let concatStr = '';
				$.each(checkedItems, function(index, el){
					concatArr.push($(el).val());
				});	
				concatStr = concatArr.join(",");
				$displayButton.data("value", concatStr);
			}
		} else {
			if (checkedboxLength == 0){
				$displayText = $displayButton.data('name');
				if( $selector.data("function", "concat") ){
					$displayButton.data("value", checkedItems.val());
				}
			} else if (checkedboxLength > 1) {
				$displayText = checkedItems.first().next().text() + ' ' + i18nManager.tr('commonDropdown.etc') + ' +' + (checkedboxLength - 1);

				if( $selector.data("function", "concat") ){
					let concatArr = [];
					let concatStr = '';
					$.each(checkedItems, function(index, el){
						concatArr.push($(el).val());
					});	
					concatStr = concatArr.join(",");
					$displayButton.data("value", concatStr);
				}
			} else {
				$displayText = checkedItems.next().text();
				if( $selector.data("function", "concat") ){
					$displayButton.data("value", checkedItems.val());
				}
			}
		}
	}

	$displayButton.eq(0).html($displayText + '<span class="caret"></span>').addClass("active");
	
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
	var itemGroup = $selector.find('li');
	let firstCheckbox = itemGroup.first();
	let input = itemGroup.find('input[type="checkbox"]');

	firstCheckbox.on("click", function(){
		console.log("item---", $(this))
		$(this).toggleClass('active');
		if( $(this).hasClass('active') ) {
			input.prop("checked", true);
			// input.not($(this)).prop("checked", false);
			// firstInput.prop('checked', true);
		} else {
			input.prop("checked", false);
			// input.not($(this)).prop("checked", true);
			// firstInput.prop('checked', false);
		}
	})
}


/**
 * dropDown selectAll group (IN PROGRESS!!!!!)
 *
 * @param $selector
 */
const selectAllGroup = ($selector) => {
	let group = $selector.find('.dropdown-menu.chk-type');
	$.each(group, function(){
		let item = $(this).find("li");
		let firstCheckbox = item.first();
		let input = item.find('input[type="checkbox"]');
		let firstInput = firstCheckbox.find('input[type="checkbox"]');

		// item.on("click", function(){
		// 	if($(this).index() == 0) {
		// 		if($(this).find("input[type='checkbox']").is(':checked')) {
		// 			input.prop("checked", true);
		// 		} else {
		// 			input.prop("checked", false);
		// 		}
		// 	} else {
		// 		// if($(this).find("input[type='checkbox']").is(':checked')) {
		// 		// 	item.first().find("input[type='checkbox']").prop("checked", false);
		// 		// }
		// 	}
		// });
		firstCheckbox.on("click", function(){
			console.log("item---", $(this))
			$(this).toggleClass('active');
			if( $(this).hasClass('active') ) {
				input.prop("checked", true);
				// input.not($(this)).prop("checked", false);
				// firstInput.prop('checked', true);
			} else {
				input.prop("checked", false);
				// input.not($(this)).prop("checked", true);
				// firstInput.prop('checked', false);
			}
		})
	})
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
	//button.text().replace(/<[^>]+>/g, buttonNm);
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
		//$(this).data('value', '').text().replace(/<[^>]+>/g, $(this).data('name'));
	});
}

/**
 * dropdown value change (NOT suitable for ajax updated dropdown)
 *
 * @param $selector
 */
const setDropdownValue = ($selector) => {
	$selector.each(function(index, element) {
		let item = $(this).find("li");
		let btn = $(this).prev();

		item.on("click", function() {
			let val = $(this).data('value');
			let name = $(this).data('name');

			if(!isEmpty(val)){
				btn.data('value', val);
			}
			if(!isEmpty(name)){
				btn.data('name', name);
			}

		});
	});
	return false;
}

/**
 * single select dropdown groups
 *
 * @param $selector
 */
const setSingleSelectDropdown = ($selector) => {
	let btn = $selector.find(".dropdown-menu:not('.chk-type')");
	$.each(btn, function(index, element) {
		let item = $(this).find("li");
		item.on("click", function() {
			let val = $(this).data('value');
			$(this).parents().find(".dropdown-toggle").data('value', val);
		});
	});
	return false;
}


// TO DO !!!!!!    선택 클릭시 btn => disabled color 적용
// $displayButton.eq(0).html($displayText + '<span class="caret"></span>').addClass("active");
