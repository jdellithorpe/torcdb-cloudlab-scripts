#!/bin/bash

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
for edgetype in comment_hasCreator_person comment_hasTag_tag comment_isLocatedIn_place comment_replyOf_comment comment_replyOf_post forum_containerOf_post forum_hasMember_person forum_hasModerator_person forum_hasTag_tag organisation_isLocatedIn_place person_email_emailaddress person_hasInterest_tag person_isLocatedIn_place person_knows_person person_likes_comment person_likes_post person_speaks_language person_studyAt_organisation person_workAt_organisation place_isPartOf_place post_hasCreator_person post_hasTag_tag post_isLocatedIn_place tagclass_isSubclassOf_tagclass tag_hasType_tagclass
do
  edgetypecount=0
  for file in $(ls ${DATASET}/social_network/${edgetype}_[0-9]*_0.csv)
  do
    subcount=$(wc -l ${file} | awk '{print $1}')
    (( edgetypecount += subcount - 1 ))
  done

  echo "  $edgetype: $edgetypecount"

  (( globaledgecount += edgetypecount ))

done

echo "  Total: $globaledgecount"
