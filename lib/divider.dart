import 'package:flutter/material.dart';

class Div extends StatelessWidget {
  const Div({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
                'Vrikshveda',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                )
            ),
          ),
        ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/1.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: Expanded(
          child:Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: (){
                    Navigator.pushNamed(context, '/plant');
                  },
                    child: Expanded(
                      child: Card(
                        elevation: 500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Image.asset(
                            'assets/project.png',
                          alignment: Alignment.center,
                              width: double.infinity,
                              fit: BoxFit.fill,

                            ),
                      ),
                    ),
                    ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/disease');
                    },
                    child: Expanded(
                      child: Card(
                        elevation: 500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/project1.png',
                          alignment: Alignment.center,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          // color: Color(0xFF2F6847),
                          // opacity: AlwaysStoppedAnimation(.5),
                          // colorBlendMode: BlendMode.hardLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
