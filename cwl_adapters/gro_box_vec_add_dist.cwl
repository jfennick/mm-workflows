#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

label: Adds 2 times input_box_vec_dist to each of the unit cell box vectors

doc: |-
  Adds 2 times input_box_vec_dist to each of the unit cell box vectors

baseCommand: python
arguments: ["/gro_box_vec_add_dist.py"]

hints:
  DockerRequirement:
    dockerPull: jakefennick/gro_box_vec_add_dist

inputs:
  input_gro_path:
    label: Path to the input GRO file
    doc: |-
      Path to the input GRO file
      Type: string
      File type: input
      Accepted formats: gro
      Example file: https://github.com/bioexcel/biobb_md/raw/master/biobb_md/test/data/gromacs/editconf.gro
    type: File
    format:
    - edam:format_2033
    inputBinding:
      prefix: --input_gro_path

  output_gro_path:
    label: Path to the output GRO file
    doc: |-
      Path to the output GRO file
      Type: string
      File type: output
      Accepted formats: gro
      Example file: https://github.com/bioexcel/biobb_md/raw/master/biobb_md/test/reference/gromacs/ref_editconf.gro
    type: string
    format:
    - edam:format_2033
    inputBinding:
      prefix: --output_gro_path
    default: system.gro

  input_box_vec_dist:
    type: float
    inputBinding:
      prefix: --input_box_vec_dist

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
