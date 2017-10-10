package com.balt.ui
{
	import com.gs.TweenLite;
	import com.balt.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;		
	
	/**
	* Asset-based dropdown
	* Pass in base container clip which must contain:
	* Texbox for current selection ( labelTxt )
	* Button to toggle list ( dropDownBtn )
	* Optional overlay graphic, such as an arrow ( overlayMc )
	* Selection list mask ( dropDownMask )
	* Selection list ( dropDownList ) which contains:
	* 	List content container ( dropDownContent )
	* 	List content mask ( dropDownMask )
	*/	
	
	public class UIDropDown extends Sprite
	{
		public static const CHANGE:String = "dropDownChange";
		public var selectedItem:String;

		private var _base:MovieClip;
		private var _defaultY:Number;		
		private var _openedY:Number;
		private var _closedY:Number;
		private var _shrunken:Boolean = false;
		
		private var _buildable:Boolean = true;
		
		/**
		* Instantiates a new drop-down menu
		* 
		* @param base A movieclip containing at minimum: "labelTxt", "dropDownBtn", "dropDownMask", "dropDownList",
		* and within "dropDownList" - "dropDownContent" and "dropDownMask"
		*/		
		
		public function UIDropDown( base:MovieClip ):void
		{
			this._base = base;
			
			if( !base.labelTxt )
			{
				trace( "*** ERROR: Drop down component is missing 'labelTxt' asset." );
				this._buildable = false;
				return;
			}
			if( !base.dropDownBtn )
			{
				trace( "*** ERROR: Drop down component is missing 'dropDownBtn' asset." );
				this._buildable = false;
				return;
			}
			if( !base.dropDownMask )
			{
				trace( "*** ERROR: Drop down component is missing 'dropDownMask' asset." );
				this._buildable = false;
				return;
			}
			if( !base.dropDownList )
			{
				trace( "*** ERROR: Drop down component is missing 'dropDownList' asset." );
				this._buildable = false;
				return;
			}
			if( !base.dropDownList.dropDownContent )
			{
				trace( "*** ERROR: Drop down component is missing 'dropDownList.dropDownContent' asset." );
				this._buildable = false;
				return;
			}
			if( !base.dropDownList.dropDownMask )
			{
				trace( "*** ERROR: Drop down component is missing 'dropDownList.dropDownMask' asset." );
				this._buildable = false;
				return;
			}
			
			this._base.labelTxt.mouseEnabled = false;
			this._base.labelTxt.autoSize = TextFieldAutoSize.LEFT;
			
			if( this._base.overlayMc ) this._base.overlayMc.mouseEnabled = false;
			
			if( this._base.dropDownBtn is MovieClip || this._base.dropDownBtn is Sprite )
			{
				this._base.dropDownBtn.mouseChildren = false;
				this._base.dropDownBtn.buttonMode = true;
			}
			
			this._openedY = this._base.dropDownMask.y;
			this._closedY = ( this._base.dropDownBtn.y + this._base.dropDownBtn.height/2 ) - this._base.dropDownList.height;
			this._defaultY = this._base.dropDownList.dropDownContent.y;
			this._base.dropDownList.y = this._closedY;
			
			this.addChild( base );	
		}
		
		/**
		* Sets the textbox width
		* 
		* @param textWidth The new drop-down textbox width 
		*/			
		
		override public function set width( textWidth:Number ):void
		{
			var baseAsset:Object;
			var sizeDiff:Number;
			
			if( this._base.dropDownBg )	baseAsset = this._base.dropDownBg;
			else baseAsset = this._base.dropDownBtn;
			
			sizeDiff = textWidth - baseAsset.width;
			baseAsset.width = textWidth;
			
			if( this._base.dropDownBg ) this._base.dropDownBtn.x += sizeDiff;
			
			this._base.labelTxt.width += sizeDiff;
			this._base.dropDownMask.width += sizeDiff;
			this._base.dropDownList.dropDownMask.width += sizeDiff;
			
			if( this._base.overlayMc ) this._base.overlayMc.x += sizeDiff;
			if( this._base.textMask ) this._base.textMask.width += sizeDiff;
			if( this._base.dropDownList.dropDownBg ) this._base.dropDownList.dropDownBg.width += sizeDiff;
		}
		
		/**
		* Sets the active list item via text value
		* 
		* @param selectedText The text value matching the item to be set as active
		*/		
		
		public function setActive( selectedText:String ):void
		{
			this._base.labelTxt.text = selectedText;
			this.selectedItem = selectedText;
			
			toggleSelected( selectedText );
			toggleList( false );			
		}
		
		/**
		* Builds the drop-down list from an array of display objects
		* 
		* @param itemList An array of display objects
		*/			

		public function buildList( itemList:Array ):void
		{
			if( !this._buildable )
			{
				trace( "*** ERROR: Cannot build because of missing component assets." );
				return;
			}
			
			for(var i:int=0; i<itemList.length; i++)
			{
				var listItem:Sprite = new Sprite();
				
				listItem.addChild( itemList[i] );
				listItem.y = listItem.height * i;
				listItem.alpha = 0.5;
				
				this._base.dropDownList.dropDownContent.addChild( listItem );

				listItem.buttonMode = true;
				listItem.mouseChildren = false;
				listItem.addEventListener( MouseEvent.ROLL_OVER, onItemAction );
				listItem.addEventListener( MouseEvent.ROLL_OUT, onItemAction );
				listItem.addEventListener( MouseEvent.CLICK, onItemAction );
				
				this.addEventListener( UIDropDown.CHANGE, updateSelected );					
			}
			
			this._base.addEventListener( MouseEvent.ROLL_OUT, onComboAction );
			this._base.dropDownBtn.addEventListener( MouseEvent.CLICK, onButtonAction );
			
			if( this._base.dropDownList.dropDownContent.height < this._base.dropDownList.dropDownMask.height ) shrinkList();		
		}
		
		private function shrinkList():void
		{
			this._openedY -= this._base.dropDownList.dropDownMask.height - this._base.dropDownList.dropDownContent.height;
			this._shrunken = true;
		}
		
		private function toggleList( active:Boolean ):void
		{
			if(active)
			{
				TweenLite.to( this._base.dropDownList, 0.5, {y:this._openedY} );
				this._base.dropDownList.addEventListener( Event.ENTER_FRAME, onListAction );
				
			} else
			{
				TweenLite.to( this._base.dropDownList, 0.5, {y:this._closedY} );
				this._base.dropDownList.removeEventListener( Event.ENTER_FRAME, onListAction );				
			}
			
		}
		
		private function toggleSelected( selectedText:String ):void
		{
			for( var c:int=0; c<this._base.dropDownList.dropDownContent.numChildren; c++ )
			{
				this._base.dropDownList.dropDownContent.getChildAt(c).mouseEnabled = true;
				this._base.dropDownList.dropDownContent.getChildAt(c).alpha = 0.5;
				
				if( this._base.dropDownList.dropDownContent.getChildAt(c).getChildAt(0) is TextField &&
					this._base.dropDownList.dropDownContent.getChildAt(c).getChildAt(0).text == selectedText )
				{
					this._base.dropDownList.dropDownContent.getChildAt(c).mouseEnabled = false;
					this._base.dropDownList.dropDownContent.getChildAt(c).alpha = 1;					
				}
			}
		}
		
		private function onListAction( evt:Event ):void
		{
			if( this._shrunken )
			{
				this._base.dropDownList.dropDownContent.y = ( this._base.dropDownList.dropDownMask.y + this._base.dropDownList.dropDownMask.height ) - this._base.dropDownList.dropDownContent.height + 2;
				return;
			}
			
			var topBuffer:Number 		= -10;
			var bottomBuffer:Number 	= -25;			
			var mousePos:Number 		= evt.currentTarget.mouseY;
			var scrollOffset:Number 	= this._base.dropDownList.dropDownContent.height - this._base.dropDownList.dropDownMask.height;
			var scrollIncrement:Number 	= ( mousePos - this._base.dropDownList.dropDownMask.y + topBuffer ) / ( this._base.dropDownList.dropDownMask.height + bottomBuffer );
			var maxScroll:Number 		= ( this._defaultY +  this._base.dropDownList.dropDownMask.height ) - this._base.dropDownList.dropDownContent.height;
			var listPos:Number 			= this._defaultY - ( scrollOffset * scrollIncrement );
			
			if( listPos > ( this._defaultY + 5 )){ listPos = ( this._defaultY + 5 ); }
			if( listPos < maxScroll - 5 ){ listPos = maxScroll - 5; }	
			
			TweenLite.to( this._base.dropDownList.dropDownContent, 1, {y:listPos} );
		}
		
		private function onItemAction( evt:MouseEvent ):void
		{
			if( !evt.currentTarget.mouseEnabled ) return;
			
			if( evt.type=='rollOver' ){ TweenLite.to( evt.currentTarget, 0.5, {autoAlpha:1} ); }
			else if( evt.type=='rollOut' ){ TweenLite.to( evt.currentTarget, 0.5, {autoAlpha:0.5} ); }
			else if( evt.type=='click' )
			{
				var newSelection:String = TextField( evt.currentTarget.getChildAt( 0 ) ).text;
				
				this.dispatchEvent( new GenericDataEvent( UIDropDown.CHANGE, false, false, newSelection ) );
			}
		}
		
		private function onButtonAction( evt:MouseEvent ):void
		{
			this.parent.setChildIndex( this, this.parent.numChildren - 1 );
			toggleList( true );
		}
		
		private function onComboAction(e:MouseEvent):void
		{
			toggleList( false );
		}
		
		private function updateSelected( evt:GenericDataEvent ):void
		{
			setActive( evt.data );
		}
	}
}