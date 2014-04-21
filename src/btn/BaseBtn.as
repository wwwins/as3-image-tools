package btn 
{
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	
	import flash.display.MovieClip;
	import flash.events.*

	/**
	 * button effect
	 */
	public class BaseBtn extends MovieClip
	{
		public var onClick:Function = null;
		public var onRollOver:Function = null;
		public var onRollOut:Function = null;
		public var onDown:Function = null;

		public function BaseBtn()
		{
			stop();
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			
			buttonMode = true;
			// 避免 children 的元件干擾
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			addEventListener(MouseEvent.CLICK, clickHandler)
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler)
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function destroy(e:Event = null):void {
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler)
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}

		// 按鈕消失
		public function enableBtn(__arg:Boolean):void 
		{
			//if (__arg) TweenMax.to(this, 0.25, { autoAlpha:1 } );
			//else TweenMax.to(this, 0.25, { autoAlpha:0 } );
		}

		// 按鈕反白
		public function enableMouseChildren(__arg:Boolean):void 
		{
			mouseEnabled = __arg;
			//if (__arg) {
				//TweenMax.to(this, 0.25, { colorMatrixFilter: { brightness:1.0, remove:true }, alpha:1.0 } );
			//}
			//else {
				//TweenMax.to(this, 0.25, { colorMatrixFilter: { brightness:2.0 }, alpha:0.1 } );
			//}
		}

		private function overHandler(e:MouseEvent)
		{
			if (onRollOver != null) {
				onRollOver(e);
			}
			TweenLite.to(this, 0.25, { colorMatrixFilter: { brightness:1.5 }, alpha:1.0 } );
		}
		
		private function outHandler(e:MouseEvent)
		{
			if (onRollOut != null) {
				onRollOut(e);
			}
			TweenLite.to(this, 0.25, { colorMatrixFilter: { brightness:1.0, remove:true }, alpha:1.0 } );
		}
		
		private function downHandler(e:MouseEvent)
		{
			if (onDown != null) {
				onDown(e);
			}	
		}
		private function clickHandler(e:Event):void 
		{
			if (onClick != null) {
				onClick(e);
			}
		}
	}
}