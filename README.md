# Metagenomics-16SRNA-Qiime2
Metagenomics involves studying genetic material directly extracted from environmental samples, providing insights into the collective genomes of entire microbial communities. 
This approach, enabled by high-throughput sequencing, is vital for understanding the diversity and functional potential of unculturable microorganisms in various ecosystems. 
Qiime 2, an advanced bioinformatics platform, specializes in analyzing metagenomic data. 
With a modular plugin architecture, integrated workflows, and visualization tools, Qiime 2 facilitates reproducible and transparent analyses, supporting both command-line and GUI interactions. 
Its active community and comprehensive documentation enhance accessibility, making it a valuable tool for researchers exploring microbial ecology and community dynamics.
Let's go through each script in this repository:
### 1. Import Data script (`1.import.sh`)
`import.sh` performs the import of single-end sequencing data using Qiime 2. Let's break down the script step by step:

```bash
qiime tools import \
  --type EMPSingleEndSequences \
  --input-path emp-single-end-sequences \
  --output-path emp-single-end-sequences.qza
```

1. **Qiime 2 Import Command:**
   - `qiime tools import`: Initiates the data import process in Qiime 2.
   - `--type EMPSingleEndSequences`: Specifies the type of data being imported, in this case, single-end sequencing data using the EMP protocol.
   - `--input-path emp-single-end-sequences`: Specifies the path to the input data directory (`emp-single-end-sequences` in this case).
   - `--output-path emp-single-end-sequences.qza`: Specifies the path for the output artifact, which is a Qiime 2 Artifact file in the QZA format.

2. **Peek at the Imported Artifact:**
   ```bash
   qiime tools peek emp-single-end-sequences.qza
   ```
   - This command allows you to peek into the contents of the generated Qiime 2 Artifact file (`emp-single-end-sequences.qza`), providing a summary of its contents.

**Output:**
- The primary output of this script is the Qiime 2 Artifact file named `emp-single-end-sequences.qza`. This file encapsulates the imported single-end sequencing data in a format compatible with Qiime 2's analysis pipelines. It serves as an essential input for subsequent steps in the metagenomics analysis workflow.

### 2. demultiplexing (`2.demultiplexing.sh`)
The script `demultiplexing.sh` performs the demultiplexing of the imported single-end sequencing data using Qiime 2. Let's break down the script step by step:

```bash
qiime demux emp-single \
  --i-seqs emp-single-end-sequences.qza \
  --m-barcodes-file sample-metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences demux.qza \
  --o-error-correction-details demux-details.qza
```

1. **Demultiplexing Command:**
   - `qiime demux emp-single`: Initiates the demultiplexing process using the EMP protocol for single-end sequencing data.
   - `--i-seqs emp-single-end-sequences.qza`: Specifies the input Qiime 2 Artifact file containing the imported single-end sequencing data.
   - `--m-barcodes-file sample-metadata.tsv`: Specifies the sample metadata file that contains information about the barcodes associated with each sample.
   - `--m-barcodes-column barcode-sequence`: Specifies the column in the metadata file where barcode sequences are located.
   - `--o-per-sample-sequences demux.qza`: Specifies the output Qiime 2 Artifact file containing per-sample demultiplexed sequences.
   - `--o-error-correction-details demux-details.qza`: Specifies the output Qiime 2 Artifact file containing details about error correction during demultiplexing.

2. **Demultiplexing Summary:**
   ```bash
   qiime demux summarize \
     --i-data demux.qza \
     --o-visualization demux.qzv
   ```
   - This command generates a visualization summarizing the demultiplexed data (`demux.qza`) for further analysis and assessment.

**Output:**
- The primary outputs of this script are two Qiime 2 Artifact files:
  1. `demux-details.qza`: Contains details about error correction during demultiplexing.
  2. `demux.qza`: Contains per-sample demultiplexed sequences.

- Additionally, a Qiime 2 Visualization file (`demux.qzv`) is generated, providing a summary visualization of the demultiplexed data.

This demultiplexed data is a crucial step in preparing the data for downstream analyses, allowing for the identification of individual samples based on their barcodes.

### 3.a.  `QC-feature_table-DADA2.sh`
The script `QC-feature_table-DADA2.sh` performs quality control and feature table construction using the DADA2 algorithm in Qiime 2. Let's break down the script step by step:

```bash
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences rep-seqs-dada2.qza \
  --o-table table-dada2.qza \
  --o-denoising-stats stats-dada2.qza
```

1. **DADA2 Denoising:**
   - `qiime dada2 denoise-single`: Initiates the denoising process using the DADA2 algorithm for single-end sequencing data.
   - `--i-demultiplexed-seqs demux.qza`: Specifies the input Qiime 2 Artifact file containing demultiplexed sequences.
   - `--p-trim-left 0`: Specifies no trimming from the left end of the sequences.
   - `--p-trunc-len 120`: Specifies the truncation length for the sequences.
   - `--o-representative-sequences rep-seqs-dada2.qza`: Specifies the output Qiime 2 Artifact file containing representative sequences.
   - `--o-table table-dada2.qza`: Specifies the output Qiime 2 Artifact file containing the feature table.
   - `--o-denoising-stats stats-dada2.qza`: Specifies the output Qiime 2 Artifact file containing denoising statistics.

2. **Tabulate Denoising Statistics:**
   ```bash
   qiime metadata tabulate \
     --m-input-file stats-dada2.qza \
     --o-visualization stats-dada2.qzv
   ```
   - This command generates a visualization summarizing the denoising statistics using the Qiime 2 Metadata tabulate function.

3. **Renaming Output Files:**
   ```bash
   mv rep-seqs-dada2.qza rep-seqs.qza
   mv table-dada2.qza table.qza
   ```
   - Renames the output files for representative sequences and feature table for easier reference.

4. **Convert Biom to TXT:**
   ```bash
   biom convert \
     -i input.biom \
     -o output.txt \
     --to-tsv
   ```
   - This command converts a Biom format file (assumed to be named `input.biom`) to a tab-separated values (TSV) format file named `output.txt`.

**Output:**
- The primary outputs of this script are three Qiime 2 Artifact files:
  1. `rep-seqs.qza`: Contains representative sequences after DADA2 denoising.
  2. `table.qza`: Contains the feature table after DADA2 denoising.
  3. `stats-dada2.qza`: Contains denoising statistics.

- Additionally, a Qiime 2 Visualization file (`stats-dada2.qzv`) provides a summary of denoising statistics.

- The Biom to TXT conversion outputs a TSV file (`output.txt`).

### 3.b. `QC-feature_table-Deblur.sh`
The script `QC-feature_table-Deblur.sh` performs quality control and feature table construction using the Deblur algorithm in Qiime 2. Let's break down the script step by step:

```bash
qiime quality-filter q-score \
 --i-demux demux.qza \
 --o-filtered-sequences demux-filtered.qza \
 --o-filter-stats demux-filter-stats.qza
```

1. **Quality Filtering with Q-Score:**
   - `qiime quality-filter q-score`: Applies quality filtering to demultiplexed sequences based on Q-scores.
   - `--i-demux demux.qza`: Specifies the input Qiime 2 Artifact file containing demultiplexed sequences.
   - `--o-filtered-sequences demux-filtered.qza`: Specifies the output Qiime 2 Artifact file containing filtered sequences.
   - `--o-filter-stats demux-filter-stats.qza`: Specifies the output Qiime 2 Artifact file containing filter statistics.

2. **Deblur Denoising:**
   ```bash
   qiime deblur denoise-16S \
     --i-demultiplexed-seqs demux-filtered.qza \
     --p-trim-length 120 \
     --o-representative-sequences rep-seqs-deblur.qza \
     --o-table table-deblur.qza \
     --p-sample-stats \
     --o-stats deblur-stats.qza
   ```
   - Initiates the denoising process using the Deblur algorithm for 16S data.
   - `--i-demultiplexed-seqs demux-filtered.qza`: Specifies the input Qiime 2 Artifact file containing filtered sequences.
   - `--p-trim-length 120`: Specifies the trim length for the sequences.
   - `--o-representative-sequences rep-seqs-deblur.qza`: Specifies the output Qiime 2 Artifact file containing representative sequences.
   - `--o-table table-deblur.qza`: Specifies the output Qiime 2 Artifact file containing the feature table.
   - `--p-sample-stats`: Generates sample-level statistics during denoising.
   - `--o-stats deblur-stats.qza`: Specifies the output Qiime 2 Artifact file containing Deblur statistics.

3. **Tabulate and Visualize Stats:**
   ```bash
   qiime metadata tabulate \
     --m-input-file demux-filter-stats.qza \
     --o-visualization demux-filter-stats.qzv
   qiime deblur visualize-stats \
     --i-deblur-stats deblur-stats.qza \
     --o-visualization deblur-stats.qzv
   ```
   - Generates visualizations summarizing filter statistics and Deblur statistics.

4. **Renaming Output Files:**
   ```bash
   mv rep-seqs-deblur.qza rep-seqs.qza
   mv table-deblur.qza table.qza
   ```
   - Renames the output files for representative sequences and feature table for easier reference.

5. **Convert Biom to TXT:**
   ```bash
   biom convert \
     -i input.biom \
     -o output.txt \
     --to-tsv
   ```
   - Converts a Biom format file (assumed to be named `input.biom`) to a tab-separated values (TSV) format file named `output.txt`.

**Output:**
- The primary outputs of this script are three Qiime 2 Artifact files:
  1. `rep-seqs.qza`: Contains representative sequences after Deblur denoising.
  2. `table.qza`: Contains the feature table after Deblur denoising.
  3. `deblur-stats.qza`: Contains Deblur denoising statistics.

- Additionally, two Qiime 2 Visualization files:
  1. `demux-filter-stats.qzv`: Visualization of filter statistics.
  2. `deblur-stats.qzv`: Visualization of Deblur statistics.

- The Biom to TXT conversion outputs a TSV file (`output.txt`).

### 4. `FeatureTable-Data_summaries.sh`
The script `FeatureTable-Data_summaries.sh` generates visual summaries for the feature table and representative sequences in Qiime 2. Let's break down the script step by step:

```bash
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
```

1. **Feature Table Summary:**
   - `qiime feature-table summarize`: Generates a visual summary of the feature table.
   - `--i-table table.qza`: Specifies the input Qiime 2 Artifact file containing the feature table.
   - `--o-visualization table.qzv`: Specifies the output Qiime 2 Visualization file for the feature table summary.
   - `--m-sample-metadata-file sample-metadata.tsv`: Specifies the sample metadata file for additional sample information.

```bash
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv
```

2. **Representative Sequences Tabulation:**
   - `qiime feature-table tabulate-seqs`: Generates a visual summary of the representative sequences.
   - `--i-data rep-seqs.qza`: Specifies the input Qiime 2 Artifact file containing representative sequences.
   - `--o-visualization rep-seqs.qzv`: Specifies the output Qiime 2 Visualization file for the representative sequences summary.

**Output:**
- The primary outputs of this script are two Qiime 2 Visualization files:
  1. `table.qzv`: Visualization summarizing the feature table, providing insights into the distribution of features across samples.
  2. `rep-seqs.qzv`: Visualization summarizing the representative sequences, offering a view of the composition of the microbial community.

These visualizations are valuable for assessing the quality of your data, exploring the distribution of features, and gaining insights into the composition of the microbial community in your samples.

### 5. `phylogenetic_diversity.sh`
The script `phylogenetic_diversity.sh` performs the generation of a phylogenetic tree from representative sequences using Qiime 2. Let's break down the script step by step:

```bash
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
```

1. **Phylogenetic Tree Generation:**
   - `qiime phylogeny align-to-tree-mafft-fasttree`: Generates a phylogenetic tree from the representative sequences using the MAFFT alignment and FastTree methods.
   - `--i-sequences rep-seqs.qza`: Specifies the input Qiime 2 Artifact file containing representative sequences.
   - `--o-alignment aligned-rep-seqs.qza`: Specifies the output Qiime 2 Artifact file containing the aligned representative sequences.
   - `--o-masked-alignment masked-aligned-rep-seqs.qza`: Specifies the output Qiime 2 Artifact file containing the masked aligned representative sequences.
   - `--o-tree unrooted-tree.qza`: Specifies the output Qiime 2 Artifact file containing the unrooted phylogenetic tree.
   - `--o-rooted-tree rooted-tree.qza`: Specifies the output Qiime 2 Artifact file containing the rooted phylogenetic tree.

**Output:**
- The primary outputs of this script are four Qiime 2 Artifact files:
  1. `aligned-rep-seqs.qza`: Contains the aligned representative sequences.
  2. `masked-aligned-rep-seqs.qza`: Contains the masked aligned representative sequences.
  3. `unrooted-tree.qza`: Contains the unrooted phylogenetic tree.
  4. `rooted-tree.qza`: Contains the rooted phylogenetic tree.

These phylogenetic trees are essential for downstream analyses, including diversity metrics and visualizations, allowing for a deeper understanding of the evolutionary relationships among the microbial taxa in the samples.

### 6. `Alpha_and_beta_diversity_analysis.sh`
The script `Alpha_and_beta_diversity_analysis.sh` performs alpha and beta diversity analyses using Qiime 2. Let's break down the script step by step:

```bash
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1103 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results
```

1. **Core Metrics Phylogenetic Analysis:**
   - `qiime diversity core-metrics-phylogenetic`: Computes a set of diversity metrics using a phylogenetic tree.
   - `--i-phylogeny rooted-tree.qza`: Specifies the input Qiime 2 Artifact file containing the rooted phylogenetic tree.
   - `--i-table table.qza`: Specifies the input Qiime 2 Artifact file containing the feature table.
   - `--p-sampling-depth 1103`: Specifies the sampling depth for rarefaction.
   - `--m-metadata-file sample-metadata.tsv`: Specifies the sample metadata file.
   - `--output-dir core-metrics-results`: Specifies the output directory for results.

**Output Artifacts:**
- The primary output artifacts are a set of diversity metrics calculated for each sample, including Faith Phylogenetic Diversity, Unweighted UniFrac, Bray-Curtis, Shannon diversity, and others.

**Output Visualizations:**
- The visualizations include Emperor plots for Unweighted UniFrac, Jaccard, Bray-Curtis, and Weighted UniFrac.

```bash
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
```

2. **Alpha Diversity Group Significance Analysis:**
   - Conducts statistical tests for associations between categorical metadata columns and alpha diversity data.
   - `--i-alpha-diversity`: Specifies the input Qiime 2 Artifact file containing alpha diversity data.
   - `--m-metadata-file`: Specifies the sample metadata file.
   - Output visualizations include significance plots for Faith Phylogenetic Diversity and evenness metrics.

```bash
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column body-site \
  --o-visualization core-metrics-results/unweighted-unifrac-body-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column subject \
  --o-visualization core-metrics-results/unweighted-unifrac-subject-group-significance.qzv \
  --p-pairwise
```

3. **Beta Diversity Group Significance Analysis:**
   - Conducts statistical tests for associations between categorical metadata columns and beta diversity data.
   - `--i-distance-matrix`: Specifies the input Qiime 2 Artifact file containing beta diversity distance matrix.
   - `--m-metadata-file`: Specifies the sample metadata file.
   - `--m-metadata-column`: Specifies the categorical metadata column of interest.
   - `--p-pairwise`: Performs pairwise tests for specific pairs of groups.

**Output Visualizations:**
- The visualizations include significance plots for Unweighted UniFrac at the body site and subject levels.

```bash
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
```

4. **Emperor PCoA Plots:**
   - Generates Emperor plots for principal coordinates analysis (PCoA) results.
   - `--i-pcoa`: Specifies the input Qiime 2 Artifact file containing PCoA results.
   - `--m-metadata-file`: Specifies the sample metadata file.
   - `--p-custom-axes`: Specifies custom axes for coloring points in the Emperor plot.

**Output Visualizations:**
- The visualizations include Emperor plots for Unweighted UniFrac and Bray-Curtis with custom axes based on days since experiment start.

This script provides a comprehensive analysis of alpha and beta diversity, enabling insights into the microbial community structure and composition.

### 7. `Alpha rarefaction plotting.sh`
The script `Alpha rarefaction plotting.sh` performs alpha rarefaction analysis in Qiime 2. Let's break down the script step by step:

```bash
qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 4000 \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization alpha-rarefaction.qzv
```

1. **Alpha Rarefaction Analysis:**
   - `qiime diversity alpha-rarefaction`: Performs alpha rarefaction analysis to assess the alpha diversity of samples at varying sequencing depths.
   - `--i-table table.qza`: Specifies the input Qiime 2 Artifact file containing the feature table.
   - `--i-phylogeny rooted-tree.qza`: Specifies the input Qiime 2 Artifact file containing the rooted phylogenetic tree.
   - `--p-max-depth 4000`: Specifies the maximum depth for rarefaction. This parameter determines the maximum sequencing depth at which samples will be rarefied.
   - `--m-metadata-file sample-metadata.tsv`: Specifies the sample metadata file.
   - `--o-visualization alpha-rarefaction.qzv`: Specifies the output Qiime 2 Visualization file for the alpha rarefaction plot.

**Output Visualizations:**
- The primary output is the Qiime 2 Visualization file `alpha-rarefaction.qzv`. This file contains the alpha rarefaction plot, which visually represents how the observed diversity changes as a function of sampling depth.

The alpha rarefaction plot is useful for assessing whether the sequencing depth is sufficient to capture the diversity of the microbial community.

### 8. `Taxonomic analysis.sh`
The script `Taxonomic analysis.sh` performs taxonomic analysis in Qiime 2. Let's break down the script step by step:

```bash
# Download the pre-trained classifier
wget \
  -O "gg-13-8-99-515-806-nb-classifier.qza" \
  "https://data.qiime2.org/2023.5/common/gg-13-8-99-515-806-nb-classifier.qza"

# Taxonomic classification using the pre-trained classifier
qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

# Tabulate the taxonomic classification results
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
```

1. **Download Pre-trained Classifier:**
   - Downloads a pre-trained classifier for taxonomic classification based on the Greengenes 13.8 database. This classifier is specific for the region between the 515F and 806R primers.

2. **Taxonomic Classification:**
   - `qiime feature-classifier classify-sklearn`: Performs taxonomic classification using the pre-trained classifier.
   - `--i-classifier gg-13-8-99-515-806-nb-classifier.qza`: Specifies the input Qiime 2 Artifact file containing the pre-trained classifier.
   - `--i-reads rep-seqs.qza`: Specifies the input Qiime 2 Artifact file containing representative sequences.
   - `--o-classification taxonomy.qza`: Specifies the output Qiime 2 Artifact file containing taxonomic classifications.

3. **Tabulate Taxonomic Classification:**
   - `qiime metadata tabulate`: Generates a visualization summarizing the taxonomic classification results.
   - `--m-input-file taxonomy.qza`: Specifies the input Qiime 2 Artifact file containing taxonomic classifications.
   - `--o-visualization taxonomy.qzv`: Specifies the output Qiime 2 Visualization file for taxonomic classification.

```bash
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
```

4. **Taxa Bar Plot:**
   - `qiime taxa barplot`: Generates a bar plot to visualize the relative abundance of taxa in each sample.
   - `--i-table table.qza`: Specifies the input Qiime 2 Artifact file containing the feature table.
   - `--i-taxonomy taxonomy.qza`: Specifies the input Qiime 2 Artifact file containing taxonomic classifications.
   - `--m-metadata-file sample-metadata.tsv`: Specifies the sample metadata file.
   - `--o-visualization taxa-bar-plots.qzv`: Specifies the output Qiime 2 Visualization file for the taxa bar plot.

**Output Artifacts:**
- The primary output artifacts are:
  1. `taxonomy.qza`: Contains taxonomic classifications.
  2. `gg-13-8-99-515-806-nb-classifier.qza`: The pre-trained classifier.
  
**Output Visualizations:**
- The visualizations include:
  1. `taxonomy.qzv`: Visualization of taxonomic classification results.
  2. `taxa-bar-plots.qzv`: Visualization of taxa bar plot.

These outputs provide insights into the taxonomic composition of the microbial community in your samples.

### 9. `Differential abundance testing with ANCOM.sh`
The script you provided performs differential abundance analysis using ANCOM (Analysis of Composition of Microbiomes) in Qiime 2. Here's a breakdown of the script:

```bash
# Filter the feature table to only contain gut samples
qiime feature-table filter-samples \
  --i-table table.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-where "[body-site]='gut'" \
  --o-filtered-table gut-table.qza

# Output Artifact: gut-table.qza

# Add pseudocount to the filtered gut table
qiime composition add-pseudocount \
  --i-table gut-table.qza \
  --o-composition-table comp-gut-table.qza

# Output Artifact: comp-gut-table.qza

# Run ANCOM on the subject level
qiime composition ancom \
  --i-table comp-gut-table.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column subject \
  --o-visualization ancom-subject.qzv

# Output Visualization: ancom-subject.qzv

# Perform differential abundance test at a specific taxonomic level (level 6)
qiime taxa collapse \
  --i-table gut-table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table gut-table-l6.qza

qiime composition add-pseudocount \
  --i-table gut-table-l6.qza \
  --o-composition-table comp-gut-table-l6.qza

qiime composition ancom \
  --i-table comp-gut-table-l6.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column subject \
  --o-visualization l6-ancom-subject.qzv

# Output Artifacts:
#   gut-table-l6.qza
#   comp-gut-table-l6.qza

# Output Visualization:
#   l6-ancom-subject.qzv
```

1. **Filtering Gut Samples:**
   - Filters the feature table to only contain samples from the gut.

2. **Adding Pseudocount:**
   - Adds a pseudocount to the filtered gut table to avoid issues with zero values in compositional data.

3. **ANCOM at Subject Level:**
   - Runs ANCOM on the compositional gut table at the subject level to identify differentially abundant features between subjects.

4. **Differential Abundance Test at Taxonomic Level 6:**
   - Collapses the feature table at taxonomic level 6.
   - Adds a pseudocount to the collapsed table.
   - Runs ANCOM on the collapsed table at the subject level to identify differentially abundant taxa between subjects.

**Output Artifacts:**
- `gut-table.qza`: Filtered feature table containing gut samples.
- `comp-gut-table.qza`: Compositional table with added pseudocount.
- `gut-table-l6.qza`: Collapsed feature table at taxonomic level 6.
- `comp-gut-table-l6.qza`: Compositional table at taxonomic level 6 with added pseudocount.

**Output Visualizations:**
- `ancom-subject.qzv`: Visualization of ANCOM results at the subject level.
- `l6-ancom-subject.qzv`: Visualization of ANCOM results at taxonomic level 6.

These analyses help identify features (either sequences or taxa) that are differentially abundant between gut samples, providing insights into the microbial composition in the gut.

### Additional Script (`MergDenoisedData.sh`)
The script `MergDenoisedData.sh` uses Qiime 2 commands to merge denoised feature tables and representative sequences. Here's a breakdown of the script:

```bash
# Merge denoised feature tables
qiime feature-table merge \
  --i-tables table-1.qza \
  --i-tables table-2.qza \
  --o-merged-table table.qza

# Merge denoised representative sequences
qiime feature-table merge-seqs \
  --i-data rep-seqs-1.qza \
  --i-data rep-seqs-2.qza \
  --o-merged-data rep-seqs.qza

# Summarize the merged feature table
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

# Tabulate sequences in the merged representative sequences
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv
```

1. **Merge Denoised Feature Tables:**
   - `qiime feature-table merge`: Merges two feature tables (`table-1.qza` and `table-2.qza`) into a single feature table (`table.qza`).

2. **Merge Denoised Representative Sequences:**
   - `qiime feature-table merge-seqs`: Merges two sets of representative sequences (`rep-seqs-1.qza` and `rep-seqs-2.qza`) into a single set of representative sequences (`rep-seqs.qza`).

3. **Summarize Merged Feature Table:**
   - `qiime feature-table summarize`: Generates a visualization (`table.qzv`) to summarize the merged feature table (`table.qza`), providing information on the distribution of features across samples.

4. **Tabulate Sequences in Merged Representative Sequences:**
   - `qiime feature-table tabulate-seqs`: Generates a visualization (`rep-seqs.qzv`) to tabulate information about the sequences in the merged representative sequences (`rep-seqs.qza`), including sequence lengths and frequencies.

**Output Artifacts:**
- `table.qza`: Merged denoised feature table.
- `rep-seqs.qza`: Merged denoised representative sequences.

**Output Visualizations:**
- `table.qzv`: Visualization summarizing the merged feature table.
- `rep-seqs.qzv`: Visualization tabulating information about the sequences in the merged representative sequences.

These commands are useful for combining the results of denoising from different datasets or processing runs into a single dataset for downstream analyses.

## References

Bolyen, E., Rideout, J.R., Dillon, M.R., Bokulich, N.A., Abnet, C.C., Al-Ghalith, G.A., ... Caporaso, J.G. (2019). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. *Nature Biotechnology, 37*, 852–857. [DOI: 10.1038/s41587-019-0209-9](https://doi.org/10.1038/s41587-019-0209-9)

