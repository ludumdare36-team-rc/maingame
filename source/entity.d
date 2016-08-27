module game.entity;
import armos.math.vector;

interface Entity{
    bool shouldDie();
    int age();
    Vector3i pos();
    int life();
}
