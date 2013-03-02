package maingame.model.vo
{
	import maingame.model.DataConfigModel;

	public class BattleInfoVO
	{
		public var HP:int;
		public var MAXHP:int;
		public var ATK:int;
		public var DEF:int;
		public var skillList:Vector.<SkillConfigVO>;
		public function BattleInfoVO()
		{
		}
		
		public function setData(obj:Object):void
		{
			this.HP = obj.HP;
			this.MAXHP = this.HP;
			this.ATK = obj.ATK;
			this.DEF = obj.DEF;
			this.skillList = new Vector.<SkillConfigVO>();
			
			var arr:Array = obj.skillList;
			for(var i:int = 0;i<arr.length;i++)
			{
				this.skillList.push(DataConfigModel.instance.getSkillById(arr[i]));
			}
		}
	}
}