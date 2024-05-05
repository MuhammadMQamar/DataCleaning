# Real Estate Data Analysis

This repository contains a Python script for analyzing real estate data. The script connects to a PostgreSQL database, extracts data, performs some cleaning and filtering, and then generates several visualizations.

## Dependencies

The script requires the following Python libraries:
- psycopg2
- pandas
- matplotlib
- seaborn

## Database Connection

The script connects to a PostgreSQL database named "DataCleaning" on localhost. The username is "postgres", and the password is hidden for security reasons. Please replace with your actual database password before running the script.

## Data Extraction and Cleaning

The script uses pandas to execute a SQL query that selects all records from the "datacleaning" table in the database. The 'saleprice' column in the DataFrame is converted to numeric values, with any errors coerced.

## Data Filtering

The DataFrame is filtered to include only properties with sale prices between $50,000 and $100,000.

## Visualizations

The script generates the following visualizations:

1. **Distribution of Sale Prices**: A histogram showing the distribution of sale prices for properties within the $50k - $100k range.
2. **Count of Properties Sold as Vacant**: A bar chart showing the number of properties sold as vacant or not.
3. **Number of Properties in Each City**: A bar chart showing the number of properties in each city, limited to the top 10 cities.

## Error Handling

In case of any exceptions (like connection issues), the script will print "Unable to connect to the database" along with the error message.

## Note

To run this code, you need to have the psycopg2, pandas, matplotlib, seaborn libraries installed, and you need to replace the password with your actual database password. Also, the database and table should exist and be accessible. The columns used ('saleprice', 'soldasvacant', 'PropertySplitCity') should also exist in the 'datacleaning' table. If any of these conditions are not met, the code may not run as expected.
