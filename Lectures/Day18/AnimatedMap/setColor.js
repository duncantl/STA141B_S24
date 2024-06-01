// better version that handles states with multiple pologyons
function setStatesColorEmbedded(n)
{
    var svg = document.getElementById("svgMap").getSVGDocument();
    for(var k in stateColors) {
	var xp = "//svg:path[ contains(@id, '" + k + "')]";	
	var nodes = svg.evaluate(xp, svg, svgNSResolver, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE);
	if(nodes.snapshotLength == 0 && n == 0)
	    console.log("no element for " + k);
	else {
	    for(var i = 0; i < nodes.snapshotLength; i++) {
		var p = nodes.snapshotItem(i);
	        p.style.fill = stateColors[k][n];// setAttribute("fill", stateColors[k][n]);
	    }
	}
    }

    var d = document.getElementById("date");
    d.innerHTML = dateLabels[n]; // format as a date

      // set the current value of the slider to show where the current data in the animation.
    d = document.getElementById("setDate");
    d.value = n;
    
    return(true);
}


function svgNSResolver(prefix) { 
     if (prefix == 'svg') 
         return 'http://www.w3.org/2000/svg';
     return null;
}




function setStatesColorInline(n)
{
//    var svg = document.embeds[0].getSVGDocument();
    for(var k in stateColors) {
/*
	var xp = "//svg:path[ @id = '" + k + "']";
	var i = svg.evaluate(xp, svg, svgNSResolver, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE );
	var p = i.snapshotItem(0);
*/
	var p = document.getElementById(k);
//	alert(k + " -> "  + p);
	if(p)
	    p.style.fill = stateColors[k][n];// setAttribute("fill", stateColors[k][n]);
    }

    return(true);
}



function old_setStatesColorEmbedded(n)
{
    var svg = document.getElementById("svgMap").getSVGDocument();
    //embeds[0].getSVGDocument();
    for(var k in stateColors) {
	    /*	
	var xp = "//svg:path[ @id = '" + k + "']";
	var i = svg.evaluate(xp, svg, svgNSResolver, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE );
	var p = i.snapshotItem(0);
*/
	var p = svg.getElementById(k);
	if(p)
	    p.style.fill = stateColors[k][n];// setAttribute("fill", stateColors[k][n]);
	else if(n == 0)
	    console.log("no element for " + k);
    }

    var d = document.getElementById("date");
    d.innerHTML = dateLabels[n]; // format as a date

    return(true);
}


