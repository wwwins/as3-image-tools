package btn 
{
	import flash.display.MovieClip;
	
	public class DisableMouse extends MovieClip 
	{
		
		public function DisableMouse() 
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
	}

}