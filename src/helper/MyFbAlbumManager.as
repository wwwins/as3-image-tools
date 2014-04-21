package helper
{
	import com.flashisobar.utility.Util;
	import f.events.LoadEvent;
	import f.net.Load;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import uk.soulwire.utils.display.Alignment;
	import uk.soulwire.utils.display.DisplayUtils;
	/**
	 * ...
	 * @author flashisobar
	 */
	public class MyFbAlbumManager 
	{
		private var tm:Timer;
		private var _imageLoader:Loader;
		private var _pic:Sprite;
		private var _box:Sprite;
		private var _mask_w:Number;
		private var _mask_h:Number;
		
		/**
		 * 
		 * @param	__container container of _pic
		 * @param	__box box of transform manager
		 * @param __drawingMask MyDrawingMask
		 * @param __box_w 顯示區域的寬
		 * @param __box_h 顯示區域的高
		 */
		public function MyFbAlbumManager(__container:Sprite, __box:Sprite, __mask_w:Number, __mask_h:Number)  
		{
			_pic = __container;
			_box = __box;
			_mask_w = __mask_w;
			_mask_h = __mask_h;
			
			initExternalInterface();
		}
		
		public function destroy():void {
			_pic = null;
			_box = null;
		}

		private function initExternalInterface():void 
		{
			tm = new Timer(100);
			tm.addEventListener(TimerEvent.TIMER, timerHandler);

			if (ExternalInterface.available) {
				try {
					ExternalInterface.addCallback("selectPhoto", fromJs_selectPhoto);
				}
				catch(e:Error) {
					tm.start();
				}
			}

		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			if (ExternalInterface.available) {
				try {
					ExternalInterface.addCallback("selectPhoto", fromJs_selectPhoto);
					tm.stop();
					tm.removeEventListener(TimerEvent.TIMER, timerHandler);					
				}
				catch(e:Error) {
				}
			}
		}

		/*
		 * js: selectPhoto
		 * var obj = swfobject.getObjectById("flashcontent");
		 * if (obj) obj.selectPhoto(photoUrl);
		 */
		private function fromJs_selectPhoto(__photoUrl:String):void
		{
			trace("js call selectPhoto:", __photoUrl);
			// 取得照片
			if (!Util.empty(__photoUrl)) {
				removeAll();
				Load.binary(__photoUrl, loadImage, null);
			}
		}
		private function loadImage( event:LoadEvent ):void
		{
			if( event.type == LoadEvent.SUCCESS ){
				trace("loadBinaryImage");
				removeAll();
				_imageLoader = new Loader();
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
				_imageLoader.loadBytes(event.data);
				_pic.addChild(_imageLoader);
			}
		}

		private function imgLoaded(e:Event):void 
		{
			trace("loader dimensions:",_imageLoader.width, _imageLoader.height);
			trace("original img dimensions:", _imageLoader.contentLoaderInfo.width, _imageLoader.contentLoaderInfo.height);
			DisplayUtils.fitIntoRect( _imageLoader, new Rectangle( 0, 0, _mask_w, _mask_h ), true, Alignment.TOP_LEFT);
			Bitmap(_imageLoader.content).smoothing = true;
			//原圖
			var originPhoto:Bitmap = Bitmap(_imageLoader.content);
			redrawBox(_imageLoader.width, _imageLoader.height);
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

		}

		private function redrawBox(__w:Number, __h:Number):void {
			trace("redrawBox:", __w, __h);
			_box.graphics.clear();
			_box.graphics.beginFill(0xFFFFFF,0.0);
			_box.graphics.drawRect(0, 0, __w, __h);
			_box.graphics.endFill();
		}

		private function removeAll():void {
			resetImage();
			while (_pic.numChildren) {
				_pic.removeChildAt(0);
			}
		}
		
		/*
		 * reset _pic/_box transform matrix
		 * reset _pic/_box x,y position
		 */
		private function resetImage():void 
		{
			_pic.transform.matrix = new Matrix(1, 0, 0, 1, _pic.x, _pic.y);
			_box.transform.matrix = new Matrix(1, 0, 0, 1, _box.x, _box.y);
			_pic.x = _pic.y = _box.x = _box.y = 0;
		}
	}

}