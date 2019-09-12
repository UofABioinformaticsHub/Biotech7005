# Major Project (15%)

In this course, the following next-generation sequencing (NGS) datasets/protocols are described in detail:

- Whole genome sequencing/Resequencing
- Transcriptome Sequencing (RNAseq)
- DNA Methylation/Bisulfite Sequencing
- Enrichment/Capture sequencing (Methyl-capture, ChIPseq, RIPseq)

Each of these NGS approaches uses similar programs and analysis approaches, such as quality control (quality and sequencing adapter trimming), genome alignment, and downstream visualisation and statistical methods. They also aim to address a particular scientific question and investigate a scientific hypothesis. For the major project, you will take a published dataset and complete all the analysis tasks (from raw data to final results) and write up a report. This report must be structured like a small journal article, with abstract (summarising the project), introduction (background on the study and identification of the research hypothesis), methods (analysis steps and programs used), results (what you found) and discusson (how the results relate to the research hypothesis) sections. Marks will also be awarded to the bash/R or RMarkdown scripts that you use.

|Section                    |Mark |
|:--------------------------|:----|
|Abstract                   |5%   |
|Introduction + hypothesis  |10%  |
|Methods                    |20%  |
|Results & Discussion       |30%  |
|References                 |5%   |
|Analysis scripts           |30%  |

**You have the freedom to choose any dataset from any research article you would like**, however you need to let either Dan or Steve know beforehand.

If you cannot find a suitable dataset, we have provided a dataset from a plant RNAseq profiling study, which has multiple mutants of the histone deacetylase gene [`hda`](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4848314/), which is involved in the regulation of flowering time in *Arabidopsis thaliana*. The details of the sequencing experiment [are found at this GEO link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE78946). To ensure that everyone is not working on the same data, each student should work on a separate sample group:

|ID      |Group |
|:-------|:-----|
|a1762813|hda5-1|
|a1202401|hda5-1|
|a1776494|hda9-1|
|a1778618|hda6-6|
|a1705074|hda6-6|
|a1790457|hda9-1|
|a1758382|hda9-1|
|a1789913|hda5-1|
|a1776998|hda6-6|
|a1776430|hda6-6|
|a1770716|hda5-1|
|a1739682|hda6-6|
|a1758693|hda6-6|
|a1781987|hda9-1|
|a1768114|hda5-1|
|a1700271|hda6-6|
|a1646510|hda9-1|
|a1779487|hda6-6|
|a1778287|hda9-1|
|a1783535|hda6-6|
|a1789486|hda9-1|
|a1758223|hda9-1|
|a1769266|hda9-1|
|a1771465|hda9-1|
|a1768183|hda6-6|
|a1781873|hda6-6|
|a1755783|hda9-1|
|a1679475|hda5-1|
|a1662216|hda5-1|
|a1780859|hda6-6|
|a1775769|hda5-1|


For this particular dataset, we expect you to run a differential expression analysis between the replicates of your sample group against the Col wildtype control sample. You will report differentially expressed genes in your results section and discuss how this relates to the study's experimental hypothesis

Raw FASTQ files will be provided via a data link provided in a myuni announcement/email.
