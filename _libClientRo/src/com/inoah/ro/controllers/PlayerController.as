package com.inoah.ro.controllers
{
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.consts.DirIndexConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.events.Event;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;

    public class PlayerController
    {
        private var _playerView:PlayerView;
        
        public function PlayerController( playerView:PlayerView )
        {
            _playerView = playerView;
        }
        
        public function tick( delta:Number ):void
        {
            if( _playerView )
            {
                moveCheck( delta );
            }
        }
        
        protected function moveCheck( delta:Number ):void
        {
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
            if( !keyMgr )
            {
                return;
            }
            _playerView.isMoving = false;
            if( _playerView.isAttacking  )
            {
                return;
            }
            if( keyMgr.isDown( Keyboard.J ))
            {
                _playerView.isAttacking = true;
                _playerView.addEventListener( ActSprViewEvent.ACTION_END, onActionEndHandler );
                return;
            }
            if( keyMgr.isDown( Keyboard.W ) )
            {
                _playerView.dirIndex = DirIndexConsts.UP;
                _playerView.y -= delta * _playerView.speed;
                _playerView.isMoving = true;
            }
            else if( keyMgr.isDown( Keyboard.S ) )
            {
                _playerView.dirIndex = DirIndexConsts.DOWN;
                _playerView.y += delta * _playerView.speed;
                _playerView.isMoving = true;
            }
            if( keyMgr.isDown( Keyboard.A ) )
            {
                if( _playerView.dirIndex == DirIndexConsts.UP )
                {
                    _playerView.dirIndex = DirIndexConsts.UP_LIFT;
                    _playerView.x -= delta * _playerView.speed ;
                }
                else if( _playerView.dirIndex == DirIndexConsts.DOWN )
                {
                    _playerView.dirIndex = DirIndexConsts.DOWN_LEFT;
                    _playerView.x -= delta * _playerView.speed ;
                }
                else
                {
                    _playerView.dirIndex = DirIndexConsts.LEFT;
                    _playerView.x -= delta * _playerView.speed;
                }
                _playerView.isMoving = true;
            }
            else if( keyMgr.isDown( Keyboard.D ) )
            {
                if( _playerView.dirIndex == DirIndexConsts.UP )
                {
                    _playerView.dirIndex = DirIndexConsts.UP_RIGHT;
                    _playerView.x += delta * _playerView.speed ;
                }
                else if( _playerView.dirIndex == DirIndexConsts.DOWN )
                {
                    _playerView.dirIndex = DirIndexConsts.DOWN_RIGHT;
                    _playerView.x += delta * _playerView.speed ;
                }
                else
                {
                    _playerView.dirIndex = DirIndexConsts.RIGHT;
                    _playerView.x += delta * _playerView.speed;
                }
                _playerView.isMoving = true;
            }
        }
        
        protected function onActionEndHandler( e:Event):void
        {
            if( _playerView.actionIndex >= 40 && _playerView.actionIndex < 48 )
            {
                _playerView.isAttacking = false;
            }
        }
    }
}