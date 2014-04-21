package 
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import com.flashisobar.utility.ScreenCapture;

	DEF::ENABLE_FB_ALBUM {
	import helper.MyFbAlbumManager;
	}
	DEF::ENABLE_TRANSF {
	import helper.MyTransformManager;
	}
	DEF::ENABLE_LOCAL_FILE {
	import helper.MyUploadManager;
	}
	
	/**
	 * Document Class: Main
	 * @author flashisobar
	 */
	public class Main extends Sprite 
	{
		// layout: static const
		static private const BOX_WIDTH:Number = 230;
		static private const BOX_HEIGHT:Number = 223;

		// layout
		private var _container:Sprite;
		private var mask_mc:Shape;
		// 使用者圖片放置的容器
		private var _pic:Sprite;
		// 最上層給使用者拖拉的區塊
		private var _box:Sprite;

		DEF::ENABLE_FB_ALBUM {
		// for external interface
		private var _myFbAlbumManager:MyFbAlbumManager;
		}
		
		// for transform manager
		DEF::ENABLE_TRANSF {
			private var _myTransformManager:MyTransformManager;
		}
		
		// for local file upload manager
		DEF::ENABLE_LOCAL_FILE {
			private var _myUploaderManager:MyUploadManager;
		}

		private var _photo_selected:Boolean;

		public var mainPage:MovieClip;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			// layout
			initLayout();
			
			DEF::ENABLE_FB_ALBUM {
			// set ExternalInterface callback function
			_myFbAlbumManager = new MyFbAlbumManager(_pic, _box, BOX_WIDTH, BOX_HEIGHT);
			}
			DEF::ENABLE_TRANSF {
			// set transform manager
			_myTransformManager = new MyTransformManager(_pic, _box);
			}
			DEF::ENABLE_LOCAL_FILE {
			// set local file upload manager
			_myUploaderManager = new MyUploadManager(_pic, _box, BOX_WIDTH, BOX_HEIGHT);
			}
			initDefaultEventHandler();
			
			initEventHandler();

		}
		
		private function initDefaultEventHandler():void 
		{
			DEF::ENABLE_LOCAL_FILE {
				this.addEventListener("BaseBtnLocalFile", function(e:Event):void {
					_photo_selected = true;
					_myUploaderManager.browse();
				});
			}

			DEF::ENABLE_FB_ALBUM {
				this.addEventListener("BaseBtnFbAlbums", function(e:Event):void {
					_photo_selected = true;
					if (ExternalInterface.available) ExternalInterface.call("showAlbum");
				});
			}
			
			DEF::ENABLE_DEFAULT_IMG {
				this.addEventListener("BaseBtnDefaultImage", function(e:Event):void {
					_photo_selected = true;
					// same as fb album flow -> call js: selectPhoto
					if (ExternalInterface.available) ExternalInterface.call("getDefaultImage");
				});
			}
		}
		
		private function initEventHandler():void 
		{
			this.addEventListener("BaseBtnSubmit", handleClicked);
		}
		
		private function handleClicked(e:Event):void 
		{
			trace("handleClicked:" + e.type);
			switch (e.type) 
			{
				case "BaseBtnSubmit":
					if (_photo_selected) {
						DEF::DEBUG {
							addChild(new Bitmap(ScreenCapture.drawFromObject(mainPage.mc_photo)));
						}
						sendData();
					}
					else {
						if (ExternalInterface.available) ExternalInterface.call("alert", "plz upload images");
					}
				break;
				default:
			}
		}
		
		private function initLayout():void 
		{
			// in fla:
			//mainPage = new mainPage();
			//addChild(mainPage);

			// TransformManager START
			// target x/y position
			_container = new Sprite();
			_container.x = 0;
			_container.y = 0;
			mainPage.mc_photo.mc_tgt.addChild(_container);
			
			// mask x/y position
			mask_mc = new Shape();
			mask_mc.graphics.clear();
			mask_mc.graphics.beginFill(0xFF0000,1);
			mask_mc.graphics.drawRect(0, 0, BOX_WIDTH, BOX_HEIGHT);
			mask_mc.graphics.endFill();
			_container.addChild(mask_mc);
			
			_pic = new Sprite();
			_pic.name = "pic";
			_pic.mask = mask_mc;
			_container.addChild(_pic);
			
			_box = new Sprite();
			_container.addChild(_box);
			// TransformManager END

		}

		/**
		 * send data to js.
		 */
		private function sendData():void 
		{
			var str1:String = ScreenCapture.getBase64FromJPG(mainPage.mc_photo);
			var str2:String = ScreenCapture.getBase64FromJPG(mainPage.mc_photo);
			if (ExternalInterface.available) ExternalInterface.call("sendData", str1, str2);
		}
		
	}
	
}