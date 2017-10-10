package com.balt.coreimplementation.display
{
	import com.gs.TweenLite;
	import com.gs.easing.Linear;
	import com.balt.core.log.Log;
	import com.balt.coreimplementation.services.ServicesConstants;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	public class PreView extends Sprite
	{
		
		public static const COMPLETE : String = "onComplete";

		private var loadedBG:Shape;
		private var loadedPercent:Shape;

		private var loadingBarWidth:Number = 300;
		private var loadingBarHeight:Number = 5;
		
		private var loadedBGColor:uint = 0x333333;
		private var loadedPercentColor:uint = 0xCCCCCC;
		
		private var mc:DisplayObjectContainer;
		private var assetProgress:int;
		private var fontProgress:int;		
		private var totalPercent:int;
		
		public function PreView()
		{
			visible = false;
			alpha = 0;
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}

		private function addedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage)
			show();//maybe here
		}
		
		private function addLoadingBar():void
		{
			loadedBG = new Shape();
			loadedPercent = new Shape();
			
			loadedBG.graphics.beginFill(loadedBGColor);
			loadedBG.graphics.drawRect(0,0, loadingBarWidth, loadingBarHeight);
			loadedBG.graphics.endFill();

			loadedPercent.graphics.beginFill(loadedPercentColor);
			loadedPercent.graphics.drawRect(0,0, 2, loadingBarHeight);
			loadedPercent.graphics.endFill();
			
			addChild(loadedBG);			
			addChild(loadedPercent);
			
			loadedBG.x = loadedPercent.x = (stage.stageWidth - loadingBarWidth)*0.5;
			loadedBG.y = loadedPercent.y = (stage.stageHeight - loadingBarHeight)*0.5;
		}
		
		private function update(percent:Number):void
		{
			percent *= 0.01
			loadedPercent.width = loadingBarWidth * percent;
		}
		
		private function show():void
		{
			Log.debug( "PreView.show" );
			TweenLite.to( this, .4, { autoAlpha:1, ease:Linear.easeIn } );
			var timer:Timer = new Timer( 5, 100 );
			timer.addEventListener( TimerEvent.TIMER, handleTimer );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, handleTimerComplete );
			timer.start();
			addLoadingBar();
		}
		
		private function handleTimer(event:TimerEvent):void
		{
			var t:Timer = event.currentTarget as Timer;
			
			update(Math.round((t.currentCount/t.repeatCount)*100));
		}
		
		private function handleTimerComplete(event:TimerEvent):void
		{
			dispatchEvent( new Event( COMPLETE ));
			hide();	
		}
		
		private function onProgress( $e:Event ):void
		{
			if( ServicesConstants.getServices().getDepot().assetProgress >= 0 )
			{
				assetProgress = ServicesConstants.getServices().getDepot().assetProgress;
				Log.debug( "    > Loading.assets @", assetProgress + "%" );
			}
			if( ServicesConstants.getServices().getDepot().fontProgress >= 0 )
			{
				fontProgress = ServicesConstants.getServices().getDepot().fontProgress;
				Log.debug( "    > Loading.fonts @", fontProgress + "%" );
			}
			
			totalPercent = assetProgress + fontProgress;
			if( assetProgress && fontProgress ) totalPercent = totalPercent*0.5;
			Log.debug( "    > Loading.TOTAL @", totalPercent + "%" );
			
			//update(totalPercent)
			
			if ( totalPercent >= 100  ) complete();
			else
			{
				// view actions	
			}
		}
		
		private function complete( evt:Event=null ):void
		{
			//dispatchEvent( new Event( COMPLETE ));
			//hide();	
		}
		
		private function hide():void
		{
			Log.debug( "PreView.hide" );
			//this.removeEventListener( Event.ENTER_FRAME, onProgress );
			//ServicesConstants.getServices().getDepot().removeEventListener( Depot.LOAD_COMPLETE, complete );		
			TweenLite.to( this, .4, { autoAlpha:0, onComplete:destroy, ease:Linear.easeOut } );
		}					

		private function destroy():void
		{
			//this.mc.removeChild( this );			
		}
		
	}
}
