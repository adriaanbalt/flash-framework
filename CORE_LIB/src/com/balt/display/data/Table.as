package com.balt.display.data
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Table extends TableCell
	{
		public static const ADD:String = "addCell";
		public static const EDIT:String = "editCell";
		public static const DELETE:String = "deleteCell";
		
		public var cells:Array = new Array();
			
		private var cellPath:Array;
		
		public function Table( _width:Number=100, _height:Number=100, dataObj:Object=null )
		{
			this.cellWidth = _width;
			this.cellHeight = _height;
			this.type = "table";
			this.ID = this.rowID = this.colID = 0;
			
			if( dataObj ) this.setData( XML( dataObj ) );
			
			this.addChild( this.container );
		}
		
		public function refresh():void
		{
			this.setDimensions( this.cellWidth, this.cellHeight );
		}
		
		override public function update():void
		{
			var cellX:Number = 0;
			var cellY:Number = 0;

			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cell:TableCell = this.container.getChildAt( i ) as TableCell;
				var isRow:Boolean = ( cell.type.indexOf( "row" ) >= 0 );
				
				if( isRow )
				{
					cell.y = cellY;
					cellY += cell.cellHeight;
				}
				else
				{
					cell.x = cellX;
					cellX += cell.cellWidth;
				}

				cell.update();
			}			
		}
		
		override public function addCell( targetCell:*, sourceCell:* = null ):void
		{
			var validTarget:TableCell = this.cellLocator( targetCell );
			var validSource:TableCell = this.cellLocator( sourceCell );

			if( validTarget )
			{
				if( validTarget != this ) validTarget.addCell( validTarget, validSource );
				else super.addCell( validTarget, validSource );
			}
		}
		
		override public function editCell( cell:* ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( validCell != this ) validCell.editCell( validCell );
				else super.editCell( validCell );
			}			
		}
		
		override public function deleteCell( cell:* ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( validCell != this ) validCell.deleteCell( validCell );
				else super.deleteCell( validCell );
			}		
		}
		
		override public function setContent( cell:*, content:* ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( validCell == this ) trace( "*** ERROR: Content must be added to an individual cell." );
				else validCell.setContent( validCell, content );
			}
		}
		
		override public function setMargins( cell:*, margin:Number, type:String=TYPE_NONE ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( validCell != this ) validCell.setMargins( validCell, margin, type );
				else super.setMargins( validCell, margin, type );
			}
		}
		
		override public function setAlignment( cell:*, alignment:String, type:String=TYPE_NONE ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( validCell != this ) validCell.setAlignment( validCell, alignment, type );
				else super.setAlignment( validCell, alignment, type );
			}
		}
		
		override public function setCellStyle( cell:*, background:*, stroke:*, type:String=TYPE_NONE ):void
		{
			var validCell:TableCell = this.cellLocator( cell );
			
			if( !( background is Array ) ) background = [ background ];
			if( stroke != undefined ) stroke = uint( stroke );

			if( validCell )
			{
				if( validCell != this ) validCell.setCellStyle( validCell, background, stroke, type );
				else super.setCellStyle( validCell, background, stroke, type );
			}
		}
		
		override public function setTextStyle( cell:*, format:*, type:String=TYPE_NONE ):void
		{
			var validCell:TableCell = this.cellLocator( cell );

			if( validCell )
			{
				if( !( format is TextField ) && !( format is TextFormat ) )
				{
					trace( "*** ERROR: Format must come from TextField or TextFormat." );
					return;						
				}
				else if( format is TextField ) format = format.defaultTextFormat;
				
				if( validCell != this ) validCell.setTextStyle( validCell, format, type );
				else super.setTextStyle( validCell, format, type );
			}
		}

		override public function setDimensions( _width:Number, _height:Number ):void
		{
			this.cellWidth = _width;
			this.cellHeight= _height;			

			
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cell:TableCell = this.container.getChildAt( i ) as TableCell;
				cell.setDimensions( _width, _height );
			}
			
			this.update();
		}
		
		public function setRowHeight( rowID:*, _height:Number ):void
		{
			if( !( rowID is String ) && !( rowID is Number ) && !( rowID is Array ) )
			{
				trace( "*** ERROR:", rowID, "is not a valid range." );
				return;
			}
			
			var filterRows:Boolean = true
			if( rowID == "*" ) filterRows = false
			
			if( rowID is String ) rowID = rowID.split( "," );
			if( rowID is String || rowID is Number ) rowID = [rowID];
			
			for( var x:uint=0; x<rowID.length; x++ )
			{			
				for( var i:uint=0; i<this.container.numChildren; i++ )
				{
					var cell:TableCell = this.container.getChildAt( i ) as TableCell;
					
					if( cell.type.indexOf( "row" ) >= 0 )
					{
						if( cell.rowID == rowID[ x ] || !filterRows )
						{			
							cell.setDimensions( cell.width, _height*this.container.numChildren );
							cell.manualHeight = true;							
						}
					}
					else
					{
						for( var j:uint=0; j< cell.container.numChildren; j++ )
						{
							var childCell:TableCell = cell.container.getChildAt( j ) as TableCell;
							if( childCell.rowID == rowID[ x ] || !filterRows )
							{
								childCell.setDimensions( childCell.width, _height*cell.container.numChildren );
								childCell.manualHeight = true;							
							}
						}
					}
				}
			}
			
			this.update();
		}
		
		public function setColumnWidth( colID:*, _width:Number ):void
		{
			if( !( colID is String ) && !( colID is Number ) && !( colID is Array ) )
			{
				trace( "*** ERROR:", colID, "is not a valid range." );
				return;
			}

			var filterCols:Boolean = true
			if( colID == "*" ) filterCols = false

			if( colID is String ) colID = colID.split( "," );
			if( colID is String || colID is Number ) colID = [colID];			
			
			for( var x:uint=0; x<colID.length; x++ )
			{
				for( var i:uint=0; i<this.container.numChildren; i++ )
				{
					var cell:TableCell = this.container.getChildAt( i ) as TableCell;
					
					if( cell.type.indexOf( "column" ) >= 0 )
					{
						if( cell.colID == colID[ x ] || !filterCols )
						{
							cell.setDimensions( _width*this.container.numChildren, cell.height );
							cell.manualWidth = true;						
						}
					}
					else
					{
						for( var j:uint=0; j< cell.container.numChildren; j++ )
						{
							var childCell:TableCell = cell.container.getChildAt( j ) as TableCell;
							if( childCell.colID == colID[ x ] || !filterCols )
							{
								childCell.setDimensions( _width*cell.container.numChildren, childCell.height );
								childCell.manualWidth = true;							
							}
						}
					}
				}
			}
			
			this.update();
		}
		
		public function setData( objXML:Object ):void
		{
			while( this.container.numChildren ) this.container.removeChildAt(0);
			this.cellPath = new Array();
			this.cellPath.push( this );
			
			this.parseXMLtoCell( objXML );
			this.setRowsColsVars();
			this.refresh();
		}

		private function parseXMLtoCell( objXML:Object ):void
		{
			if(objXML != null)
			{
				for each( var item:XML in objXML.children() )
				{
					var cell:TableCell = new TableCell();
					var cellParent:TableCell = this.cellPath[ this.cellPath.length - 1 ];
					var parentIsRow:Boolean = cellParent.type.indexOf( "row" ) >= 0;
					var parentIsColumn:Boolean = cellParent.type.indexOf( "column" ) >= 0;
					
					cell.ID = item.childIndex();
					cell.type = item.name();
					cell.cellParent = cellParent;
					
					if( cell.type.indexOf( "row" ) >= 0 )
					{
						cell.rowID = cell.ID;
						cell.colID = cellParent.colID;
						
						cellParent.numCols = 0;
						cellParent.numRows = item.parent().children().length();
					}
					else
					{
						if( parentIsRow ) cell.colID = cell.ID;
						else cell.colID = cellParent.colID;
						if( parentIsColumn ) cell.rowID = cell.ID;
						else cell.rowID = cellParent.rowID;

						cellParent.numRows = 0;
						cellParent.numCols = item.parent().children().length();	
					}
					
					if( item.hasOwnProperty( "@name" ) ) cell.name = item.@name;
					else cell.name = cell.type + cell.ID;

					this.cellPath[ this.cellPath.length - 1 ].container.addChild( cell );
					
					if( item.hasComplexContent() )
					{
						//trace( "*** Parent: " + item.name() );
						this.cellPath.push( cell );
						parseXMLtoCell( item );
					}
					else
					{
						//trace( "*** Child: " + item.name() );
						if( item.toString() != "" ) cell.setContent( cell, item.toString() );
						this.cells.push( cell );
						if( item.childIndex() == item.parent().children().length()-1 ) this.cellPath.pop();
					}
				}
			}
		}
		
		private function cellLocator( cell:* ):TableCell
		{
			var validCell:TableCell;
			
			if( !( cell is TableCell ) && !( cell is String ) && !( cell is Number ) && !( cell is Array ) )
			{
				trace( "*** ERROR:", cell, "is not valid cell definition type." );
				return validCell;
			}
			
			if( cell is TableCell ) validCell = cell;
			
			if( cell is String ) cell = cell.split( "," );
			if( cell is String || cell is Number ) cell = [cell];
			
			if( cell is Array )
			{
				var celltarget:TableCell;
				
				if( cell.length == 1 )
				{
					var nameCount:uint = 0;
					
					for( var i:uint=0; i<this.cells.length; i++ )
					{
						celltarget = this.cells[ i ] as TableCell;
						
						if( cell[0] == celltarget.name || cell[0] == celltarget.ID )
						{
							if( celltarget.cellParent.type != "title-row" ) nameCount++;
							if( !validCell && celltarget.cellParent.type != "title-row" ) validCell = celltarget;
						}
					}
					
					if( !nameCount ) trace( "*** ERROR: Cell name is not found." );
					else if( nameCount > 1 ) trace( "*** WARNING:", nameCount, "cell names were found. The first cell was used." );
				}
				else
				{
					celltarget = this;
					
					for( var j:uint=0; j<cell.length; j++ )	
					{
						var cellFound:Boolean = false;
						
						for( var k:uint=0; k<celltarget.container.numChildren; k++ )
						{
							var curCell:TableCell = celltarget.container.getChildAt( k ) as TableCell;

							if( curCell.name == cell[ j ] || curCell.ID == Number( cell[ j ] )  )
							{
								cellFound = true;
								celltarget = curCell;
								break;
							}
						}
						
						if( !cellFound )
						{
							trace( "*** ERROR: Cell path is not found at", cell[ j ] + "." );
							return validCell;
						}
					}
					
					validCell = celltarget;
				}	
			}
			
			return validCell;
		}
		
		private function setRowsColsVars():void
		{
			for( var i:uint=0; i<this.container.numChildren; i++ )
			{
				var cell:TableCell = this.container.getChildAt( i ) as TableCell;
				
				if( cell.type.indexOf( "row" ) >= 0 )
				{
					if( cell.numCols > this.numCols ) this.numCols = cell.numCols;
					this.numRows = this.container.numChildren;
				}
				else
				{
					if( cell.numRows > this.numRows ) this.numRows = cell.numRows;
					this.numCols = this.container.numChildren;
				}
			}
		}
	}
}