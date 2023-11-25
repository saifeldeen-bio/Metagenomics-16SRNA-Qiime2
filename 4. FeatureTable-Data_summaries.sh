qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv
 
 
 # Output visualizations
 
 # 1. table.qzv
 
 # 2. rep-seqs.qzv
 
 
