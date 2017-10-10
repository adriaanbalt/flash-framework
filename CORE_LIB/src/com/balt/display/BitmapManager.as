package com.balt.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	* Bitmap manipulation utilities 
	*/	
	
	public class BitmapManager
	{
		/**
		* @private
		*/	
		
		public function BitmapManager():void
		
		/**
		* Creates an empty bitmap or a new bitmap from the library
		* 
		* @param libRef Bitmap library asset name
		*/		
		
		public static function create(libRef:String=null):Bitmap
		{
			var newBMP:Bitmap = new Bitmap();
			
			if(libRef)
			{
				var classObj:Class = getDefinitionByName(libRef) as Class;
				newBMP = new Bitmap( new classObj(0,0), 'auto', true );
			}
			
			return newBMP;
		}
		
		/**
		* Scales a bitmap to a new size
		* 
		* @param srcBMP Bitmap source content
		* @param newWidth Specifies new bitmap width
		* @param newHeight Specifies new bitmap height
		*/		
		
		public static function resize(srcBMP:Bitmap, newWidth:Number=0, newHeight:Number=0):Bitmap
		{
			var matrix:Matrix = new Matrix();
			var oldDimension:Number;
			var wScale:Number;
			var hScale:Number;
			
			oldDimension = srcBMP.width;
			wScale = newWidth/oldDimension;
			oldDimension = srcBMP.height;
			hScale = newHeight/oldDimension;
			
			if(!newHeight){ hScale = wScale; }
			else if(!newWidth){ wScale = hScale; }
			
			if(!hScale || !wScale) return srcBMP;
			
			matrix.scale(wScale, hScale);

			var newBMPdata:BitmapData = new BitmapData(srcBMP.width * wScale, srcBMP.height * hScale, true, 0x000000);
			newBMPdata.draw(srcBMP, matrix, null, null, null, true);

			var newBMP:Bitmap = new Bitmap(newBMPdata, 'never', true);

			return newBMP; 
		}

		/**
		* Converts a bitmap into a sprite
		* 
		* @param srcBMP Bitmap source content
		*/		
		
		public static function toSprite(srcBMP:Bitmap):Sprite
		{
			var outputShape:Sprite = new Sprite();
			outputShape.graphics.beginBitmapFill(srcBMP.bitmapData);
			outputShape.graphics.drawRect(0, 0, srcBMP.width, srcBMP.height);
            outputShape.graphics.endFill();
            
            return outputShape;
		}
	}
}