package com.inoah.ro.characters
{
    import com.inoah.ro.infos.CharacterInfo;
    
    public class PlayerView extends CharacterView
    {
        public function PlayerView(charInfo:CharacterInfo=null)
        {
            super(charInfo);
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
    }
}