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
        EntityType type()const{return _type;};
        
        ///
        bool shouldDie(){return _shouldDie;};
        
        ///
        int age(){return _age;}
        
        ///
        int life(){return _life;}
        
        ///
        void damage(in int damage){_life-=damage;}
        
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
            if(_pos[0]%Cell.size == 0 && _pos[1]%Cell.size == 0){
                if(_cell.type == CellType.Depot && _state == ResidentState.HasFood){
                    _cell.foods += 1;
                    _state = ResidentState.Free;
                }
            }
            
            import std.random;
            if(_state == ResidentState.Free){
                switch (_moving) {
                    case ResidentMoving.Left:
                        if(_cell.down !=null && _cell.down.type == CellType.Ludder && uniform(0, 2) == 0){
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
                        if(_cell.down !=null && _cell.down.type == CellType.Ludder && _pos[0]%Cell.size == 0 && uniform(0, 2) == 0){
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
                            if(uniform(0, 2) == 1){
                                _moving = ResidentMoving.Left;
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }else{
                            if(0 < _pos[1]){
                                _pos -= Vector3i(0, 1, 0);
                            }else{
                                if(uniform(0, 2) == 1){
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
                    _state = ResidentState.HasFood;
                }
            }else if(_state == ResidentState.HasFood){
                switch (_moving) {
                    case ResidentMoving.Left:
                        if(_cell.up!=null && _cell.type == CellType.Ludder && uniform(0, 2) == 0){
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
                        if(_cell.up!=null && _cell.type == CellType.Ludder && _pos[0]%Cell.size == 0 && uniform(0, 2) == 0){
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
                            if(uniform(0, 2) == 1){
                                _moving = ResidentMoving.Left;
                            }else{
                                _moving = ResidentMoving.Right;
                            }
                        }else{
                            if(_pos[1] < (size[1] - 1)*32){
                                _pos += Vector3i(0, 1, 0);
                            }else{
                                if(uniform(0, 2) == 1){
                                    _moving = ResidentMoving.Left;
                                }else{
                                    _moving = ResidentMoving.Right;
                                }

                            }
                        }
                        break;
                    case ResidentMoving.Down:
                        if(uniform(0, 2) == 1){
                        _moving = ResidentMoving.Up;
                        }else{
                                if(uniform(0, 2) == 1){
                                    _moving = ResidentMoving.Left;
                                }else{
                                    _moving = ResidentMoving.Right;
                                }
                        }
                        break;
                    default:
                }
            }
            
            if(_life <= 0){
                _shouldDie = true;
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
                    animations("resident", 1).index(0).draw;
                    pushMatrix;
                    translate(0, 14, 0);
                    animations("food", 1).index(0).draw;
                    popMatrix;
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
        EntityType _type = EntityType.Resident;
    }//private
}//class Resident
