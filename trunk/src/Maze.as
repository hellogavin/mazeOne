package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;

	/**
	 * @author zhengxuesong
	 * @E-mail: hellogavin1988@gmail.com
	 * @version 1.0.0
	 * 创建时间：2013-4-25 下午6:31:58
	 * */
	public class Maze extends Sprite
	{
		private const MAZE_WIDTH:int = 24;
		private const MAZE_HEIGHT:int = 19;
		private const WALL_SIZE:int = 20;
		private var _mazes:Array = [];
		private var my_moves:Array = [];
		private var _maze_draw:Sprite;

		public function Maze()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			_maze_draw = new Sprite();
			var cell_count:int = MAZE_WIDTH * MAZE_HEIGHT;
			var pos:int = Math.floor(Math.random() * cell_count);
			var visited:int = 1;
			for (var i:int = 0; i < cell_count; i++)
			{
				_mazes[i] = new Array(0, 1, 1, 1, 1);
			}
			_mazes[pos][0] = 1;
			while (visited < cell_count)
			{
				var possible:String = "";
				if ((Math.floor(pos / MAZE_WIDTH) == Math.floor((pos - 1) / MAZE_WIDTH)) && (_mazes[pos - 1][0] == 0))
				{
					possible += "W";
				}
				if ((Math.floor(pos / MAZE_WIDTH) == Math.floor((pos + 1) / MAZE_WIDTH)) && (_mazes[pos+1][0] == 0))
				{
					possible += "E";
				}
				if ((Math.floor(pos + MAZE_WIDTH) < cell_count) && (_mazes[pos + MAZE_WIDTH][0] == 0))
				{
					possible += "S";
				}
				if ((Math.floor(pos - MAZE_WIDTH) > 0) && (_mazes[pos - MAZE_WIDTH][0] == 0))
				{
					possible += "N";
				}
				if (possible)
				{
					visited++;
					my_moves.push(pos);
					var way:String = possible.charAt(Math.floor(Math.random() * possible.length));
					switch (way)
					{
						case "N":
							_mazes[pos][1] = 0;
							_mazes[pos - MAZE_WIDTH][2] = 0;
							pos -= MAZE_WIDTH;
							break;
						case "S":
							_mazes[pos][2] = 0;
							_mazes[pos + MAZE_WIDTH][1] = 0;
							pos += MAZE_WIDTH;
							break;
						case "E":
							_mazes[pos][3] = 0;
							_mazes[pos + 1][4] = 0;
							pos++;
							break;
						case "W":
							_mazes[pos][4] = 0;
							_mazes[pos - 1][3] = 0;
							pos--;
							break;
					}
					_mazes[pos][0]=1;
				}
				else
				{
					pos=my_moves.pop();
				}
			}
			addChild(_maze_draw);
			_maze_draw.graphics.lineStyle(10,0,1,true);
			_maze_draw.graphics.moveTo(10,10);
			var startX:int=0;
			var startY:int=10-WALL_SIZE;
			for(i=0;i<cell_count;i++)
			{
				startX+=WALL_SIZE;
				if(i%MAZE_WIDTH==0)
				{
					startY+=WALL_SIZE;
					startX=10;
				}
				if(_mazes[i][2]==1)
				{
					_maze_draw.graphics.moveTo(startX,startY+WALL_SIZE);
					_maze_draw.graphics.lineTo(startX+WALL_SIZE,startY+WALL_SIZE);
				}
				if(_mazes[i][3]==1)
				{
					_maze_draw.graphics.moveTo(startX+WALL_SIZE,startY);
					_maze_draw.graphics.lineTo(startX+WALL_SIZE,startY+WALL_SIZE);
				}
			}
			_maze_draw.graphics.lineStyle(10,0);
			_maze_draw.graphics.moveTo(10,10);
			_maze_draw.graphics.lineTo(10+WALL_SIZE*MAZE_WIDTH,10);
			_maze_draw.graphics.lineTo(10+WALL_SIZE*MAZE_WIDTH,10+WALL_SIZE*MAZE_HEIGHT);
			_maze_draw.graphics.lineTo(10,10+WALL_SIZE*MAZE_HEIGHT);
			_maze_draw.graphics.lineTo(10,10);
		}
	}
}
