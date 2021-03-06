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
    import game.statusbar;
    public{
        ///
        void setup(){
            _tower = new Tower(ar.math.Vector2i(6, 1));
            _heiwaBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/heiwa")).isLooping(true).play;
            _sentouBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/sentou")).isLooping(true);
            _bgmChanger.set(_sentouBGM,_heiwaBGM);
            _scale = (new TestApp)._scale;
            _cellSize = (new game.cell.Cell).size;
            _cellCount=ar.app.windowSize[1]/_cellSize/_scale;
            
            _isBattle = false;
            _age = 0;
            
            _statusBar = new StatusBar;
        }

        ///
        void update(){
            
            if(_age%(60*60) == 60*60-1){
                if(!_isBattle){
                    _isBattle = true;
                    _bgmChanger.swap.start;
                }else{
                    _isBattle = false;
                    _bgmChanger.swap.start;
                }
            }
            
            updateEntities;
            updateTower;
            _bgmChanger.update;
            
            _age++;
        }

        ///
        void draw(){
            ar.math.Vector2i cursorPos = _tower.cursorPosition;
            if(_cellCount - cursorPos[1] + _dispFloor < 2){
                _dispFloor++;
            }
            if(cursorPos[1] - _dispFloor < 2 && _dispFloor >0){
                _dispFloor--;
            }
            ar.graphics.pushMatrix;
            ar.graphics.translate(0, -_dispFloor * _cellSize, 0);
            drawTower;
            version(Windows){
                ar.graphics.translate(0, -_dispFloor * _cellSize, 0);
            }
            drawEntities;
            ar.graphics.popMatrix;
            import std.algorithm;
            import std.array;
            import std.conv;
            
            int nextWave = !_isBattle?60 - _age%(60*60)/60:0;
            _statusBar.draw(_tower.foods.to!int,
                            _entities.map!(e => e.type).filter!(t => t != EntityType.Enemy).array.length.to!int,
                            nextWave, 
                            _tower.size[1]);
        }

        ///
        void keyPressed(ar.utils.KeyType key){
            switch (key) {
                case ar.utils.KeyType.Up:
                    _tower.cursorMoveUp;
                    break;
                case ar.utils.KeyType.Down:
                    _tower.cursorMoveDown;
                    break;
                case ar.utils.KeyType.Left:
                    _tower.cursorMoveLeft;
                    break;
                case ar.utils.KeyType.Right:
                    _tower.cursorMoveRight;
                    break;
                case ar.utils.KeyType.Z:
                    _tower.buildCellToCurrentCursor(CellType.House);
                    break;
                //TODO
                case ar.utils.KeyType.X:
                    _tower.buildCellToCurrentCursor(CellType.Factory);
                    break;
                case ar.utils.KeyType.C:
                    _tower.buildCellToCurrentCursor(CellType.Depot);
                    break;
                case ar.utils.KeyType.V:
                    _tower.buildCellToCurrentCursor(CellType.Ludder);
                    break;
                default:
            }
        }

        void keyReleased(ar.utils.KeyType key){}

        void mouseMoved(ar.math.Vector2i position, int button){}

        void mousePressed(ar.math.Vector2i position, int button){}

        void mouseReleased(ar.math.Vector2i position, int button){}
        
        bool isGameover(){
            import std.algorithm;
            import std.array;
            import std.conv;
            int population = _entities.map!(e => e.type).filter!(t => t != EntityType.Enemy).array.length.to!int;
            return !_tower.isExistAnyDepots || (population == 0 && _tower.foods.to!int == 0);
        }
        
        void bgmStop(){
            _heiwaBGM.stop;
            _sentouBGM.stop;
        }
    }//public

    public{
        void updateEntities(){
            import std.random;
            if(_isBattle && uniform(0, 60*4)==0) spawnEnemy();
            
            
            
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
        StatusBar _statusBar;
        game.bgm.CrossFade _bgmChanger = new game.bgm.CrossFade();
        void spawnEnemy(){
            import game.enemy;
            import std.random;
            Enemy enemy = new Enemy;
            import game.cell;
            enemy.pos = ar.math.Vector3i((_tower.size[0]-1)*Cell.size, 0, 0);
            _entities ~= enemy;
        }
        bool _isBattle = false;
        int _age = 0;
        int _waveRemain = 0;
        int _dispFloor = 0;
        int _scale;
        int _cellCount;
        int _cellSize;
    }
}//class Game


class TestApp : ar.app.BaseApp{
    this(){}

    override void setup(){
        ar.app.windowTitle = "The Babel";
        ar.graphics.blendMode = ar.graphics.BlendMode.Alpha;
        ar.graphics.lineWidth = 3;
        _state = GameStatus.Opening;
        
        _player = new ar.audio.Player;
        _titleBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/title")).play;
        _gameoverBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/gameover"));
        ar.graphics.background(146, 173, 148);
    }

    override void update(){
        switch (_state) {
            case GameStatus.Opening:
                if(_titleBGM.state == ar.audio.SourceState.Stopped){
                    _titleBGM = (new ar.audio.Source).buffer(sounds("data/kuuki")).isLooping(true).play;
                }
                break;
                
            case GameStatus.Guide:
                break;
                
            case GameStatus.Playing:
                _game.update();
                if(_game.isGameover){
                    _state = GameStatus.Gameover;
                    _game.bgmStop;
                    _gameoverBGM.play;
                }
                break;
                
            case GameStatus.Gameover:
                break;
            default:
                assert(0);
        }
    }

    override void draw(){
        ar.graphics.pushMatrix;
        ar.graphics.translate(0, ar.app.windowSize[1], 0);
        int scale = _scale;
        if(_state != GameStatus.Playing){
            scale = 2;
        }
        ar.graphics.scale(scale);
        ar.graphics.scale(1f, -1f, 1f);
        
        switch (_state) {
            case GameStatus.Opening:
                auto titleImage = animations("title", 1).index(0);
                ar.graphics.pushMatrix;
                    ar.graphics.translate(ar.app.windowSize[0]/2/_scale, 0, 0);
                    ar.graphics.pushMatrix;
                        ar.graphics.translate(-80, 0, 0);
                        titleImage.draw;
                    ar.graphics.popMatrix;
                ar.graphics.popMatrix;

                ar.graphics.scale(1f, -1f, 1f);
                auto font = new ar.graphics.BitmapFont;
                font.load("font.png", 8, 8);
                font.draw(
                        "PRESS ANY KEY !",
                        64+32,-128+16
                        );
                break;
                
            case GameStatus.Guide:
                auto font = new ar.graphics.BitmapFont;
                font.load("font.png", 8, 8);
                version(Windows){
                    import armos.graphics;
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Let's make the highest", 32, 32);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("tower in the space.", 32, 32 + 8 * 2);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("No warehouse is", 32, 32 + 8 * 3);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("game over.", 32, 32 + 8 * 4);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Enemies try", 32, 32 + 8 * 5);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("to break warehouse.", 32, 32 + 8 * 6);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("To save food,", 32, 32 + 8 * 7);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("make the house and weapon.", 32, 32 + 8 * 8);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Then, Pop can go to space!", 32, 32 + 8 * 9);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Move           : Cursor Keys", 32 , 32 + 8 * 10);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Build House    : Z", 32, 32 + 8 * 11);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Build Weapon   : X", 32, 32 + 8 * 12);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Build warehouse: C", 32, 32 + 8 * 13);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("Build Ladder   : V", 32, 32 + 8 * 14);
                    popMatrix;
                    pushMatrix;
                        ar.graphics.scale(scale);
                        font.draw("PRESS ANY KEY !", 32, 32 + 8 * 17);
                    popMatrix;
                }else{
                    ar.graphics.pushMatrix;
                    ar.graphics.scale(1f, -1f, 1f);
                    font.draw(
                            "Let's make the highest \ntower in the space. \nNo warehouse is \ngame over.\nEnemies try \nto break warehouse. \nTo save food,\nmake the house and weapon. \nThen,Pop can go to space!

Move           : Cursor Keys
Build House    : Z
Build Weapon   : X
Build Warehouse: C
Build Ladder   : V



PRESS ANY KEY !",
                            32, -ar.app.windowSize[1]/scale+32
                            );
                    ar.graphics.popMatrix;
                }
                break;
                
            case GameStatus.Playing:
                _game.draw();
                break;
                
            case GameStatus.Gameover:
                auto gameoverImage = animations("gameover", 1).index(0);
                ar.graphics.pushMatrix;
                    ar.graphics.translate(ar.app.windowSize[0]/2/scale, 0, 0);
                    ar.graphics.pushMatrix;
                        ar.graphics.translate(-64, 64, 0);
                        gameoverImage.draw;
                    ar.graphics.popMatrix;
                ar.graphics.popMatrix;
                
                ar.graphics.scale(1f, -1f, 1f);
                auto font = new ar.graphics.BitmapFont;
                font.load("font.png", 8, 8);
                font.draw(
                        "GAMEOVER",
                        128,-128-64
                        );
                break;
                
            default:
                assert(0);
        }
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
                _titleBGM = (new ar.audio.Source).gain(0.5f).buffer(sounds("data/title")).play;
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
        ar.audio.Source _gameoverBGM;
    }
}

void main(){ar.app.run(new TestApp);}
