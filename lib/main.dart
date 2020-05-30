import 'package:circle_wave_progress/circle_wave_progress.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import 'chart_tab.dart';

void main() => runApp(App());

enum Study { Todo, Yeode }

class Storage {
  Study study = Study.Todo;
}

var storage = Storage();

class _StudyButtons extends StatefulWidget {
  _StudyButtons({Key key}) : super(key: key);

  @override
  _StudyButtonsState createState() => _StudyButtonsState();
}

class _StudyButtonsState extends State<_StudyButtons> {
  var _currentStudy = storage.study;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        _StudyButton(
          name: "정석",
          icon: Icons.access_time,
          selected: _currentStudy == Study.Todo,
          onPressed: () {
            setState(() => _currentStudy = storage.study = Study.Todo);
          },
        ),
        _StudyButton(
          name: "개념원리",
          icon: Icons.album,
          selected: _currentStudy == Study.Yeode,
          onPressed: () {
            setState(() => _currentStudy = storage.study = Study.Yeode);
          },
        ),
      ],
    );
  }
}

class _StudyButton extends StatelessWidget {
  const _StudyButton(
      {Key key,
      @required this.icon,
      @required this.name,
      @required this.selected,
      @required this.onPressed,
      this.color = Colors.white,
      this.size = 60.0,
      this.selectedSize = 120.0,
      this.nameSize = 24.0})
      : super(key: key);

  final IconData icon;
  final String name;
  final bool selected;
  final void Function() onPressed;
  final Color color;
  final double size;
  final double selectedSize;
  final double nameSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.access_alarm),
          onPressed: this.onPressed,
          color: this.color,
          iconSize: this.selected ? this.selectedSize : this.size,
        ),
        Text(
          this.name,
          style: TextStyle(fontSize: this.nameSize, color: this.color),
        )
      ],
    );
  }
}

class App extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      title: Text(
        '자장자장 우리아가',
      ),
      body: Text(
        '다양한 수면 교육법의 핵심만 골라담아 간편하게 수면교육 성공의 길로 이끌어 드립니다!',
      ),
      mainImage: Text("👶", style: TextStyle(fontSize: 120)),
    ),
    PageViewModel(
        pageColor: const Color(0xFF8BC34A),
        title: Text('시작하세요!'),
        body: Text(
          '사용할 방법 하나를 골라 주세요.',
        ),
        mainImage: _StudyButtons()),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '자장자장',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:
            GoogleFonts.nanumPenScriptTextTheme(Theme.of(context).textTheme),
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: false,
          showBackButton: false,
          showSkipButton: false,
          onTapDoneButton: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _HomePage(),
              ),
            );
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  _HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  bool _showFab = true;
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _tabIndex == 0
              ? _MainTabView()
              : _tabIndex == 1 ? _TableTabView() : _ChartTabView()),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
        currentIndex: _tabIndex,
        items: [
          const BottomNavigationBarItem(
            title: Text("수면기록"),
            icon: const Icon(Icons.alarm),
          ),
          const BottomNavigationBarItem(
            title: Text("일지"),
            icon: const Icon(Icons.table_chart),
          ),
          const BottomNavigationBarItem(
            title: Text("통계"),
            icon: const Icon(Icons.pie_chart),
          )
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => _showFab && _tabIndex == 0
            ? FloatingActionButton(
                child: Icon(Icons.settings),
                onPressed: () async {
                  setState(() {
                    _showFab = false;
                  });
                  Scaffold.of(context)
                      .showBottomSheet(
                        (context) => Container(
                            child: _StudyBottomOptions(
                              onUpdate: (newStudy) =>
                                  setState(() => storage.study = newStudy),
                            ),
                            padding: const EdgeInsets.only(top: 16),
                            height: 180),
                        backgroundColor: Colors.grey,
                      )
                      .closed
                      .then((_) {
                    setState(() {
                      _showFab = true;
                    });
                  });
                },
              )
            : Container(),
      ),
    );
  }
}

class _StudyBottomOptions extends StatelessWidget {
  _StudyBottomOptions({Key key, @required this.onUpdate}) : super(key: key);

  final void Function(Study) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StudyButton(
          name: "정석",
          icon: Icons.access_time,
          selected: storage.study == Study.Todo,
          size: 50,
          selectedSize: 80,
          onPressed: () {
            onUpdate(Study.Todo);
            Navigator.pop(context);
          },
        ),
        _StudyButton(
          name: "개념원리",
          icon: Icons.album,
          selected: storage.study == Study.Yeode,
          size: 50,
          selectedSize: 80,
          onPressed: () {
            onUpdate(Study.Yeode);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _MainTabView extends StatelessWidget {
  const _MainTabView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
                "현재 사용 중인 방법은 ${storage.study == Study.Todo ? "정석" : "개념원리"}입니다.",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          CircleWaveProgress(
            size: 300,
            borderWidth: 10.0,
            backgroundColor: Colors.transparent,
            borderColor: Colors.white,
            waveColor: Colors.white54,
            progress: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _Stopwatch(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _WhitenoisePlayer(),
          ),
        ],
      )),
    );
  }
}

class _Stopwatch extends StatefulWidget {
  _Stopwatch({Key key}) : super(key: key);

  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<_Stopwatch> {
  bool _timerGoing;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startFakeTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timerGoing = false;
  }

  void _startFakeTimer() async {
    _timerGoing = true;
    while (_timerGoing) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        ++_seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration(seconds: 100).toString();
    return Column(
      children: [
        Text(
          _printDuration(Duration(seconds: this._seconds)),
          style: TextStyle(fontSize: 64, color: Colors.white),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          RaisedButton(
            child: Text("깨났다!"),
            onPressed: _timerGoing
                ? () {
                    _timerGoing = false;
                  }
                : null,
          ),
          RaisedButton(
            child: Text("잠들었다!"),
            onPressed: _timerGoing
                ? null
                : () {
                    setState(() => _seconds = 0);
                    if (!_timerGoing) {
                      _startFakeTimer();
                    }
                  },
          )
        ])
      ],
    );
  }
}

String _printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

class _WhitenoisePlayer extends StatefulWidget {
  _WhitenoisePlayer({Key key}) : super(key: key);

  @override
  _WhitenoisePlayerState createState() => _WhitenoisePlayerState();
}

class _WhitenoisePlayerState extends State<_WhitenoisePlayer> {
  bool _playing = false;
  String _sound = "청소기 소리";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          child: Text(_sound),
          onPressed: () async {
            final newSound = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('소리 목록'),
                    content: Container(
                      height: 600,
                      width: 450,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _NoiseSelectionButton(value: "청소기 소리"),
                          _NoiseSelectionButton(value: "비오는 소리"),
                          _NoiseSelectionButton(value: "비닐봉지 소리"),
                          _NoiseSelectionButton(value: "자연의 소리"),
                        ],
                      ),
                    ),
                  );
                });
            if (newSound != null) {
              setState(() => this._sound = newSound);
            }
          },
        ),
        IconButton(
          icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() => _playing = !_playing);
          },
        )
      ],
    );
  }
}

class _NoiseSelectionButton extends StatelessWidget {
  const _NoiseSelectionButton({
    Key key,
    @required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(value),
      onPressed: () {
        Navigator.of(context).pop(value);
      },
    );
  }
}

class _TableTabView extends StatelessWidget {
  const _TableTabView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Center(
                child: Text("오늘도 고생 많았어요! 👏👏👏",
                    style: TextStyle(fontSize: 24))),
          );
        }
        if (index % 4 == 1) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 12, right: 12, bottom: 12),
            child: Text("5월 22일",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          );
        }
        return Card(
          child: ListTile(
            leading: Icon(Icons.access_time),
            title: Text('5월 22일 오후 10시 ~ 23일 6시 (8시간)',
                style: TextStyle(fontSize: 20)),
            subtitle: Text('정석', style: TextStyle(fontSize: 16)),
          ),
        );
      },
      itemCount: 16,
    );
  }
}

class _ChartTabView extends StatelessWidget {
  const _ChartTabView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("통계 #${index + 1}", style: TextStyle(fontSize: 24)),
              ),
              BarChartSample4(),
            ],
          ),
        );
      },
      itemCount: 3,
    );
  }
}
