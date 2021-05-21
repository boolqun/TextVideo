//************************************************************************
//显示效果控制
//************************************************************************


//获取当前显示文本的索引
int GetIndexShow(){
    if(textMain.length ==0) return -1;
    for(int s=0;s<textMain.length;s++){
        if( (float)textMain[s][0]*1000 + readyTime > (millis()))   return s;
    }
    return textMain.length-1;
}

//获取旋转角度
//角度有随机值，会出现文字重叠情况
float GetRotateNext(float rAngleState){
    if( rAngleState > PI/4  )     return PI/2;
    if( rAngleState < -PI/4 )     return -PI/2;
    if(random(0,1)>0.5)  return PI/2;
    else                 return -PI/2;    
}

//移动坐标
void CoorMove(PGraphics tShow ,PVector vecStep,PVector vecRecord,float tRotateNow){
    tShow.translate( vecStep.x, vecStep.y );  //转移坐标
    if( tRotateNow ==0 ) vecRecord.add( vecStep.x, vecStep.y );
    if( tRotateNow > 0 ) vecRecord.add( 0-vecStep.y, vecStep.x );
    if( tRotateNow < 0 ) vecRecord.add( vecStep.y, 0-vecStep.x );
}

//移动效果控制
void EffectMove(PVector vecNow,PVector vecAim,PVector vecStep,int speedUp){
    for(int h=0;h< speedUp;h++){
        if( PVector.dist(vecAim,vecNow)<=1 ){
            vecNow = vecAim.copy();
            break;
        }
        else if( PVector.dist(vecAim,vecNow) >30*speedUp )  vecNow.add(vecStep.copy().mult(15));  //距离太远，需要加速
        vecNow.add(vecStep);
    }
}

//缩放效果控制
float EffectScale(float sNow,float sAim,float sOffest){
    if( abs(sAim-sNow) <= sOffest )   return sAim;
    for(int s=0;s<1;s++){
        //if( abs(sAim-sNow)>= sOffest*30)   s--;
        if( sAim > sNow )            sNow += sOffest;
        else                         sNow -= sOffest;
    }
    return sNow;
}

//旋转效果控制
float EffectRotate(float rNow,float rAim,float rOffest){
    if( abs(rAim-rNow) <= rOffest )   return rAim;
    for(int s=0;s<1;s++){
        //if( abs(rAim-rNow)>= rOffest*30)  s--;
        if( rAim > rNow )            rNow += rOffest;
        else                         rNow -= rOffest;
    }
    return rNow;
}