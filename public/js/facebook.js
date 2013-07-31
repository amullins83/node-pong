var fbInitialize, testAPI, updateStatusCallback;

$(document).ready(function() {
  $.ajaxSetup({
    cache: true
  });
  return $.getScript('//connect.facebook.net/en_US/all.js', function() {
    FB.init({
      appId: 483976228358350,
      channelUrl: "//node-pong.herokuapp.com/fbChannel",
      status: true,
      cookie: true,
      xfbml: true
    });
    return fbInitialize();
  });
});

testAPI = function() {
  console.log('Welcome!  Fetching your information.... ');
  return FB.api('/me', function(response) {
    return console.log('Good to see you, ' + response.name + '.');
  });
};

updateStatusCallback = function(status) {
  if (status.status === 'connected') {
    return testAPI();
  }
};

fbInitialize = function() {
  console.log("Initializing FB");
  FB.Event.subscribe('auth.authResponseChange', function(response) {
    if (response.status === 'connected') {
      return testAPI();
    } else if (response.status === 'not_authorized') {
      return console.log("This fb user has not authorized this app");
    } else {
      return console.log("This user is not logged in to FB");
    }
  });
  return FB.getLoginStatus(updateStatusCallback);
};
