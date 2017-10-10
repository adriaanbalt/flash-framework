package com.balt.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;	

	/**
	 * DIVIDE A CLIP INTO LOTS OF LITTLES PIECES WHICH ARE CLIPS 
	 * 
	 * NOTE: I HAD TO USE 2 STEPS WHEN DRAWING THE MASKED CONTENT HAS IT APPEARS THERE IS A FLASH BUG
	 * THAT MAKES FLASH PLAYER CRASH WHEN WE TRY TO DRAW A MASKED CLIP
			 
	 
	 */
	public class MaskSplitter 
	{

		
		private var _pieces : Array;

		private var _masks : Array;

		/* the source on which the snapshot will be taken from */
		private var _source : Sprite;

		/* the target where all the little pieces will be */
		private var _target : DisplayObjectContainer;

		/* the sprite which contains all the masks  */
		private var _masksContainer : Sprite;

		
		private var _sourceBitmapData : BitmapData;

		/* if we return a series of bitmapData or directly create some clips on the target */
		private var _returnBitmapData : Boolean;
		private var _width : Number;
		private var _height : Number;

		
		
		public function MaskSplitter(param_source : Sprite,param_masksContainer : Sprite,param_target : DisplayObjectContainer = null)
		{
			_masksContainer = param_masksContainer;
			_source = param_source;
			_target = param_target;
			_pieces = [];
			_masks = [];
		}

		//split a displayObject into several sprites
		public function split(param_returnBitmapData : Boolean = false) : Array
		{
				
			//array of list of split clips
			_pieces = [];
				
			_returnBitmapData = param_returnBitmapData;

			_width = _source.width;
			_height = _source.height;

			splitting();
			return _pieces;
		}

		
		
		private function splitting() : void
		{
			
			_sourceBitmapData = new BitmapData(_width, _height, true, 0x00000000);
			_sourceBitmapData.draw(_source);
			
			_masks = [];
			//PARSE THE CHILDREN OF THE MASKCONTAINER
			for (var i : uint = 0;i < _masksContainer.numChildren;i++)
			{
				
				var currentGlassMask : DisplayObject = _masksContainer.getChildAt(i) as DisplayObject;
				_masks.push(currentGlassMask);
			}
			
			for (i = 0;i < _masks.length;i++)
			{
				
				currentGlassMask = _masks[i] as DisplayObject;
				
				var newPieceBmdata : BitmapData = new BitmapData(Math.round(currentGlassMask.width), Math.round(currentGlassMask.height), true, 0x00000000);
				
				// translate the coordinates of the current mask position
				var transMatrix : Matrix = new Matrix();
				transMatrix.translate(-Math.round(currentGlassMask.x), -Math.round(currentGlassMask.y));
				
				// make the piece at the position where the mask was
				var maskPositionX : Number = currentGlassMask.x;
				var maskPositionY : Number = currentGlassMask.y;
				
				//mask the source
				_source.addChild(currentGlassMask);
				_source.mask = currentGlassMask;
				
				//take snapshot of the source masked (translated)
				newPieceBmdata.draw(_source, transMatrix, null, null, new Rectangle(0, 0, Math.round(currentGlassMask.width), Math.round(currentGlassMask.height)));
				
				
				//create a new sprite which will contain the bitmap and add it to the target
				var newPieceMasked : Sprite = new Sprite();
				var newBmp : Bitmap = new Bitmap(newPieceBmdata, "auto", true);
				newPieceMasked.x = Math.round(maskPositionX);
				newPieceMasked.y = Math.round(maskPositionY);
				newPieceMasked.addChild(newBmp);
				
				
				// REMOVE THE CURRENT MASK
				currentGlassMask.parent.removeChild(currentGlassMask);
				
				_target.addChild(newPieceMasked);
				//
				_pieces.push(newPieceMasked);
			}
			
			_source.mask = null;
		}
	}
}
