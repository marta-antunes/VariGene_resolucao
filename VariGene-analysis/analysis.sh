#!/bin/bash

# Verifica se os ficheiros de input são fornecidos
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_file1> <input_file2>"
    exit 1
fi

# atribui os ficheiros de input a variáveis
INPUT_FILE_1=$1
INPUT_FILE_2=$2
INPUT_FILE_3=$3 #este ficheiro é o ficheiro fasta do genoma

# imprime que ficheiros estão a ser utilizados
echo "Processing file 1: $input_file1"
echo "Processing file 2: $input_file2"
echo "Processing file 3: $input_file3"

INPUT_FILE_1=$1
INPUT_FILE_2=$2
INPUT_FILE_3=$3
RESULTS_DIR="/usr/local/analysis/results"

# Cria um diretório para os resultados caso não exista
mkdir -p $RESULTS_DIR

# Corre o fastp (que faz o trimming das reads para garantir que estas têm qualidade) 
fastp -i $INPUT_FILE_1 -I INPUT_FILE_2 -o $RESULTS_DIR/cleaned_1.fastq -O $RESULTS_DIR/cleaned_2.fastq --average_qual 20 --length_required 120 --overrepresentation_analysis

#navega para a pasta "input"
cd input

#Faz o index do genoma de referência
bwa index $INPUT_FILE_3

#volta para a working directory
cd ..

# Corre o BWA-MEM (alinhamento contra o genoma de referância fornecido como input)
bwa mem $INPUT_FILE_3 $RESULTS_DIR/cleaned_1.fastq $RESULTS_DIR/cleaned_2.fastq > $RESULTS_DIR/aligned.sam

# Converte SAM para BAM
samtools view -b $RESULTS_DIR/aligned.sam > $RESULTS_DIR/aligned.bam

# Ordena o ficheiro BAM
samtools sort $RESULTS_DIR/aligned.bam -o $RESULTS_DIR/sorted.bam

# Faz o Index do fichero BAM
samtools index $RESULTS_DIR/sorted.bam

# Gera o ficheiro mpileup
samtools mpileup -u -t DP,SP -f $INPUT_FILE_3 $RESULTS_DIR/sorted.bam > $RESULTS_DIR/output.mpileup

# detecta variantes com o bcftools
bcftools call -mv -Oz -o $RESULTS_DIR/variants.vcf.gz $RESULTS_DIR/output.mpileup

# filtra por vários parâmetros para garantir qualidade 
vcftools --gzvcf $RESULTS_DIR/variants.vcf.gz --minQ 20 --minDP 7 --min-alleles 2 --max-alleles 2 --minGQ 20 --recode --out $RESULTS_DIR/variants.Q30DP7GQ20

#annotation
java -Xmx4g -jar /opt/tools/snpEff/snpEff.jar hg19 $RESULTS_DIR/variants.Q30DP7GQ20.recode.vcf > ficheiro_vcf_filtrado.ann.vcf


echo "Analysis complete. Results:"
echo "Cleaned FASTQ 1: $RESULTS_DIR/cleaned_1.fastq"
echo "Cleaned FASTQ 2: $RESULTS_DIR/cleaned_2.fastq"
echo "Aligned SAM: $RESULTS_DIR/aligned.sam"
echo "Aligned BAM: $RESULTS_DIR/aligned.bam"
echo "Sorted BAM: $RESULTS_DIR/sorted.bam"
echo "Mpileup: $RESULTS_DIR/output.mpileup"
echo "Variants VCF: $RESULTS_DIR/variants.vcf.gz"
echo "Filtered and annotated VCF: $RESULTS_DIR/variants.ann.vcf"