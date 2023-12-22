import 'package:flutter/material.dart';
class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, this.text,required this.ontap, this.clr,this.txtclr});
  final String? text;
  final Widget? ontap;
  final Color? clr;
  final Color? txtclr;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (e)=>ontap! ));
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration:BoxDecoration(
          color: clr! ,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50)
          ),
        ),

        child:Text(
            text!,
        textAlign: TextAlign.center,
        style:
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: txtclr!,
        ),),

      ),
    );
  }
}
