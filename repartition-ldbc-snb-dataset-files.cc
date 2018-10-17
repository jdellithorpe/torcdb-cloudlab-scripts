#include <cstdio>
#include <fstream>
#include <iostream>
#include <dirent.h>
#include <string.h>
#include <vector>
#include <regex>
#include <sys/stat.h>

using namespace std;

int main(int argc, char* argv[]) {
  if (argc != 4) {
    printf(
        "For each LDBC SNB node type and edge type in a given dataset,\n"
        "re-partition the CSV files into N equally sized partitions.\n"
        "\n"
        "Usage: repartition-ldbc-snb-dataset-files DATASET_DIR OUTPUT_DIR N\n"
        "  DATASET_DIR     LDBC SNB dataset directory containing\n"
        "                  social_network/ and\n"
        "                  social_network_supplementary_files/ directories.\n"
        "  OUTPUT_DIR      Directory to place new dataset files.\n"
        "  N               Number of partitions to evenly divide data into.\n"
        );
    return -1;
  }

  string dataset_dir = argv[1];
  string output_dir = argv[2];
  int partitions = atoi(argv[3]);

//  string social_network_dir = dataset_dir + "/social_network";
//  string social_network_supp_dir = dataset_dir + "/social_network_supplementary_files";
//  string output_social_network_dir = output_dir + "/social_network";
//  string output_social_network_supp_dir = output_dir + "/social_network_supplementary_files";

  // Make the output directories if needed
//  mkdir(output_social_network_dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
//  mkdir(output_social_network_supp_dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);

  string entity_types[] {
      "comment", 
      "forum", 
      "organisation", 
      "person", 
      "place", 
      "post", 
      "tag", 
      "tagclass", 
      "comment_hasCreator_person", 
      "comment_hasCreator_person_ridx", 
      "comment_hasTag_tag", 
      "comment_hasTag_tag_ridx", 
      "comment_isLocatedIn_place", 
      "comment_isLocatedIn_place_ridx", 
      "comment_replyOf_comment", 
      "comment_replyOf_comment_ridx", 
      "comment_replyOf_post", 
      "comment_replyOf_post_ridx", 
      "forum_containerOf_post", 
      "forum_containerOf_post_ridx", 
      "forum_hasMember_person", 
      "forum_hasMember_person_ridx", 
      "forum_hasModerator_person", 
      "forum_hasModerator_person_ridx", 
      "forum_hasTag_tag", 
      "forum_hasTag_tag_ridx", 
      "organisation_isLocatedIn_place", 
      "organisation_isLocatedIn_place_ridx", 
      "person_email_emailaddress", 
      "person_hasInterest_tag", 
      "person_hasInterest_tag_ridx", 
      "person_isLocatedIn_place", 
      "person_isLocatedIn_place_ridx", 
      "person_knows_person", 
      "person_likes_comment", 
      "person_likes_comment_ridx", 
      "person_likes_post", 
      "person_likes_post_ridx", 
      "person_speaks_language", 
      "person_studyAt_organisation", 
      "person_studyAt_organisation_ridx", 
      "person_workAt_organisation", 
      "person_workAt_organisation_ridx", 
      "place_isPartOf_place", 
      "place_isPartOf_place_ridx", 
      "post_hasCreator_person", 
      "post_hasCreator_person_ridx", 
      "post_hasTag_tag", 
      "post_hasTag_tag_ridx", 
      "post_isLocatedIn_place", 
      "post_isLocatedIn_place_ridx", 
      "tagclass_isSubclassOf_tagclass", 
      "tagclass_isSubclassOf_tagclass_ridx", 
      "tag_hasType_tagclass", 
      "tag_hasType_tagclass_ridx"};

  string input_data_directories[] {dataset_dir + "/social_network", dataset_dir + "/social_network_supplementary_files"};
  string output_data_directories[] {output_dir + "/social_network", output_dir + "/social_network_supplementary_files"};

  for (int j = 0; j < 2; j++) {
    string social_network_dir = input_data_directories[j];
    string output_social_network_dir = output_data_directories[j];

    mkdir(output_social_network_dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);

    DIR *dir;
    struct dirent *ent;
    vector<string> file_listing;
    if ((dir = opendir(social_network_dir.c_str())) != NULL) {
      while ((ent = readdir(dir)) != NULL) {
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
          continue;

        file_listing.emplace_back(ent->d_name);
      }
      closedir(dir);
    } else {
      /* could not open directory */
      perror ("");
      return EXIT_FAILURE;
    }

    // Partition the edge files in social_network/
    for (string type : entity_types) {
      printf("Processing %s/%s\n", social_network_dir.c_str(), type.c_str());

      bool is_edge = false;
      if (type.find("_") != string::npos)
        is_edge = true;

      // Parse out source dataset files for this node type from master list
      char pattern[256];
      sprintf(pattern, "^%s_[0-9]*_[0-9]*.csv", type.c_str());
      regex r(pattern);
      vector<string> type_file_listing;
      for (string file : file_listing) {
        if (regex_match(file, r))
          type_file_listing.emplace_back(file);
      }

      if (!type_file_listing.empty()) {
        // Open output files, one for each partition
        ofstream outfiles[partitions];
        for (int i = 0; i < partitions; i++) {
          char filename[256];
          sprintf(filename, "%s/%s_%d_0.csv", output_social_network_dir.c_str(), type.c_str(), i);
          outfiles[i].open(filename);
        }

        // Spread data across output files
        bool headers_written = false;
        long entity_count = 0;
        long last_id = -1;
        for (string type_file : type_file_listing) {
          ifstream infile(social_network_dir + "/" + type_file);
          string line;
          bool first_line = true;
          while(getline(infile, line)) {
            if (first_line == true) {
              if (headers_written == false) {
                for (int i = 0; i < partitions; i++)
                  outfiles[i] << line << endl;
                headers_written = true;
              }

              first_line = false;
              continue;
            }
        
            if (is_edge) { 
              long this_id = atol(line.substr(0,line.find_first_of('|')).c_str());

              if (last_id != -1 && this_id != last_id) {
                entity_count++;
              }

              last_id = this_id;
              
              outfiles[entity_count % partitions] << line << endl;
            } else {
              outfiles[entity_count % partitions] << line << endl;

              entity_count++;
            }
          }
        }
      }
    }
  }

  return 0;
}
