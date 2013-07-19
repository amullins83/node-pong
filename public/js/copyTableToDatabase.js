// Copies OldTable info to mongoDB using the assignments API
var copyTableToDB = function() {
	$("tr").each(function() {
		var columns = $(this).find("td");
		var assignment = {
			name: columns.eq(1).text(),
			date: new Date(columns.eq(0).text()),
			postURL: columns.eq(2).find("a").attr("href"),
			reflectURL: columns.eq(3).find("a").attr("href")
		};
		
		$.post("/api/assignments", assignment, function(response) {
			console.log(response);
		});
	});
};