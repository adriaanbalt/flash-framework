package com.balt.display.graphics
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class GraphicUtil
	{
		public static const PNT_UP:String = "up";
		public static const PNT_DOWN:String = "down";
		public static const PNT_LEFT:String = "left";
		public static const PNT_RIGHT:String = "right";						
		
		public function GraphicUtil(){ }

		public static function drawRoundRect(target:Sprite, w:Number, h:Number, fillColor:uint=0xFFFFFF, topLeftRadius:Number = 0, topRightRadius:Number = 0, bottomLeftRadius:Number = 0, bottomRightRadius:Number = 0):Sprite
		{
			if (!target) {
				target = new Sprite();
			}
			target.graphics.clear();
			target.graphics.beginFill( fillColor, 1 );
			target.graphics.drawRoundRectComplex(
				0,
				0,
				w,
				h,
				topLeftRadius,
				topRightRadius,
				bottomLeftRadius,
				bottomRightRadius
			);
			target.graphics.endFill();
			return target;	
		}
		
		public static function tint (target:DisplayObject, tintColor:uint, alpha:Number=NaN):void
		{
			var tmpTrans:ColorTransform = target.transform.colorTransform;
			tmpTrans.redOffset = tintColor;
			target.transform.colorTransform = tmpTrans;
			if (!isNaN(alpha)) {
				target.alpha = alpha;
			}
		}
		
		public static function drawTriangle( colors:Array, alphas:Array, directionPnt:String=GraphicUtil.PNT_UP ):Sprite
		{
			var triangleClip:Sprite = new Sprite();
			var gradMatrix:Matrix = new Matrix();
			
			if( directionPnt==GraphicUtil.PNT_DOWN )
			{
				gradMatrix.createGradientBox(120, 120, 0, -40, -50);
				triangleClip.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, [0, 95], gradMatrix);
				triangleClip.graphics.lineTo(40, 0);
				triangleClip.graphics.lineTo(20, 30);
				triangleClip.graphics.lineTo(0, 0);
			}
			else if( directionPnt==GraphicUtil.PNT_LEFT )
			{
				gradMatrix.createGradientBox(120, 120, 0, -40, -42);
				triangleClip.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, [0, 95], gradMatrix);
				triangleClip.graphics.moveTo(30, 0);		
				triangleClip.graphics.lineTo(30, 40);
				triangleClip.graphics.lineTo(0, 20);
				triangleClip.graphics.lineTo(30, 0);		
			}
			else if( directionPnt==GraphicUtil.PNT_RIGHT )
			{
				gradMatrix.createGradientBox(120, 120, 0, -50, -42);
				triangleClip.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, [0, 95], gradMatrix);
				triangleClip.graphics.lineTo(30, 20);
				triangleClip.graphics.lineTo(0, 40);
				triangleClip.graphics.lineTo(0, 0);		
			}
			else
			{
				gradMatrix.createGradientBox(120, 120, 0, -40, -42);
				triangleClip.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, [0, 95], gradMatrix);		
				triangleClip.graphics.moveTo(20, 0);
				triangleClip.graphics.lineTo(40, 30);
				triangleClip.graphics.lineTo(0, 30);
				triangleClip.graphics.lineTo(20, 0);
			}
			
			return triangleClip;
		}
	}
}