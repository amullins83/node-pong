"use strict";
var fbInitialize;

fbInitialize = function() {};

window.fbAsyncInit = function() {
  FB.init({
    appId: process.env.FB_KEY,
    channelUrl: "//node-pong.herokuapp.com/fbChannel",
    status: true,
    xfbml: true
  });
  return fbInitialize();
};

(function(d, s, id) {
  var fjs, js;
  fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {
    return;
  }
  js = d.createElement(s);
  js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js";
  return fjs.parentNode.insertBefore(js, fjs);
})(document, 'script', 'facebook-jssdk');
