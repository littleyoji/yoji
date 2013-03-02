package maingame.model.vo
{
	public class GridVO
	{
		private var _bijoulist:Array = [];
		public function GridVO()
		{
		}
		
		
		/**
		 * 根据地图初始化一个网格 
		 * @param _map
		 * 
		 */		
		public function newGrid(_map:MapVO):void
		{
			_bijoulist = [];
			var map:Array = _map.map;
			for(var i:int=0;i<map.length;i++)
			{
				var row:Array = map[i];
				var bijou_row:Array = [];
				for(var j:int = 0;j<row.length;j++)
				{
					var bijou:BijouVO= new BijouVO(this);
					bijou.value = row[j];
					bijou_row.push(bijou);
				}
				_bijoulist.push(bijou_row);
			}
		}
		
		public function getBijou(column:int,row:int):BijouVO
		{
			return _bijoulist[column][row];
		}
		
		/**
		 *  
		 * @param value
		 * 
		 */		
		public function setBijou(column:int,row:int,value:BijouVO=null):void
		{
			if(value!=null)
			{
				value.column = column;
				value.row = row;
				_bijoulist[column][row] = value;
				//TODO:处理显示业务
			}else
			{
				_bijoulist[column][row] = null;
			}
		}
		
		/**
		 * 设置某个宝石的列位置 
		 * @param value
		 * @param column
		 * 
		 */		
		public function setColumn(value:BijouVO,column:int):void
		{
			
		}
		
		/**
		 * 设置某个宝石行位置
		 * @param value
		 * @param row
		 * 
		 */		
		public function setRow(value:BijouVO,row:int):void
		{
			
		}
	}
}