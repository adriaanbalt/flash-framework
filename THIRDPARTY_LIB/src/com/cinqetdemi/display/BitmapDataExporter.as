import mx.events.EventDispatcher;

import cinqetdemi.delay.DelayedFor;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.filters.ColorMatrixFilter;

/**
 * This class exports 24-bit images to a compressed format
 * It translates pixels into base64, then performs several
 * compression schemes to obtain a color table and a compressed
 * string. Details of the format are available in readme.txt
 */
class cinqetdemi.display.BitmapDataExporter
{
	//The number of steps to take for the export process
	private var steps : Number;
	//The bitmap to export
	private var bmp : BitmapData;
	//The number of pixels per step
	var stepLength : Number;
	//The bitmap represented as a string
	private var bmpStr : String;
	
	//EventDispatcher helpers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	//The width and height of the bitmap
	private var height:Number;
	private var width:Number;

	private var exportFor : DelayedFor;
	
	var depth:Number;
	
	/**
	 * Constructor
	 * @param bmp The BitmapData object to export
	 * @param steps The number of steps to use for the export
	 * @param depth The bit depth exported (currently supported 24 and 32, default 24)
	 */
	function BitmapDataExporter(bmp:BitmapData, steps:Number, depth:Number)
	{
		//Initialize the EventDispatcher
		EventDispatcher.initialize(this);
		
		//Store steps
		this.steps = steps;
		
		//Apply a color transformation to flatten alpha on the image
		this.bmp = bmp;
		this.width = bmp.width;
		this.height = bmp.height;
		this.depth = depth == null ? 24 : depth;
	}
	
	/**
	 * Start the export process
	 */
	public function export():Void
	{
		//Start our export process
		bmpStr = "";
		if(depth == 24)
		{
			trace('in depth 24');
			stepLength = Math.ceil(bmp.width*bmp.height/steps/2)*2;
			exportFor = new DelayedFor(this, steps, exportOne24, exportFinished);
			
		}
		else if(depth == 32)
		{
			trace('in depth 32');
			stepLength = Math.ceil(bmp.width*bmp.height/steps/3)*3;
			exportFor = new DelayedFor(this, steps, exportOne32, exportFinished);
		}
		else if(depth == 12)
		{
			trace('in depth 12');
			var mat:ColorMatrixFilter = new ColorMatrixFilter([1/17, 0, 0, 0, 0,
															   0, 1/17, 0, 0, 0, 
															   0, 0, 1/17, 0, 0,
															   0, 0, 0, 1, 0]);
			bmp.applyFilter(bmp, bmp.rectangle, new Point(), mat);
			stepLength = Math.ceil(bmp.width*bmp.height/steps/3)*3;
			exportFor = new DelayedFor(this, steps, exportOne12, exportFinished);
		}
		exportFor.start();
	}
	
	/**
	 * Export a part of the image, called by the delayed for
	 * @param currStep the current step in the export process
	 * @param totalSteps The total number of steps in teh export process
	 */
	private function exportOne12(currStep:Number, totalSteps:Number):Void
	{
		//The extracted pixel
		var pix1:Number;
		var pix2:Number;
		var pix3:Number;

		//The max value to consider in the local for loop
		var maxVal:Number = Math.min((currStep + 1)*stepLength, bmp.width*bmp.height);

		//Loop through the relevant pixels
		var buff = "";
		var oldBuff = "";
		var rle = false;
		var numRle = 0;
		
		var tmpBmpStr:String = "";
		var bmpW = bmp.width;
		
		/* Declared locally for faster access */
		var BASE64_CHARS:Array = [
				'A','B','C','D','E','F','G','H',
				'I','J','K','L','M','N','O','P',
				'Q','R','S','T','U','V','W','X',
				'Y','Z','a','b','c','d','e','f',
				'g','h','i','j','k','l','m','n',
				'o','p','q','r','s','t','u','v',
				'w','x','y','z','0','1','2','3',
				'4','5','6','7','8','9','+','/'
			];
		
		for(var i:Number = currStep*stepLength; i < maxVal; i+=3)
		{
			//The pixel to examine
			pix1 = bmp.getPixel(i % bmpW, Math.floor(i / bmpW));
			pix2 = bmp.getPixel((i + 1) % bmpW, Math.floor((i + 1) / bmpW));
			pix3 = bmp.getPixel((i + 2) % bmpW, Math.floor((i + 2) / bmpW));
			
			buff = BASE64_CHARS[(pix1 >> 14 & 0x3f) + (pix1 >> 10 & 0x3)] + 
				   BASE64_CHARS[(pix1 >> 4  & 0x3f) + (pix1 & 0xf)] + 
				   BASE64_CHARS[(pix2 >> 14 & 0x3f) + (pix2 >> 10 & 0x3)] + 
				   BASE64_CHARS[(pix2 >> 4  & 0x3f) + (pix2 & 0xf)] + 
				   BASE64_CHARS[(pix3 >> 14 & 0x3f) + (pix3 >> 10 & 0x3)] + 
				   BASE64_CHARS[(pix3 >> 4  & 0x3f) + (pix3 & 0xf)];
			
			if(buff == oldBuff)
			{
				if(rle)
				{
					numRle++;
					if(numRle == 64)
					{
						tmpBmpStr += "/#";
						numRle = 0;
					}
				}
				else
				{
					tmpBmpStr += '#';
					rle = true;
					numRle = 0;
				}
			}
			else
			{
				if(rle)
				{
					tmpBmpStr += BASE64_CHARS[numRle];
					rle = false;
				}
				tmpBmpStr += buff;
			}
			oldBuff = buff;
		}
		if(rle)
		{
			tmpBmpStr += BASE64_CHARS[numRle];
			rle = false;
		}
		
		bmpStr += tmpBmpStr;
		
		dispatchEvent({type:'progress', target:this, complete:(currStep + 1), total:steps});
	}
	
	/**
	 * Export a part of the image, called by the delayed for
	 * @param currStep the current step in the export process
	 * @param totalSteps The total number of steps in teh export process
	 */
	private function exportOne24(currStep:Number, totalSteps:Number):Void
	{
		//The extracted pixel
		var pix1:Number;
		var pix2:Number;

		//The max value to consider in the local for loop
		var maxVal:Number = Math.min((currStep + 1)*stepLength, bmp.width*bmp.height);

		//Loop through the relevant pixels
		var buff = "";
		var oldBuff = "";
		var rle = false;
		var numRle = 0;
		var tmpBmpStr:String = "";
		
		var bmpW = bmp.width;
		
		/* Declared locally for faster access */
		var BASE64_CHARS:Array = [
				'A','B','C','D','E','F','G','H',
				'I','J','K','L','M','N','O','P',
				'Q','R','S','T','U','V','W','X',
				'Y','Z','a','b','c','d','e','f',
				'g','h','i','j','k','l','m','n',
				'o','p','q','r','s','t','u','v',
				'w','x','y','z','0','1','2','3',
				'4','5','6','7','8','9','+','/'
			];

		for(var i:Number = currStep*stepLength; i < maxVal; i+=2)
		{
			//The pixel to examine
			pix1 = bmp.getPixel(i % bmpW, Math.floor(i / bmpW));
			pix2 = bmp.getPixel((i + 1) % bmpW, Math.floor((i + 1) / bmpW));
			
			buff = BASE64_CHARS[pix1 >> 18] + 
				   BASE64_CHARS[pix1 >> 12 & 0x3f] + 
				   BASE64_CHARS[pix1 >> 6  & 0x3f] + 
				   BASE64_CHARS[pix1       & 0x3f] + 
				   BASE64_CHARS[pix2 >> 18] + 
				   BASE64_CHARS[pix2 >> 12 & 0x3f] + 
				   BASE64_CHARS[pix2 >> 6  & 0x3f] + 
				   BASE64_CHARS[pix2       & 0x3f];
			
			if(buff == oldBuff)
			{
				if(rle)
				{
					numRle++;
					if(numRle == 64)
					{
						tmpBmpStr += "/#";
						numRle = 0;
					}
				}
				else
				{
					tmpBmpStr += '#';
					rle = true;
					numRle = 0;
				}
			}
			else
			{
				if(rle)
				{
					tmpBmpStr += BASE64_CHARS[numRle];
					rle = false;
				}
				tmpBmpStr += buff;
			}
			oldBuff = buff;
		}
		if(rle)
		{
			tmpBmpStr += BASE64_CHARS[numRle];
			rle = false;
		}
		bmpStr += tmpBmpStr;
		
		dispatchEvent({type:'progress', target:this, complete:(currStep + 1), total:steps});
	}
	
	/**
	 * Export a part of the image, called by the delayed for
	 * @param currStep the current step in the export process
	 * @param totalSteps The total number of steps in teh export process
	 */
	private function exportOne32(currStep:Number, totalSteps:Number):Void
	{
		//The extracted pixels
		var pix1:Number;
		var pix2:Number;
		var pix3:Number;

		//The max value to consider in the local for loop
		var maxVal:Number = Math.min((currStep + 1)*stepLength, bmp.width*bmp.height);

		//Loop through the relevant pixels
		var oldBuff = '';
		var buff = '';
		var rle = false;
		var numRle = 0;
		var tmpBmpStr:String = "";
		
		/* Declared locally for faster access */
		var BASE64_CHARS:Array = [
				'A','B','C','D','E','F','G','H',
				'I','J','K','L','M','N','O','P',
				'Q','R','S','T','U','V','W','X',
				'Y','Z','a','b','c','d','e','f',
				'g','h','i','j','k','l','m','n',
				'o','p','q','r','s','t','u','v',
				'w','x','y','z','0','1','2','3',
				'4','5','6','7','8','9','+','/'
			];
			
		var bmpW = bmp.width;
		
		for(var i:Number = currStep*stepLength; i < maxVal; i+=3)
		{
			//The pixel to examine
			pix1 = bmp.getPixel32(i % bmpW, Math.floor(i / bmpW));
			pix2 = bmp.getPixel32((i + 1)% bmpW, Math.floor((i + 1) / bmpW));
			pix3 = bmp.getPixel32((i + 2)% bmpW, Math.floor((i + 2) / bmpW));
			
			pix1 = ((255 - (pix1 >> 24 & 0xff)) << 24) | (pix1 & 0xffffff);
			pix2 = ((255 - (pix2 >> 24 & 0xff)) << 24) | (pix2 & 0xffffff);
			pix3 = ((255 - (pix3 >> 24 & 0xff)) << 24) | (pix3 & 0xffffff);
			
			buff = BASE64_CHARS[pix1 >> 26 & 0x3f] + 
					  BASE64_CHARS[pix1 >> 20 & 0x3f] + 
					  BASE64_CHARS[pix1 >> 14 & 0x3f] + 
					  BASE64_CHARS[pix1 >> 8  & 0x3f] + 
					  BASE64_CHARS[pix1 >> 2  & 0x3f] + 
					  BASE64_CHARS[(pix1     & 0x3 )*16 + (pix2 >> 28 & 0xf)] + 
					  BASE64_CHARS[pix2 >> 22 & 0x3f] + 
					  BASE64_CHARS[pix2 >> 16 & 0x3f] + 
					  BASE64_CHARS[pix2 >> 10 & 0x3f] + 
					  BASE64_CHARS[pix2 >> 4  & 0x3f] + 
					  BASE64_CHARS[(pix2        & 0xf)*4 + (pix3 >> 30 & 0x3)] + 
					  BASE64_CHARS[pix3 >> 24 & 0x3f] + 
					  BASE64_CHARS[pix3 >> 18 & 0x3f] + 
					  BASE64_CHARS[pix3 >> 12 & 0x3f] + 
					  BASE64_CHARS[pix3 >> 6  & 0x3f] + 
					  BASE64_CHARS[pix3 & 0x3f];
			
			if(buff == oldBuff)
			{
				if(rle)
				{
					numRle++;
					if(numRle == 64)
					{
						tmpBmpStr += "/#";
						numRle = 0;
					}
				}
				else
				{
					tmpBmpStr += '#';
					rle = true;
					numRle = 0;
				}
			}
			else
			{
				if(rle)
				{
					tmpBmpStr += BASE64_CHARS[numRle];
					rle = false;
				}
				tmpBmpStr += buff;
			}
			oldBuff = buff;
		}
		if(rle)
		{
			tmpBmpStr += BASE64_CHARS[numRle];
			rle = false;
		}
		
		bmpStr += tmpBmpStr;
		
		dispatchEvent({type:'progress', target:this, complete:(currStep + 1), total:steps});
	}
	
	function cancel()
	{
		exportFor.cancel();
	}

	function getSplitCondition()
	{
		if(depth == 32)
		{
			return 2;
		}
		else if(depth == 24)
		{
			return 2;
		}
		else if(depth == 12)
		{
			return 2;
		}
	}
	
	/**
	 * Called when the export is finished
	 * Tell everyone we're done with the export
	 */
	private function exportFinished():Void
	{
		trace('in export finished');
		dispatchEvent({type:'complete', target:this});
	}
	
	/**
	 * Replace a string by another string
	 */
	private function replace(src:String, needle:String, rpl:String):String
	{
		return src.split(needle).join(rpl);
	}
	
	/**
	 * The the compressed bitmap as a string
	 */
	public function getCompressedData():String
	{
		return bmpStr;
	}
	
	public function getWidth():Number
	{
		return width;
	}
	
	public function getHeight():Number
	{
		return height;
	}
}