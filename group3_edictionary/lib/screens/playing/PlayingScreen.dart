import 'package:flutter/material.dart';
import '../../models/Word.dart';
import './components/ListeningGame.dart';
import './components/WritingGame.dart';
import '../../helpers/RandomHelper.dart';
import '../../models/GameplayState.dart';
import 'package:provider/provider.dart';
import './components/SummaryScreen.dart';
import './components/ReadingGame.dart';

class PlayingScreen extends StatefulWidget {
  List<Word> words;
  PlayingScreen({Key key, this.words}) : super(key : key);

  @override
  PlayingScreenState createState() => PlayingScreenState();
}

class PlayingScreenState extends State<PlayingScreen> {
  int _currentPage = 0;
  PageController pageController = PageController();
  List<Word> get words => widget.words;

  RandomHelper _randomHelper = new RandomHelper();

  @override 
  Widget build(BuildContext context){ 
    var appBar = AppBar(
      backgroundColor: Colors.red[200],
      title: Text('CHƠI'),
      leading: IconButton(
        icon : Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: (){
          Navigator.maybePop(context);
        }
      ),
      automaticallyImplyLeading: true,
    );

    return ChangeNotifierProvider(
      builder: (context) => GameplayState(),
      child : Scaffold(
        appBar: appBar,
        body: Stack(
          children : <Widget>[ 
            PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: _buildPageItem,
              itemCount : words.length,
              onPageChanged: (int page){
                this.setState((){
                  _currentPage = page;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            SummaryScreen()
          ]
        ),
      )
    );
  }

  Widget _buildPageItem(BuildContext context, int position){
    // Word currentWord = words[position];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var appBar = new AppBar();

    return Container(
      height: screenHeight - appBar.preferredSize.height,
      width: screenWidth,
      decoration: BoxDecoration(color:  Colors.red[100]),
      padding: EdgeInsets.fromLTRB(0, screenHeight * 0.05 , 0, 0),
      child: _getRandomGame(position)
    );
  }

  Widget _getRandomGame(int position){
    int randomGameIndex = _randomHelper.getRandomInt(3);
    print(randomGameIndex);
    if (randomGameIndex == 0)
      return ListeningGame(words: words, currentIndex: position, pageController: pageController,);
    if (randomGameIndex == 1)
      return WritingGame(words: words, currentIndex: position, pageController: pageController);
    if (randomGameIndex == 2)
      return ReadingGame(words: words, currentIndex: position, pageController: pageController);
  }
}