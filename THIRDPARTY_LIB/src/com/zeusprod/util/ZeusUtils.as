/*
 * @author: Bruce Epstein (bruce@zeusprod.com)
**/
package com.zeusprod.util
{
	import com.asual.SWFAddress;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	
	public class ZeusUtils
	{
		public static var outputPane:*;		// TextArea defined in ReflectedGallery
		
		public static const TWO_PI:Number = (2 * Math.PI);
		public static const DEGREES_360:Number = 360;
		public static const DEGREES_90:Number = DEGREES_360/4;					// 90
		public static const DEGREES_PER_RADIAN:Number = DEGREES_360 / TWO_PI;	
		public static const RADIANS_PER_DEGREE:Number = 1/DEGREES_PER_RADIAN;	
		public static const FULL_TURN:Number = DEGREES_360;						// 360
		public static const HALF_TURN:Number = DEGREES_360/2;					// 180
		public static const THREE_QUARTER_TURN:Number = DEGREES_90 * 3;			// 270
		public static const QUARTER_TURN:Number = DEGREES_90;					// 90
		
		public function ZeusUtils()
		{
		}

		public static function noCache(url:String, cacheBust:Boolean = true):String {
			var temp:String = (cacheBust) ? url + "?nocache=" + (Math.random() * 99999).toString() : url;			
			return temp;
		}
		
		
		
		
		
		// Check if two values are within the margin of error
		public static function closeEnough(val1:Number, val2:Number, errorMargin:Number=NaN):Boolean {
			if (isNaN(errorMargin)) errorMargin = .0001;
			// Could alternatively use rounding....
			if (Math.abs(val1-val2) > errorMargin) {
				return false;
			}
			return true;
		}
		
		
		// Scale something as big as possible in x,y without exceeding max dimensions, while maintaining aspect ratio
		public static function determineScaleFactor (inW:Number, inH:Number, maxW:Number, maxH:Number):Number {
			return Math.min (maxW/inW, maxH/inH);
		}
		
		
		// FIXME - generalize for +/- and any number, etc.
		// Modulo division to get numbers within 0 - 360
		public static function mod360 (startingRotationDegrees:Number, deltaRotationDegrees:Number):Number {
			// FIXME - what about when it exceeds -360?
			var modVal:Number = startingRotationDegrees % DEGREES_360;
			// Make sure it is positive....
			modVal += deltaRotationDegrees; // + 10 * DEGREES_360;
			modVal %= DEGREES_360;
			return modVal;
		}
		
		
		// Modulo division to get numbers within 0 - 2*PI
		public static function modTwoPI (startingThetaRadians:Number, deltaRotationRadians:Number):Number {
			// FIXME - what about when it exceeds - 2*PI?
			var modVal:Number = startingThetaRadians - TWO_PI;
			modVal += deltaRotationRadians;
			modVal -= TWO_PI;
			return modVal;
		}
		
		public static function sign (inVal:Number):int {
		  return (inVal < 0) ? -1 : + 1;
		}
		
		
		// Adapted from ActionScript Cookbook by Joey Lott (edited by Bruce)
		public static function roundTo (num:Number, roundToInterval:Number = 1):Number {
			// roundToInterval defaults to 1 (round to the nearest integer).
			return Math.round(num / roundToInterval) * roundToInterval;
		}
	
		public static function roundDecPl (num:Number, decPl:Number = 0):Number {
			// decPl defaults to 0 (round to the nearest integer).
			var multiplier:Number = Math.pow(10, decPl);
			return Math.round(num * multiplier ) / multiplier;
		}

		
		public static function truncateDecPl (num:Number, decPl:Number = 0):Number {
			// decPl defaults to 0 (truncate to the nearest integer).
			var multiplier:Number = Math.pow(10, decPl);
			return int(num * multiplier ) / multiplier;
		}
		
		
		// Use modulo division to extract the right element if the array is too short
		public static function getModuloArrayElement (indexInto:int, shortArray:Array, defaultItem:Object):* {
			if (shortArray == null || shortArray.length <= 0) {
				return defaultItem;
			} else if (indexInto < shortArray.length) {
				return shortArray[indexInto];
			} else {
				// Reuse the index elements as necessary
				return shortArray[indexInto % shortArray.length];
			}
		}
		
	
		// Recursion test
		public static function sumElements (tmpArray:Array, i:int):Number {
			if (tmpArray[i+1] == null) {
				return tmpArray[i];
			} else {
				return tmpArray[i] + sumElements(tmpArray, i+1);
			}
		}
		
		
		/* Alignment convenience functions */
		public static function below (someItem:DisplayObject, yOffset:Number):Number {
			var tmpY:Number = (someItem.y + someItem.height + yOffset);
			return tmpY;
		}
		
		
		public static function toRightOf (someItem:DisplayObject, xOffset:Number):Number {
			var tmpX:Number = (someItem.x + someItem.width + xOffset);
			return tmpX;
		}
		
		
		public static function rightJustify (someItem:DisplayObject, xOffset:Number):Number {
			var tmpX:Number = (-someItem.width + xOffset);
			return tmpX;
		}
		
		
		public static function bottomJustify (someItem:DisplayObject, yOffset:Number):Number {
			var tmpY:Number = (-someItem.height + yOffset);
			return tmpY;
		}
		
		
		public static function goToUrl(url:String, window:String=null):void {
			try {
				SWFAddress.href(url);
			} catch (err:Error) {
			}
		}
	
		
		// Append one XMLList to another and return the result. 
		public static function appendXMLList (xmlList1:XMLList, xmlList2:XMLList):XMLList {
			return xmlList1 + xmlList2;
			/*
			for (var i:int = 0; i < xmlList2.length(); i++) {
				xmlList1[xmlList1.length()] = xmlList2[i];
			}
			return xmlList1;
			*/
		}
		
	}
}