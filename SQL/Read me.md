Global Power Plants Analysis & Generation Estimation

Project Overview

This project analyzes global power plant data to uncover insights about energy production, fuel mix, and plant performance. It focuses on actual vs estimated generation, capacity utilization, and energy trends across countries and fuel types.

The analysis is based on the Global Power Plant Database, which includes detailed information on power plants worldwide such as capacity, fuel type, and electricity generation.


Objectives

Analyze global electricity generation by country and fuel type
Compare actual generation vs estimated generation
Calculate capacity factor as a key performance indicator
Identify top-performing and underperforming power plants
Evaluate renewable vs non-renewable energy contribution
Assess generation growth trends over time


Dataset Description

The dataset contains the following key fields:

`name` – Power plant name
`country_long` – Country
`primary_fuel` – Main energy source
`capacity_mw` – Installed capacity (MW)
`generation_gwh_2013–2017` – Annual electricity generation
`estimated_generation_gwh` – Estimated annual generation
`commissioning_year` – Year of operation start
`latitude`, `longitude` – Location


Methodology

1. Data Cleaning

Removed null and invalid values
Standardized fuel types
Validated capacity and generation fields

2. Feature Engineering

Capacity Factor Calculation

  Capacity Factor = Actual Generation / (Capacity × 8760)

Forecast Error

  Error (%) = (Actual - Estimated) / Estimated

Classified plants into:

  Renewable (Solar, Wind, Hydro)
  Non-renewable (Coal, Gas, Oil, Nuclear)


Key Analysis

Global Generation Trends

Total generation analyzed across multiple years (2013–2017)
Identified year-over-year growth patterns

Fuel Mix Analysis

Compared contribution of different energy sources
Observed dominance of fossil fuels vs growth in renewables

Country-Level Insights

Ranked countries by total generation
Evaluated renewable energy share per country

Performance Metrics

Capacity factor per plant and fuel type
Identification of high-efficiency plants

Forecast Accuracy

Compared actual vs estimated generation
Highlighted plants with highest deviation



Tools & Technologies

SQL (Data analysis & transformation)
Excel / CSV (Data source handling)



Sample Insights

A small number of plants contribute significantly to total generation
Nuclear and coal plants typically show higher capacity factors
Renewable energy shows rapid growth but lower utilization rates
Forecast models may significantly over/underestimate generation


How to Use

1. Import dataset into your SQL database
2. Run the provided SQL queries for analysis
3. (Optional) Connect to Power BI for visualization
4. Explore insights and build dashboards



Future Enhancements

Add CO₂ emissions estimation per plant
Integrate real-time generation data
Develop predictive models for generation forecasting
Build interactive dashboards



Author
Ahmed Abdelzaher  
PMP-Certified Senior Project & Operations Engineer  
Data Analysis | Excel | SQL | Tableau | Power BI


License

This project is for educational and analytical purposes using publicly available data.
