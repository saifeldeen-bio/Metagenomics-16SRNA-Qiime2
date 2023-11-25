qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1103 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results
  
  
 
# Output artifacts:

# 1. core-metrics-results/faith_pd_vector.qza

# 2. core-metrics-results/unweighted_unifrac_distance_matrix.qza

# 3. core-metrics-results/bray_curtis_pcoa_results.qza

# 4. core-metrics-results/shannon_vector.qza

# 5. core-metrics-results/rarefied_table.qza

# 6. core-metrics-results/weighted_unifrac_distance_matrix.qza

# 7. core-metrics-results/jaccard_pcoa_results.qza

# 8. core-metrics-results/weighted_unifrac_pcoa_results.qza

# 9. core-metrics-results/observed_features_vector.qza

# 10. core-metrics-results/jaccard_distance_matrix.qza

# 11. core-metrics-results/evenness_vector.qza

# 12. core-metrics-results/bray_curtis_distance_matrix.qza

# 13. core-metrics-results/unweighted_unifrac_pcoa_results.qza

# Output visualizations:

# 1. core-metrics-results/unweighted_unifrac_emperor.qzv

# 2. core-metrics-results/jaccard_emperor.qzv

# 3. core-metrics-results/bray_curtis_emperor.qzv

# 4. core-metrics-results/weighted_unifrac_emperor.qzv	


#first test for associations between categorical metadata columns and alpha diversity data for Faith Phylogenetic Diversity (a measure of community richness) and evenness metrics.

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
  
  
  
# Output visualizations:

# 1. core-metrics-results/faith-pd-group-significance.qzv
# 2. core-metrics-results/evenness-group-significance.qzv



#Next we’ll analyze sample composition in the context of categorical metadata using PERMANOVA

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column body-site \ #select your interest column
  --o-visualization core-metrics-results/unweighted-unifrac-body-site-significance.qzv \
  --p-pairwise #perform pairwise tests that will allow you to determine which specific pairs of groups (e.g., tongue and gut) differ from one another



qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column subject \
  --o-visualization core-metrics-results/unweighted-unifrac-subject-group-significance.qzv \
  --p-pairwise
  
  
  


# Output visualizations:

# 1. core-metrics-results/unweighted-unifrac-body-site-significance.qzv
# 2. core-metrics-results/unweighted-unifrac-subject-group-significance.qzv


#PCoA
qiime emperor plot \
  --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization core-metrics-results/unweighted-unifrac-emperor-days-since-experiment-start.qzv



qiime emperor plot \
  --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization core-metrics-results/bray-curtis-emperor-days-since-experiment-start.qzv

# Output visualizations:
# 1. core-metrics-results/bray-curtis-emperor-days-since-experiment-start.qzv
# 2. core-metrics-results/unweighted-unifrac-emperor-days-since-experiment-start.qzv
