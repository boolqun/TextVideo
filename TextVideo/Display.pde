//************************************************************************
//文本显示
//************************************************************************

PGraphics showMain;  //文本显示//
PVector showPointNow,showPointPlan,showPointOffest;  //当前显示坐标//计划显示坐标//显示坐标的偏移量
PVector tempPointNext;  //下一个坐标点
float showScaleNow,showScalePlan;  //当前缩放值//计划缩放值
float showRotateNow, showRotatePlan,showRotateState;  //当前旋转值//计划旋转值//旋转状态记录
int showIndexNow,showIndexOld;  //当前显示索引//历史显示索引
float textHeightNow,textHeightOld;  //当前文字高度//历史文字高度
float textWidthNow,textWidthOld;  //当前文字宽度//历史文字宽度

//显示参数初始化
void IniShow(){
    showIndexNow =0;  //当前显示索引
    showIndexOld =-1;   //历史显示索引
    showPointNow = new PVector(0,0);  //当前显示坐标
    showPointPlan = new PVector(0,0);  //计划显示坐标
    showPointOffest  = new PVector(0,0);  //显示坐标的偏移量
    tempPointNext = new PVector(0,0);  //下一个坐标点
    showScaleNow =1;  //当前缩放值
    showScalePlan =1;  //计划缩放值
    showRotateNow =0;  //当前旋转值
    showRotatePlan =0;  //计划旋转值
    showRotateState =0;  //旋转状态记录
    
    showMain = createGraphics(5000,5000);  //文本显示//
    showMain.beginDraw();
    showMain.textFont(createFont( textsFont , 32, true));  //文本字体
    showMain.textAlign(LEFT,CENTER);  //文本对齐
    tempPointNext.set( showMain.width/2, 0 );
    CoorMove(showMain,tempPointNext,showPointPlan,showRotateState);  //移动坐标
    showPointNow = showPointPlan.copy();
    showMain.pushMatrix();  
    showMain.endDraw();
    
    //imageMode(CENTER);
    imageMode(CORNER);
}


//显示控制
void ShowRun(){
    showIndexNow = GetIndexShow();  //当前显示索引
    if(showIndexNow != showIndexOld ){  //有新的文本要显示
        showMain.beginDraw();
        TextUpdate( (String)textMain[showIndexNow][1]  ); //文本更新
        showMain.endDraw();
        showIndexOld = showIndexNow;  //历史显示索引
        showPointOffest = PVector.sub(showPointPlan,showPointNow);  //显示坐标的偏移量
        showPointOffest.normalize();  //计算步长
    }
    Display();  //文本屏幕显示
    
}

//文本更新
void TextUpdate(String tempStr){
    showMain.textSize(round( random(textsSize[0],textsSize[1]) ));
    showMain.fill( textsColor[showIndexNow % textsColor.length]);
    stroke(textsColor[showIndexNow % textsColor.length]);
    textHeightNow = showMain.textAscent()+showMain.textDescent() +5 ;  //当前文字高度
    textWidthNow = showMain.textWidth( tempStr ) ;  //当前文字宽度
    showScalePlan = 1 / map( showMain.textSize , textsSize[0],textsSize[1], 1/1.2,2);  //计划缩放值
    
    showMain.popMatrix();
    if( showIndexNow % limitRotateSwitch ==0 && showIndexNow >0 ) {  //是否旋转
        showRotatePlan = GetRotateNext( showRotateState ) ;  //计划旋转值
        
        tempPointNext.set(-15,10);  //下一个坐标点
        if( showRotatePlan > 0  )   tempPointNext.set(textWidthOld+10,10);  //下一个坐标点
        CoorMove(showMain,tempPointNext,showPointPlan,showRotateState);  //移动坐标
        
        showMain.rotate(  0-showRotatePlan );  //旋转坐标
        showRotateState -= showRotatePlan;  //旋转状态记录
        
        if( showRotatePlan > 0  ){
            tempPointNext.set( 0-textWidthNow,0 );
            CoorMove(showMain,tempPointNext,showPointPlan,showRotateState);  //移动坐标
        }
    }
    else {
        if( (textsSize[1]+textsSize[0])/2 > showMain.textSize )  tempPointNext.set(0, textHeightNow +10 );  //下一个坐标点
        else                                                        tempPointNext.set(0, textHeightNow );  //下一个坐标点
        CoorMove(showMain,tempPointNext,showPointPlan,showRotateState);  //移动坐标
    }
    showMain.pushMatrix();
    textWidthOld = textWidthNow;  //当前文字宽度//历史文字宽度
    textHeightOld = textHeightNow;  //当前文字高度//历史文字高度
    
    showMain.text(tempStr, 0, 0);  //添加文字
}

//文本屏幕显示
void Display(){
    EffectMove(showPointNow,showPointPlan,showPointOffest,speedMove);  //移动效果控制
    showScaleNow = EffectScale(showScaleNow,showScalePlan ,speedScale);  //缩放效果控制
    showRotateNow = EffectRotate(showRotateNow, -showRotateState ,speedRotate);  //旋转效果控制
    
    translate(width/3, height/2);
    scale(showScaleNow);  //缩放
    line(0,textHeightNow,textWidthNow,textHeightNow);  //划线
    rotate( showRotateNow );  //旋转
    image(showMain, -showPointNow.x, -showPointNow.y );  //屏幕显示文字
}