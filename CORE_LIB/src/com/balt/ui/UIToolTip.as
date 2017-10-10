/*
 * Display a tooltip with a little border and arrow (talk-bubble style)
 *
 * @author: bruce epstein
**/
package com.balt.ui {
	import com.balt.log.Log;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class UIToolTip {
		// If these are all static, they can be shared by all callers. If they are not static, we can have a separate one for the each entity
		private var tip_mc:MovieClip;
		private var tFormat:TextFormat;
		private var textField_mc:TextField;
		
		//private var tipDepth:Number;
		//private var textDepth:Number;
		private var drawNubbin:Boolean;
		private var bgColor:Number;
		private var lineColor:Number;
		private var baseClip:DisplayObjectContainer;
		
		public function UIToolTip (inBaseClip:DisplayObjectContainer, inBgColor:Number = 0xFFFFEC, inLineColor:Number = 0x000000, 
								 inFont:String = "Arial", inPointSize:Number = 12, inAlign:String = "center", nubbin:Boolean = true) {
			//Log.traceMsg ("ToolTip constructor inBaseClip " + targetPath(inBaseClip));
			baseClip = inBaseClip;
			//Log.traceMsg ("ToolTip constructor baseClip " + targetPath(baseClip));
			
			//Log.traceMsg ("baseclip " + targetPath(baseClip));
			if (tip_mc == null)  {
				//Log.traceMsg ("Tooltip baseclip.tip_mc is null "  + targetPath(baseClip.tip_mc));
			}  else {
				//Log.traceMsg ("Tooltip baseclip.tip_mc is present and should be deleted "  + targetPath(baseClip.tip_mc));
				baseClip.removeChild(tip_mc);
				tip_mc = null;
				//Log.traceMsg ("Tooltip baseclip.tip_mc is deleted and should be gone now "  + targetPath(baseClip.tip_mc));
			}
			
			tip_mc = new MovieClip();
			baseClip.addChild (tip_mc);
			
			//Log.traceMsg ("BaseClip is " + targetPath(baseClip));
			//Log.traceMsg ("ToolTip constructor: tip_mc is " + targetPath(tip_mc) + " and tipDepth is " + tipDepth);
			
			tFormat = new TextFormat();
			tFormat.font  = inFont;
			tFormat.size  = inPointSize;
			tFormat.align = inAlign;
			
			bgColor    = inBgColor;
			lineColor  = inLineColor;
			drawNubbin = nubbin;  // Determines whether to draw small point on toolTip box (like a speech bubble)
		}
		
		private function redrawTip (tipText:String):void {
			var width:Number;
			var height:Number;
			var pointStart:Number = 20;
			var pointEnd:Number = 10;
			var pointHeight:Number = 10;
			
			// Use the properties of flash.text.TextField for the measurements 
			// of a field containing a line of text, and use flash.text.TextLineMetrics
			// for the measurements of the content within the text field.
			var metrics:Object = new Object(); // AS3 FIX - tFormat.getTextExtent(tipText);
			metrics.textFieldWidth = 200;
			metrics.textFieldHeight = 20;
			
			width  = metrics.textFieldWidth + 5;
			height = metrics.textFieldHeight;
			
			//Log.traceMsg ("TipText is '" + tipText + "' and width is " + width);
			//Log.traceMsg ("tip_mc is still " + targetPath(tip_mc) + " and textDepth is " + textDepth);
			if (textField_mc != null) {
				tip_mc.removeChild(textField_mc);
				textField_mc = null;
			}
			textField_mc = new TextField();
			textField_mc.x = 3;
			textField_mc.y = 1;
			textField_mc.autoSize = TextFieldAutoSize.LEFT;
			//textField_mc.width =  metrics.textFieldWidth;
			//textField_mc.height = metrics.textFieldHeight;
			
			textField_mc.name = "textField_mc";
			tip_mc.addChild(textField_mc);
			
			//myTextField = tip_mc.getChildByName("textField_mc");
			//Log.traceMsg("tip_mc.textField_mc is " + textField_mc);
			textField_mc.selectable = false;
			textField_mc.setTextFormat(tFormat);  // setNewTextFormat?
			textField_mc.text = tipText;
			// This calc works, provided you set the text string first
			width  = textField_mc.getBounds(textField_mc).width  + 7;
			height = textField_mc.getBounds(textField_mc).height + 4;
			//var foo:* = textField_mc.getLineMetrics(0);
			tip_mc.graphics.clear();
			tip_mc.graphics.beginFill(bgColor);
			tip_mc.graphics.lineStyle(1, lineColor, 100);
			tip_mc.graphics.moveTo(0, 0);
			tip_mc.graphics.lineTo(width, 0);
			tip_mc.graphics.lineTo(width, height);
			if (drawNubbin) {
				// Draw the little "triangle" point at the bottom
				tip_mc.graphics.lineTo(pointStart, height);
				tip_mc.graphics.lineTo((pointStart+pointEnd)/2, height+pointHeight);
				tip_mc.graphics.lineTo(pointEnd, height);
			} else {
				// Just draw a line straight across the bottom
			}
			tip_mc.graphics.lineTo(0, height);
			tip_mc.graphics.lineTo(0, 0);
			tip_mc.graphics.endFill();
			tip_mc.visible = false;
		}
		
		
		public function showTip(tipText:String, xLoc:Number=NaN, yLoc:Number=NaN):void {
			redrawTip(tipText);
			//Log.traceMsg ("showTip tip_mc " + targetPath(tip_mc));
			if (isNaN(xLoc)) {
				xLoc = baseClip.mouseX - 15;
			}
			if (isNaN(yLoc)) {
				yLoc = baseClip.mouseY - 65;
			}
			tip_mc.x = xLoc;
			tip_mc.y = yLoc;
			tip_mc.visible = true;
			/* This interferes with mouse events as the tooltip moves around
			tip_mc.onMouseMove = function() {
				//trace("yes");
				this.x = baseClip.mouseX-15 ;
				this.y = baseClip.mouseY-35;
				updateAfterEvent();
			}
			*/
		}
		
		public function removeTip():void {
			if (tip_mc != null) {
				tip_mc.visible = false;
				delete tip_mc.onEnterFrame;
				//tip_mc.removeClip ();
			}
			
		}
	
	}
}
