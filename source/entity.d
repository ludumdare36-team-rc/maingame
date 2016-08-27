module game.entity;
import armos.math.vector;

interface Entity{
    bool shouldDie();
    int age();
    Vector3i pos();
    void pos(in Vector3i);
    int life();
    
    void setup();
    void update();
    void draw();
}
