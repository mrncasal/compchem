#!/usr/bin/env python3
import argparse
import re
from typing import List, Dict, Optional

RE_SCF = re.compile(r'^SCF Done:')
RE_EXC = re.compile(r'^Excited State\s+\d+:')
RE_EXC1 = re.compile(r'^Excited State\s+1:')
RE_STAT = re.compile(r'Stationary point')
RE_SCAN = re.compile(r'!\s+\S+\s+(R\(\d+,\d+\))\s+([\d\.\-]+).*Scan')

def parse_gaussian_log(filename: str):
    results = []
    last_scf_val = None
    current_block = None
    last_block = None
    scan_label = None
    scan_values = []

    with open(filename, 'r', errors='replace') as fh:
        lines = fh.readlines()

    # Pass 1: find scan label
    for line in lines:
        m = RE_SCAN.search(line)
        if m:
            scan_label = m.group(1)  # e.g. "R(17,25)"
            break

    # Pass 2: collect scan values (third column)
    if scan_label:
        for line in lines:
            if scan_label in line and "Scan" not in line:
                parts = line.split()
                if len(parts) >= 4:
                    try:
                        val = float(parts[3])  # third column
                        scan_values.append(val)
                    except ValueError:
                        pass

    # Pass 3: parse SCF + excited states + stationary points
    for raw in lines:
        line = raw.strip()

        # Extract SCF energy
        if RE_SCF.match(line):
            parts = line.split()
            try:
                last_scf_val = float(parts[4])
            except (IndexError, ValueError):
                last_scf_val = None
            continue

        # Start new excited-state block
        if RE_EXC1.match(line):
            current_block = {"energies": [], "osc_strengths": []}
            try:
                parts = line.split()
                energy = float(parts[4])  # excitation energy in eV
                m = re.search(r"f=([0-9.]+)", line)
                osc = float(m.group(1)) if m else None
                current_block["energies"].append(energy)
                current_block["osc_strengths"].append(osc)
            except (IndexError, ValueError):
                pass
            last_block = current_block
            continue

        # Continue excited-state block
        if current_block is not None and RE_EXC.match(line):
            try:
                parts = line.split()
                energy = float(parts[4])
                m = re.search(r"f=([0-9.]+)", line)
                osc = float(m.group(1)) if m else None
                current_block["energies"].append(energy)
                current_block["osc_strengths"].append(osc)
            except (IndexError, ValueError):
                pass
            continue

        # Save block on Stationary point
        if RE_STAT.search(line):
            results.append({
                "scf": last_scf_val,
                "energies": list(last_block["energies"]) if last_block else [],
                "osc_strengths": list(last_block["osc_strengths"]) if last_block else []
            })
            current_block = None
            last_block = None
            continue

    return results, scan_label, scan_values

def main():
    parser = argparse.ArgumentParser(
        description="Extract SCF energies, excitation energies, oscillator strengths, and scan coordinates into a table."
    )
    parser.add_argument("filename", help="Gaussian log filename")
    args = parser.parse_args()

    entries, scan_label, scan_values = parse_gaussian_log(args.filename)
    if not entries:
        print("No stationary point data found.")
        return

    if scan_label and scan_values and len(scan_values) < len(entries):
        print("⚠ Warning: fewer scan values than stationary points found!")

    max_states = max(len(e["energies"]) for e in entries)

    # Header
    header = ["#"]
    if scan_label:
        header.append(scan_label)
    header.append("Tot_S0_ua")
    header += [f"E{i}_eV" for i in range(1, max_states + 1)]
    header += [f"f{i}" for i in range(1, max_states + 1)]
    widths  = [8] + [12] + [12] + [8]*max_states + [8]*max_states
    formatted_header = "".join(f"{h:<{w}}" for h, w in zip(header, widths))
    print(formatted_header)

    # Rows
    for i, e in enumerate(entries, start=1):
        row = [f"{i}"]
        if scan_label and i-1 < len(scan_values):
            row.append(f"{scan_values[i-1]:.4f}")
        elif scan_label:
            row.append("")
        row.append(f"{e['scf']:.8f}" if e['scf'] else "")
        for j in range(max_states):
            if j < len(e["energies"]):
                row.append(f"{e['energies'][j]:.4f}")
            else:
                row.append("")
        for j in range(max_states):
            if j < len(e["osc_strengths"]):
                val = e["osc_strengths"][j]
                row.append(f"{val:.4f}" if val is not None else "")
            else:
                row.append("")
        print("\t".join(row))

if __name__ == "__main__":
    main()

