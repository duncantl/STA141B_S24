/*
  These are three global variables that get set in the functions
  below and represent the state of the animation.
  + tickNum correspond to what the current day being displayed is.
  + timer is the JavaScript value/object returned by setTimer() which we need
    when we want to clear the timer with clearInterval()
  + delay is the clock time between steps in the animation.
*/
var tickNum = 0;
var timer;
var delay = 50;

/* This is the function that sets the colors of the states for a given day.
   It uses the variable tickNum to know which day and updates that by one so the next
   call to this function will update for the next day. 
*/
function setColors() {

    setStatesColorEmbedded(tickNum);

    tickNum++;
    // if we are at the end of the array of values to be shown, terminate the animation.
    // we could also have it start over again. That's a design decision.
    if(tickNum == stateColors[ Object.keys(stateColors)[0] ] .length) // stateColors["california"].length)
       clearInterval(timer)
}



function setDelay(val)
{
    delay = val;
    if(timer) {
	clearInterval(timer);
	timer = setInterval(setColors, delay);
    }
}


// Called when the page is loaded and has to both show the start and end dates
// at each end of the slider, based on the current data set.
function init()
{
    setDateRange();
      // The next line should probably simply call start().
    timer = setInterval(setColors, delay);
}


// start the animation from the beginning, first stopping it if it is currently running
function start()
{
    if(timer) {
	clearInterval(timer);
	timer = null;
    }
    
    tickNum = 0;
    resume();

      // Change the pause button to read Pause.  It could have been changed previously to Resume.
    document.getElementById("pause").innerHTML = "Pause";
}

// This stops the animation, but does not change the tickNum value.
// This allows resuming the animation at the same point.
function pause()
{
    if(timer) {
	clearInterval(timer);
	timer = null;
    }
}

// Continue the animation from wherever we stopped/suspended/paused it.
function resume()
{
    if(!timer) {
	timer = setInterval(setColors, delay)
    }

      // Change the pause button to read Pause.  It could have been changed previously to Resume.
    document.getElementById("pause").innerHTML = "Pause";    
}


/*
  Put the start and end dates from the data at each end of the slider for selecting the day.
  We could manually put them in the HTML. However, we would have to adjust them each day.
  So instead, we determine them directly from the data.  
  This whole setup assumes the data are in chronological order, so we get the first and last date label.
*/
function setDateRange()
{
    var e = document.getElementById("startDate");
    e.innerHTML = dateLabels[0];
    var e = document.getElementById("endDate");    
    e.innerHTML = dateLabels[dateLabels.length - 1];
}