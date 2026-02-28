import 'package:flutter/material.dart';

import '../../main.dart';
class ReuseableContainer extends StatelessWidget {
  String differentImages;
  String text;
  VoidCallback onTap;
  ReuseableContainer({super.key,required this.differentImages,required this.text,required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;

    return  InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(mq.width * 0.02),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0XFFDCEDC8),
          border: Border.all(
            width: 1,
            color: const Color(0xFFC5E1A5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 0), // Only at the bottom
            ),
          ],
        ),

              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(),
                      height: mq.height * 0.2,
                      width: mq.width * 0.04,
                      child: ClipRRect(
                        //borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          differentImages,
                          fit: BoxFit
                              .contain, // Ensures the image fits within the container
                        ),
                      ),
                    ),
                  ),
                    Padding(
                      padding: EdgeInsets.only(bottom: mq.width*0.02),
                      child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                    )

                  // Center(child: Text(countValue,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.green),textAlign: TextAlign.center,),)
                ],
              ),

      ),
    );
  }
}


