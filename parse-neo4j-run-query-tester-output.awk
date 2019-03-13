BEGIN{
  "date +\"%Y-%m-%d %T\"" | getline datetime
  hw_type="m510"
  scale=100
}

{
  if ($1 == "Min:") {
    printf $2",";
  } else if ($1 == "Max:") {
    printf $2",";
  } else if ($2 == "Percentile:") {
    if ($1 == "99th")
      printf $3"\n";
    else 
      printf $3",";
  } else {
    printf datetime","hw_type","scale","substr($1,6)","substr($0,index($0,$2),index($0,"--repeat")-index($0,$2)-1)","substr($NF,1,length($NF)-1)","
  }
}
