// Script to get field values on Moodle post page.
//  Moodle has a querySelector function "$" that does not
//  do even a smidge of what jQuery does.
// I can only verify this works in Chrome, which is good enough for me.
var fieldValues = {};
var inputs = document.getElementsByTagName("input");
for(var i = 0; i < inputs.length; i++) {
	fieldValues[inputs[i].name] = inputs[i].value;
}