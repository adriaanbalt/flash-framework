package com.balt.display
{
	import flash.display.DisplayObject;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;	

	public class Snapshooter 
	{

		private var _bitmapContainer : Bitmap;
		private var _bitmapData : BitmapData;
		private var _containerSource : DisplayObjectContainer;
		private var _containerTarget : DisplayObjectContainer;

		
		/**	
		 * Take a snapShot
		 * 
		 * @param containerSource The source DisplayObjectContainer that will be snapshoted 
		 * 
		 * @param containerTarget the target of the snapshot
		 */
		
		public function Snapshooter(containerSource : DisplayObjectContainer,containerTarget : DisplayObjectContainer,width:Number=0,height:Number=0)
		{
			
			this._containerTarget = containerTarget;
			this._containerSource = containerSource;
			
			
			
			
			if (width!=0 && height!=0){
				_bitmapData = new BitmapData(width, height, true, 0x00000000);
			} else {
				_bitmapData = new BitmapData(Stage(_containerSource).stageWidth, Stage(_containerSource).stageHeight, true, 0x00000000);
			}
			
			_bitmapContainer = new Bitmap(_bitmapData, "auto", true);
			_containerTarget.addChild(_bitmapContainer);
		}

		
		
		
		public function takeSnapshot(newSource : DisplayObject=null) : void
		{
			
			_bitmapData.draw(_containerSource);
			if (newSource)	_bitmapData.draw(newSource);
		}
	}
}
