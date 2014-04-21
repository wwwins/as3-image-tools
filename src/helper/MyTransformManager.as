package helper
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformManager;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author flashisobar
	 */
	public class MyTransformManager 
	{
		private var manager:TransformManager;
		private var _pic:Sprite;
		private var _box:Sprite;
		private var _enabled:Boolean;
		
		/**
		 * 
		 * @param	__container container of _pic
		 * @param	__box box of transform manager
		 * @param __drawingMask MyDrawingMask
		 */
		public function MyTransformManager(__container:Sprite, __box:Sprite) 
		{
			_pic = __container;
			_box = __box;
			initTransformManager();
		}
		
		public function destroy():void {
			_pic = null;
			_box = null;

			manager.removeEventListener(TransformEvent.SCALE, onScale);
			manager.removeEventListener(TransformEvent.ROTATE, onScale);
			manager.removeEventListener(TransformEvent.MOVE, onScale);
			manager.removeItem(_box);
			manager.destroy();
		}

		private function initTransformManager():void 
		{
			trace("initTransformManager");
			manager = new TransformManager({targetObjects:[], lineColor:0x0066FF, handleSize:10, constrainScale:false, lockRotation:false, allowDelete:false, arrowKeysMove:false, autoDeselect:true, allowMultiSelect:false, 
forceSelectionToFront: false, hideCenterHandle: true } );
			manager.addEventListener(TransformEvent.SCALE, onScale);
			manager.addEventListener(TransformEvent.ROTATE, onScale);
			manager.addEventListener(TransformEvent.MOVE, onScale);
			manager.addItem(_box);
		}
		
		// copy _box matrix to _pic
		private function onScale(e:TransformEvent):void 
		{
			var m:Matrix = Sprite(e.items[0].targetObject).transform.matrix;
			_pic.transform.matrix = m;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			manager.enabled = value;
		}
	}

}