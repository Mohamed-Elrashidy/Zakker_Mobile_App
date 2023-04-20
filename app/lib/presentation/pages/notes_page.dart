import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/utils/dummy_data.dart';
import 'package:app/utils/note_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';
import '../../utils/routes.dart';
import '../widgets/small_text.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Dimension scaleDimension;
  late List<Note> notes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaleDimension = GetIt.instance.get<Dimension>();
    notes = [];
    BlocProvider.of<NoteCubit>(context).getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              _appBarBuilder(),
              _tabBarBuilder(),
              SizedBox(
                height: scaleDimension.scaleHeight(20),
              ),
              _bodyBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/notes_page_logo.svg",
                  semanticsLabel: 'Acme Logo',
                ),
                SizedBox(
                  width: scaleDimension.scaleWidth(10),
                ),
                BigText(text: "Your Notes")
              ],
            ),
            Spacer(),
            MainButton(
                title: "Add note",
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.addNotePage);
                })
          ],
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
          width: scaleDimension.screenWidth,
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Container(
        height: scaleDimension.scaleHeight(400),
        child: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is AllNotesLoaded) {
              notes = (state).allNotes;
            } else if (state is FavouriteNotesLoaded) {
              notes = (state.favouriteNotes);
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _noteWidgetBuilder(notes[index]),
                    SizedBox(
                      height: scaleDimension.scaleHeight(20),
                    )
                  ],
                );
              },
            );
          },
        ));
  }

  Widget _tabBarBuilder() {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        int x=0;
        if(state is AllNotesLoaded)
          {
            x=0;
          }
        else if(state is FavouriteNotesLoaded)
          {
            x=2;
          }
        print("x is here"+x.toString());
        return Container(
          width: scaleDimension.screenWidth,
          height: scaleDimension.scaleHeight(50),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(
                  scaleDimension.scaleWidth(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MainButton(
                title: "Notes",
                onTap: () {
                  BlocProvider.of<NoteCubit>(context).getAllNotes();
                },
                buttonColor:(x==0)?Colors.black: Colors.grey[200]!,
                textColor: (x==0)?Colors.white:Colors.grey,
              ),
              MainButton(
                title: "Session",
                onTap: () {},
                buttonColor:(x==1)?Colors.black: Colors.grey[200]!,
                textColor: (x==1)?Colors.white:Colors.grey,
              ),
              MainButton(
                title: "Favourites",
                onTap: () {
                  BlocProvider.of<NoteCubit>(context).getFavouriteNotes();

                },
                buttonColor:(x==2)?Colors.black: Colors.grey[200]!,
                textColor: (x==2)?Colors.white:Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _noteWidgetBuilder(Note note) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(Routes.notePage, arguments: note);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: scaleDimension.scaleWidth(20),
            vertical: scaleDimension.scaleHeight(10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
            color: NoteColors.color[note.color]!.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(text: note.title),
            SizedBox(
              height: scaleDimension.scaleHeight(5),
            ),
            NormalText(
              text: note.body,
              maxline: 2,
              color: Colors.grey,
            ),
            SizedBox(
              height: scaleDimension.scaleHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallText(
                  text: '${note.category} | ${note.source}',
                  isBold: true,
                ),
                SmallText(
                  text: note.date,
                  isBold: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
