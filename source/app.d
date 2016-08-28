static import ar = armos;
import game.resources;

///
enum GameStatus{
    Opening,
    Guide,
    Playing,
    PreGameover,
    Gameover,
}

/++
+/
class Game {
    import std.algorithm;
    import game.entity;
    import game.tower;
    public{
        ///
        void setup(){
            _tower = new Tower(ar.math.Vector2i(6, 1));
            import std.stdio;
            "setup game".writeln;
        }

        ///
        void update(){
            updateEntities;
            updateTower;
            import std.stdio;
            "update game".writeln;
        }

        ///
        void draw(){
            drawEntities;
            drawTower;
            import std.stdio;
            "draw game".writeln;
        }

        ///
        void keyPressed(ar.utils.KeyType key){
            import game.cell;
            switch (key) {
                case ar.utils.KeyType.W:
                    _tower.cursorMoveUp;
                    break;
                case ar.utils.KeyType.S:
                    _tower.cursorMoveDown;
                    break;
                case ar.utils.KeyType.A:
                    _tower.cursorMoveLeft;
                    break;
                case ar.utils.KeyType.D:
                    _tower.cursorMoveRight;
                    break;
                case ar.utils.KeyType.Z:
                    _tower.buildCellToCurrentCursor(CellType.House);
                    break;
                //TODO
                // case ar.utils.KeyType.X:
                //     _tower.buildCellToCurrentCursor(CellType.Ferm);
                //     break;
                // case ar.utils.KeyType.C:
                //     _tower.buildCellToCurrentCursor(CellType.Factory);
                //     break;
                case ar.utils.KeyType.Enter:
                    // _tower.cursorMoveRight;
                    break;
                default:
            }
        }

        void keyReleased(ar.utils.KeyType key){}

        void mouseMoved(ar.math.Vector2i position, int button){}

        void mousePressed(ar.math.Vector2i position, int button){}

        void mouseReleased(ar.math.Vector2i position, int button){}
    }//public

    public{
        void updateEntities(){
            _entity.each!(e => update);
        };
        
        void drawEntities(){
            _entity.each!(e => draw);
        }
        
        void updateTower(){
            _tower.update;
        };
        
        void drawTower(){
            _tower.draw;
        };
        
        Entity[] _entity;
        Tower _tower;
    }//private
}//class Game


class TestApp : ar.app.BaseApp{
    this(){}

    override void setup(){
		ar.graphics.blendMode = ar.graphics.BlendMode.Alpha;
        _state = GameStatus.Opening;
        
        _player = new ar.audio.Player;
        _titleBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/title")).play;
        ar.graphics.background(146, 173, 148);
    }

    override void update(){
        if(_state == GameStatus.Opening){
            if(_titleBGM.state == ar.audio.SourceState.Stopped){
                _titleBGM = (new ar.audio.Source).buffer(sounds("data/kuuki")).isLooping(true).play;
            }
        }
        if(_game){
            _game.update();
        }
    }

    override void draw(){
        ar.graphics.pushMatrix;
        ar.graphics.translate(0, ar.app.windowSize[1], 0);
        ar.graphics.scale(_scale);
        ar.graphics.scale(1f, -1f, 1f);
        
        if(_game){
            _game.draw();
        }
        if(_state == GameStatus.Opening){}
        if(_state == GameStatus.Guide){}
        if(_state == GameStatus.Playing){}
        if(_state == GameStatus.PreGameover){}
        if(_state == GameStatus.Gameover){}
        ar.graphics.popMatrix;
    }

    override void keyPressed(ar.utils.KeyType key){
        if(_game){
            _game.keyPressed(key);
        }
    }

    override void keyReleased(ar.utils.KeyType key){
        if(_game){
            _game.keyReleased(key);
        }
    }

    override void mouseMoved(ar.math.Vector2i position, int button){
        if(_game){
            auto flipped = ar.math.Vector2i(position[0],  -position[1] + ar.app.windowSize[1]);
            _game.mouseMoved(flipped/_scale, button);
            import std.stdio;
            (flipped/_scale).writeln;
        }
    }

    override void mousePressed(ar.math.Vector2i position, int button){
        if(_game){
            auto flipped = ar.math.Vector2i(position[0],  -position[1] + ar.app.windowSize[1]);
            _game.mousePressed(flipped/_scale, button);
        }
        
        switch (_state) {
            case GameStatus.Opening:
                _titleBGM.stop;
                _state = GameStatus.Guide;
                break;
            case GameStatus.Guide:
                _state = GameStatus.Playing;
                _game = new Game;
                if(_game){
                    _game.setup();
                }
                break;
            case GameStatus.Playing:
                break;
            case GameStatus.PreGameover:
                break;
            case GameStatus.Gameover:
                _state = GameStatus.Opening;
                break;
            default:
                assert(0);
        }
    }

    override void mouseReleased(ar.math.Vector2i position, int button){
        if(_game){
            auto flipped = ar.math.Vector2i(position[0],  -position[1] + ar.app.windowSize[1]);
            _game.mouseReleased(flipped/_scale, button);
        }
    }

    private{
        GameStatus _state;
        Game _game;
        int _scale = 3;
        ar.audio.Player _player;
        ar.audio.Source _titleBGM;
    }
}

void main(){ar.app.run(new TestApp);}
