package com.balt.ui
{
/**
* TEMPORARY PLACEMENT FOR UILIST CLASS 
*/	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	/**
	 * @TODO: Add in functionality for sorting items somehow...
	 * @TODO: Remove dependancy on novartis
	 * @TODO: Add separator option (name?) divideLine?? divider??
	 * @TODO: Add functionality for paddingBottom & paddingRight
	 * @author thaylin
	 * 
	 */
	public class UIList extends Sprite
	{
		private var _width:Number = 10;
		private var _height:Number = 10;
		private var _border:Boolean = false;
		private var _borderColor:uint = 0x000000;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundAlpha:Number = 1;
		private var _contentContainerBackground:Sprite;
		private var _mask:Sprite;
		private var _contentContainer:Sprite;
		private var _padding:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingBottom:Number = 0;
		private var _paddingLeft:Number = 0;
		private var _paddingRight:Number = 0;
		private var _background:Sprite;
		private var _scroller:TScrollBar;
		
		public function UIList( width:Number, height:Number, borderColor:uint = 0x000000, backgroundColor:uint = 0xFFFFFF, scroller:TScrollBar = null )
		{
			super();
			_width = width;
			_height = height;
			_background = new Sprite();
			_contentContainer = new Sprite();
			_mask = new Sprite();
			_border = (borderColor != this.borderColor);
			_borderColor = borderColor;
			if(scroller)_scroller = scroller;
			
			init()
			this.addEventListener(Event.CHANGE,  redraw)
		}
		/**
		 *	get / set Padding updates list immediately affecting items within the list
		 * @return Number
		 * @param value:Number 
		 */	
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(value==_padding) return;
			_padding = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function set backgroundAlpha(value:Number):void
		{
			if ( value == _backgroundAlpha ) return;
			 _backgroundAlpha = value < 0 ? 0 : value; 
			 dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 *	get / set Padding Left updates list immediately affecting items within the list
		 * @return Number
		 * @param value:Number 
		 */	
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void
		{
			if(value==_paddingLeft) return;
			
			_paddingLeft = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 *	Get / Set Padding Right updates list immediately affecting items within the list
		 * @return Number
		 * @param value:Number 
		 */	
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		public function set paddingRight(value:Number):void
		{
			if(value==_paddingRight) return;
			
			_paddingRight = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 *	Get / Set Padding Top updates list immediately affecting items within the list
		 * @return Number
		 * @param value:Number
		 */	
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		public function set paddingTop(value:Number):void
		{
			if(value==_paddingTop) return;
			
			_paddingTop = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 *	Get / Set Padding Bottom updates list immediately affecting items within the list
		 * @return Number
		 * @param value:Number
		 */		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		public function set paddingBottom(value:Number):void
		{
			if(value==_paddingBottom) return;
			
			_paddingBottom = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * border 
		 * @param value:Boolean
		 * 
		 */		
		public function set border(value:Boolean):void
		{
			if(value==_border) return;
			
			_border = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get border():Boolean
		{
			return _border;
		}
		/**
		 * borderColor
		 * @param value:uint
		 * 
		 */		
		public function set borderColor(value:uint):void
		{
			if(value==_borderColor) return;
			
			_borderColor = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get borderColor():uint
		{
			return _borderColor;
		}
		/**
		 * backgroundColor
		 * @param value:uint
		 * @return uint
		 */		
		public function set backgroundColor(value:uint):void
		{
			if(value==_backgroundColor) return;
			
			_backgroundColor = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		public override function set height(value:Number):void
		{
			if(value==_height) return;
		
			_height = value;
			
			dispatchEvent(new Event(Event.CHANGE));
			//redraw()
		}
		public override function get height():Number
		{
			return _height;
		}
		public override function set width(value:Number):void
		{
			if(value!=_width)dispatchEvent(new Event(Event.CHANGE));
			_width = value;
		}
		public override function get width():Number
		{
			return _width
		}
		private function repositionItems():void
		{
			for(var i:int = 0; i<_contentContainer.numChildren; i++)
			{
				var prevItem:DisplayObject 
				var item:DisplayObject = _contentContainer.getChildAt(i)
				
				if(i) prevItem = _contentContainer.getChildAt(i-1);
				item.x = paddingLeft;
				item.y = (!prevItem) ? paddingTop : prevItem.y + prevItem.height + padding;
			}
		}
		public function init():void
		{
			addChild(_background);
			
			_contentContainer.name = 'contentContainer'
			
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect(0,0,this.width, this.height); 
			addChild(_contentContainer);
			_contentContainerBackground = new Sprite();
			_contentContainerBackground.graphics.drawRect(0,0,_mask.width, 1);
			_contentContainerBackground.alpha = 0;
			_contentContainer.addChild(_contentContainerBackground)
			addChild(_mask);
			_contentContainer.mask = _mask;
			if(_scroller)
			{
				_scroller.height = _mask.height + this.paddingTop + paddingBottom;
				_scroller.build( _contentContainer, _mask, true, 0xFFFFFF, 0x999999, 0x999999 );
				_scroller.x = _mask.x + _mask.width - _scroller.width;
				_scroller.y = _mask.y;
				
				addChild(_scroller);  
			}
			redraw();
		}
		public function addItem(item:DisplayObject):void
		{
			item.y = _contentContainer.height + padding;
			item.y += (_contentContainer.numChildren>1) ? 0 : paddingTop;
			_contentContainerBackground.height = item.y + item.height + paddingBottom;
			item.x = paddingLeft;
			_contentContainer.addChild(item);
			redraw();
		}
		public function addItems(itemArr:Array):void
		{
			for(var i:int = 0; i<itemArr.length; i++)
			{
				var item:DisplayObject = itemArr[i] as DisplayObject;
				addItem(item);
			}
			positionItems();
		}
		public function removeItems():void
		{
			for(var i:int = _contentContainer.numChildren-1; i>=0; i--)
			{
				if(_contentContainer.getChildAt(i)!=_contentContainerBackground)_contentContainer.removeChildAt(i);
				_contentContainer.y = 0;
				if(_scroller)_scroller.update();
			}
			_contentContainerBackground.height = 0;
			redraw();
		}
		public function removeItemAt(index:int):void
		{
			try
			{
				_contentContainer.removeChildAt(index);
				positionItems();
			}
			catch(error:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false,error.message))
			}
		}
		private function positionItems():void
		{
			for(var i:int = 0; i<_contentContainer.numChildren; i++)
			{
				var item:DisplayObject  = _contentContainer.getChildAt(i);
				item.y = (!i) ? paddingTop : _contentContainer.getChildAt(i-1).height + padding;
				item.x = paddingLeft;
			}
			redraw();
		}
		private function redraw(event:Event = null):void
		{
			_mask.width  = this.width;
			_mask.height = this.height;
			
			_background.graphics.clear();
			_background.graphics.beginFill(backgroundColor, _backgroundAlpha);
			if( border ) _background.graphics.lineStyle(1,borderColor, 1)
			_background.graphics.drawRect(0,0,this.width, this.height);
			_background.graphics.endFill(); 
			
			if(_scroller)_scroller.update();
			
		}
	}
}