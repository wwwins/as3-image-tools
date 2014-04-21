package helper
{
	import com.flashisobar.net.UploadManager;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import uk.soulwire.utils.display.Alignment;
	import uk.soulwire.utils.display.DisplayUtils;
	/**
	 * ...
	 * @author flashisobar
	 */
	public class MyUploadManager 
	{
		private var uploadmanager:UploadManager = UploadManager.Instance;
		
		private var _pic:Sprite;
		private var _box:Sprite;
		private var _mask_w:Number;
		private var _mask_h:Number;

		/**
		 * 
		 * @param	__container container of _pic
		 * @param	__box box of transform manager
		 * @param __box_w 顯示區域的寬
		 * @param __box_h 顯示區域的高
		 */
		public function MyUploadManager(__container:Sprite, __box:Sprite, __mask_w:Number, __mask_h:Number) 
		{
			_pic = __container;
			_box = __box;
			_mask_w = __mask_w;
			_mask_h = __mask_h;
			
			initUploadManager();
		}

		public function destroy():void {
			_pic = null;
			_box = null;
		}
		
		public function browse():void {
			uploadmanager.Browse();
		}
		
		private function initUploadManager():void {
			// init uploadmanager
			uploadmanager.ApplyFileFilters([new FileFilter("Images (*.jpg, *.jpeg, *.JPG, *.JPEG, *.png, *.PNG)", "*.jpg;*.jpeg;*.JPG;*.JPEG;*.png;*.PNG")]);
			uploadmanager.onFileLoaded.add(myPhotoLoaded);
			uploadmanager.fileSelected.add(mySelectedFilename);
		}
		
		/**
		 * 選取的檔名
		 * @param	__fn
		 */
		private function mySelectedFilename(__fn:String):void 
		{
			// trace("selected filename:"+__fn);
		}
		
		/**
		 * 載入圖檔
		 * @param	__loader
		 */
		private function myPhotoLoaded(__loader:Loader):void
		{
			trace("myPhotoLoaded");
			removeAll();
			_pic.addChild(__loader);
			DisplayUtils.fitIntoRect( __loader, new Rectangle( 0, 0, _mask_w, _mask_h ), true, Alignment.TOP_LEFT );
			Bitmap(__loader.content).smoothing = true;
			//原圖
			var originPhoto:Bitmap = Bitmap(__loader.content);
			// see imgLoaded()
			redrawBox(__loader.width, __loader.height);
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