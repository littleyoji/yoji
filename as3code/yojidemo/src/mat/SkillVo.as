package mat
{
	public class SkillVo
	{
		/**
		 * 技能id 
		 */		
		public var id:String;
		/**
		 * 攻击力加成 
		 */		
		public var atkBuffer:Number;
		
		/**
		 * 技能名 
		 */		
		public var name:String;
		/**
		 * 防御力加成 
		 */		
		public var defBuffer:Number;
		
		/**
		 * 攻击力加成比 
		 */
		public var atkEffect:Number;
		
		/**
		 * 防御力加成比 
		 */		
		public var defEffect:Number;
		public function SkillVo(obj:Object = null)
		{
			id = obj.id;
			name = obj.name;
			atkBuffer = obj.atkBuffer;
			defBuffer = obj.defBuffer;
			atkEffect = obj.atkEffect;
			defEffect = obj.defEffect;
		}
	}
}