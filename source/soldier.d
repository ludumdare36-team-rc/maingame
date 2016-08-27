module game.soldier;

import game.entity;
import armos.math.vector;

/++
+/
class Soldier : Entity{
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
        
        
        void setup(){};
        void update(){};
        void draw(){};
        
    }//public

    private{
        bool _shouldDie = false;
        int _age = 0;
        int _life = 10;
        Vector3i _pos;
    }//private
}//class Soldier
