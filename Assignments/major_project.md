# Major Project (15%)

In this course, the following next-generation sequencing (NGS) datasets/protocols are described in detail:

- Whole genome sequencing/Resequencing
- Transcriptome Sequencing (RNAseq)
- DNA Methylation/Bisulfite Sequencing
- Enrichment/Capture sequencing (Methyl-capture, ChIPseq, RIPseq)
- Metagenomics/Microbial profiling

Each of these NGS approaches uses similar programs and analysis approaches, such as quality control (quality and sequencing adapter trimming), genome alignment, and downstream visualisation and statistical methods. They also aim to address a particular scientific question and investigate a scientific hypothesis. For the major project, you will take a published dataset and complete all the analysis tasks (from raw data to final results) and write up a report. This report must be structured like a small journal article, with abstract (summarising the project), introduction (background on the study and identification of the research hypothesis), methods (analysis steps and programs used), results (what you found) and discusson (how the results relate to the research hypothesis) sections. Marks will also be awarded to the bash/R or RMarkdown scripts that you use.

|Section                    |Mark |
|:--------------------------|:----|
|Abstract                   |5%   |
|Introduction + hypothesis  |10%  |
|Methods                    |20%  |
|Results & Discussion       |30%  |
|References                 |5%   |
|Analysis scripts           |30%  |

**You have the freedom to choose any dataset from any research article you would like**, however you need to let either Dan, Steve or Jimmy know beforehand.

If you cannot find a suitable dataset, we have provided a dataset from a plant RNAseq profiling study, which has multiple mutants of the histone deacetylase gene [`hda`](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4848314/), which is involved in the regulation of flowering time in *Arabidopsis thaliana*. The details of the sequencing experiment [are found at this GEO link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE78946). To ensure that everyone is not working on the same data, each student should work on a separate sample group:

|ID       |Group        |
|:--------|:------------|
|a1735804 |hda5-1       |
|a1696678 |hda6-6       |
|a1611214 |hda5-1       |
|a1691643 |hda9-1       |
|a1667810 |hda6-6       |
|a1733239 |hda9-1       |
|a1718998 |hda5-1       |
|a1731952 |hda9-1       |
|a1710508 |hda5-1       |
|a1690770 |hda6-6       |
|a1652167 |hda9-1       |
|a1714893 |hda5-1       |
|a1702741 |hda5-1       |
|a1701030 |hda6-6       |
|a1662822 |hda9-1       |
|a1606913 |hda5-1       |
|a1731155 |hda6-6       |
|a1713960 |hda5-1       |
|a1674898 |hda9-1       |
|a1729128 |hda9-1       |
|a1719003 |hda6-6       |
|a1660066 |hda9-1       |
|a1710741 |hda5-1       |
|a1673245 |hda6-6       |
|a1701389 |hda5-1       |
|a1701747 |hda9-1       |
|a1643251 |hda6-6       |
|a1735934 |hda9-1       |
|a1738360 |hda5-1       |
|a1619733 |hda5-1       |
|a1683838 |hda6-6       |

For this particular dataset, we expect you to run a differential expression analysis between the replicates of your sample group against the Col wildtype control sample. You will report differentially expressed genes in your results section and discuss how this relates to the study's experimental hypothesis

Raw FASTQ file will be provided via a data link provided in a myuni announcement/email
