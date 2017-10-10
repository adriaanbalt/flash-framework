package com.balt.util
{
	import com.balt.log.Log;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	
	// Utilities for MovieClips and DisplayObjects
	public class MovieUtil
	{
		
		private static const SPACES:String = "       ";	
	
	
		public function MovieUtil()
		{
		}

		public static function traceChildren (clip:DisplayObjectContainer, verbosity:Number=NaN, recurse:Boolean=true, indent:String=""):void {
			if (isNaN(verbosity)) verbosity = Log.traceThreshold;
			Log.traceMsg(indent + "Numchildren " + clip.numChildren, verbosity);
			for (var i:int = 0; i < clip.numChildren; i++) {
				
				Log.traceMsg (indent + "SubObject " + i + " is named " + clip.getChildAt(i).name, verbosity);
				if (recurse && clip.getChildAt(i) is DisplayObjectContainer) {
					traceChildren (clip.getChildAt(i) as DisplayObjectContainer, verbosity, recurse, indent + "    ");
				}
			}
		}
		
			
		public static function removeAllChildren(someContainer:*, clearChildren:Boolean=false, recurse:Boolean=false):uint {
			// Could also detect RangeError
			// traceMsg ("someContainer numChildren is " + someContainer.numChildren);
			var numChildren:Number;
			try {
				numChildren = someContainer.numChildren;
			} catch (err:Error) {
				numChildren = 0;
				return numChildren;
			}
			while (someContainer.numChildren > 0) {
				if (clearChildren) {
					if (recurse) {
						removeAllChildren(someContainer.getChildAt(0), clearChildren, recurse);
					}
					// FIXME - Error 1105: Target of assignment must be a reference value.
					//someContainer.getChildAt(0) = null;
				}
				someContainer.removeChildAt(0);
			}
			numChildren = someContainer.numChildren;
			return numChildren;
		}
		
		
		// Utilities to help locate/diagnose missing/problematic movie clips and text fields.
		public static function findIt (findThing:*, recurseUp:Boolean, recurseDown:Boolean,
									 indent:String="", verbosity:Number=NaN):void {
			if (isNaN(verbosity)) verbosity = Log.traceThreshold;
			var stageWidth:Number = 1000;
			var stageHeight:Number = 800;
			
			//traceMsg ("....", verbosity);
			//traceMsg ("FindThing ", verbosity);
			//traceMsg (indent + "Analyzing object " + findThing.name, verbosity);
			//traceMsg (indent + "typeof object " + (typeof findThing), verbosity);
		
			if (String(indent) == "undefined") {
				indent = "";
			}
			if (typeof findThing == "movieclip" || findThing is MovieClip) {
				traceMsg(indent + "MovieClip '" + findThing + "'; currentframe: " + (findThing as MovieClip).currentFrame, verbosity);
			} else if (findThing is TextField) {
				traceMsg(indent + "TextField '" +  + findThing + "'; text: '" + (findThing as TextField).text + "'", verbosity);
			} else if (findThing is Sprite) {
				traceMsg(indent + "Sprite '" + (findThing as Sprite).name, verbosity);
			} else if (findThing is Shape) {
				traceMsg(indent + "Shape '" + (findThing as Shape).name, verbosity);
			} else if (findThing is Stage) {
				traceMsg(indent + "Stage '" + (findThing as Stage).name, verbosity);
			} else {
				traceMsg (indent + "FindThing: Unknown Type: '" + (typeof findThing) + "'", Log.WARN);
			}
			
			if (findThing.stage == null) {
				traceMsg (indent +  "Stage is null so it might not be on the display list ", Log.WARN);
			} else {
				stageWidth = findThing.stage.width;
				stageHeight = findThing.stage.height;
				//traceMsg (indent +  "Found valid stage H/W: " + 
					//		roundDecPl(stageWidth, 2) + " : " + roundDecPl(stageHeight, 2), verbosity);
			}
			// Not supported?
			//traceMsg (indent + "Depth of clip is: " + findThing.depth);
			
			// FIXME - TODO - x,y should be relative to Stage, not parent object. And Stage width should be checked explicitly
			traceMsg (indent + "FindThing: X:Y is " + roundDecPl(findThing.x, 2) + " : " + roundDecPl(findThing.y, 2) + 
						" and W:H is " + roundDecPl(findThing.width, 2) + " : " + roundDecPl(findThing.height, 2), verbosity);
						
			if (Math.abs(findThing.scaleX) > 20) {
				traceMsg (indent + "ERROR: scaleX seems really big, so correct it: " + roundDecPl(findThing.scaleX, 2), Log.ERROR);
				findThing.scaleX = 1;
			}
			
			if (Math.abs(findThing.scaleY) > 20) {
				traceMsg (indent + "ERROR: scaleY seems really big, so correct it: " + roundDecPl(findThing.scaleY, 2), Log.ERROR);
				findThing.scaleY = 1;
			}
			if (findThing.x > stageWidth || findThing.x < 0) {
				traceMsg (indent + "Warning: findThing.x might be off-stage: " + roundDecPl(findThing.x, 2), Log.WARN);
			}
			if (findThing.y > stageHeight || findThing.y < 0) {
				traceMsg (indent + "Warning findThing.y might be off-stage: " + roundDecPl(findThing.y, 2), Log.WARN);
			}
			if (Math.abs(findThing.x) > 1200) {
				traceMsg (indent + "ERROR: findThing.x seems really wrong: " + roundDecPl(findThing.x, 2), Log.ERROR);
			}
			if (Math.abs(findThing.y) > 1200) {
				traceMsg (indent + "ERROR: findThing.y seems really wrong: " + roundDecPl(findThing.y, 2), Log.ERROR);
			}
			
			if (Math.abs(findThing.scaleX) < 0.1) {
				traceMsg (indent + "ERROR: scaleX seems really small: " + roundDecPl(findThing.scaleX, 2), Log.ERROR);
			}
			
			if (Math.abs(findThing.scaleY) < 0.1) {
				traceMsg (indent + "ERROR: scaleY seems really small: " + roundDecPl(findThing.scaleY, 2), Log.ERROR);
			}
				
			if (findThing.width < 2) {
				traceMsg (indent + "Warning: findThing.width is very small: " + roundDecPl(findThing.width, 2), Log.WARN);
			}
			
			if (findThing.height < 2) {
				traceMsg (indent + "Warning: findThing.height is very small: " + roundDecPl(findThing.height, 2), Log.WARN);
			}
			
			if (findThing.alpha < 0.1) {
					traceMsg (indent + "WARNING: findThing.alpha may be transparent: " + findThing.alpha, Log.WARN);
			} else if (findThing.alpha < 1) {
				traceMsg (indent + "WARNING: findThing.alpha is not 1: " + findThing.alpha, Log.WARN);
			}
			
			if (!findThing.visible) {
				traceMsg (indent + "WARNING: findThing.visible is Invisible: "  + findThing.visible, Log.WARN);
			}
		
			if (recurseUp && (findThing.parent is DisplayObjectContainer)) {
				// Recurse up the clip hierarchy to diagnose parent clips
				findIt (findThing.parent, recurseUp, false, SPACES + indent, verbosity);
			} else {
				traceMsg ("...", verbosity);	// Add a blank line for spacing.
			}
			
			if (recurseDown) {
				try {
					for (var i:Number = 0; i < findThing.numChildren; i++) {
						//traceMsg (indent + "******* Checking nesting ***************", verbosity);
						findIt (findThing.getChildAt(i), false, recurseDown, SPACES + indent, verbosity);
					}
					if (findThing.numChildren == 0) {
						//traceMsg (indent + "******* No more children ***************", verbosity);
					}
				} catch (err:Error) {
					//traceMsg (indent + "*** No more children: " + err.message, verbosity);
				}
			
			}
		}

		
		/* Obsolete AS2-style:
		// findClipProperties() function From http://www.oreilly.com/catalog/actscript/chapter/ch13.html#96092
		public static function findClipProperties (myClip:*, indentSpaces:Number = 0, numSubClips:Number = 0):void {
	
			// Use spaces to indent the child clips on each successive tier
	  		var indent:String = " ";
	  		for (var i:Number = 0; i < indentSpaces; i++) {
	    		indent += " ";
	  		}
	  		// Use numChildren instead.
	  		for (var property:* in myClip) {
	   			// Check if the current property of myClip is a movie clip
	   		 	if (typeof myClip[property] == "movieclip") {
					numSubClips++;
	      			traceMsg(indent + myClip[property].name);
	     			// Recurse as necessary
	     		 	findClips(myClip[property], indentSpaces + 4, numSubClips);
	    		}
	 	 	}
	 	 	
			if (numSubClips == 0) {
				traceMsg ("No subclips found");	// in " + targetPath(myClip));	// AS3 FIX
			}
		}
		*/
		
		// findClips(), traceClips(), findChildren
		// FIXME - add feature to find other properties, such as findClipProperties() above
		public static function findClips (myClip:DisplayObjectContainer, indentSpaces:Number = 0, numSubClips:Number = 0):void {
			var thisClip:DisplayObject;
			var i:int;
			
			// Use spaces to indent the child clips on each successive tier
	  		var indent:String = " ";
	  		for (i = 0; i < indentSpaces; i++) {
	    		indent += " ";
	  		}
	  		
	  		var n:int = 0;
	  		
	  		if (myClip) {
	  			n = myClip.numChildren;
	  		} else {
	  			//traceMsg (indent + "We hit bottom");
	  		}
	  		
	  		for (i = 0; i < n; i++) {
	   			numSubClips++;
	   			thisClip = myClip.getChildAt(i);
	      		traceMsg(indent + thisClip.name);
	     		// Recurse as necessary
	     		findClips(thisClip as DisplayObjectContainer, indentSpaces + 4, numSubClips);
	 	 	}
	 	 	
			if (numSubClips == 0) {
				traceMsg ("No subclips found");	// in " + targetPath(myClip));	// AS3 FIX
			}
		} 
	
		// convenience function
		private static function roundDecPl (num:Number, decPl:Number = 0):Number {
			var multiplier:Number = Math.pow(10, decPl);
			return Math.round(num * multiplier ) / multiplier;
		}
		
		
		private static function traceMsg (msg:String, verbosity:Number=NaN):void {
			if (isNaN(verbosity)) verbosity = Log.traceThreshold;
			
			//trace (msg);
			Log.traceMsg (msg, verbosity);
		}
	}
}