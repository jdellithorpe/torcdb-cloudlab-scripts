BEGIN{
  "date +\"%Y-%m-%d %T\"" | getline datetime
  hw_type="m510"
  rc_s=4
  rc_r=3
  rc_transport="basic+dpdk"
  scale=1
  query_config="tx=0 txapi=0"
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
    printf datetime","hw_type","rc_s","rc_r","rc_transport","scale","substr($1,6)","query_config","substr($0,index($0,$2),index($0,"--repeat")-index($0,$2)-1)","substr($NF,1,length($NF)-1)","
  }
}
