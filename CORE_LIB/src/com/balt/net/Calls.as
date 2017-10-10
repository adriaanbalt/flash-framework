package com.balt.net
{
	import com.balt.events.GenericDataEvent;
	import com.balt.events.ObjectDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import com.balt.text.TextUtil;
	import com.balt.log.Log;
	
	/**
	* Methods for making various network calls
	*/	
	
	public class Calls extends EventDispatcher
	{
		public static const DATA_LOADED:String = "dataLoaded";
		
		/**
		* @private
		*/
		
		public function Calls():void
		
		/**
		* A simple URL request with error catching
		* 
		* @param url URL address
		* @param target URL target
		* @param params optional parameters to append to URL 
		* @return Success status
		*/			
		
		public static function getURL(url:String, target:String=null, params:URLVariables=null, delimiter:String=null ):Boolean
		{
			var request:URLRequest;
			
			// If no delimiter is specified,aAppend params with a "?" unless the url 
			// already contains a "?" indicating existing params.
			// In that case, use an ampersand ("&") instead
			if (!delimiter) {
				if (TextUtil.stringContains(url, "?")) {
					delimiter = "&";
				} else {
					delimiter = "?";
				}
			}
			
			if( params ) url += delimiter + params.toString();
			Log.traceMsg ("url with params is " + url, Log.DEBUG);
			request = new URLRequest( url );

			try { navigateToURL(request, target); }
			catch (err:Error){ return false; }
			
			return true;
		}
		
		
		public static function unitTest ():Boolean {
			Log.traceThreshold = Log.DEBUG;
			// No additional params passed in, so delimiter is irrelevant
			getURL ("foo");
			getURL ("foo?param1=foo2");
			getURL ("foo?param1=foo2&param2=foo3");
			
			var myParams:URLVariables = new URLVariables("newparam=myval");
			// These correctly add "?" or "&" as necessary, depending on initial url string
			getURL ("foo", null, myParams);
			getURL ("foo?param1=foo2", null, myParams);
			getURL ("foo?param1=foo2&param2=foo3", null, myParams);
			
			// The "?" is optional but not problematic in this case
			getURL ("foo", null, myParams, "?");
			// The next two produce erroneous results in which there are two "?" in the url string
			getURL ("foo?param1=foo2", null, myParams, "?");
			getURL ("foo?param1=foo2&param2=foo3", null, myParams, "?");
			
			// This produce erroneous results because "?" is used instead of "&" in the url string
			getURL ("foo", null, myParams, "&");
			// These correctly "&", but better to leave it at the default delimiter.
			getURL ("foo?param1=foo2", null, myParams, "&");
			getURL ("foo?param1=foo2&param2=foo3", null, myParams, "&");

			return true; // Should return true only if it passes all unit test, so this is a fake status
		}
		
		/**
		* A simple Javascript request and return response
		* 
		* @param jsFunc Javascript function name
		* @param jsArgs Javascript function optional arguments
		* @return Response
		*/		
		
		public static function callJS(jsFunc:String, jsArgs:String=null):String
		{
			var callResponse:* = ExternalInterface.call(jsFunc, jsArgs);
			trace('Response: '+callResponse);
			
			return callResponse;
		}
		
		/**
		* A URL data sender
		* 
		* @param url URL address
		* @param parameters Optional data call parameters
		* @param postMethod Makes URL call with POST method
		* @param receiveData Optional function to pass back loader data
		*/			
		
		public static function sendData(url:String, parameters:URLVariables=null, postMethod:Boolean=false, receiveData:Function=null):void
		{
			var newRequest:URLRequest = new URLRequest(url);
			var dataLoader:URLLoader = new URLLoader();

			if(postMethod){ newRequest.method = URLRequestMethod.POST; }
			
			newRequest.data = parameters;
			
			//dataLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			// Use a weak reference since dataLoader isn't accessible externally, and this class never removes the listener (perhaps it should)
			if( receiveData != null ) dataLoader.addEventListener(Event.COMPLETE, receiveData, false, 0, true);			
			dataLoader.addEventListener(Event.COMPLETE, removeListeners);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dataError);
			
			dataLoader.load(newRequest);
			//trace(parameters);
		}
		
		private static function removeListeners(e:Event):void
		{
			if(e.target.hasEventListener(Event.COMPLETE)){ e.target.removeEventListener(Event.COMPLETE, removeListeners); }
			if(e.target.hasEventListener(IOErrorEvent.IO_ERROR)){ e.target.removeEventListener(IOErrorEvent.IO_ERROR, dataError); }
			
			var incomingLoader:URLLoader = URLLoader( e.target );
			trace( incomingLoader.data );
		}
		
		private static function dataError(e:IOErrorEvent):void
		{
			if(e.target.hasEventListener(Event.COMPLETE)){ e.target.removeEventListener(Event.COMPLETE, removeListeners); }
			if(e.target.hasEventListener(IOErrorEvent.IO_ERROR)){ e.target.removeEventListener(IOErrorEvent.IO_ERROR, dataError); }		
			trace("Error loading URL");
		}
	}
}