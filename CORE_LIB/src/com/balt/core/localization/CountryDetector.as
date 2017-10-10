
/**
 * This class detects the country of the client. The current implementation is
 * based on the FDP detection service.
 * 
 * @author adriaan scholvinck
 * @version oct 21 2008
 */

package com.balt.core.localization {
	
	import com.balt.loaders.LoadUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;

	public class CountryDetector extends EventDispatcher {
		
		// Dispatched when the detection has finished
		public static var EVENT_ON_DETECTED 	: String = "onDetected";
		// Dispatched when there was an error that prevented the country detection
		public static var EVENT_ON_ERROR 		: String = "onError";
		
		// TODO: Make this dynamically loaded 
		private var requestUrl 					: String;
		private static var UNKNOWN_COUNTRY_NAME : String = "UNKNOWN";	
		
		private var requestXML 					: XML;
		
		// we need to remove this at some point
		private var retryCount 					: Number;
		private var maxRetries 					: Number = 3;
		private var time 						: Number;
		
		private var _code						: String;
		private var _name						: String;
		
		public function CountryDetector(requestUrl:String) {
			this.requestUrl = requestUrl;
		}
		
		public function detectCountry():void {
			doDetection();
		}
		
		/***************************
		 * PRIVATE METHODS         *
		 ***************************/
		 
		private function doDetection():void {
			
			this.retryCount = 0;
			
			// Setup the XML object that will get the reply
			
			var scope:CountryDetector = this;
	
			makeRequest();
		}
			
		private function makeRequest():void {
			LoadUtil.loadData( requestUrl , onDataLoaded, onDataLoadError );
			
			this.retryCount++;
		}
		
		/**
		 * Parses the data in replyXML into the mapTileArray. This methods is called after 
		 * the photos xml is loaded from the server through requestXML.sendAndLoad() call on
		 * loadData().
		 */
		private function onDataLoaded( event:Event ):void {
			
			var status:Number = requestXML.childNodes[1].attributes["status"];
			
			if (status==0) {
				this.handleLoadSuccess();
			} else {
				this.handleLoadError();
			}
		
		}
		
		private function onDataLoadError ( event:IOErrorEvent ) :void {
			if (retryCount<maxRetries) {
				makeRequest();
			} else {
				this.handleLoadError();
			}
		}
		
		private function handleLoadSuccess():void {
			var xmlNodes : Array = requestXML.childNodes[1].childNodes[1].childNodes;
			_code = xmlNodes[1].firstChild.nodeValue;
			_name = xmlNodes[3].firstChild.nodeValue;
			//trace("CountryDetector: detected country: " + code + " - " + name); 
			if (name!=UNKNOWN_COUNTRY_NAME) {
				dispatchEvent(new Event(CountryDetector.EVENT_ON_DETECTED, {code: code, name: name}));
			} else {
				dispatchEvent(new Event(CountryDetector.EVENT_ON_ERROR, {code: code, name: name}));
			}
		}
		
		private function handleLoadError():void {
			_code = "ERROR";
			_name = "ERROR";
			dispatchEvent(new Event(CountryDetector.EVENT_ON_ERROR ));
		}
		
		public function get code(): String {
			return _code;
		}
		
		public function get name (): String {
			return _name;
		}
		
	}
}
