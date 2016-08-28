module game.resident;

import game.entity;
import armos.math.vector;

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
        void update(){
            if(_age > 60*30){
                _shouldDie = true;
            }
        };
        
        ///
        void draw(){
            import game.resources;
            import armos.graphics;
            animations("resident", 1).index(0).draw;
        };
        
    }//public

    private{
        bool _shouldDie = false;
        int _age = 0;
        int _life = 10;
        Vector3i _pos;
    }//private
}//class Resident
