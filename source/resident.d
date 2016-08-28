module game.resident;

import game.entity;
import game.cell;
import armos.math.vector;

enum ResidentState{
    HasFood, 
    Free, 
}

enum ResidentMoving{
    Up,
    Down,
    Left,
    Right, 
}

/++
+/
class Resident : Entity{
    public{
        ///
        bool shouldDie(){return _shouldDie;};
        
        ///
        int age(){return _age;}
        
        ///
        int life(){return _life;}
        
        ///
        Vector3i pos(){return _pos;}
        
        ///
        void pos(in Vector3i p){_pos = p;}
        
        ///
        void setup(){
            _age = 0;
        };
        
        ///
        void update(in Vector2i size){
            import std.random;
            if(_state == ResidentState.Free){
                switch (_moving) {
                    case ResidentMoving.Left:
                        if(_cell.down !=null && _cell.down.type == CellType.Ludder){
                            _moving = ResidentMoving.Down;
                        }else{
                            if(_pos[0] < (size[0]-1)*32){
                                _pos += Vector3i(1, 0, 0);
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }
                        break;
                    case ResidentMoving.Right:
                        if(_cell.down !=null && _cell.down.type == CellType.Ludder && _pos[0]%Cell.size == 0){
                            _moving = ResidentMoving.Down;
                        }else{
                            if(0 < _pos[0]){
                                _pos -= Vector3i(1, 0, 0);
                            }else{
                                _moving = ResidentMoving.Left;
                            }
                        }
                        break;
                    case ResidentMoving.Down:
                        if(_cell.down !=null && _cell.down.type != CellType.Ludder && _pos[1]%Cell.size == 0){
                            if(uniform(0, 1) == 1){
                                _moving = ResidentMoving.Left;
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }else{
                            if(0 < _pos[1]){
                                _pos -= Vector3i(0, 1, 0);
                            }else{
                                if(uniform(0, 1) == 1){
                                    _moving = ResidentMoving.Left;
                                }else{
                                    _moving = ResidentMoving.Right;
                                }

                            }
                        }
                        break;
                    default:
                }
                
                if(_pos[1] == 0 && _pos[0]/Cell.size == size[0]-1){
                    import std.stdio;
                    "hasFood!".writeln;
                    _state = ResidentState.HasFood;
                }
            }else if(_state == ResidentState.HasFood){
                switch (_moving) {
                    case ResidentMoving.Left:
                        if(_cell.up!=null && _cell.type == CellType.Ludder){
                            _moving = ResidentMoving.Up;
                        }else{
                            if(_pos[0] < (size[0]-1)*32){
                                _pos += Vector3i(1, 0, 0);
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }
                        break;
                    case ResidentMoving.Right:
                        if(_cell.up!=null && _cell.type == CellType.Ludder && _pos[0]%Cell.size == 0){
                            _moving = ResidentMoving.Up;
                        }else{
                            if(0 < _pos[0]){
                                _pos -= Vector3i(1, 0, 0);
                            }else{
                                _moving = ResidentMoving.Left;
                            }
                        }
                        break;
                    case ResidentMoving.Up:
                        if(_cell.up != null && _cell.type != CellType.Ludder && _pos[1]%Cell.size == 0){
                            if(uniform(0, 1) == 1){
                                _moving = ResidentMoving.Left;
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }else{
                            if(_pos[1] < (size[1] - 1)*32){
                                _pos += Vector3i(0, 1, 0);
                            }else{
                                if(uniform(0, 1) == 1){
                                    _moving = ResidentMoving.Left;
                                }else{
                                    _moving = ResidentMoving.Right;
                                }

                            }
                        }
                        break;
                    default:
                }
            }
            
            if(_age > 60*30){
                _shouldDie = true;
            }
        };
        
        ///
        void draw(){
            import game.resources;
            import armos.graphics;
            switch (_state) {
                case ResidentState.Free:
                    animations("resident", 1).index(0).draw;
                    break;
                case ResidentState.HasFood:
                    color(255, 127, 127);
                    animations("resident", 1).index(0).draw;
                    color(255, 255, 255);
                    break;
                default:
                    assert(0);
            }
        };
        
        ///
        void cell(Cell* c){_cell = c;};
    }//public

    private{
        ResidentState _state = ResidentState.Free;
        ResidentMoving _moving = ResidentMoving.Right;
        bool _shouldDie = false;
        int _age = 0;
        int _life = 10;
        Vector3i _pos;
        Cell* _cell;
    }//private
}//class Resident
