package
{
	/**
	 * @author zhengxuesong
	 * @E-mail: hellogavin1988@gmail.com
	 * @version 1.0.0
	 * 创建时间：2013-4-25 上午10:55:33
	 * */
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	public class mazeOne extends Sprite
	{
		public static const MAZE_WIDTH:int = 61;
		public static const MAZE_HEIGHT:int = 53;
		public static const MAZE_SCALE:int = 10;

		public static const ILLEGAL:int = 0;
		public static const OPEN:int = 1;
		public static const RIGHT:int = 2;
		public static const LEFT:int = 3;
		public static const DOWN:int = 4;
		public static const UP:int = 5;

		public var closed:BitmapData = new BitmapData(MAZE_WIDTH, MAZE_HEIGHT, false, 0);
		public var data:BitmapData = new BitmapData(MAZE_WIDTH, MAZE_HEIGHT, false, 0xFFFFFF);
		public var bitmap:Bitmap ;

		public var start:Point;
		public var end:Point;
		public var pathShape:Shape = new Shape();
		private var txt:TextField=new TextField();

		public function mazeOne()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var loader:Loader=new Loader();
//			loader.loaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			MonsterDebugger.initialize(this);
			bitmap=new Bitmap();
			bitmap.scaleX = bitmap.scaleY = MAZE_SCALE;
			bitmap.x = bitmap.y = 0;
			x = bitmap.width - stage.stageWidth * 0.5;
			y = (bitmap.height - stage.stageHeight) * 0.5;
			addChild(bitmap);

			pathShape.scaleX = pathShape.scaleY = MAZE_SCALE;
			pathShape.x = pathShape.y = MAZE_SCALE * 0.5;
			addChild(pathShape);
//			setInterval(test,100,1,2);
			
			var format:TextFormat=new TextFormat();
			format.size=20;
			txt.defaultTextFormat=format;
			txt.text="绘制中……";
			
			this.addChild(txt);
			setTimeout(generateMaze,2000);
//			setInterval(generateMaze,2000);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function loadComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			start = end;
			end = new Point(int(mouseX / MAZE_SCALE), int(mouseY / MAZE_SCALE));
			if (start != null)
			{
				pathShape.graphics.clear();
				pathShape.graphics.beginFill(0xFF0000);
				pathShape.graphics.drawCircle(start.x, start.y, 0.25);
				pathShape.graphics.drawCircle(end.x, end.y, 0.25);
				pathShape.graphics.endFill();
				pathShape.graphics.lineStyle(0, 0xFF0000);

				var path:Array = pathFind(start, end);
				if (path != null && path.length > 1)
				{
					pathShape.graphics.moveTo(path[0].x, path[0].y);
					for (var i:int = 1; i < path.length; i++)
						pathShape.graphics.lineTo(path[i].x, path[i].y);
				}
			}
		}

		private function pathFind(start:Point, end:Point):Array
		{
			if (!getTile(start.x, start.y) && !getTile(end.x, end.y))
			{
				closed.fillRect(closed.rect, 0xFF000000 | OPEN);
				setClosed(start.x, start.y, ILLEGAL);

				var x:int;
				var y:int;
				var xQueue:Array = [];
				var yQueue:Array = [];
				xQueue.push(start.x);
				yQueue.push(start.y);
				/*while(xQueue.length>0)
				{
					x=
				}*/
			}
			return null;
		}

		private function setClosed(x:Number, y:Number, value:int):void
		{
			closed.setPixel(x, y, value);
		}

		private var xStack:Array = [];
		private var yStack:Array = [];

		
		
		private function generateMaze():void
		{

			var sides:Array = [];
			data.fillRect(data.rect, 0xFF000000);

			var x:int = 1 + int(Math.random() * (MAZE_WIDTH * 0.5)) * 2;
			var y:int = 1 + int(Math.random() * (MAZE_HEIGHT * 0.5)) * 2;
			xStack.push(x);
			yStack.push(y);

			while (xStack.length > 0)
			{
				trace("random :  " + Math.random());
				x = xStack[xStack.length - 1];
				y = yStack[yStack.length - 1];
				sides.length = 0;
				
				/**  judge can through side.	Use 2 steps is necessary.	 Because just one step may be can't move next. */
				if (getTile(x + 2, y))
				{
					sides.push(RIGHT);
				}
				if (getTile(x - 2, y))
				{
					sides.push(LEFT);
				}
				if (getTile(x, y + 2))
				{
					sides.push(DOWN);
				}
				if (getTile(x, y - 2))
				{
					sides.push(UP);
				}
				/**  random a side,then move two steps.		 */
				if (sides.length > 0)
				{
					var side:int = sides[int(Math.random() * sides.length)];
					switch (side)
					{
						case RIGHT:
							setTile(x + 1, y, false);
							setTile(x + 2, y, false);
							xStack.push(x + 2);
							yStack.push(y);
							break;
						case LEFT:
							setTile(x - 1, y, false);
							setTile(x - 2, y, false);
							xStack.push(x - 2);
							yStack.push(y);
							break;
						case DOWN:
							setTile(x, y + 1, false);
							setTile(x, y + 2, false);
							xStack.push(x);
							yStack.push(y + 2);
							break;
						case UP:
							setTile(x, y - 1, false);
							setTile(x, y - 2, false);
							xStack.push(x);
							yStack.push(y - 2);
							break;
					}
//					drawing(side,x,y);private
				}
				else
				{
					xStack.pop();
					yStack.pop();
				}
			}
			this.removeChild(txt);
		}

		private function setTile(x:int, y:int, solid:Boolean):void
		{
//			setTimeout(setIt,Math.random()*100,x,y,solid);
			setIt(x,y,solid);
			
		}
		
		/**
		 *  set bitmap a target a new color 
		 * @param x 
		 * @param y
		 * @param solid 
		 * 
		 */		
		private function setIt(x:int,y:int,solid:Boolean):void
		{
			data.setPixel(x, y, solid ? 0x000000 : 0xFFFFFF);
//			data.
		}

		private function getTile(x:int, y:int):Boolean
		{
			if (x < 0 || y < 0 || x >= MAZE_WIDTH || y >= MAZE_HEIGHT)
				return false;
			return data.getPixel(x, y) < 0xFFFFFF;
		}
	}
}
