package com.inoah.ro.controllers
{
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.infos.CharacterInfo;
    
    import flash.display.Sprite;

    public class MonsterController
    {
        private var _root:Sprite;
        private var _monsterViewList:Vector.<MonsterView>;
        
        public function MonsterController( root:Sprite )
        {
            _root = root;
            var monsterInfo:CharacterInfo = new CharacterInfo();
            monsterInfo.init( "" , "" , "data/sprite/阁胶磐/poring.act" );
            _monsterViewList = new Vector.<MonsterView>();
            for( var i:int = 0;i<10 ;i++)
            {
                _monsterViewList[i] = new MonsterView( monsterInfo );
                _monsterViewList[i].x = 700 * Math.random() + 50;
                _monsterViewList[i].y = 500 * Math.random() + 50;
                root.addChild( _monsterViewList[i] );
            }
        }
        
        public function get monsterViewList():Vector.<MonsterView>
        {
            return _monsterViewList;
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _monsterViewList.length;
            for( var i:int = 0;i<len;i++)
            {
                _monsterViewList[i].tick( delta ); 
            }
        }
    }
}