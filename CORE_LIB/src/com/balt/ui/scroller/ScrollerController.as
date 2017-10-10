package com.balt.ui.scroller {

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.balt.ui.LoadUtil;	

	public class ScrollerController extends Sprite
	{
		// width
		// height
		private var elements:Array;  
		private var contentArea:Sprite; 
		private var contentMask:Shape;
		
		private var loadIndex:uint = 0;
		private var path:Array;
		
		public function ScrollerController(_path:Array,_maskRectangle:Rectangle,_contentRectangle:Rectangle)
		{
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy,false, 0, false);
			
			path = _path;
			
			contentArea = new Sprite();	
			contentMask = new Shape();
			
			Box.drawBox(contentArea,_contentRectangle.x,_contentRectangle.y,_contentRectangle.width,_contentRectangle.height,0x000000,1);
			Box.drawBox(contentMask,_maskRectangle.x,_maskRectangle.y,_maskRectangle.width,_maskRectangle.height,0x000000,0);
		
			contentArea.mask = contentMask; 
			
			elements = new Array(); // of type scroller ARRAY;
			
			addChild(contentArea);
			addChild(contentMask);
			
			//addChild(lArrow);
			//addChild(rArrow);

		}
		private function recursiveLoad():void
		{
			if (loadIndex < path.length) 
			{
				LoadUtil.loadExternal(path[loadIndex],loadedElement,errorLoading);	
				
			} else {
				path = null; 
				// FINISHED LOADING ASSETS SYNCHONOUSLY INTO THE ELEMENTS ARRAY - loadIndex is now the modulo	
			}
		}
		private function loadedElement(evt:Event):void 
		{
			loadIndex++;
			var scrollItem:ScrollerItem = new ScrollerItem((evt.currentTarget.content) as DisplayObject,loadIndex);	
			
			elements.push(scrollItem);
			
				scrollItem.x = loadIndex*scrollItem.width;
				scrollItem.y = 0;
				
						
			contentArea.addChild(scrollItem);
			recursiveLoad();
		}
		private function errorLoading(evt:Event):void
		{
			
		}
		private function destroy():void  
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
		
	}
}
