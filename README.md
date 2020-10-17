# Read VCF operator

##### Description

`read_VCF` operator reads a VCF data file into Tercen.

##### Usage

Input projection|.
---|---
`col`        | document ID

Output relations|.
---|---
`CHROM`        | numeric, median of the input data
`POS`        | numeric, median of the input data
`ID`        | numeric, median of the input data
`REF`        | character, reference allele
`ALT`        | character, alternate allele
`FORMAT`        | character, format field
`sample`        | character, sample ID
`genotype`        | numeric, number of alternate alleles (0, 1 or 2)

##### References

[VCF format on Wikipedia](https://en.wikipedia.org/wiki/Variant_Call_Format).