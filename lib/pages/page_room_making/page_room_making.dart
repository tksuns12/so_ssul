import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/database.dart';
import 'room_making_actions.dart';


class RoomMakingPage extends StatefulWidget {
  final FirebaseUser currentUser;

  const RoomMakingPage({this.currentUser});

  @override
  _RoomMakingPageState createState() => _RoomMakingPageState();
}

class _RoomMakingPageState extends State<RoomMakingPage> {
  String title;
  int charLimint;
  String initSentence;
  int partLimit;
  List<String> tags;
  bool enjoy;

  @override
  Widget build(BuildContext context) {
    List<LabeledCheckBox> genreList = [
      LabeledCheckBox(
        label: '로맨스',
      ),
      LabeledCheckBox(
        label: '무협',
      ),
      LabeledCheckBox(
        label: '판타지',
      ),
      LabeledCheckBox(
        label: '스릴러',
      ),
      LabeledCheckBox(
        label: '추리',
      ),
      LabeledCheckBox(
        label: '역사',
      ),
      LabeledCheckBox(
        label: 'BL',
      ),
      LabeledCheckBox(
        label: '전쟁',
      ),
      LabeledCheckBox(
        label: '현대판타지',
      ),
      LabeledCheckBox(
        label: '호러',
      )
    ];


    DBManager _dbmanager = GetIt.I.get<DBManager>();

    return Material(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: kDarkPrimaryColor,
            expandedHeight: 350,
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.penNib),
                onPressed: () {
                  _dbmanager.openRoom(
                      title: null,
                      currentUser: widget.currentUser,
                      charLimit: null,
                      initSentence: null,
                      partLimit: null,
                      tags: null,
                      enjoy: null);
                },
              ),
            ],
            flexibleSpace: Center(
              child: TextField(
                onChanged: (text) {
                  title = text;
                },
                keyboardType: TextInputType.text,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '제목을 입력하세요.',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 35)),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Text(
              '장르 선택',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )),
          SliverGrid(
            delegate: SliverChildListDelegate(genreList),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 3),
          ),
          SliverToBoxAdapter(
            child: Divider(
              thickness: 3,
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: <Widget>[
                Text('참여인원'),
                DropdownButton(
                    items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value.toString(),
                            child: Text(
                              value.toString(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {partLimit = value;})
              ],
            ),
          ),
          LabeledRadioButtons(),
        ],
      ),
    );
  }
}

class LabeledCheckBox extends StatefulWidget {
  final String label;

  const LabeledCheckBox({Key key, this.label}) : super(key: key);

  @override
  LabeledCheckBoxState createState() => LabeledCheckBoxState();
}

class LabeledCheckBoxState extends State<LabeledCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: kDarkPrimaryColor),
          child: Checkbox(
              activeColor: Colors.white,
              checkColor: Colors.red,
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value;
                });
                
              }),
        ),
        Container(
            width: 80,
            height: 30,
            child: Text(
              widget.label,
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}

class LabeledRadioButtons extends StatefulWidget {

  const LabeledRadioButtons({Key key}) : super(key: key);
  @override
  _LabeledRadioButtonsState createState() => _LabeledRadioButtonsState();
}

class _LabeledRadioButtonsState extends State<LabeledRadioButtons> {
  int _enjoyOrNot;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
              activeColor: kDarkPrimaryColor,
              value: 0,
              groupValue: _enjoyOrNot,
              onChanged: (value) {
                setState(() {
                  _enjoyOrNot = value;
                });
              }),
          Text(
            '하자',
            style: TextStyle(fontSize: 45),
          ),
          SizedBox(
            width: 20,
          ),
          Radio(
            activeColor: kDarkPrimaryColor,
            value: 1,
            groupValue: _enjoyOrNot,
            onChanged: (value) {
              setState(() {
                _enjoyOrNot = value;
              });
            },
          ),
          Text(
            '놀자',
            style: TextStyle(fontSize: 45),
          ),
        ],
      ),
    );
  }
}
