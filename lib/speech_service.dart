import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  double _confidence = 1.0;
  String _text = 'Press the button and start speaking';

  void startListening(
      Function(String) onResult, Function(bool) onListeningStatusChange) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        onListeningStatusChange(true);
        _speech.listen(
          onResult: (val) {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            onResult(_text);
          },
        );
      }
    } else {
      onListeningStatusChange(false);
      _speech.stop();
    }
  }
}
