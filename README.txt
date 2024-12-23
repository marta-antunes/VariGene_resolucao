Resolucão do desafio - Ponto 2
Instruções para executar a imagem Docker:
1)


Resolucão do desafio - Ponto 3
3.1) Todos os exerxícios foram feitos usando a linha de comandos linux
Número total de reads mapeadas e não mapeadas
bamtools stats -in AMOSTRA_A.bam
Total reads:       802979
Mapped reads:      802979	(100%)
Forward strand:    398846	(49.6708%)
Reverse strand:    404133	(50.3292%)
Failed QC:         0	(0%)
Duplicates:        0	(0%)
Paired-end reads:  0	(0%)


Número total de variantes identificadas:
grep -v "^#" AMOSTRA_A.anotada.vcf | wc -l
83

Número total de variantes identificadas por gene:
grep -v '^#' AMOSTRA_A.anotada.vcf | awk -F'\t' '{split($8, info, ";"); for (i in info) if (info[i] ~ /^GENE=/) {split(info[i], gene, "="); print gene[2];}}' | sort | uniq -c | sort -nr
11 APC:324
8 MSH6:2956
7 POLD1:5424
5 RPS20:6224
4 TP53:7157
4 MSH3:4437
4 MLH1:4292
4 ATM:472|C11orf65:160140
3 MUTYH:4595
3 CTNNA1:1495
3 CDH1:999
3 ATM:472
2 POLE:5426|LOC130009266:130009266
2 POLE:5426
2 PMS2:5395
2 GREM1:26585
2 GALNT12:79695
2 DHFR:1719|MSH3:4437
2 BLM:641
1 STK11:6794
1 RPS20:6224|SNORD54:26795
1 RNF43:54894
1 NTHL1:4913
1 MSH2:4436
1 CHEK2:11200
1 AXIN2:8313

Número total de variantes identificadas por tipo:
grep -v '^#' AMOSTRA_A.anotada.vcf | awk -F'\t' '{split($8, info, ";"); for (i in info) if (info[i] ~ /^TYPE=/) {split(info[i], gene, "="); print gene[2];}}' | sort | uniq -c | sort -nr
74 single_nucleotide_variant
2 Microsatellite
2 Duplication
2 Deletion
2 del
1 complex,snp


3.2) Após a filtragem das variantes por qualidade, eu identificava variantes de interesse clínico, fazendo uma procura por Classification=Pathogenic utilizando o seguinte comando "grep "CLASSIFICATION=Pathogenic"  AMOSTRA_A.anotada.vcf ". Nesta amostra A só existe uma variante patogénica.



3.3) grep "NTHL1" AMOSTRA_A.anotada.vcf
Não existe a presença da variante patogénica c.244C>T p.(Gln82*) no gene NTHL1. A variante patogénica que existe neste gene é uma troca de G>A.
Se existisse a variante seria no cromossoma 16, na posicao 244 e havia a troca de uma citosina por uma timina provocando uma alteracao no aminoácido Gln. 
