package maingame.model.vo
{
	public class SceneConfigVO
	{
		public var scene_id:String;
		public var scene_name:String;
		
		//以下为材质名，通过名称纪录，加载时即时加载
		public var scene_icon:String;
		public var scene_background:String;
		/**
		 * 对应加载的地图信息
		 */		
		public var scene_map:MapVO;
		public function SceneConfigVO()
		{
		}
	}
}