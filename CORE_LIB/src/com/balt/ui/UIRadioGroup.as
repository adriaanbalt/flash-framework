package com.balt.ui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class UIRadioGroup extends EventDispatcher
	{
		protected var _radioArray:Array;
		protected var _isMultiSelection:Boolean;
		protected var _selectedRadio:UIButton;
		
		public static var EVENT_SELECTED:String = "uiraidogroup_selected";
		
		public function UIRadioGroup( p_radioArray:Array, p_isMultiSelection:Boolean = false )
		{
			_isMultiSelection = p_isMultiSelection;
			_radioArray = p_radioArray;
			for ( var i:Number=0; i<_radioArray.length; i++ ) {
				var btn:UIButton = UIButton(_radioArray[i]);
				btn.addEventListener( MouseEvent.MOUSE_DOWN, onRadioButtonSelected );
			}
		}
		
		private function onRadioButtonSelected ( p_event:MouseEvent ):void {
			if ( _selectedRadio != null ) {
				_selectedRadio.enabled = true;
				_selectedRadio.selected = false;
			}  
			_selectedRadio = UIButton(p_event.target)
			_selectedRadio.selected = true;
			_selectedRadio.disabled = true;
			this.dispatchEvent( new Event ( EVENT_SELECTED ) );
		}
		
		public function get selectedRadio():UIButton {
			return _selectedRadio;
		}
		
	}
}