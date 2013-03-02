package maingame.scene.view
{
	
	import maingame.model.vo.BijouVO;
	import maingame.model.vo.GridVO;
	
	import starling.display.Sprite;
	
	public class GridCanvas extends Sprite
	{
		private var _grid:GridVO;
		
		private var _vec_bijou:Vector.<BijouView>;
		/**
		 * 棋盘所所使用的列 
		 */		
		private var _col:int;
		
		/**
		 * 棋盘所使用的行数 
		 */		
		private var _row:int;
		public function GridCanvas()
		{
			super();
		}
		
		/**
		 * 初始化游戏棋盘图形
		 * @param col
		 * @param row
		 * @param grid
		 * 
		 */		
		public function initGameGrid(col:int,row:int,grid:GridVO):void
		{
			cleanGrid();
			_grid = grid;
			_col = col;
			_row = row;
			//TODO: 第一次初始化棋盘信息
			for(var i:int=0;i<_col;i++)
			{
				for(var j:int = 0;j<row;j++)
				{
					var bijouVO:BijouVO = grid.getBijou(i,j);
					var bijou:BijouView = new BijouView(bijouVO);
					_vec_bijou.push(bijou);
					fixPos(bijou);
					addChild(bijou);
				}
			}
		}
		
		/**
		 * 修正位置 
		 * 
		 */		
		private function fixPos(bijou:BijouView):void
		{
			
		}
		/**
		 * 清除棋盘 
		 * 
		 */		
		private function cleanGrid():void
		{
			if(_vec_bijou)
			{
				for each(var bijou:BijouView in _vec_bijou)
				{
					bijou.dispose();
					this.removeChild(bijou);
				}
				_vec_bijou = new Vector.<BijouView>;
			}
		}
	}
}