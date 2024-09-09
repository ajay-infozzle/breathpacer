import 'package:breathpacer/utils/custom_button.dart';
import 'package:flutter/material.dart';

class SaveCustomDialogBoxWidget extends StatefulWidget {
  const SaveCustomDialogBoxWidget({super.key, required this.onClose, required this.onSave, required this.controller});

  final VoidCallback onClose;
  final VoidCallback onSave;
  final TextEditingController controller;

  @override
  State<SaveCustomDialogBoxWidget> createState() => _SaveCustomDialogBoxWidgetState();
}

class _SaveCustomDialogBoxWidgetState extends State<SaveCustomDialogBoxWidget> with SingleTickerProviderStateMixin{

  late AnimationController animController;
  late Animation<Offset> positionOfAnim;
  late Animation<double> scaleAnim;


  @override
  void initState() {
    super.initState();

    animController = AnimationController(duration: const Duration(milliseconds: 500),vsync: this);

    positionOfAnim = Tween<Offset>(
      begin: const Offset(1, -50),
      end: Offset.zero
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOut));

    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOut));
  }

  void closeAnimation(){
    animController.reverse().then((_){
      animController.reset();
    });
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    animController.forward();
    double size = MediaQuery.of(context).size.width;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: animController,
          builder: (context, child) {
            return Transform.translate(
              offset: positionOfAnim.value,
              child: Transform.scale(
                scale: scaleAnim.value,
                child: Container(
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
                            // onPressed: widget.onClose, 
                            onPressed: () {
                              closeAnimation();
                              widget.onClose();
                            }, 
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
                          controller: widget.controller,
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
                          // onPress: widget.onSave
                          onPress: () {
                            closeAnimation();
                            widget.onSave() ;
                          },
                        )
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}