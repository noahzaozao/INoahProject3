package
{
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.controllers.PlayerController;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#2f2f2f")]
    public class ClientRoWeb extends Sprite
    {
        private var _tipTxt:TextField;
        
        [Embed(source="bg.jpg" , mimeType="image/jpeg")]
        private var _bg:Class;
        private var _bgBmp:Bitmap;
        
        private var _playerController:PlayerController;
        private var _charView:PlayerView;
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
            lastTimeStamp = getTimer();
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
            
            MainMgr.instance;
            var keyMgr:KeyMgr = new KeyMgr( stage );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, keyMgr );
            
            _bgBmp = new _bg();
            _bgBmp.x = - 50;
            _bgBmp.y = - 50;
            addChild( _bgBmp );
            
            
            var charInfo:CharacterInfo = new CharacterInfo();
            charInfo.init( "可爱的早早", "data/sprite/firstCharHead.act", "data/sprite/firstChar.act" );
            _charView = new PlayerView( charInfo );
            _charView.x = 400;
            _charView.y = 400;
            addChild( _charView );
            
            _playerController = new PlayerController( _charView );
            
            _tipTxt = new TextField();
            _tipTxt.width = 200;
            var tf:TextFormat = new TextFormat( "宋体", 14, 0xffff00 );
            _tipTxt.defaultTextFormat = tf;
            _tipTxt.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            addChild( _tipTxt );
            _tipTxt.text = "wasd移动 j攻击";
        }
        
        protected function onEnterFrameHandler(e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            
            _playerController.tick( delta );
            _charView.tick( delta );
        }
    }
}