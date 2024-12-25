enum levels{normal,full,low,empty}

String checkLevels(double high,double low,double val){
  // double mean = (high+low)/2;
  if(val>=high){
    return "Full";
  }else{  
    if(val>high-20 && val<=high){
      return "Almost Full";  
  }else{
    if(val<low+10 && val>=low ){
      return "Almost empty";
    }else{
      if(val<=low){
        return "Empty";
      }else{
        return "Normal";
      }
    }
  }
}

}

