package com.balt.media.camera {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import com.balt.util.encoder.PNGEncoder;	

	public class CameraCapture extends EventDispatcher
	{
		/*
		 * SINGLETON 
		 */
		private static var _instance:CameraCapture;
		
		private var canvas:DisplayObjectContainer; 
		
		private var cam:Camera; 
		private var vid:Video;
		private var fps:uint;
		
		private var vid_capture:BitmapData;
		private var bit:Bitmap;
		private var bit_x:int;
		private var bit_y:int;
		
		private var iMatrix:Matrix;
		private var renderTimer:Timer;
		private var vid_mask:DisplayObject;
		
		public function CameraCapture(pvt:SingletonEnforcer)
		{
		}
		static public function getInstance():CameraCapture
		{
			if (_instance == null) 
			{
				return new CameraCapture(new SingletonEnforcer);
			} else {
				return null;
			}
		}
		public function init(_canvas:DisplayObjectContainer,_x:int,_y:int,_width:int,_height:int,_fps:uint,_mask:DisplayObject = null):void
		{
			 canvas 	= _canvas;
			 fps 		= _fps;
			 bit_x 		= _x;
			 bit_y 		= _y;
			 
			 if (_mask != null) vid_mask =_mask; 

			 cam = new Camera();
			 cam = Camera.getCamera();
			 cam.setMode(_width,_height,_fps);
			
			 vid = new Video(_width,_height);
			 vid.attachCamera(cam);
			 
			 vid_capture = new BitmapData(vid.width,vid.height,true); 
			 //
			 // SETUP RENDER 
			 //
			 setUpRender();
		}
		// ------------------------------------
		 //			RENDER FUNCTION
		 // ------------------------------------
		private function setUpRender():void 
		{
			if (cam != null) 
			{	
				if (!cam.muted) 
				{
					//
					// CAMERA 
					//
					dispatchEvent(new Event("RENDER_SUCCESS"));
				
					renderTimer = new Timer(1000/fps);
					renderTimer.addEventListener(TimerEvent.TIMER,render);
					iMatrix = new Matrix();
				
					bit = new Bitmap(vid_capture);
					bit.x = bit_x;
					bit.y = bit_y;
					
					canvas.addChild(bit);
					if (vid_mask != null) canvas.addChild(vid_mask); 
				
					startRender();
				} else {
				//
				// CAMERA IS MUTED
				//
					dispatchEvent(new Event("RENDER_MUTED"));
					Security.showSettings(SecurityPanel.PRIVACY);
					cam.addEventListener(StatusEvent.STATUS, statusHandler);		
				}
			} else {
				//
				// NO CAMERA
				//
				dispatchEvent(new Event("RENDER_FAIL"));
			}
		}
		public function startRender():void
		{
			renderTimer.start();	
		}
		public function stopRender():void 
		{
			renderTimer.stop();
			renderTimer.removeEventListener(TimerEvent.TIMER,render);
			iMatrix 	= null;
			renderTimer = null;
			canvas.removeChild(bit);
			canvas.removeChild(vid_mask);
		}
		 // ------------------------------------
		 //			STATUS HANDLER 
		 // ------------------------------------
		private function statusHandler(event:StatusEvent):void 
		{
			if (event.code == "Camera.Unmuted") {
				dispatchEvent(new Event("RENDER_UNMUTED"));
                setUpRender();
                cam.removeEventListener(StatusEvent.STATUS, statusHandler);
            }
		}
		private function render(evt:TimerEvent):void 
		{
			vid_capture.draw(vid,iMatrix);
		}
		 // ------------------------------------
		 //			SNAPSHOT FUNCTION
		 // ------------------------------------
		public function takeSnapshot():BitmapData
		{
			return vid_capture.clone();	
		}
		 // ------------------------------------
		 //			ENCODE FUNCTION
		 // ------------------------------------
		public function returnPNG():ByteArray
		{
			return PNGEncoder.encode(vid_capture); 
		}
		// ------------------------------------
	    //			CLEAN UP
		// ------------------------------------
		public function destroy():void
		{	
			stopRender();
			//delete this;
			//this = null;
			_instance = null;
		}
	}
}

import com.balt.util.encoder.PNGEncoder;

internal class SingletonEnforcer{}
