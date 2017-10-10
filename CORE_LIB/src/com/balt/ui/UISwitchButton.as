package com.balt.ui {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	public class UISwitchButton extends UIButton
	{
		private var _switchGroup:Array;
		
		public function UISwitchButton( p_clip: MovieClip )
		{
			super( p_clip );
		}
		
		public function setup( p_switchGroup: Array, p_selected: Boolean = false ): void
		{
			_switchGroup = p_switchGroup;
			_selected = p_selected;
		}
		
		override protected function down( p_event:MouseEvent ): void
		{
			if( ! _selected )
			{
				selected = true;
				this.dispatchEvent( new Event( EVENT_CHANGED ) );
				gotoLabel( SELECTED );
				
				updateTheOthers();
			}
		}
		
		public function deselect():void
		{
			gotoLabel( OFF );
			_selected = false;
			_disabled = false;
		}
		
		private function updateTheOthers(): void
		{
			var len: int = _switchGroup.length;
			var item: UISwitchButton;
			
			for( var i: int = 0; i < len; i++ )
			{
				item = _switchGroup[ i ];
				if( item != this )
				{
					item.deselect();
				}
			}
		}
	}
}