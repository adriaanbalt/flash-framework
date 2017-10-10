package com.balt.display.data
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TableCell extends Sprite
	{
		public const ALIGN_LEFT:String = "left";
		public const ALIGN_CENTER:String = "center";
		public const ALIGN_RIGHT:String = "right";
		
		public const TYPE_NONE:String = null;
		public const TYPE_TITLEROW:String = "title-row";
		public const TYPE_ROW:String = "row";
		public const TYPE_COLUMN:String = "column";				
		
		public var ID:uint;
		public var type:String;
		public var rowID:uint;
		public var colID:uint;
		public var numRows:uint;
		public var numCols:uint;
		public var cellParent:TableCell;
		public var content:Sprite = new Sprite();
		public var container:Sprite = new Sprite();
		public var background:Sprite = new Sprite();
		
		internal var manualWidth:Boolean = false;
		internal var manualHeight:Boolean = false;
		internal var cellWidth:Number;
		internal var cellHeight:Number;
		
		protected var styleObj:Object = new Object();
		
		private var cellMask:Sprite = new Sprite();
		
		public function TableCell()
		{	
			this.addChild( this.background );
			this.addChild( this.container );
			this.addChild( this.content );
			this.addChild( this.cellMask );
			
			this.content.mask = this.cellMask;
			
			this.styleObj.align = ALIGN_LEFT;
			this.styleObj.background = [0xFFFFFF];
			this.styleObj.margin = 0;
			this.styleObj.stroke = 0x000000;
			this.styleObj.textFormat = 0x000000;
			
			//this.addEventListener( MouseEvent.CLICK, traceValues );
		}
		
		private function traceValues( evt:MouseEvent ):void
		{
			trace( "" );
			trace( this.type, "Name:", this.name );
			trace( this.type, "ID:", this.ID );
			trace( this.type, "rowID:", this.rowID );
			trace( this.type, "colID:", this.colID );
			trace( this.type, "numRows:", this.numRows);
			trace( this.type, "numCols:", this.numCols );
			trace( "===================" );
			trace( this.type, "align:", this.styleObj.align );
			trace( this.type, "back:", this.styleObj.background );
			trace( this.type, "margin:", this.styleObj.margin );
			trace( this.type, "stroke:", this.styleObj.stroke );
			trace( this.type, "format:", this.styleObj.format );		
		}
		
		public function update():void
		{
			var isRow:Boolean = ( this.type.indexOf( "row" ) >= 0 );
			var isColumn:Boolean = ( this.type.indexOf( "column" ) >= 0 );
			var cellX:Number = 0;
			var cellY:Number = 0;

			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cell:TableCell = this.container.getChildAt( i ) as TableCell;
				
				if( isRow )
				{
					cell.x = cellX;
					cellX += cell.cellWidth;
				}
				if( isColumn )
				{
					cell.y = cellY;
					cellY += cell.cellHeight;
				}

				cell.update();
			}
			
			if( this.content.numChildren )
			{
				if( this.content.getChildByName( "cellText" ) ) this.setTextFormat( TextField( this.content.getChildByName( "cellText" ) ) );
				
				var margin:Number = 0;
				if( this.styleObj.margin ) margin = this.styleObj.margin;
				if( this.styleObj.align == ALIGN_LEFT ) this.content.x = margin;
				if( this.styleObj.align == ALIGN_RIGHT ) this.content.x = this.cellWidth - this.content.width - margin;				
				if( this.styleObj.align == ALIGN_CENTER ){ this.content.x = ( this.cellWidth - this.content.width ) * 0.5; }
				
				this.content.y = ( this.cellHeight - this.content.height ) * 0.5;
			}			
		}
		
		public function addCell( targetCell:*, sourceCell:* = null ):void
		{
			//if( !sourceCell )
			// sourceCell = targetCell
			trace( "ADD to", targetCell.name );
		}
		
		public function editCell( cell:* ):void
		{
			trace( "EDIT", cell.name );			
		}
		
		public function deleteCell( cell:* ):void
		{
			trace( "DELETE", cell.name );			
		}
		
		public function setContent( cell:*, contentObj:* ):void
		{
			if( cell != this ) return;
			
			while( this.content.numChildren ) this.content.removeChildAt(0);
			
			//trace( "*** Placing Content for", this.name );
			
			if( contentObj is String ) contentObj = this.createTextField( contentObj );
			this.content.addChild( contentObj );
		}
		
		public function setMargins( cell:*, margin:Number, type:String=TYPE_NONE ):void
		{
			if( cell != this ) return;
			
			//trace( "*** Setting margins for", this.name );
			var inherit:Boolean = ( this.cellParent && this.cellParent.type == type );
			
			if( !type || this.type == type || inherit )
			{
				this.styleObj.margin = margin;
			}
			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cellChild:TableCell = this.container.getChildAt( i ) as TableCell;

				cellChild.setMargins( cellChild, margin, type );
			}
		}
		
		public function setAlignment( cell:*, alignment:String, type:String=TYPE_NONE ):void
		{
			if( cell != this ) return;
			
			//trace( "*** Aligning Content for", this.name );
			var inherit:Boolean = ( this.cellParent && this.cellParent.type == type );
			
			if( !type || this.type == type || inherit )
			{
				this.styleObj.align = alignment;
			}
			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cellChild:TableCell = this.container.getChildAt( i ) as TableCell;

				cellChild.setAlignment( cellChild, alignment, type );
			}
		}
		
		public function setCellStyle( cell:*, background:*, stroke:*, type:String=TYPE_NONE ):void
		{
			if( cell != this ) return;
			
			//trace( "*** Styling Content for", this.name );
			var inherit:Boolean = ( this.cellParent && this.cellParent.type == type );
			
			if( !type || this.type == type || inherit )
			{
				this.styleObj.background = background;
				this.styleObj.stroke = stroke;
			}
			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cellChild:TableCell = this.container.getChildAt( i ) as TableCell;

				cellChild.setCellStyle( cellChild, background, stroke, type );
			}			
		}
		
		public function setTextStyle( cell:*, format:*, type:String=TYPE_NONE ):void
		{
			if( cell != this ) return;
			
			//trace( "*** Styling Content text for", this.name );
			var inherit:Boolean = ( this.cellParent && this.cellParent.type == type );
			
			if( !type || this.type == type || inherit )
			{
				this.styleObj.format = format;
			}
			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cellChild:TableCell = this.container.getChildAt( i ) as TableCell;

				cellChild.setTextStyle( cellChild, format, type );
			}			
		}

		public function setDimensions( _width:Number, _height:Number ):void
		{
			var isRow:Boolean = ( this.type.indexOf( "row" ) >= 0 );
			var parentIsColumn:Boolean = ( Object( this.parent.parent ).type.indexOf( "column" ) >= 0 );
			var divNum:uint = this.parent.numChildren;
			
			if( isRow || parentIsColumn ) _height = _height/divNum;	
			else _width = _width/divNum;
			
			if( !this.manualWidth ) this.cellWidth = _width;
			if( !this.manualHeight ) this.cellHeight = _height;
			
			this.createBackground();
			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cell:TableCell = this.container.getChildAt( i ) as TableCell;
				cell.setDimensions( this.cellWidth, this.cellHeight );
			}
			
			this.update();
		}
		
		private function createBackground():void
		{
			this.cellMask.graphics.clear();
			this.background.graphics.clear();
			while( this.background.numChildren ) this.background.removeChildAt(0);
			
			var isRow:Boolean = ( this.type.indexOf( "row" ) >= 0 );
			var isColumn:Boolean = ( this.type.indexOf( "column" ) >= 0 );
			var bgAlpha:uint = int( !( isRow || isColumn ) );
			var lineAlpha:uint = bgAlpha;
			var gradMatrix:Matrix = new Matrix();
			
			if( this.styleObj.background==undefined ) bgAlpha = 0;

			gradMatrix.createGradientBox( this.cellWidth, this.cellHeight, Math.PI/2 );
			
			if( this.styleObj.stroke!=undefined ) this.background.graphics.lineStyle( 0.1, this.styleObj.stroke, lineAlpha );
			this.background.graphics.beginGradientFill( GradientType.LINEAR, this.styleObj.background, [bgAlpha,bgAlpha], [ 100, 255 ], gradMatrix );
			this.background.graphics.drawRect( 0, 0, this.cellWidth, this.cellHeight );
			this.background.graphics.endFill();
			
			this.cellMask.graphics.beginFill( 0x000000 );
			this.cellMask.graphics.drawRect( 0, 0, this.cellWidth, this.cellHeight );
			this.cellMask.graphics.endFill();
		}
		
		private function createTextField( textStr:String ):TextField
		{
			var cellText:TextField = new TextField();
			
			cellText.name			= "cellText";
			cellText.embedFonts 	= true;
			cellText.selectable 	= false;
			cellText.multiline 		= true;
			cellText.wordWrap 		= true;
			cellText.autoSize 		= TextFieldAutoSize.LEFT;
			cellText.antiAliasType	= AntiAliasType.ADVANCED;
			
			this.setTextFormat( cellText );
			
			cellText.htmlText 		= textStr;

			return cellText;
		}
		
		private function setTextFormat( cellText:TextField ):void
		{
			if( this.styleObj.format )
			{
				this.styleObj.format.align = this.styleObj.align;
				cellText.setTextFormat( this.styleObj.format );
			}
			
			cellText.width = this.cellWidth - ( this.styleObj.margin * 2 );
		}
	}
}