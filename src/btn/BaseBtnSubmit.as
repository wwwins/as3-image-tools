package btn 
{
	import flash.events.Event;
	/**
	 * submit
	 * @author jacky
	 */
	public class BaseBtnSubmit extends BaseBtn 
	{
		
		public function BaseBtnSubmit() 
		{
			onClick = function():void {
				trace('new Event("BaseBtnSubmit")');
				dispatchEvent(new Event("BaseBtnSubmit", true));
			}
			onRollOver = function():void {
				trace("over");
				gotoAndPlay("lv1");
			}
			onRollOut = function():void {
				trace("out");
				gotoAndPlay("lv2");
			}
		}
		
	}

}