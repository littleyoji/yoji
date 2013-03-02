package maingame.model.vo
{
	import maingame.model.DataConfigModel;

	public class SkillConfigVO
	{
		/**
		 * 技能id
		 */		
		public var id:String;
		
		/**
		 * 技能名 
		 */		
		public var name:String;
		
		/**
		 * 对应图标，若为空则为后续技能 
		 */		
		public var iconTexture:String;
		
		/**
		 * 技能对应贴图名 
		 */		
		public var skillTexture:String;
		
		/**
		 * 技能开始祯
		 */		
		public var skillBegin:int;
		
		/**
		 * 技能结束祯 
		 */		
		public var skillEnd:int;
		/**
		 * 脚本 
		 */		
		public var script:String;
		
		/**
		 * 技能攻击力  
		 */		
		public var ATKBuffer:int;
		
		/**
		 * 技能防御力修正
		 */		
		public var DEFBuffer:int;
		
		/**
		 * 基础攻数据影响 
		 */		
		public var ATKEffect:Number;
		
		/**
		 * 基础防御数据影响
		 */		
		public var DEFEffect:Number;
		
		/**
		 * 后续技能 若為null發動結束
		 */		
		public var nextSkill:SkillConfigVO;
		
		
		public function setData(data:Object):void
		{
			this.ATKBuffer = data.ATKBuffer;
			this.ATKEffect = data.ATKEffect;
			this.DEFBuffer = data.DEFBuffer;
			this.DEFEffect = data.DEFEffect;
			this.iconTexture = data.iconTexture;
			this.id = data.id;
			this.name = data.name;
			this.nextSkill = null;		//TODO:待处理
			this.script = data.script;
			this.skillBegin = data.skillBegin;
			this.skillEnd = data.skillEnd;
			this.skillTexture = data.skillTexture;
		}
		
		public function setNextSkill(skillid:String):void
		{
			this.nextSkill = DataConfigModel.instance.getSkillById(skillid);
		}
	}
}