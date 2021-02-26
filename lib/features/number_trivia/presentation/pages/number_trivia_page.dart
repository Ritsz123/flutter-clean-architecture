import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:clean_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => sl<NumberTriviaBloc>(),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: "Start Searching",
                      );
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message);
                    }
                    return Container(
                      color: Colors.amber,
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TriviaControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) => inputString = value,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: RaisedButton(
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 18),
                ),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: RaisedButton(
                child: Text(
                  "Get random trivia",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }
}
