BEGIN{
  "date +\"%Y-%m-%d %T\"" | getline datetime
  hardware_type="m510"
  rc_servers=8
  rc_replicas=3
  rc_transport="basic+dpdk"
  dataset="sf0100"
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
    printf datetime",\""hardware_type"\","rc_servers","rc_replicas",\""rc_transport"\",\""dataset"\",\""substr($1,6)"\",\"tx=0 txapi=0\",\""substr($0,index($0,$2),index($0,"--repeat")-index($0,$2)-1)"\","substr($NF,1,length($NF)-1)","
  }
}
