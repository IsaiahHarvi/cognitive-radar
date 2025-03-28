#!/bin/bash
set -e

# Set the target directory via TORNET_ROOT; defaults to "./tornet_data" if not set.
TORNET_ROOT="${TORNET_ROOT:-./tornet_data}"
mkdir -p "$TORNET_ROOT"
echo "Using TORNET_ROOT = $TORNET_ROOT"

declare -A tornet_dois=(
  ["2013"]="10.5281/zenodo.12636522"
  ["2014"]="10.5281/zenodo.12637032"
  ["2015"]="10.5281/zenodo.12655151"
  ["2016"]="10.5281/zenodo.12655179"
  ["2017"]="10.5281/zenodo.12655183"
  ["2018"]="10.5281/zenodo.12655187"
  ["2019"]="10.5281/zenodo.12655716"
  ["2020"]="10.5281/zenodo.12655717"
  ["2021"]="10.5281/zenodo.12655718"
  ["2022"]="10.5281/zenodo.12655719"
)

for year in "${!tornet_dois[@]}"; do
    doi="${tornet_dois[$year]}"
    output_file="$TORNET_ROOT/tornet_${year}.tar.gz/tornet_${year}.tar.gz"
    if [ -f "$output_file" ]; then
        echo "File for Tornet $year already exists at $output_file; skipping download."
    else
        echo "Downloading Tornet $year (DOI: $doi)..."
        zenodo_get --doi "$doi" --output "$output_file"
    fi
done

echo "Download complete. Now extracting files..."

for year in "${!tornet_dois[@]}"; do
    archive="$TORNET_ROOT/tornet_${year}.tar.gz/tornet_${year}.tar.gz"
    if [ -f "$archive" ]; then
        echo "Extracting $archive..."
        tar -xzvf "$archive" -C "$TORNET_ROOT"
    else
        echo "Archive $archive not found; skipping..."
    fi
done

echo "Extraction complete."
echo "Your TORNET_ROOT directory ($TORNET_ROOT) now contains the catalog and the data organized (typically with train/ and test/ directories)."
