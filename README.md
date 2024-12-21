# Analyzing-F1-Data-Using-Neo4j
This repository contains a Jupyter Notebook designed to analyze and visualize Formula 1 driver and constructor statistics. It leverages data stored in a graph database and queried using Cypher to uncover trends, insights, and records in the sport's history.

## Features

- **Data Exploration**: Includes queries to retrieve key statistics like:
  - Youngest and oldest champions.
  - Most wins by drivers and constructors.
  - Performance trends over seasons.
  - Circuit-specific achievements.

- **Visualization**: Generates dynamic and insightful visualizations to:
  - Compare drivers' ages and performance.
  - Analyze win percentages and other metrics.
  - Display trends over time.

- **Customizable Queries**: Enables users to dynamically modify parameters (e.g., year, driver, circuit) for tailored analyses.

## Libraries Used

This project is built using Python (version 3.8 or higher) along with the following libraries:

- **`pandas`**: For data manipulation and analysis.
- **`matplotlib`**: For static visualizations and plotting.
- **`seaborn`**: For advanced and aesthetically pleasing data visualizations.
- **`neo4j`**: For connecting to and querying the graph database.
  
## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/simonevigasio/Analyzing-F1-Data-Using-Neo4j.git
   cd  Analyzing-F1-Data-Using-Neo4j
   ```

2. Open the notebook `smbud_project.ipynb`.

3. Run each cell sequentially to load data, perform analysis, and generate visualizations.

## Acknowledgments

- Data sourced from this [dataset](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020/data?select=constructors.csv).
- Formula 1 statistics and insights inspired by historical records.
