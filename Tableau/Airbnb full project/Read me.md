Airbnb Pricing Analysis – Tableau Dashboard
This repository contains a Tableau project that analyzes Airbnb listing prices. It explores how average prices vary by zipcode, bedroom count, and year.
Overview
The main goals of this project are to:
• Visualize the average listing price by zipcode.
• Understand how price changes with the number of bedrooms.
• Examine price trends over time based on listing year.
All visualizations are created in Tableau Desktop Public Edition and can be published to Tableau Public.
Data
• Source: Airbnb listings for Seattle from an open dataset (e.g., Kaggle or Inside Airbnb).
• Format: xlsx file.
• Key fields:
 • zipcode – Zip code of the listing
 • price – Nightly price
 • bedrooms – Number of bedrooms
 • date or year – Used to derive the year dimension
The main Tableau dashboard includes:
1. Avg Price by Zipcode Map
 • A map of Seattle zipcodes colored by average listing price.
2. Avg Price by Zipcode (Bar Chart)
 • Bars sorted by average price to highlight the most and least expensive zipcodes.
3. Avg Price per Bedroom (Bar Chart)
 • Average price for listings with 1, 2, 3+ bedrooms.
4. Avg Price per Bedroom (Table)
 • A text table with bedroom count, number of listings, and average price for precise values.
5. Avg Price by Year (Bubble Chart)
 • One bubble per year, sized or colored by the average price for that year.
