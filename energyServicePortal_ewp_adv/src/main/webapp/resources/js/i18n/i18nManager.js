const i18nManager = {
	tr: (key) => {
		return Cookies.get('lang') === "KO" ? koTranslation[key] : enTranslation[key];
	}
};
