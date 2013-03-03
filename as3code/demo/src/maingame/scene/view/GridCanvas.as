package maingame.scene.view
{
	
	import flash.geom.Point;
	
	import maingame.model.vo.BijouVO;
	import maingame.model.vo.GridVO;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GridCanvas extends Sprite
	{
		private var _grid:GridVO;
		
		private var _vec_bijou:Vector.<BijouView>;
		/**
		 * 棋盘所所使用的列 
		 */		
		private var _col:int;
		
		private var _selectedCube:BijouView = null;
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
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		public function onTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch&&_selectedCube==null)
			{
				//选择touch的对象
				//TODO:计算出当前选中的宝石
				
				var pos:Point = touch.getLocation(this);
				var col:int = Math.round(pos.x/BijouView.CUBE_WIDTH);
				var row:int = _row - Math.round(pos.y/BijouView.CUBE_HEIGHT);
				if(col <=_col&&row<=_row)
				{
					_selectedCube = _grid.getBijou(col,row).view;
					if(_selectedCube.intween)
					{
						_selectedCube = null;
						return;
					}
				}
			}
			//处理选中完毕
			var touches:Vector.<Touch> = e.getTouches(this,TouchPhase.MOVED);
			
			if(touches.length == 1)
			{
				if(_selectedCube!=null&&_selectedCube.intween==false)
				{	
					pos = touches[0].getLocation(this);
					col = Math.round(pos.x/BijouView.CUBE_WIDTH);
					row = _row - Math.round(pos.y/BijouView.CUBE_HEIGHT);
					var moveX:int = col - _selectedCube.col;
					var moveY:int = row - _selectedCube.row;
					var targetC:int = _selectedCube.col;
					var targetR:int = _selectedCube.row;
					if(moveX!=0||moveY!=0)
					{
						if(moveX<=moveY&&moveX>=-moveY)
						{
							//处理向右
							if(x<_col)
								targetC +=1;
						}else if(moveX<=moveY&&moveX<-moveY)
						{
							//处理向下 的反 动画应处理做向上移动
							if(y<_row)
								targetR +=1;
						}else if(moveX>moveY&&moveX>=-moveY)
						{
							//处理向上
							if(y>0)
								targetR -=1;
						}else if(moveX>moveY&&moveY<-moveY)
						{
							//处理向左
							if(x>0)
								targetC -=1;
						}
						changeBijou(_selectedCube.vo,targetC,targetR);
						return;
					}else
					{
						return;
					}
				}
				touch = e.getTouch(this,TouchPhase.ENDED);
				if(touch){
					checkGameGrid();
				}
			}
		}
		/**
		 * 修正位置 
		 * 
		 */		
		private function fixPos(bijou:BijouView):void
		{
			bijou.x = BijouView.CUBE_WIDTH*bijou.col;
			bijou.y = BijouView.CUBE_HEIGHT*bijou.row;
		}
		
		/**
		 * 更换两个宝石位置
		 * @param bijou
		 * @param col
		 * @param row
		 */		
		public function changeBijou(bijou:BijouVO,toCol:int,toRow:int):void
		{
			
		}
		
		/**
		 * 每次移动结束
		 * 计算处理消除效果
		 * 
		 */		
		private function checkGameGrid():void
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