module game.soldier;

import game.entity;
import game.cell;
import armos.math.vector;

enum SoldierType{
    Infantry, 
}

enum SoldierMoving{
    Up,
    Down,
    Left,
    Right, 
}

/++
+/
class Soldier : Entity{
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
        void setup(){};
        
        ///
        void update(in Vector2i size){
            import std.random;
            import std.algorithm;
            import std.array;
            
            attack;
            
            bool left = _cell.left != null && _cell.left.entities.map!(e=>e.type).find(EntityType.Enemy).array != [];
            bool right = _cell.right != null && _cell.right.entities.map!(e=>e.type).find(EntityType.Enemy).array != [];
            bool existEnemy = left || right;
            switch (_moving) {
                case SoldierMoving.Left:
                    if(_cell.down !=null && _cell.down.type == CellType.Ludder && !existEnemy){
                        _moving = SoldierMoving.Down;
                    }else{
                        if(_pos[0] < (size[0]-1)*32){
                            _pos += Vector3i(1, 0, 0);
                        }else{
                            _moving = SoldierMoving.Right;
                        }
                    }
                    break;
                case SoldierMoving.Right:
                    if(_cell.down !=null && _cell.down.type == CellType.Ludder && _pos[0]%Cell.size == 0 && !existEnemy){
                        _moving = SoldierMoving.Down;
                    }else{
                        if(0 < _pos[0]){
                            _pos -= Vector3i(1, 0, 0);
                        }else{
                            _moving = SoldierMoving.Left;
                        }
                    }
                    break;
                case SoldierMoving.Down:
                    if(_cell.down !=null && _cell.down.type != CellType.Ludder && _pos[1]%Cell.size == 0){
                        if(uniform(0, 2) == 1){
                            _moving = SoldierMoving.Left;
                        }else{
                            _moving = SoldierMoving.Right;
                        }
                    }else{
                        if(0 < _pos[1]){
                            _pos -= Vector3i(0, 1, 0);
                        }else{
                            if(uniform(0, 2) == 1){
                                _moving = SoldierMoving.Left;
                            }else{
                                _moving = SoldierMoving.Right;
                            }

                        }
                    }
                    break;
                default:
            }
            
            if(_life <= 0){
                _shouldDie = true;
            }
            
            if(_age > 60*60){
                _shouldDie = true;
            }
            _age++;
        }
        
        ///
        void draw(){
            import game.resources;
            import armos.graphics;
            animations("infantry", 1).index(0).draw;
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
        bool _shouldDie = false;
        int _age = 0;
        int _life = 10;
        Vector3i _pos;
        Cell* _cell;
        EntityType _type = EntityType.Soldier;
        SoldierMoving _moving = SoldierMoving.Right;
        
        void attack(){
            import std.random;
            import std.conv;
            import std.algorithm;
            import std.array;
            foreach (enemy; _cell.entities.filter!(e=>e.type==EntityType.Enemy).array) {
                if(uniform(0, 15)==1)enemy.damage = 1;
            }
        }
    }//private
}//class Soldier
