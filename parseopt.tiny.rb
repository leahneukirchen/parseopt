def parseopt(p,o=z=v={})
  $1?(break o[v]=z[0]?z*'':$*.shift):o[v]=(o[v]||"-")+v while p=~/#{v,*z=*z;v}(:)?/&&v while$*[0]&&(z=$*[0].chars).shift=="-"&&$*.shift!="--";o
end
