package com.balt.net
{
	import com.balt.events.GenericDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	/**
	* Methods for making various network calls
	*/	
	
	public class CallInstance extends EventDispatcher
	{
		public static const DATA_LOADED:String = "dataLoaded";
		
		/**
		* @private
		*/
		
		private var dataLoader:URLLoader;
		
		
		public function CallInstance():void {
			// empty constructor
		}
			
		/**
		* A URL data sender
		* 
		* @param url URL address
		* @param parameters Optional data call parameters
		* @param postMethod Makes URL call with POST method
		* 
		* Because this class extends EventDispatcher, an invoking class should listen for 
		* the custom CallInstance.DATA_LOADED event to receive the data back from the remote call
		*/			
		
		public function sendData(url:String, parameters:URLVariables=null, postMethod:Boolean=false):void
		{
			var newRequest:URLRequest = new URLRequest(url);
			dataLoader = new URLLoader();
		
			if(postMethod){ newRequest.method = URLRequestMethod.POST; }
			
			newRequest.data = parameters;
			
			//dataLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			// I'm not sure why the wrong url yields:
			// Error #2044: Unhandled ioError:. text=Error #2032: 
			// Stream Error. URL: file:///C|/whatever/test.xml
			// I think I'm handling errors below...
			// Maybe I have to listen on something else.
			dataLoader.addEventListener(Event.COMPLETE, dataLoaded);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dataError);
			
			dataLoader.load(newRequest);
			//trace(parameters);
		}
		
		private function dataLoaded(evt:Event):void
		{
			removePrivateListeners();
			var incomingLoader:URLLoader = URLLoader( evt.target );
			trace( incomingLoader.data );
			// Dispatch the DATA_LOADED event, containing the data of interest.
			this.dispatchEvent(new GenericDataEvent(DATA_LOADED, false, false, incomingLoader.data));
		}
		
		private function dataError(evt:IOErrorEvent):void
		{
			removePrivateListeners();
			trace("Error loading URL " + evt.text);
			// Re-dispatch this event for anyone listening on this object.
			this.dispatchEvent(evt);
		}


		private function removePrivateListeners():void {
			dataLoader.removeEventListener(Event.COMPLETE, dataLoaded);
			dataLoader.removeEventListener(IOErrorEvent.IO_ERROR, dataError);
		}	
	}
}