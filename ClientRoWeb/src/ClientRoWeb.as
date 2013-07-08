package
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.controllers.MapController;
    import com.inoah.ro.controllers.MonsterController;
    import com.inoah.ro.controllers.PlayerController;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.BattleMgr;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.uis.TopText;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#2f2f2f")]
    public class ClientRoWeb extends Sprite
    {
        private var _topTxt:TopText;
        
        private var _mapController:MapController;
        private var _playerController:PlayerController;
        private var _monsterController:MonsterController;
        //        private var testMapView:*;
        private var lastTimeStamp:int;
        
        public function ClientRoWeb()
        {
            if( stage )
            {
                init();
            }
            else
            {
                stage.addEventListener( Event.ADDED_TO_STAGE , init );
            }
        }
        
        private function init( e:Event = null ):void
        {
            stage.removeEventListener( Event.ADDED_TO_STAGE , init )
            lastTimeStamp = getTimer();
            
            MainMgr.instance;
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_1207.act" );
            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            assetMgr.getResList( resPathList , onInitLoadComplete );
            
            TopText.init();
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        private function onInitLoadComplete( loader:ActSprLoader ):void
        {
            var keyMgr:KeyMgr = new KeyMgr( stage );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, keyMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.BATLLE_MGR, new BattleMgr( this ) );
            
            _mapController = new MapController( this );
            _playerController = new PlayerController( _mapController.currentContainer );
            _monsterController = new MonsterController( _mapController.currentContainer );
            
            _playerController.targetList = _monsterController.monsterViewList;;
            
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
        }
        
        protected function onEnterFrameHandler(e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            
            var battleMgr:BattleMgr = MainMgr.instance.getMgr( MgrTypeConsts.BATLLE_MGR ) as BattleMgr;
            if( battleMgr )
            {
                battleMgr.tick( delta );
            }
            if( _mapController )
            {
                _mapController.tick( delta );
            }
            if( _playerController )
            {
                _playerController.tick( delta );
            }
            if( _monsterController )
            {
                _monsterController.tick( delta );
            }
            TopText.tick( delta );
        }
    }
}