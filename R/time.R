

#' Get System Time as a Float
#'
#' Grabs the absolute system time value from [base::Sys.time()]. This is used by the package to accurately time frames across instances and computers.
#' @details `= as.double(Sys.time())`
#' @returns A [double] representing the seconds since 1970 with sub-millisecond precision.
#' @examples
#' print(time.sec(),digits=20)
time.sec = function(){
	return(as.double(Sys.time()))
}




#' Temporal RAM Position
#'
#' @description
#' Returns how far, in seconds, the RAM is 'ahead' of the System time. Used for convenience in [ram.update()].
#'
#' See `vignette("timing")` for more info; the x-axis of the diagrams are `time.ram()`.
#' @details `= RAM$time - time.sec()`
#' @param RAM [RAM](ram.init) object.
time.ram = function(RAM){
		return(RAM$time - time.sec())
}


