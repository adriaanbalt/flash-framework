//****************************************************************************
//Copyright (C) 2004 Macromedia, Inc. All Rights Reserved.
//****************************************************************************
/**
*  GetURLQueue-
*  handles all get url requests to ensure only a single request is fired off per playback frame.
*
*  Singleton class.
*  
*  Modified to reference getURL instead of com.balt.core.mx.com.balt.core.Application.getURL by Mlego 11/14/05
* 
* @author adriaan scholvinck
* @version oct 21 2008
*/

package com.balt.net
{
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
    
	public class GetURLQueue 
	{
		private static var instance : GetURLQueue;
		
		private var requestDelay : Number = 400; // at the default framerate (24 fps), each frame is 41.6 ms
		
		private var interval : Timer;
		private var requestQueue : Array;
		
		////////////////
		//   PUBLIC METHODS
		///////////////
		
		public static function getInstance() : GetURLQueue {
			if( instance == null ){
				GetURLQueue.instance = new GetURLQueue();
			}
			return GetURLQueue.instance;
		}
		
		// constructor
		public function GetURLManager() : void {
			// Empty
		}
		
		public static function destroyQueue() : void {
			// static because implementing static variable "instance"
			instance.killInterval();
	//		delete instance;
		}
		
		
		/**
		*  Request a getURL call.
		*  @param String URL
		*  @param String window (optional)
		*  @param String method (optional) "Get" or "Post"
		*
		*  usage :
		*      GetURLManagar.getInstance().sendRequest ("http://www.macromedia.com", "_top");
		*/
		public function sendRequest ($url : String, $target_win : String, $method:String = null) : void {
			// create request Object
			var request : Object = new Object();
			request.url = $url;
			request.method = $method;
			request.target_win = $target_win;
	
			//if the queue array hasn’t already been created, create it
			if(requestQueue == null)
				requestQueue = new Array();
			
			//add the new request object to the array 
			requestQueue.push(request);
			
			//only recreate intervalID if it doesn't already exist
			if (interval == null){
	            interval = new Timer(requestDelay, 0);
	            interval.addEventListener(TimerEvent.TIMER, sendQueuedRequests);
	            interval.start();
			}
	
		}
		
		////////////////
		//   PRIVATE METHODS
		///////////////
		
		/** 
		*  interval function for sending getURL requests
		*/
		private function sendQueuedRequests(event:TimerEvent) : void {
			
			var request:Object = requestQueue.shift();
	
			// if queue is empty clear interval and get out
			if (request == null) {
				killInterval();
				return;
			}

			// send getURL request
			var urlRequest:URLRequest;
			if (request.target_win == "_blank") {
				urlRequest = new URLRequest("javascript:doNewWindow('" + request.url + "')");
				try {
					navigateToURL(urlRequest, '_blank'); // second argument is target
				} catch (e:Error) {
					trace("GetURLQueue.sendQueuedRequests() Error occurred!");
				}
			} else {
				urlRequest = new URLRequest(request.url);
				try {
					navigateToURL(urlRequest, request.target_win); // second argument is target
				} catch (e:Error) {
					trace("GetURLQueue.sendQueuedRequests() Error occurred!");
				}
			}
		}
		/**
		*  clears interval
		*/
		private function killInterval():void {
			interval.stop();
		}
	}
}