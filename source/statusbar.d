module game.statusbar;
import armos.graphics.bitmapfont;
import armos.graphics.renderer;

/++
+/
class StatusBar {
    public{
        this(){
            _font = new BitmapFont;   
            _font.load("font.png", 8, 8);
        }
        
        // void update(){}
        
        void draw(in int foodsRemaining, in int population, in int wave, in int currentHeight){
            import armos.app.basewindow;
            version(Posix){
                pushMatrix;
                translate(0, windowSize[1]/3, 0);
                scale(1f, -1f, 1f);
                drawFoods(foodsRemaining);
                translate(0, 8, 0);
                drawPopulation(population);
                translate(0, 8, 0);
                drawWaveTime(wave);
                translate(0, 8, 0);
                drawHeight(currentHeight);
                popMatrix;
            }
            version(Windows){
                pushMatrix;
                    scale(3);
                    drawFoods(foodsRemaining);
                popMatrix;
                pushMatrix;
                    scale(3);
                    translate(0, 8, 0);
                    drawPopulation(population);
                popMatrix;
                pushMatrix;
                    scale(3);
                    translate(0, 16, 0);
                    drawWaveTime(wave);
                popMatrix;
                pushMatrix;
                    scale(3);
                    translate(0, 24, 0);
                    drawHeight(currentHeight);
                popMatrix;
            }
        }
        
        void drawFoods(in int num){
            import std.conv;
			_font.draw(
				"Foods      : " ~ text(num),
				0,0
			);
        }
        
        void drawPopulation(in int num){
            import std.conv;
			_font.draw(
				"Population : " ~ text(num>=0?num:0),
				0,0
			);
        }
        
        void drawWaveTime(in int num){
            if(num == 0){
            color(255, 138, 0);
            import std.conv;
			_font.draw(
				"Next wave  : Enemy Attack", 
				0,0
			);
            color(255, 255, 255);
            }else{
            import std.conv;
			_font.draw(
				"Next wave  : " ~ text(num) ~ "s",
				0,0
			);
            }
        }
        
        void drawHeight(in int num){
            import std.conv;
			_font.draw(
				"Height     : " ~ text(num),
				0,0
			);
        }
    }//public

    private{
        BitmapFont _font;
        
        //food
        //polu
        //wave
        //current height
    }//private
}//class StatusBar
