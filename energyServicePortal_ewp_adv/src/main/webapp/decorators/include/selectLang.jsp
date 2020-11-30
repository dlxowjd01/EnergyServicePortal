<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<div class="lang dropdown"><!--
--><button type="button" class="dropdown-toggle" data-toggle="dropdown">${cookieLang}<span class="caret"></span></button><!--
--><ul class="dropdown-menu"><!--
	--><li class="lang"><a href="#">KO</a></li><!--
	--><li class="lang"><a href="#">EN</a></li><!--
--></ul>
</div>
<script type="text/javascript">
	$(function () {
		let tempLang = '${cookieLang}';
		$("html").attr('lang', tempLang.toLowerCase());


        $('li.lang').on('click touchend', function(e) {
            e.preventDefault();

            let selectLangText = $(this).find('a').text();
            if(tempLang === selectLangText) return false;

            document.cookie = 'lang' + '=' + selectLangText + '; path=/';
            let f;
            if (document.getElementById('dashboardForm') != null) {
                f = document.getElementById('dashboardForm');
                f.action = "${pageContext.request.requestURL}";
            } else {
                f = document.getElementById('loginForm');
                f.action = "/login.do";
            }

            let inp = document.createElement('input');
            inp.id = 'language';
            inp.name = 'language';
            inp.value = selectLangText;
            inp.type = 'hidden';
            f.append(inp);
            if (typeof(sgid) != 'undefined') {
                let inp = document.createElement('input');
                inp.id = 'sgid';
                inp.name = 'sgid';
                inp.value = sgid;
                inp.type = 'hidden';
                f.append(inp);
            } else if (typeof(vgid) != 'undefined') {
                let inp = document.createElement('input');
                inp.id = 'vgid';
                inp.name = 'vgid';
                inp.value = vgid;
                inp.type = 'hidden';
                f.append(inp);
            } else if (typeof(siteId) != 'undefined') {
                let inp = document.createElement('input');
                inp.id = 'sid';
                inp.name = 'sid';
                inp.value = siteId;
                inp.type = 'hidden';
                f.append(inp);
            }

            f.method = "post";
            f.submit();
        });
	});

</script>