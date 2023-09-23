""" Some molecular modeling solvation software does not performs distance
checks between periodic images of atoms. Thus, there can be steric clashes
which may cause nasty minimization failures. In at least one test case,
the solution was to simply add an additional 0.001 nm = 0.01 Angstrom to the
periodic box after solvation. The obvious solution is to use gmx editconf.
However, by default gmx editconf re-centers the box, and since the gro file
format rounds the coordinates to 3 decimal places, this masks the true error.
Unfortunately, attempting to prevent this using
`gmx editconf ... -d 0.001 -noc` does not work, due to an apparent bug.
See https://gitlab.com/gromacs/gromacs/-/issues/4875
Explicitly setting the box vectors using
`gmx editconf -box [... ... ...] -noc` works, but requires parsing the box
vectors and performing the addition separately anyway.
"""

import argparse
import sys


def gro_box_vec_add_dist(input_box_vec_dist: float, input_gro_path: str, output_gro_path: str) -> None:
    """Adds 2 times input_box_vec_dist to each of the unit cell box vectors

    Args:
        input_box_vec_dist (float): The number to add to
        input_gro_path (str): The name of the input gromacs gro file.
        output_gro_path (str): The name of the output gromacs gro file.
    """
    with open(input_gro_path, mode='r', encoding='utf-8') as f:
        lines = f.readlines()

    # A gromacs *.gro file should be of the form:
    # Comment line
    #    90
    #     1SOL     OW    1   0.230   0.628   0.113
    #    ...
    #    30SOL    HW2   90   0.389   0.384   0.603
    #    1.00000   1.00000   1.00000
    # (blank line)

    num_atoms = int(lines[1])
    if len(lines) != num_atoms + 3:
        print('Error! Number of lines in the file does not match the number of atoms on the second line')
        print('(plus headers at the top and one blank line at the bottom)')
        sys.exit(1)

    box_vec_line = lines[-1]
    vecs = box_vec_line.split()
    if len(vecs) != 3:
        print(f'Error! Need three numbers to define the unit cell. Found: {vecs}')
    # TODO: use format instead of round? (For fixed width columns)
    vecs_plus_dist = [round(float(d) + 2*input_box_vec_dist, 5) for d in vecs]
    box_vec_line_new = f'   {vecs_plus_dist[0]}   {vecs_plus_dist[1]}   {vecs_plus_dist[2]}'
    lines[-1] = box_vec_line_new

    with open(output_gro_path, mode='w', encoding='utf-8') as f:
        f.writelines(lines)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_box_vec_dist', default=0.001, type=float)  # 0.001 nm = 0.01 Angstrom
    parser.add_argument('--input_gro_path', required=True, type=str)
    parser.add_argument('--output_gro_path', required=True, type=str)
    args = parser.parse_args()

    gro_box_vec_add_dist(args.input_box_vec_dist, args.input_gro_path, args.output_gro_path)
