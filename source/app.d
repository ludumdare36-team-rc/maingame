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
    import game.cell;
    public{
        ///
        void setup(){
            _tower = new Tower(ar.math.Vector2i(6, 1));
            _heiwaBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/heiwa")).isLooping(true).play;
            _sentouBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/sentou")).isLooping(true);
            bgmChanger.set(_sentouBGM,_heiwaBGM);
            _scale = (new TestApp)._scale;
            _cellSize = (new game.cell.Cell).size;
            _cellCount=ar.app.windowSize[1]/_cellSize/_scale;
            
            _tower.buildCellToCurrentCursor(CellType.Depot);
            _tower.cursorMoveRight;
            _tower.buildCellToCurrentCursor(CellType.House);
            
        }

        ///
        void update(){
            updateEntities;
            updateTower;
            bgmChanger.update;
        }

        ///
        void draw(){
            import std.stdio;
            _tower.foods.writeln;
            ar.graphics.pushMatrix;
            ar.math.Vector2i cursorPos = _tower.cursorPosition;
            if(_cellCount - cursorPos[1] + _dispFloor < 2){
                _dispFloor++;
            }
            if(cursorPos[1] - _dispFloor < 2 && _dispFloor >0){
                _dispFloor--;
            }
            ar.graphics.translate(0, -_dispFloor * _cellSize, 0);
            drawTower;
            drawEntities;
            ar.graphics.popMatrix;
        }

        ///
        void keyPressed(ar.utils.KeyType key){
            switch (key) {
                case ar.utils.KeyType.J:
                    bgmChanger.swap.start;
                    break;
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
                    if(_tower.foods>0){
                        _tower.buildCellToCurrentCursor(CellType.House);
                        _tower.decFoods(1);
                    }
                    break;
                //TODO
                case ar.utils.KeyType.X:
                    if(_tower.foods>0){
                        _tower.buildCellToCurrentCursor(CellType.Factory);
                        _tower.decFoods(1);
                    }
                    break;
                case ar.utils.KeyType.C:
                    if(_tower.foods>0){
                        _tower.buildCellToCurrentCursor(CellType.Depot);
                        _tower.decFoods(1);
                    }
                    break;
                case ar.utils.KeyType.V:
                    if(_tower.foods>0){
                        _tower.buildCellToCurrentCursor(CellType.Ludder);
                        _tower.decFoods(1);
                    }
                    break;
                case ar.utils.KeyType.Enter:
                    _tower.buildCellToCurrentCursor(CellType.Broken);
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
            import std.random;
            if(uniform(0, 60*30)==0) spawnEnemy();
            
            
            
            _tower.connectEntitiesWithCell(_entities);
            
            ar.math.Vector2i towerSize = _tower.size;
            foreach (entity; _entities) {
                entity.update(towerSize);
            }
            
            import std.array;
            _entities = _entities.filter!(e=>!e.shouldDie).array;
        };
        
        void drawEntities(){
            foreach (entity; _entities) {
                import std.conv;
                ar.graphics.pushMatrix;
                ar.graphics.translate(entity.pos.to!(ar.math.Vector3f));
                entity.draw;
                ar.graphics.popMatrix;
            }
        }
        
        void updateTower(){
            _tower.update(_entities);
        };
        
        void drawTower(){
            _tower.draw;
        };
        
        
        Entity[] _entities;
        Tower _tower;
    }//private
    private{
        ar.audio.Source _heiwaBGM;
        ar.audio.Source _sentouBGM;
        game.bgm.CrossFade bgmChanger = new game.bgm.CrossFade();
        void spawnEnemy(){
            import game.enemy;
            import std.random;
            Enemy enemy = new Enemy;
            import game.cell;
            enemy.pos = ar.math.Vector3i((_tower.size[0]-1)*Cell.size, 0, 0);
            _entities ~= enemy;
        }
        bool isBattle = false;
        int _dispFloor = 0;
        int _scale;
        int _cellCount;
        int _cellSize;
    }
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

    override void keyReleased(ar.utils.KeyType key){
        if(_game){
            _game.keyReleased(key);
        }
    }

    override void mouseMoved(ar.math.Vector2i position, int button){
        if(_game){
            auto flipped = ar.math.Vector2i(position[0],  -position[1] + ar.app.windowSize[1]);
            _game.mouseMoved(flipped/_scale, button);
        }
    }

    override void mousePressed(ar.math.Vector2i position, int button){
        if(_game){
            auto flipped = ar.math.Vector2i(position[0],  -position[1] + ar.app.windowSize[1]);
            _game.mousePressed(flipped/_scale, button);
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
