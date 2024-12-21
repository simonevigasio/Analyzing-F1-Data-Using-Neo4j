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

## Libraries used

- **Python**: Version 3.8 or higher.
- **Libraries**:
  - `pandas`
  - `matplotlib`
  - `seaborn`
  - `neo4j`

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/smbud_project.git
   cd smbud_project
   ```

2. Open the notebook in Jupyter:
   ```bash
   jupyter notebook smbud_project.ipynb
   ```

3. Run each cell sequentially to load data, perform analysis, and generate visualizations.

## Acknowledgments

- Data sourced from this [dataset](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020/data?select=constructors.csv).
- Formula 1 statistics and insights inspired by historical records.

---

Feel free to customize the queries, visualizations, or analyses for your specific needs!
