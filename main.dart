import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(debugShowCheckedModeBanner:false, theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff1765c0)),useMaterial3:true), home:Home(cameras:cameras)));
}
const letters=['ا','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','و','ي','ء'];
const words=['مرحباً','السلام عليكم','وعليكم السلام','شكراً','من فضلك','نعم','لا','أنا','أنت','ماء','أكل','شرب','مساعدة','أين؟','مع السلامة'];
class Home extends StatelessWidget {
 final List<CameraDescription> cameras; const Home({super.key,required this.cameras});
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.record_voice_over,size:90,color:Color(0xff1765c0)),const Text('صوتك',style:TextStyle(fontSize:44,fontWeight:FontWeight.bold,color:Color(0xff123a78))),const Text('SAWTAK',style:TextStyle(letterSpacing:3)),const SizedBox(height:35),SizedBox(width:double.infinity,height:58,child:FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Chat(cameras:cameras))),child:const Text('إنشاء محادثة',style:TextStyle(fontSize:20))))])))));
}
class Chat extends StatefulWidget {final List<CameraDescription> cameras;const Chat({super.key,required this.cameras});@override State<Chat> createState()=>_ChatState();}
class _ChatState extends State<Chat>{
 CameraController? cam; final tts=FlutterTts(); String text='وجّه يدك نحو الكاميرا'; bool ready=false;
 @override void initState(){super.initState();tts.setLanguage('ar');tts.setSpeechRate(.45);initCam();}
 Future<void> initCam()async{if(widget.cameras.isEmpty)return;final front=widget.cameras.where((c)=>c.lensDirection==CameraLensDirection.front);cam=CameraController(front.isNotEmpty?front.first:widget.cameras.first,ResolutionPreset.medium,enableAudio:false);try{await cam!.initialize();if(mounted)setState(()=>ready=true);}catch(_){if(mounted)setState(()=>text='تعذر تشغيل الكاميرا');}}
 void choose(String s){setState(()=>text=s);tts.stop();tts.speak(s);}
 @override void dispose(){cam?.dispose();tts.stop();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('محادثة صوتك')),body:Column(children:[Expanded(flex:6,child:Container(margin:const EdgeInsets.all(12),clipBehavior:Clip.antiAlias,decoration:BoxDecoration(borderRadius:BorderRadius.circular(20)),child:ready?CameraPreview(cam!):const Center(child:CircularProgressIndicator()))),Expanded(flex:4,child:Padding(padding:const EdgeInsets.all(12),child:Column(children:[Container(width:double.infinity,padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xffe3eeff),borderRadius:BorderRadius.circular(18)),child:Row(children:[Expanded(child:Text(text,textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold))),IconButton(onPressed:()=>tts.speak(text),icon:const Icon(Icons.volume_up))])),const Text('أزرار اختبار النص والنطق — ليست تعرفاً بصرياً'),const SizedBox(height:6),Expanded(child:ListView(scrollDirection:Axis.horizontal,children:letters.map((s)=>Padding(padding:const EdgeInsets.all(3),child:OutlinedButton(onPressed:()=>choose(s),child:Text(s)))).toList())),Expanded(child:ListView(scrollDirection:Axis.horizontal,children:words.map((s)=>Padding(padding:const EdgeInsets.all(3),child:OutlinedButton(onPressed:()=>choose(s),child:Text(s)))).toList()))])))]));
}
