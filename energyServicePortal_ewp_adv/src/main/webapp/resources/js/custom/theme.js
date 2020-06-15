function userTheme(toggle = false) {
  let userMode = localStorage.userThemeMode || 'auto';
  const osMode = !!window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches ? 'dark' : 'light';
  if(toggle) {
    switch(userMode) {
      case 'auto':
        userMode = 'light'; break;
      case 'dark':
        if(toggle==='light')
          userMode = 'light'; break;
      case 'light':
        if(toggle==='dark')
          userMode = 'dark'; break;
      default:
        userMode = 'auto';
    }
    localStorage.userThemeMode = userMode;
  }
  console.log(`current mode : ${userMode}`);
  window.__THEME_MODE = userMode === 'auto' ? osMode : userMode;
  if(window.__THEME_MODE === 'dark'){
    document.getElementById('dark').checked = true;
  }
  document.getElementsByTagName('html')[0].classList[window.__THEME_MODE === 'dark' ? 'add' : 'remove']('darkmode');
}


if (!!window.matchMedia) {
  ['light', 'dark'].forEach(mode => {
    window.matchMedia(`(prefers-color-scheme: ${mode})`).addListener(e => {
      if(!!e.matches) {
        userTheme();
      }
    });
  });
}