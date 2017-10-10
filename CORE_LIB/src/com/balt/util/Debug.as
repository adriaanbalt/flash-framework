// Class to indicate whether you are running in the debugger.
// Adapted from http://blog.tbam.com.ar/2009/09/automatic-conditional-debugrelease.html
//
// Copyright (C) 2009 - Martín Sebastíán Wain - http://www.tbam.com.ar
// Shared under the MIT permissive licence. Please do not remove this comment.
//
// Example Usage:
// import com.balt.util.Debug
// Debug.initialize()
// if (Debug.RUNNING_DEBUGGER) { trace ("We're in the debugger"); }
//
// See also http://stackoverflow.com/questions/1133235/adobe-air-detect-if-running-in-adl
//
package com.balt.util
{
	import flash.system.Capabilities;
	
	public class Debug
	{
		public static var RUNNING_DEBUGGER:Boolean = false;
		public static var RUNNING_AIR:Boolean = false;
		
		public function Debug()
		{
			
		}

        static public function initialize():void {
        	//var cap:Capabilities = Capabilities(null);
        	
        	RUNNING_DEBUGGER = Capabilities.isDebugger;
			// Capabilities.playerType will return "Desktop" only while running in AIR/ADL. 
			RUNNING_AIR = (Capabilities.playerType == "Desktop");
			
            try {
                throw new Error("Intentional error to get call stack");
            } catch (evt:Error) {
                // Test the call stack for file/line info
                var re:RegExp = /\[.*:[0-9]+\]/;
                RUNNING_DEBUGGER = re.test(evt.getStackTrace());
            }
        }
    }
}
