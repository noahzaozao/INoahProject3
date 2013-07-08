package com.inoah.ro.managers
{
    import com.inoah.ro.characters.CharacterView;
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.uis.TopText;
    
    import flash.utils.getTimer;
    
    public class BattleMgr implements IMgr
    {
        public function BattleMgr()
        {
        }
        
        /**
         * 进行一次攻击判定 
         * @param atkView
         * @param hitView
         */        
        public function attack( atkView:CharacterView, hitView:CharacterView ):void
        {
            TopText.show(  + getTimer()  + "[attack] " +atkView.charInfo.name + " 对 " + hitView.charInfo.name + " 造成 " + atkView.charInfo.atk + "点伤害 " ); 
            hitView.charInfo.curHp -= atkView.charInfo.atk;
            if( hitView.charInfo.curHp <= 0 )
            {
                hitView.charInfo.curHp = 0;
                hitView.charInfo.isDead = true;
            }
        }
        
        public function dispose():void
        {
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
    }
}