import 'package:breathpacer/utils/custom_button.dart';
import 'package:flutter/material.dart';

class SaveCustomDialogBoxWidget extends StatelessWidget {
  const SaveCustomDialogBoxWidget({super.key, required this.onClose, required this.onSave, required this.controller});

  final VoidCallback onClose;
  final VoidCallback onSave;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: size*0.05),
          padding: EdgeInsets.symmetric(horizontal: size*0.03, vertical: size*0.035),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Save breathwork as",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontWeight: FontWeight.bold,
                      fontSize: size*0.06
                    ),
                  ),
                  SizedBox(width: size*0.02,),
                  IconButton(
                    onPressed: onClose, 
                    icon: Icon(Icons.close,color: Colors.black.withOpacity(.5),size: 30,)
                  ),
                ],
              ),

              Container(
                width: size,
                margin: EdgeInsets.only(top: size*0.02, bottom: size*0.06),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextFormField(
                  controller: controller,
                  cursorWidth: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    hintText: "Enter breathwork name",
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(.7),
                        fontWeight: FontWeight.w400,
                        fontSize: null
                    ),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: null),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
        
              SizedBox(
                width: size,
                child: CustomButton(
                  title: "Save breathwork", 
                  textsize: size*0.043,
                  height: 48,
                  spacing: .7,
                  radius: 10,
                  onPress: onSave
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}