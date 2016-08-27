static import ar = armos;

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
        void setup(){
            _tower = new Tower(ar.math.Vector2i(5, 6));
            import std.stdio;
            "setup game".writeln;
        }

        void update(){
            updateEntities;
            updateTower;
            import std.stdio;
            "update game".writeln;
        }

        void draw(){
            drawEntities;
            drawTower;
            import std.stdio;
            "draw game".writeln;
        }

        void keyPressed(ar.utils.KeyType key){}

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
        
    }

    override void update(){
        if(_game){
            _game.update();
        }
    }

    override void draw(){
        ar.graphics.pushMatrix;
        ar.graphics.scale(scale);
        
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
            _game.mouseMoved(position, button);
        }
    }

    override void mousePressed(ar.math.Vector2i position, int button){
        if(_game){
            _game.mousePressed(position, button);
        }
        
        switch (_state) {
            case GameStatus.Opening:
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
            _game.mouseReleased(position, button);
        }
    }

    private{
        GameStatus _state;
        Game _game;
        int scale = 3;
    }
}

void main(){ar.app.run(new TestApp);}
