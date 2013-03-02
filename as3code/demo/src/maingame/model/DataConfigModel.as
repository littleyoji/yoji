package maingame.model
{
	import com.nbu.framework.model.BaseModel;
	import com.nbu.framework.utils.Singleton;
	
	import flash.utils.Dictionary;
	
	import maingame.model.vo.SceneConfigVO;
	import maingame.model.vo.SkillConfigVO;

	public class DataConfigModel extends BaseModel
	{
		private static var _test_skill_data:Array = [
			{
				'ATKBuffer':50,
				'ATKEffect':2.0,
				'DEFBuffer':-100,
				'DEFEffect':100,
				'iconTexture':"",
				'id':1,
				'name':"挠一挠",
				'nextSkill':null,	//TODO:待处理
				'script':null,
				'nextSkill':null,
				'skillBegin':0,
				'skillEnd':0,
				'skillTexture':"",
				'skillType':1
			},
			{
				'ATKBuffer':50,
				'ATKEffect':2.0,
				'DEFBuffer':-100,
				'DEFEffect':100,
				'iconTexture':"",
				'id':1,
				'name':"挠一挠",
				'nextSkill':null,	//TODO:待处理
				'script':null,
				'nextSkill':null,
				'skillBegin':0,
				'skillEnd':0,
				'skillTexture':"",
				'skillType':1
			}
		];
		/**
		 * 当前场景配置信息 
		 */		
		private var _dic_sceneConfig:Dictionary;
		
		/**
		 * 当前游戏技能配置信息 
		 */		
		private var _dic_skillConfig:Dictionary;
		public function DataConfigModel()
		{
			
			inittestdata();
		}
		public static function get instance():DataConfigModel
		{
			return Singleton.getInstance(DataConfigModel);
		}
		
		public function getSceneById(id:String):SceneConfigVO
		{
			return _dic_sceneConfig[id] as SceneConfigVO;
		}
		
		public function getSkillById(id:String):SkillConfigVO
		{
			return _dic_skillConfig[id] as SkillConfigVO;
		}
		
		private function inittestdata():void
		{
			_dic_skillConfig = new Dictionary();
			var skill:SkillConfigVO;
			for(var i:int=0;i<_test_skill_data.length;i++)
			{
				skill = new SkillConfigVO();
				skill.setData(_test_skill_data[i]);
				_dic_skillConfig[skill.id] = skill;
			}
		}
	}
}