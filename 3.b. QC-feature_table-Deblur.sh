qiime quality-filter q-score \
 --i-demux demux.qza \
 --o-filtered-sequences demux-filtered.qza \
 --o-filter-stats demux-filter-stats.qza


# Output artifacts:

# 1. demux-filtered.qza

# 2. demux-filter-stats.qza


qiime deblur denoise-16S \
  --i-demultiplexed-seqs demux-filtered.qza \
  --p-trim-length 120 \
  --o-representative-sequences rep-seqs-deblur.qza \
  --o-table table-deblur.qza \
  --p-sample-stats \
  --o-stats deblur-stats.qza

# Output artifacts:

# 1. deblur-stats.qza

# 2. table-deblur.qza

# 3.rep-seqs-deblur.qza


qiime metadata tabulate \
  --m-input-file demux-filter-stats.qza \
  --o-visualization demux-filter-stats.qzv
qiime deblur visualize-stats \
  --i-deblur-stats deblur-stats.qza \
  --o-visualization deblur-stats.qzv

# Output visualizations:

# 1. demux-filter-stats.qzv

# 2. deblur-stats.qzv

  
  
mv rep-seqs-deblur.qza rep-seqs.qza
mv table-deblur.qza table.qza

#Output artifacts

# 1. rep-seqs.qza
# 2. table.qza


# convert biom to txt
biom convert \
  -i input.biom \
  -o output.txt \
  --to-tsv
