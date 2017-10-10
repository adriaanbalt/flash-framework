package com.balt.log
{
	/**
	 * @author Bruce Epstein
	 *
	 * history: 17 November 2009 - initial version committed
	 * 
	 * example usage:
	 * 		import com.balt.log.Log;
	 * 		Log.traceMsg ("some message);
	 * 		Log.traceMsg ("some warning message. Log.WARN);
	 * 		Log.traceThreshold = Log.WARN;
	 * 		Log.traceMsg ("low priority message not shown if traceThreshold is higher");
	 */
	/**
	 * NOTES:
	 * This utility replaces the basic trace() method so that all logging is centralized.
	 * Note that it doesn't accept the same parameters as trace(), which outputs a comma-separated list of arguments.
	 * Second parameter to traceMsg() is a priority threshold. Use Log.traceThreshold to change the verbosity of the output.
	 * Optional logging to server requires call to setServerLogging(url) to specify remote url to receiev log messages.
	 * 
	 * FIXME -
	 * Alert dialog box doesn't seem to work yet.
	 * Logging to a local file not yet supported (requires AIR classes)
	*/
	//import com.dVyper.utils.Alert;  // Requires classpath to include thirdparty libraries...
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Log
	{
		private static var  SHOW_ALERTS:Boolean = true;
		private static var  SHOW_DEBUG_ALERTS:Boolean = true;
		//private static var 	LOG_FILE:File = "logfile.txt"; //File.applicationStorageDirectory.resolvePath("logfile.txt");
		
		public static const NO_LOG:int		= 12;	// Avoid writing to log regardless of threshold
		public static const LOG_TO_SERVER:int = 11;	// Write to log on server only regardless of _serverLogThreshold but obeying _serverLogging
		public static const LOG_TO_CLIENT:int = 10;	// Write to log on client only regardless of _clientLogThreshold but obeying _clientLogging
		public static const LOG_TO_CS:int  	= 9;	// Write to log on client and server regardless of threshold
		public static const EXCLUDE:int  	= 8;	// Nothing gets through
		public static const ALERT:int 	 	= 7;	// Displays result on screen
		public static const ALERT_DEBUG:int = 6;	// Reminder for later without displaying results on screen
		public static const ERROR:int 	 	= 5;	// Most urgent
		public static const WARN:int 	 	= 4;	// Important enough to warrant attention
		public static const NORMAL:int 	 	= 3;	// You want it to show up by default (if no priority is specified)
		public static const DEBUG:int 	 	= 2;	// Usually not needed but helpful for debugging
		public static const INFO:int   		= 1;	// Mostly extraneous or lengthy (used in loops)
		public static const VERBOSE:int  	= 0;	// Mostly extraneous or lengthy (used in loops)
		public static const ESOTERIC:int 	= -1;	// Exclude except in most lenient situations
		// Consider allowing these settings to be overridden by a config.xml
		private static var _traceThreshold:int = NORMAL;	
		public static var _clientLogThreshold:int = WARN;
		public static var _serverLogThreshold:int = ERROR;
		public static var _clientLogging:Boolean = false; 	// Enables logging to local logfile.txt
		public static var _serverLogging:Boolean = false;	// Enables logging to server
		
		private static var _serverLogUrl:String = null;		// URL of remote script to receive server log messages	
		private static var _failureCode:int = -1;
		private static var _successCode:int = 0;
		
		public function Log()
		{
			traceMsg("You should never construct the Log class", ERROR);
		}
		
		public static function init(stageReference:Stage):void {
			//Alert.init(stageReference);
		}
		
		public static function get traceThreshold ():int {
			return _traceThreshold;
		}
		
		
		/**
		 *  Set traceThreshold to VERBOSE or ESOTERIC for most permissive messages.
		 *  Set traceThreshold to EXCLUDE to prevent all messages.
		 *  Set traceThreshold to ERROR to prevent all but the most important messages.
		*/
		public static function set traceThreshold (value:int):void {
			_traceThreshold = value;
		}
		
		public static function get clientLogThreshold ():int {
			return _clientLogThreshold;
		}
		
		public static function set clientLogThreshold (value:int):void {
			_clientLogThreshold = value;
		}
		
		public static function get serverLogThreshold ():int {
			return _serverLogThreshold;
		}
		
		public static function set serverLogThreshold (value:int):void {
			_serverLogThreshold = value;
		}
	
		
		public static function get clientLogging ():Boolean {
			return _clientLogging;
		}
		
		public static function set clientLogging (value:Boolean):void {
			_clientLogging = value;
		}
		
		public static function get serverLogging ():Boolean {
			return _serverLogging;
		}
		
		public static function set serverLogging (value:Boolean):void {
			_serverLogging = value;
		}
		
		public static function get serverLogUrl ():String {
			return _serverLogUrl;
		}
		
		public static function set serverLogUrl (value:String):void {
			serverLogging = true;
			_serverLogUrl = value;
		}
		
		public static function setServerLogging (url:String, failureCode:int, successCode:int):void {
			serverLogUrl = url;
			serverLogging = true;
			_failureCode = failureCode;
			_successCode = successCode;
		}
		
		
		// traceMsgByCode() gives you a way to look up a localized version of the error text by its error code.
		// This is not presently implemented.
		public static function traceMsgByCode( msgCode:String = "0", msgPriority:int=NORMAL):void {
			traceMsg ("Need to lookup code " + msgCode, msgPriority);
		}
		
		public static function traceMsg (msg:String, msgPriority:int=NORMAL, msgCode:String = "0"):void 
		{
 			if (msgPriority >= _traceThreshold) {
    			trace( msg);
 			}
 			
 			if (msgPriority >= clientLogThreshold || msgPriority == LOG_TO_CS || msgPriority == LOG_TO_CLIENT) {
 				if (clientLogging && msgPriority != NO_LOG && msgPriority != LOG_TO_SERVER) {
    				logToFile(msg, msgPriority, msgCode);
    			}
 			}
 			
 			if (msgPriority >= serverLogThreshold || msgPriority == LOG_TO_CS || msgPriority == LOG_TO_SERVER) {
 				if (serverLogging && msgPriority != NO_LOG && msgPriority != LOG_TO_CLIENT) {
    				logToServer(msg, msgPriority, msgCode);
    			}
 			}
 			
 			if ((SHOW_ALERTS && msgPriority == ALERT) || (SHOW_DEBUG_ALERTS && msgPriority == ALERT_DEBUG)) {
	 			//mx.controls.Alert.okLabel = getLocalizedString("Okay");
	 			// Note, it is possible to show an ALERT_DEBUG message if SHOW_DEBUG_ALERTS
	 			// even if SHOW_ALERTS is false! This lets us turn off just what we want.
	 			if (SHOW_ALERTS && msgPriority == ALERT) {
	 			 	//Alert.show (msg);
	 			} else if (SHOW_DEBUG_ALERTS && msgPriority == ALERT_DEBUG) {
	 			 	//Alert.show (msg);
	 			}
	 			return;
	 		} else {
	 			return;
	 		}
		}
		
		 public static function postDialog (msg:String, titleText:String, closeHandler:Function):void {
 			var flags:uint;
 			//flags = mx.controls.Alert.NO | mx.controls.Alert.YES;
 			
 			//Alert.CANCEL,  Alert.NONMODAL, Alert.OK,
 			var defaultButtonFlag:uint;
 			//defaulButtonFlag = mx.controls.Alert.NO;
 			var parentSpr:Sprite = null;
 			var iconClass:Class = null;
 			// Translate the message and title text, or pass in a custom string.
 			//msg 	  = (TextUtils.undefinedOrEmpty(getLocalizedString(msg)))		? msg 		: getLocalizedString(msg);
 			//titleText = (TextUtils.undefinedOrEmpty(getLocalizedString(titleText))) ? titleText : getLocalizedString(titleText);
 			msg 	  = (undefinedOrEmpty(getLocalizedString(msg)))		? msg 		: getLocalizedString(msg);
 			titleText = (undefinedOrEmpty(getLocalizedString(titleText))) ? titleText : getLocalizedString(titleText);
 			//mx.controls.Alert.okLabel = getLocalizedString("Okay");
 			//mx.controls.Alert.cancelLabel = getLocalizedString("Cancel");
 			//mx.controls.Alert.noLabel  = getLocalizedString("No");
 			//mx.controls.Alert.yesLabel = getLocalizedString("Yes");
 			//mx.controls.Alert.show(msg, titleText, flags, parentSpr, closeHandler, iconClass, defaultButtonFlag);
			//com.dVyper.utils.Alert.show(msg);
		}
		
		private static function logToFile (msg:String, msgPriority:int, msgCode:String):void {
			// FIXME - disabled for now because it worsk in AIR only.
			return;
			/*
			var logStream:FileStream;
			var now:Date = new Date();
				
			if (!LOG_FILE.exists) {
 				traceMsg("Log file doesn't exist " + LOG_FILE.nativePath + " so we'll create it.", NO_LOG);
 			}
			logStream = new FileStream();
			logStream.addEventListener(IOErrorEvent.IO_ERROR, logFileError);
			try {
				logStream.open( LOG_FILE, FileMode.APPEND );
			} catch (err:Error) {
				traceMsg("CATCH: Error logging to file: " + err.errorID + ": " + err.message, NO_LOG);
 				return;
			}
			
			// Writes a UTF-8 string to the file stream. The length of the UTF-8 string, in bytes,
			// is written first, as a 16-bit integer, followed by the bytes 
			// representing the characters of the string.
			logStream.writeMultiByte("LOG: " + now.toDateString() + " " +  now.toTimeString() + 
								"; priority: " + msgPriority + "; code: " + msgCode + "; msg: " + msg + 
								"\n", File.systemCharset);
			logStream.close();
			*/
		}
		
		
		private static function logFileError(evt:IOErrorEvent):void {
			traceMsg("Error writing to log file" + evt.text, NO_LOG);
			//Alert.show ("Error writing to log file" + evt.text);
		}
		
		
		private static function logToServer (msg:String, msgPriority:int, msgCode:String):void {
			// FIXME - check if connection exists...
			/*
			if (monitor == null || !monitor.available) {
				traceMsg ("Not logging to server because there is no active connection: " + msg, NO_LOG);
				return;
			}
			*/
			
			//trace ("Log this to server in xml post format" + msg);
			var url:String = _serverLogUrl;
			if (!url) {
				traceMsg ("Not logging to server because server url has not been set: " + msg, NO_LOG);
				return;
			}
            var request:URLRequest = new URLRequest(url);
            var variables:URLVariables = new URLVariables();
            var loader:URLLoader = new URLLoader()
            
            variables.msg = escape(msg);
            variables.priority = msgPriority;
            variables.code = msgCode;
            request.data = variables;
            request.method = URLRequestMethod.POST;
            
			loader.addEventListener(Event.COMPLETE, onServerLogCheckSuccess);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onServerLogError);
			loader.load(request);
		}
		
		protected static function onServerLogCheckSuccess(evt:Event):void {
			if ( evt.target.data == _successCode ) {
				//traceMsg ("Succesfully logged info to server", NO_LOG);
			} else {
				var stringMe:String = evt.target.data as String;
				// Problem logging to server. Perhaps a 500 Internal Server Error...
				traceMsg ("onServerLogCheckSuccess: Failed to log to server: " + evt.type + ": " + 
						stringMe.substr(0, Math.min(100, stringMe.length)), LOG_TO_CLIENT, "SL1"); // "APE
			}
		}
		
		protected static function onServerLogError(evt:IOErrorEvent):void {
			traceMsg ("Failed to log info to server: " + evt.text, LOG_TO_CLIENT, "SL2");  // "APE
		}
		
		private static function getLocalizedString(inString:String):String {
			// Dummy for now, always returns same string.
			// TODO - implement localization framework
			return inString;
		}
		
		// TODO - move to TextUtils class
		private static function undefinedOrEmpty(inString:String):Boolean {
			if (inString == "" || inString == null) {
				return true;
			} else {
				return false;
			}
		}

	}
}