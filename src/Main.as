package {
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	//CLICK ON 2 BLACK TILES TO PATHFIND BETWEEN THEM!
	public class Main extends Sprite {
		//Maze should always be an odd-number of tiles! (eg. 9x9, 33x15, etc.)
		public const MAZE_WIDTH:int=31;
		public const MAZE_HEIGHT:int=23;
		public const MAZE_SCALE:Number=20;

		//Directional constants
		public const ILLEGAL:int=0;
		public const OPEN:int=1;
		public const RIGHT:uint=2;
		public const LEFT:uint=3;
		public const DOWN:uint=4;
		public const UP:uint=5;

		public var closed:BitmapData=new BitmapData(MAZE_WIDTH,MAZE_HEIGHT,false,0);
		public var data:BitmapData=new BitmapData(MAZE_WIDTH,MAZE_HEIGHT,false,0xFFFFFF);
		public var bitmap:Bitmap=new Bitmap(data);

		public var start:Point;
		public var end:Point;
		public var pathShape:Shape = new Shape();

		public function Main() {
			x=10;
			y=10;
			bitmap.scaleX=bitmap.scaleY=MAZE_SCALE;
			addChild(bitmap);

			pathShape.scaleX=pathShape.scaleY=MAZE_SCALE;
			pathShape.x=pathShape.y=MAZE_SCALE/2;
			addChild(pathShape);

			generateMaze();
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function onClick(e:MouseEvent):void {
			start=end;
			end = new Point(int(mouseX / MAZE_SCALE), int(mouseY / MAZE_SCALE));

			if (start != null) {
				pathShape.graphics.clear();
				pathShape.graphics.beginFill(0xFF0000);
				pathShape.graphics.drawCircle(start.x, start.y, 0.25);
				pathShape.graphics.drawCircle(end.x, end.y, 0.25);
				pathShape.graphics.endFill();
				pathShape.graphics.lineStyle(0, 0xFF0000);

				var path:Array=pathfind(start,end);
				if (path != null && path.length > 1) {
					pathShape.graphics.moveTo(path[0].x, path[0].y);
					for (var i:int = 1; i < path.length; i++) {
						pathShape.graphics.lineTo(path[i].x, path[i].y);
					}
				}
			}
		}

		public function pathfind(start:Point, end:Point):Array {
			if (! getTile(start.x,start.y)&&! getTile(end.x,end.y)) {
				closed.fillRect(closed.rect, 0xFF000000 | OPEN);
				setClosed(start.x, start.y, ILLEGAL);

				var x:int;
				var y:int;
				var xQueue:Array=[];
				var yQueue:Array=[];
				xQueue.push(start.x);
				yQueue.push(start.y);

				while (xQueue.length > 0) {
					x=xQueue.shift();
					y=yQueue.shift();

					if (x == end.x && y == end.y) {
						var path:Array=[];
						var tile:int=getClosed(x,y);
						while (tile != ILLEGAL) {
							path.push(new Point(x, y));
							switch (tile) {
								case RIGHT :
									x++;
									break;
								case LEFT :
									x--;
									break;
								case DOWN :
									y++;
									break;
								case UP :
									y--;
									break;
							}
							tile=getClosed(x,y);
						}
						path.push(new Point(x, y));
						return path.reverse();
					}
					else {
						if (getClosed(x + 1, y) == OPEN && !getTile(x + 1, y)) {
							setClosed(x + 1, y, LEFT);
							xQueue.push(x + 1);
							yQueue.push(y);
						}
						if (getClosed(x - 1, y) == OPEN && !getTile(x - 1, y)) {
							setClosed(x - 1, y, RIGHT);
							xQueue.push(x - 1);
							yQueue.push(y);
						}
						if (getClosed(x, y + 1) == OPEN && !getTile(x, y + 1)) {
							setClosed(x, y + 1, UP);
							xQueue.push(x);
							yQueue.push(y + 1);
						}
						if (getClosed(x, y - 1) == OPEN && !getTile(x, y - 1)) {
							setClosed(x, y - 1, DOWN);
							xQueue.push(x);
							yQueue.push(y - 1);
						}
					}
				}
			}

			return null;
		}

		public function generateMaze():void {
			var xStack:Array=[];
			var yStack:Array=[];
			var sides:Array=[];

			data.fillRect(data.rect, 0xFFFFFFFF);

			//Pick random start point
			var x:int=1+int(Math.random()*(MAZE_WIDTH/2))*2;
			var y:int=1+int(Math.random()*(MAZE_HEIGHT/2))*2;
			xStack.push(x);
			yStack.push(y);

			//Maze generation loop
			while (xStack.length > 0) {
				x=xStack[xStack.length-1];
				y=yStack[yStack.length-1];
				sides.length=0;

				if (getTile(x + 2, y)) {
					sides.push(RIGHT);
				}
				if (getTile(x - 2, y)) {
					sides.push(LEFT);
				}
				if (getTile(x,y+2)) {
					sides.push(DOWN);
				}
				if (getTile(x,y-2)) {
					sides.push(UP);
				}

				if (sides.length>0) {
					var side:int=sides[int(Math.random()*sides.length)];
					switch (side) {
						case RIGHT :
							setTile(x + 1, y, false);
							setTile(x + 2, y, false);
							xStack.push(x + 2);
							yStack.push(y);
							break;
						case LEFT :
							setTile(x - 1, y, false);
							setTile(x - 2, y, false);
							xStack.push(x - 2);
							yStack.push(y);
							break;
						case DOWN :
							setTile(x, y + 1, false);
							setTile(x, y + 2, false);
							xStack.push(x);
							yStack.push(y + 2);
							break;
						case UP :
							setTile(x, y - 1, false);
							setTile(x, y - 2, false);
							xStack.push(x);
							yStack.push(y - 2);
							break;
					}
				}
				else {
					xStack.pop();
					yStack.pop();
				}
			}
		}

		public function getTile(x:int, y:int):Boolean {
			if (x < 0 || y < 0 || x >= MAZE_WIDTH || y >= MAZE_HEIGHT) {
				return false;
			}
			return data.getPixel(x, y) > 0x000000;
		}

		public function setTile(x:int, y:int, solid:Boolean):void {
			data.setPixel(x, y, solid ? 0xFFFFFF : 0x000000);
		}

		public function getClosed(x:int, y:int):int {
			if (x < 0 || y < 0 || x >= MAZE_WIDTH || y >= MAZE_HEIGHT) {
				return ILLEGAL;
			}
			return closed.getPixel(x, y);
		}

		public function setClosed(x:int, y:int, value:int):void {
			closed.setPixel(x, y, value);
		}
	}
}