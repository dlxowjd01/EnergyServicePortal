module.exports = async function(context, commands) {
  await commands.navigate(
    'http://localhost:8080/loginUser'
  );
  // Add text into an input field y finding the field by id
  await commands.addText.byId('loginUserId', 'demo');
  await commands.addText.byId('password', 'demo');

  // find the sumbit button and click it
  await commands.click.byNameAndWait('login');

  // we wait for something on the page that verifies that we are logged in
  return commands.wait.byId('userGroupList',3000);
};