package maingame.model.vo
{
	import maingame.scene.view.BijouView;

	public class BijouVO
	{
		/**
		 * 所在列 
		 */		
		private var _column:int;
		
		/**
		 * 所在行 
		 */		
		private var _row:int;
		
		/**
		 * 该宝石所在的网格，可相互查询 
		 */		
		private var _grid:GridVO;
		
		/**
		 * 该宝石是否进入场景 
		 */		
		private var _view:BijouView;
		/**
		 * 该宝石的值 
		 */		
		private var _value:int;
		public function BijouVO(grid:GridVO)
		{
			_grid = grid;
		}
		public function inGamegrid(view:BijouView):void
		{
			_view = view;
		}
		public function set value(value:int):void
		{
			_value = value;
			
			//TODO:修改其对应的可视化内容
		}
		
		public function get value():int
		{
			return _value;
		}
		/**
		 * 获得所在的列 
		 * @return 
		 * 
		 */		
		public function get column():int
		{
			return _column;
		}
		
		/**
		 * 设置列
		 * @param value
		 * 
		 */		
		public function set column(value:int):void
		{
			_column = value;
			_grid.setColumn(this,value);
		}
			
		public function set row(value:int):void
		{
			_column = value;
			_grid.setRow(this,value);
		}
		public function get row():int
		{
			return _row;
		}
	}
}