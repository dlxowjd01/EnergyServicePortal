module.exports = async function(context, commands) {
  context.log.info('Log message from the task');

  await commands.navigate(
      'http://derms.enertalk.com:8080/login'
  );
  // Add text into an input field y finding the field by id
  await commands.addText.byId('spadmin', 'loginUserId');
  await commands.addText.byId('11111111', 'loginUserPw');

  // find the sumbit button and click it
  await commands.click.byXpath('//*[@id="loginForm"]/div[2]/input');

  // we wait for something on the page that verifies that we are logged in
  return commands.wait.byTime(10000);
};
