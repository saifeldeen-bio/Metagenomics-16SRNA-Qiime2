qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences rep-seqs-dada2.qza \
  --o-table table-dada2.qza \
  --o-denoising-stats stats-dada2.qza
  

# Output artifacts:

# 1. stats-dada2.qza

# 2. table-dada2.qza

# 3. rep-seqs-dada2.qza



qiime metadata tabulate \
  --m-input-file stats-dada2.qza \
  --o-visualization stats-dada2.qzv
  
# Output visualizations
# stats-dada2.qzv

mv rep-seqs-dada2.qza rep-seqs.qza
mv table-dada2.qza table.qza

#Output artifacts

# 1. rep-seqs.qza
# 2. table.qza


# convert biom to txt
biom convert \
  -i input.biom \
  -o output.txt \
  --to-tsv
