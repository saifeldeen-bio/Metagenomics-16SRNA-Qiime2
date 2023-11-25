qiime demux emp-single \
  --i-seqs emp-single-end-sequences.qza \
  --m-barcodes-file sample-metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences demux.qza \
  --o-error-correction-details demux-details.qza

# Output artifacts:
# 1. demux-details.qza
# 2. demux.qza
  
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv
  

# Output visualizations:
# demux.qzv

