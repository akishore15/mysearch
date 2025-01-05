var input = prompt("Search...");
var url = "google.com/search?q=" + input;
var output = fetch(url);
alert(output);