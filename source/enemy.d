module game.enemy;

import game.entity;
import game.cell;
import armos.math.vector;

enum EnemyMoving{
    Up,
    Down,
    Left,
    Right, 
}

class Enemy : Entity{
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
            import std.random;
            if(_pos[0]%Cell.size == 0 && _pos[1]%Cell.size == 0){
                attack();
            }
            
            
            switch (_moving) {
                case EnemyMoving.Left:
                    if(_cell.up!=null && _cell.type == CellType.Ludder && _pos[0]%Cell.size == 0 && uniform(0, 10) == 0){
                        // if(uniform(0, 1) == 1){
                            _moving = EnemyMoving.Up;
                        // }
                    }else{
                        if(_pos[0] < (size[0]-1)*32){
                            _pos += Vector3i(1, 0, 0);
                        }else{
                            _moving = EnemyMoving.Right;
                        }
                    }
                    break;
                case EnemyMoving.Right:
                    if(_cell.up!=null && _cell.type == CellType.Ludder && _pos[0]%Cell.size == 0 && uniform(0, 10) == 0){
                        // if(uniform(0, 1) == 1){
                            _moving = EnemyMoving.Up;
                        // }
                    }else{
                        if(0 < _pos[0]){
                            _pos -= Vector3i(1, 0, 0);
                        }else{
                            _moving = EnemyMoving.Left;
                        }
                    }
                    break;
                    case EnemyMoving.Up:
                    import std.stdio;
                        "up".writeln;
                        if(_cell.up != null && _cell.type != CellType.Ludder && _pos[1]%Cell.size == 0){
                            if(uniform(0, 1) == 1){
                                _moving = EnemyMoving.Left;
                            }else{
                                _moving = EnemyMoving.Right;
                            }
                        }else{
                            if(_pos[1] < (size[1] - 1)*32){
                                _pos += Vector3i(0, 1, 0);
                            }else{
                                if(uniform(0, 1) == 1){
                                    _moving = EnemyMoving.Left;
                                }else{
                                    _moving = EnemyMoving.Right;
                                }

                            }
                        }
                        break;
                default:
            }
            
            if(_life <= 0){
                _shouldDie = true;
            }
            
            if(_age > 60*30){
                _shouldDie = true;
            }
            _age++;
        };
        
        ///
        void draw(){
            import game.resources;
            import armos.graphics;
            animations("enemy", 1).index(0).draw;
            pushMatrix;
            import std.math;
            translate(10f, ((_age/8)%2)+12, 0);
            rotate(-90f, 0, 0, 1);
            animations("sword", 1).index(0).draw;
            popMatrix;
        };
        
        ///
        void cell(Cell* c){_cell = c;};
    }//public

    private{
        EnemyMoving _moving = EnemyMoving.Right;
        bool _shouldDie = false;
        int _age = 0;
        int _life = 10;
        Vector3i _pos;
        Cell* _cell;
        EntityType _type = EntityType.Enemy;
        
        void attack(){
            import std.random;
            _cell.life--;
            if(uniform(0, 5) == 0){
                _life--;
            }
            
            if(_cell.entities.length != 0){
                if(_cell.entities[0].type!=EntityType.Enemy) _cell.entities[0].damage = 10;
            } 
        }
    }//private
}//class Enemy
