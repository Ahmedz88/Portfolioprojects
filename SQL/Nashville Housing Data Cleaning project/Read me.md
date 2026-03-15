Nashville Housing Data Cleaning – SQL Project

Overview

This project focuses on cleaning and preparing a housing dataset using SQL.
The goal is to transform raw housing data into a structured and analysis-ready format.

The project demonstrates practical data cleaning techniques using SQL, including handling missing values, removing duplicates, and standardizing data formats.

Objectives

- Clean and prepare raw housing data
- Standardize inconsistent data formats
- Improve data quality for further analysis
- Practice SQL data cleaning techniques used in real-world projects

Tools Used

- Microsoft SQL Server
- SQL for data transformation and cleaning

Data Cleaning Steps

The following steps were performed in this project:

1. Standardizing Date Format

   - Converted the sale date column into a consistent SQL date format to improve data consistency.

2. Populating Missing Property Address

   - Used existing rows with matching Parcel IDs to populate missing property addresses.

3. Splitting Address Columns

   - Separated the address field into multiple columns such as:

      - Property Address
      - City
      - State

4. Splitting Owner Address

   -Used string functions to divide owner address into:

       - Owner Street
       - Owner City
       - Owner State

5. Standardizing Values

Converted abbreviated values such as:

- Y → Yes
- N → No

6. Removing Duplicate Records

   - Identified and removed duplicate rows using SQL window functions.

7. Removing Unused Columns

   - Dropped unnecessary columns that were not needed for analysis.

Key SQL Skills Demonstrated

- Data cleaning
- Data transformation
- String functions
- Window functions
- Data standardization
- Removing duplicates

Dataset

The dataset contains housing sales data including:

- Parcel ID
- Property Address
- Owner Address
- Sale Price
- Sale Date
- Legal Reference
- Property Details


Purpose of the Project

This project demonstrates the ability to clean raw datasets using SQL, which is a critical step before performing data analysis or building dashboards.


Author
Ahmed Abdelzaher  
PMP-Certified Senior Project & Operations Engineer  
Data Analysis | Excel | SQL | Tableau | Power BI
