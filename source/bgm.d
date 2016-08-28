module game.bgm;
static import ar = armos;

class CrossFade{
	bool isFading(){
		return _isFading;
	}
 	CrossFade set(ar.audio.Source before, ar.audio.Source after){
		_source[0] = before;
		_defaultGain[0] = before.gain;
		_source[1] = after;
		_defaultGain[1] = after.gain;
		return this;
	}
	void start(){
		if(!_isFading){
			_isFading = true;
			_source[1].gain(0);
			_source[1].play;
		}
	}
	void update(){
		if(_isFading){
			float gain1 = fade(_source[0].gain, 0);
			_source[0].gain(gain1);
			float gain2 = fade(_source[1].gain, _defaultGain[1]);
			_source[1].gain(gain2);
			if(gain1 ==0 && gain2 == _defaultGain[1]){
				_isFading = false;
			}
		}
	}
	CrossFade swap(){
		ar.audio.Source tmpS = _source[0];
		_source[0] = _source[1];
		_source[1] = tmpS;
		float tmpG = _defaultGain[0];
		_defaultGain[0] = _defaultGain[1];
		_defaultGain[1] = tmpG;
		return this;
	}
	private{
		ar.audio.Source[2] _source;
		float[2] _defaultGain;
		float _gainStep = 0.001f;
		bool _isFading = false;
		float fade(float from, float to){
			if(from - to < _gainStep && from - to > -_gainStep){
				from = to;
			}else if(from < to){
				from = from + _gainStep;
			}else if(from > to){
				from = from - _gainStep;
			}
			return from;
		}
	}
}
