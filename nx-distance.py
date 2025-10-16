import numpy as np
import matplotlib.pyplot as plt
import sys

def read_trajectory(filename):
    """Reads trajectory file and returns times and coordinates per frame."""
    times = []
    frames = []

    with open(filename, "r") as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line.isdigit():
            n_atoms = int(line)
            time_line = lines[i + 1].split()
            time = float(time_line[0])

            coords = []
            for j in range(n_atoms):
                parts = lines[i + 2 + j].split()
                x, y, z = map(float, parts[1:4])
                coords.append([x, y, z])

            times.append(time)
            frames.append(np.array(coords))

            i += 2 + n_atoms
        else:
            i += 1

    return np.array(times), frames


def compute_distances(frames, atom1, atom2):
    """Compute distances between two atoms (1-based index)."""
    distances = []
    for frame in frames:
        r1 = frame[atom1 - 1]
        r2 = frame[atom2 - 1]
        distances.append(np.linalg.norm(r1 - r2))
    return np.array(distances)


def plot_distance(times, distances, atom1, atom2):
    plt.figure(figsize=(6,4))
    plt.plot(times, distances, marker='o')
    plt.xlabel("Time")
    plt.ylabel(f"Distance between atoms {atom1} and {atom2} (Å)")
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("distance_plot.png", dpi=150)


if __name__ == "__main__":
    # Example usage: python script.py trajectory.txt 17 25
    if len(sys.argv) != 4:
        print("Usage: python script.py <filename> <atom1> <atom2>")
        sys.exit(1)

    filename = sys.argv[1]
    atom1 = int(sys.argv[2])
    atom2 = int(sys.argv[3])

    times, frames = read_trajectory(filename)
    distances = compute_distances(frames, atom1, atom2)
    plot_distance(times, distances, atom1, atom2)

