//************************************************************************
//导入文字
//注意：文本文件的编码格式为“UTF-8 无BOM”，否则中文会出现乱码。
//************************************************************************

//获取显示文本
void GetTextMain(){ 
    String[] textLines;  //文本数组//从文件导入
    String[] textRow;  //文本行内容
    
    textLines = TextInput(textPath);  //文本数组//
    textMain = new Object[textLines.length][2];  //要显示的文字数组
    for(int t=0;t<textLines.length;t++){
        if( !(textLines[t].contains("[") && textLines[t].contains("]") && textLines[t].contains(":")) ){
            continue;  //格式不符合
        }
        textRow = textLines[t].split("]");  //文本行内容
        if( textRow.length==1 ) textRow = new String[]{textRow[0],""};  //没有内容
        textRow[0]=(textRow[0].substring(textRow[0].indexOf("[")+1)); 
        textMain[t][0]= float(textRow[0].split(":")[0])*60 + float(textRow[0].split(":")[1]);   //文本时间
        textMain[t][1]=textRow[1];  //文本内容
    }
}


//导入文本
String[] TextInput(String tPath){
    String[] textLines = {};  //文本数组//从文件导入

    textLines =  loadStrings(tPath);  //文本数组
    println("一共导入 " + textLines.length + " 行文本");
    for (int p = 0 ; p < textLines.length; p++) {
        println(textLines[p]);
    }
    return textLines;
}