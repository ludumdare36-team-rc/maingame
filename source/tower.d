module game.tower;
import game.floor;
/**
 *
 */
struct Tower{
    private Floor[] floors;
    void floorAdd(Floor floor){
        floors ~= floor;
    }
    Floor floorRemove(int n){
        Floor floor = floors[n];
        floors = floors[0..n-1] ~ floors[n+1..floors.length];
        return floor;
    }
    Floor get(int n){
        return floors[n];
    }
}
