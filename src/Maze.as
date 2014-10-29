package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author zhengxuesong
	 * @E-mail: hellogavin1988@gmail.com
	 * @version 1.0.0
	 * 创建时间：2013-4-25 下午6:31:58
	 * */
	[SWF(frameRate = 1, backgroundColor = "#FFFFFF")]
	public class Maze extends Sprite
	{
		private const MAZE_WIDTH:int = 24;
		private const MAZE_HEIGHT:int = 19;
		private const WALL_SIZE:int = 16;
		private var _mazes:Array = [];
		private var my_moves:Array = [];
		private var _maze_draw:Sprite;
		private var starter:Sprite;
		private var currentPos:int;
		private var initPos:int;

		public function Maze()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;

			init();
			addEvent();
		}

		private function init():void
		{
			initMoves();
			initMaze();
			drawEnterAndOut();
			initStarter();
		}

		private function drawEnterAndOut():void
		{
			var path:Sprite = new Sprite();
			this.addChild(path);
			path.graphics.beginFill(0xFFFFFF);
			path.graphics.drawRect(0, 0.5 * WALL_SIZE, 0.5 * WALL_SIZE, 0.5 * WALL_SIZE);
			path.graphics.drawRect(MAZE_WIDTH * WALL_SIZE, MAZE_HEIGHT * WALL_SIZE - 0.5 * WALL_SIZE, 0.5 * WALL_SIZE, 0.5 * WALL_SIZE);
			path.graphics.endFill();
		}

		private function addEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardEvent);
			stage.addEventListener(Event.ENTER_FRAME, draw);
		}

		private var i:int = -1;
		private var startX:int = -0.25 * WALL_SIZE;
		private var startY:int = -0.25 * WALL_SIZE;

		protected function draw(event:Event):void
		{
			var cell_count:int = MAZE_WIDTH * MAZE_HEIGHT;
			i++;
			if (i < cell_count)
			{
				startX += WALL_SIZE;

				if (i % MAZE_WIDTH == 0)
				{
					startY += WALL_SIZE;
					startX = WALL_SIZE - 0.25 * WALL_SIZE;
				}
				if (_mazes[i][DirectionConst.SOUTH] == 1)
				{
					_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
					_maze_draw.graphics.lineTo(startX + 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
				}
				if (_mazes[i][DirectionConst.NORTH] == 1)
				{
					_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
					_maze_draw.graphics.lineTo(startX + 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
				}
				if (_mazes[i][DirectionConst.EAST] == 1)
				{
					_maze_draw.graphics.moveTo(startX + WALL_SIZE * 0.5, startY - 0.5 * WALL_SIZE);
					_maze_draw.graphics.lineTo(startX + WALL_SIZE * 0.5, startY + 0.5 * WALL_SIZE);
				}
				if (_mazes[i][DirectionConst.WEST] == 1)
				{
					_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
					_maze_draw.graphics.lineTo(startX - 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
				}
			}
			else
				stage.removeEventListener(Event.ENTER_FRAME, draw);
		}

		protected function keyboardEvent(event:KeyboardEvent):void
		{
			if (!moveStart(event.keyCode))
				return;
			switch (event.keyCode)
			{
				case Keyboard.UP:
					starter.y -= WALL_SIZE;
					break;
				case Keyboard.DOWN:
					starter.y += WALL_SIZE;
					break;
				case Keyboard.LEFT:
					starter.x -= WALL_SIZE;
					break;
				case Keyboard.RIGHT:
					starter.x += WALL_SIZE;
					break;
			}
			/*if (starter.x == MAZE_WIDTH * WALL_SIZE && starter.y == MAZE_HEIGHT * WALL_SIZE - 0.5 * WALL_SIZE)
				init();*/
		}

		private function moveStart(direction:int):Boolean
		{
			switch (direction)
			{
				case Keyboard.UP:
					if (currentPos < MAZE_WIDTH || _mazes[currentPos][DirectionConst.NORTH] == 1)
						return false;
					currentPos -= MAZE_WIDTH;
					break;
				case Keyboard.DOWN:
					if (currentPos >= MAZE_WIDTH * (MAZE_HEIGHT - 1) || _mazes[currentPos][DirectionConst.SOUTH] == 1)
						return false;
					currentPos += MAZE_WIDTH;
					break;
				case Keyboard.LEFT:
					if (currentPos % MAZE_WIDTH == 0 || _mazes[currentPos][DirectionConst.WEST] == 1)
						return false;
					currentPos -= 1;
					break;
				case Keyboard.RIGHT:
					if ((currentPos + 1) % MAZE_WIDTH == 0 || _mazes[currentPos][DirectionConst.EAST] == 1)
						return false;
					currentPos += 1;
					break;
			}
			return true;
		}

		private function initStarter():void
		{
			starter = new Sprite();
			this.addChild(starter);
			starter.graphics.beginFill(0xFF0000);
			starter.graphics.drawRect(WALL_SIZE * 0.5, WALL_SIZE * 0.5, 0.5 * WALL_SIZE, 0.5 * WALL_SIZE);
			starter.graphics.endFill();
		}

		private function initMoves():void
		{
			var cell_count:int = MAZE_WIDTH * MAZE_HEIGHT;
			var pos:int = Math.floor(Math.random() * cell_count);
			initPos = pos;
			var visited:int = 1;
			for (var i:int = 0; i < cell_count; i++)
			{
				_mazes[i] = new Array(0, 1, 1, 1, 1);
			}
			_mazes[pos][0] = 1;
			while (visited < cell_count)
			{
				var possible:Array = [];
				if ((Math.floor(pos / MAZE_WIDTH) == Math.floor((pos - 1) / MAZE_WIDTH)) && (_mazes[pos - 1][0] == 0))
				{
					possible.push(DirectionConst.WEST);
				}
				if ((Math.floor(pos / MAZE_WIDTH) == Math.floor((pos + 1) / MAZE_WIDTH)) && (_mazes[pos + 1][0] == 0))
				{
					possible.push(DirectionConst.EAST);
				}
				if ((Math.floor(pos + MAZE_WIDTH) < cell_count) && (_mazes[pos + MAZE_WIDTH][0] == 0))
				{
					possible.push(DirectionConst.SOUTH);
				}
				if ((Math.floor(pos - MAZE_WIDTH) > 0) && (_mazes[pos - MAZE_WIDTH][0] == 0))
				{
					possible.push(DirectionConst.NORTH);
				}
				if (possible.length > 0)
				{
					visited++;
					my_moves.push(pos);
					var way:int = possible[Math.floor(Math.random() * possible.length)];
					switch (way)
					{
						case DirectionConst.NORTH:
							_mazes[pos][DirectionConst.NORTH] = 0;
							pos -= MAZE_WIDTH;
							_mazes[pos][DirectionConst.SOUTH] = 0;
							break;
						case DirectionConst.SOUTH:
							_mazes[pos][DirectionConst.SOUTH] = 0;
							pos += MAZE_WIDTH;
							_mazes[pos][DirectionConst.NORTH] = 0;
							break;
						case DirectionConst.EAST:
							_mazes[pos][DirectionConst.EAST] = 0;
							pos++;
							_mazes[pos][DirectionConst.WEST] = 0;
							break;
						case DirectionConst.WEST:
							_mazes[pos][DirectionConst.WEST] = 0;
							pos--;
							_mazes[pos][DirectionConst.EAST] = 0;
							break;
					}
					_mazes[pos][0] = 1;
				}
				else
				{
					pos = my_moves.pop();
				}
			}
		}

		private function initMaze():void
		{
			_maze_draw = new Sprite();
			addChild(_maze_draw);
			_maze_draw.graphics.lineStyle(WALL_SIZE * 0.5, 0, 1, true);
		/*var startX:int = -0.25*WALL_SIZE;
		var startY:int = -0.25*WALL_SIZE;
		var cell_count:int = MAZE_WIDTH * MAZE_HEIGHT;
		for (var i:int = 0; i < cell_count; i++)
		{
			startX += WALL_SIZE;
			if (i % MAZE_WIDTH == 0)
			{
				startY += WALL_SIZE;
				startX = WALL_SIZE-0.25*WALL_SIZE;
			}
			if (_mazes[i][DirectionConst.SOUTH] == 1)
			{
				_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
				_maze_draw.graphics.lineTo(startX + 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
			}
			if (_mazes[i][DirectionConst.NORTH] == 1)
			{
				_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
				_maze_draw.graphics.lineTo(startX + 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
			}
			if (_mazes[i][DirectionConst.EAST] == 1)
			{
				_maze_draw.graphics.moveTo(startX + WALL_SIZE * 0.5, startY - 0.5 * WALL_SIZE);
				_maze_draw.graphics.lineTo(startX + WALL_SIZE * 0.5, startY + 0.5 * WALL_SIZE);
			}
			if (_mazes[i][DirectionConst.WEST] == 1)
			{
				_maze_draw.graphics.moveTo(startX - 0.5 * WALL_SIZE, startY - 0.5 * WALL_SIZE);
				_maze_draw.graphics.lineTo(startX - 0.5 * WALL_SIZE, startY + 0.5 * WALL_SIZE);
			}
		}*/
		}
	}
}
