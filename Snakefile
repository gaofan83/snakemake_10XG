from os.path import join
configfile: "config.yaml"

dir=config["DIR"]
ref=config["REF"]
thread=config["THREAD"]
cell=config["CELL"]
chem=config["CHEM"]
shell("mkdir results_{dir}")

for sample in config["SAMPLES"]:
  print("Sample " + sample + " will be processed")

rule all:
    input: expand("log/{sample}.txt", sample=config["SAMPLES"])

rule run_cellranger:
    output:
        "log/{sample}.txt"
    benchmark:
        "benchmarks/cell_ranger_{sample}.txt"
    params:
        id="data_{sample}",
        sample="{sample}"
    shell:
        """
         cd results_{dir}
         /home/fgao/software/cellranger-2.2.0/cellranger count --id={params.id} --transcriptome={ref} --fastqs=../{dir} \
            --localcores={thread} --sample={params.sample} --expect-cells={cell} --nosecondary --chemistry={chem}
         cd ..
         echo "Sample is complete" > {output}
        """
