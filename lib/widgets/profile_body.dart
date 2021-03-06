import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_codingpapa/constants/common_size.dart';
import 'package:flutter_instagram_codingpapa/constants/screen_size.dart';
import 'package:flutter_instagram_codingpapa/screens/profile_screen.dart';
import 'package:flutter_instagram_codingpapa/widgets/rounded_avatar.dart';

enum SelectedTab { left, right }

class ProfileBody extends StatefulWidget {
  final Function onMenuChanged;

  const ProfileBody({
    Key key,
    this.onMenuChanged,
  }) : super(key: key);
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

//* SingleTickerProviderStateMixin
class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  // bool selectedLeft = true;
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesMargin = 0;
  double _rightImagesMargin = size.width;
  AnimationController
      _iconAnimationController; // 아래 AnimatedController를 만들다 컨트롤러 필요해져서 만듬

  @override
  void initState() {
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appbar(),
          // sliverList  는  sliver로 감싼 리스트뷰
          // CustomScrollView는 Expanded로 감싸야한다. 안그러면 안보여 SliverChildListDelegate가 전체를 먹기 때문에.
          //? ProfileBody(), 대신에 아래내용.
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    _userStatus(),
                    _username(),
                    _userBio(),
                    _editProfileBtn(), //? CustomScrollView 안에 SliverList로 넣으니까 가로를 꽉 채우는 버튼이 되었다.
                    _tabButtons(),
                    _selectedIndicator(),
                  ]),
                ),
                _imagesPager(),
              ],
            ),
          ),
        ],
      ),
    );

    // sliverList  는  sliver로 감싼 리스트뷰
    // CustomScrollView는 Expanded로 감싸야한다.
    // 안그러면 안보여 SliverChildListDelegate가 전체를 먹기 때문에.
    // 일반 위젯(GridView,ListView 등)을 slivers 안에 넣을때는
    // SliverToBoxAdapter로 감싸줘야한다.
    //
    // return Expanded(
    //   child: CustomScrollView(
    //     slivers: <Widget>[
    //       SliverList(
    //         delegate: SliverChildListDelegate([
    //           _userStatus(),
    //           _username(),
    //           _userBio(),
    //           _editProfileBtn(), //? CustomScrollView 안에 SliverList로 넣으니까 가로를 꽉 채우는 버튼이 되었다.
    //           _tabButtons(),
    //           _selectedIndicator(),
    //         ]),
    //       ),
    //       _imagesPager(),
    //     ],
    //   ),
    // );
  }

  Row _appbar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 44,
        ),
        Expanded(
            child: Text(
          "The Coding Chan",
          textAlign: TextAlign.center,
        )),
        IconButton(
          // icon: Icon(Icons.menu),
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress:
                _iconAnimationController, //? 이 progress가 뭔지를 보니... 컨트롤러를 던져주는 것이네
          ),
          //! onPressed가 null 이면 아이콘이 회색. null이 아니면 활성화된다.
          onPressed: () {
            widget.onMenuChanged(); //이 함수의 내용은profileScreen에서 정의되있다.여기선 트리거역할.
            _iconAnimationController.status == AnimationStatus.completed
                ? _iconAnimationController.reverse()
                : _iconAnimationController.forward();
          },
        ),
      ],
    );
  }

  Row _userStatus() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: RoundedAvatar(
            size: 80,
          ),
        ),
        Expanded(
          child: Table(
            children: [
              TableRow(children: [
                _valueText('123123'),
                _valueText('9401274123'),
                _valueText('61'),
              ]),
              TableRow(children: [
                _lableText('Post'),
                _lableText('Followers'),
                _lableText('Following'),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Text _valueText(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Text _lableText(String lable) {
    return Text(
      lable,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
      child: Stack(children: [
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(_leftImagesMargin, 0, 0),
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(_rightImagesMargin, 0, 0),
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
      ]),
    );
  }

  GridView _images() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1,
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: "https://picsum.photos/id/$index/100")),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 2,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  Row _tabButtons() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // spaceAround로 하면 딱 이미지 크기만 터치가 가능하지만 아래처럼
      // Expanded로 감싸면 넓은 범위를 터치할수있게되니 이게 더 좋다.
      children: <Widget>[
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/images/grid.png'),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black
                  : Colors.black26,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.left);
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/images/saved.png'),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black26
                  : Colors.black,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.right);
            },
          ),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesMargin = 0;
          _rightImagesMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesMargin = -size.width;
          _rightImagesMargin = 0;
          break;
      }
    });
  }

  // Widget _selectedIndicator() {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 300),
  //     alignment: _selectedTab == SelectedTab.left
  //         ? Alignment.centerLeft
  //         : Alignment.centerRight,
  //     child: Container(
  //       height: 2,
  //       width: size.width / 2,
  //       color: Colors.black87,
  //     ),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  // Row _tabButtons() {
  //   return Row(
  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     // spaceAround로 하면 딱 이미지 크기만 터치가 가능하지만 아래처럼
  //     // Expanded로 감싸면 넓은 범위를 터치할수있게되니 이게 더 좋다.
  //     children: <Widget>[
  //       Expanded(
  //         child: IconButton(
  //           icon: ImageIcon(
  //             AssetImage('assets/images/grid.png'),
  //             color: _selectedTab == SelectedTab.left
  //                 ? Colors.black
  //                 : Colors.black26,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               _selectedTab = SelectedTab.left;
  //             });
  //           },
  //         ),
  //       ),
  //       Expanded(
  //         child: IconButton(
  //           icon: ImageIcon(
  //             AssetImage('assets/images/saved.png'),
  //             color: _selectedTab == SelectedTab.left
  //                 ? Colors.black26
  //                 : Colors.black,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               _selectedTab = SelectedTab.right;
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        "username",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        "This is what I believe!!",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

// enum SelectedTab { left, right }
