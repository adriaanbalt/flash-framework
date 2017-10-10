package com.balt.display.color
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;	

	public class GradientTween extends Sprite
	{
		
		public static var EVENT_ON_FINISH : String = "onFinished";
		public static var EVENT_ON_STOP : String = "onStop";
		
		public var sColor:Number;
		public var eColor:Number;
		
		private var sTwnSteps:Array;
		private var eTwnSteps:Array;
		
		private var gWidth:Number;
		private var gHeight:Number;
		private var alphas:Array;
		private var ratios:Array;
		private var matr:Matrix;
		private var fillType:String;
		
		private var twnFrames:Number;
		private var currentFrame:Number;
		
		private var angle_offset : Number = 2;
		private var angle : Number;
		
		public function GradientTween($width:Number, $height:Number, $startColor:Number, $endColor:Number, $angle:Number = 0)
		{
			this.sColor = $startColor;
			this.eColor = $endColor;
			this.angle = $angle;
			this.gWidth = $width;
			this.gHeight = $height;
			var colors:Array = [$startColor, $endColor];
		}
		
		public function init() : void
		{
			this.fillType = "linear";
			this.alphas = [100, 100];
			this.ratios = [0x00, 0xFF];
			this.matr = new Matrix();
			matr.createGradientBox(gWidth, gHeight, (angle * Math.PI/180), 0, 0);
			this.updateGradient(sColor, eColor);	
		}
		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, doTween);
			this.dispatchEvent(new Event( EVENT_ON_STOP ));
		}
		
		public function tweenGradient($startColor:Number, $endColor:Number, $steps:Number):void
		{
			this.currentFrame = 0;
			this.stop();
			
			this.sTwnSteps = this.getDifferenceAsSteps(this.HEXtoRGB(this.sColor), this.HEXtoRGB($startColor), $steps);
			this.eTwnSteps = this.getDifferenceAsSteps(this.HEXtoRGB(this.eColor), this.HEXtoRGB($endColor), $steps);
			this.sColor = $startColor;
			this.eColor = $endColor;

			this.addEventListener(Event.ENTER_FRAME, doTween);
		}
		
		private function doTween(evt:Event = null):void
		{
			this.updateGradient(this.RGBtoHEX( sTwnSteps[this.currentFrame].r, sTwnSteps[this.currentFrame].g, sTwnSteps[this.currentFrame].b), this.RGBtoHEX(eTwnSteps[this.currentFrame].r,eTwnSteps[this.currentFrame].g,eTwnSteps[this.currentFrame].b));
			if(this.currentFrame==this.twnFrames-1) {
				this.removeEventListener(Event.ENTER_FRAME, doTween);
				this.dispatchEvent(new Event( EVENT_ON_FINISH ));
			}
			else this.currentFrame++;
		}
		
		// FIXME - move these to centralized utility class
		private function randRange(min:Number, max:Number) : Number
		{
			var r : Number = Math.round( Math.random() * (max - min)) + min;
			return r;
		}
		
		private function updateGradient(s:Number, e:Number):void
		{
			var r : Number = Math.round( randRange( 0, 1 ) );
			if ( r == 0 ){
				angle -= ( angle_offset );
			} else {
				angle += ( angle_offset );
			}
			if ( angle >= 360 ) {
				angle = 0;
			}
			if ( angle <= 0 ){
				angle = 360;
			}
			
			matr.createGradientBox(gWidth, gHeight, (angle * Math.PI/180), 0, 0);
			this.graphics.clear();
			this.graphics.beginGradientFill(this.fillType, [s, e], this.alphas, this.ratios, this.matr);  
			this.graphics.drawRect(0,0,this.gWidth,this.gHeight);
		}
		
		// FIXME - move these to centralized utility class
		private function HEXtoRGB(hex:Number):Object
		{
			return {r:hex >> 16, g:(hex >> 8) & 0xff, b:hex & 0xff};
		}
		
		// FIXME - move these to centralized utility class
		private function RGBtoHEX(red:Number, green:Number, blue:Number):Number
		{
			var s:String = new String('0x');
			var r:String = red.toString(16);
			s += (r.length<2)?('0'+r):r;
			var g:String = green.toString(16);
			s += (g.length<2)?('0'+g):g;
			var b:String = blue.toString(16);
			s += (b.length<2)?('0'+b):b;
			return Number(s);
		}
		
		private function getDifferenceAsSteps(a:Object, z:Object, stepCount:Number):Array
		{
			stepCount--;
			
			var r:Number = ((z.r - a.r) / stepCount);
			var g:Number = ((z.g - a.g) / stepCount);
			var b:Number = ((z.b - a.b) / stepCount);  
	
			var rgbVector:Array = new Array(); 
			var i:Number=0;
			var obj:Object = new Object();
			
			while(i < stepCount){
				obj = (i > 0) ? rgbVector[i-1] : a;
				rgbVector.push({r:obj.r+r, g:obj.g+g, b:obj.b+b});
				i++;
			}
			
			rgbVector.unshift(a);
			this.twnFrames = rgbVector.length;
			
			return rgbVector;
		}
	}
}
