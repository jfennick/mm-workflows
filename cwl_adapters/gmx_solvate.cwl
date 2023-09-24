#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

label: Wrapper class for the GROMACS solvate module.

doc: |-
  The GROMACS solvate module generates a box around the selected structure (if any).

baseCommand: gmx
arguments: ["-nobackup", "-nocopyright", "solvate"]

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/biobb_gromacs:4.0.0--pyhdfd78af_1

inputs:
  input_crd_path:
    label: Path to the input GRO file
    doc: |-
      Path to the input GRO file
      Type: string
      File type: input
      Accepted formats: gro, pdb
      Example file: https://github.com/bioexcel/biobb_md/raw/master/biobb_md/test/data/gromacs/editconf.gro
    type: File?  # NOTE: optional
    format:
    - edam:format_2033
    - edam:format_1476
    inputBinding:
      position: 1
      prefix: -f

  output_gro_path:
    label: Path to the output GRO file
    doc: |-
      Path to the output GRO file
      Type: string
      File type: output
      Accepted formats: pdb, gro
      Example file: https://github.com/bioexcel/biobb_md/raw/master/biobb_md/test/reference/gromacs/ref_editconf.gro
    type: string
    format:
    - edam:format_2033
    - edam:format_1476
    inputBinding:
      position: 2
      prefix: -o
    default: system.gro

  box:
    type: float
    inputBinding:
      position: 3
      prefix: -box

  scale:
    type: float
    inputBinding:
      position: 4
      prefix: -scale
    default: 0.57

outputs:
  output_gro_path:
    label: Path to the output GRO file
    doc: |-
      Path to the output GRO file
    type: File
    outputBinding:
      glob: $(inputs.output_gro_path)
    format: edam:format_2033

$namespaces:
  edam: https://edamontology.org/

$schemas:
- https://raw.githubusercontent.com/edamontology/edamontology/master/EDAM_dev.owl
