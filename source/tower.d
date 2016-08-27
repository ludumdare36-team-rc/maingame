module game.tower;
import game.floor;
/**
 *
 */
struct Tower{
    Floor[] floors;
    void add(Floor floor){
        floors ~= floor;
    }
    bool del(int n){
        if(n >= floors.length){
            return false;
        }
        floors = floors[0..n] ~ floors[n+1..floors.length];
        return true;
    }
    ref Floor get(int n){
        return floors[n];
    }
}
