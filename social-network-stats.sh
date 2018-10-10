#!/bin/bash

if [[ $# != 1 ]]
then
  echo "Calculate statistics on a LDBC SNB dataset."
  echo ""
  echo "Usage: social-network-stats.sh DATASET_DIR"
  echo "  DATASET_DIR      Location of the dataset. Expects social_network/ "
  echo "                   and social_network_supplementary_files/ in this "
  echo "                   directory."

  exit
fi

DATASET=$1

echo "Size on disk: $(du -hs ${DATASET}/social_network | awk '{print $1}')"

echo "Nodes:"

globalnodecount=0
for nodetype in comment forum organisation person place post tag tagclass
do
  nodetypecount=0
  for file in $(ls ${DATASET}/social_network/${nodetype}_[0-9]*_0.csv)
  do
    subcount=$(wc -l ${file} | awk '{print $1}')
    (( nodetypecount += subcount - 1 ))
  done

  echo "  $nodetype: $nodetypecount"

  (( globalnodecount += nodetypecount ))
done

echo "  Total: $globalnodecount"

echo "Edges:"

globaledgecount=0
for edgetype in comment_hasCreator_person comment_hasTag_tag comment_isLocatedIn_place comment_replyOf_comment comment_replyOf_post forum_containerOf_post forum_hasMember_person forum_hasModerator_person forum_hasTag_tag organisation_isLocatedIn_place person_hasInterest_tag person_isLocatedIn_place person_knows_person person_likes_comment person_likes_post person_studyAt_organisation person_workAt_organisation place_isPartOf_place post_hasCreator_person post_hasTag_tag post_isLocatedIn_place tagclass_isSubclassOf_tagclass tag_hasType_tagclass
do
  edgecount=0
  edgelistcount_out=0
  edgelistcount_in=0

  # Count the total number of edges and also the number of out-bound edge lists,
  # which is the number of source vertices. In the case of person_knows_person
  # we need to use the dual file in the supplementary directory, handled in the
  # for loop below.
  for file in $(ls ${DATASET}/social_network/${edgetype}_[0-9]*_0.csv)
  do
    edgesubcount=$(wc -l ${file} | awk '{print $1}')
    (( edgecount += edgesubcount - 1 ))

    if [[ ${edgetype} != "person_knows_person" ]]
    then
      edgelistsubcount_out=$(cat ${file} | cut -d'|' -f1 | uniq | wc -l)
      (( edgelistcount_out += edgelistsubcount_out - 1 ))
    fi
  done

  # Count the total number of in-bound edge lists, which is the total number of 
  # destination vertices. In the case of person_knows_person, we really have no
  # in-bound edges, because all the knows edges are actually out-bound in TorcDB
  # and the dual file contains this information.
  if [[ ${edgetype} == "person_knows_person" ]]
  then
    for file in $(ls ${DATASET}/social_network_supplementary_files/${edgetype}_[0-9]*_0.csv)
    do
      edgelistsubcount_out=$(cat ${file} | cut -d'|' -f1 | uniq | wc -l)
      (( edgelistcount_out += edgelistsubcount_out - 1 ))
    done
  else
    for file in $(ls ${DATASET}/social_network_supplementary_files/${edgetype}_ridx_[0-9]*_0.csv)
    do
      edgelistsubcount_in=$(cat ${file} | cut -d'|' -f1 | uniq | wc -l)
      (( edgelistcount_in += edgelistsubcount_in - 1 ))
    done
  fi


  echo "  $edgetype edge count: $edgecount"
  echo "  $edgetype OUT edge list count: $edgelistcount_out"
  echo "  $edgetype IN edge list count: $edgelistcount_in"

  (( globaledgecount += edgecount ))

done

echo "  Total: $globaledgecount"
