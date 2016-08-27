static import ar = armos;

enum GameStatus{
    Opening,
    Guide,
    Playing,
    PreGameover,
    Gameover,
}

class TestApp : ar.app.BaseApp{
    this(){}

    override void setup(){
        _state = GameStatus.Opening;
    }

    override void update(){}

    override void draw(){
        if(_state == GameStatus.Opening){}
        if(_state == GameStatus.Guide){}
        if(_state == GameStatus.Playing){}
        if(_state == GameStatus.PreGameover){}
        if(_state == GameStatus.Gameover){}
    }

    override void keyPressed(ar.utils.KeyType key){}

    override void keyReleased(ar.utils.KeyType key){}

    override void mouseMoved(ar.math.Vector2i position, int button){}

    override void mousePressed(ar.math.Vector2i position, int button){
        if(_state == GameStatus.Playing){}
        if(_state == GameStatus.Opening){
            _state = GameStatus.Guide;
        }
        if(_state == GameStatus.Guide){}
        if(_state == GameStatus.PreGameover){}
        if(_state == GameStatus.Gameover){
            _state = GameStatus.Opening;
        }
    }

    override void mouseReleased(ar.math.Vector2i position, int button){}

    private GameStatus _state;
}

void main(){ar.app.run(new TestApp);}
