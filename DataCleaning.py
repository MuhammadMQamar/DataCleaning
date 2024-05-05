import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.ticker as mtick

try:
    # Connect to your postgres DB
    conn = psycopg2.connect(
        dbname="DataCleaning", 
        user="postgres", 
        password="", #Hidden for security
        host="localhost", 
        port="5432"
    )
    
    print("Database connection successful")
    
    # Use pandas to execute SQL query and store the result in a DataFrame
    df = pd.read_sql_query('SELECT * FROM datacleaning', conn)

    # Convert 'saleprice' to numeric
    df['saleprice'] = pd.to_numeric(df['saleprice'], errors='coerce')

    # Filter DataFrame to include only properties with sale prices between $50,000 and $100,000
    df_filtered = df[(df['saleprice'] >= 50000) & (df['saleprice'] <= 100000)]

    # Distribution of sale prices
    plt.figure(figsize=(10,6))
    ax = sns.histplot(df_filtered['saleprice'], kde=True, color='skyblue', binwidth=5000)
    plt.title('Distribution of Sale Prices ($50k - $100k)', fontsize=16)
    plt.ylabel('Frequency', fontsize=14)
    plt.xticks([50000, 60000, 70000, 80000, 90000, 100000], ['$50k', '$60k', '$70k', '$80k', '$90k', '$100k'], fontsize=10)
    ax.yaxis.set_major_formatter(mtick.StrMethodFormatter('{x:,.0f}'))
    sns.despine()
    plt.tight_layout()
    plt.show()


    # Number of properties sold as vacant or not
    plt.figure(figsize=(10,6))
    ax = sns.countplot(x='soldasvacant', data=df, palette="viridis")
    plt.title('Count of Properties Sold as Vacant', fontsize=16)
    plt.ylabel('Number of Properties', fontsize=14)
    plt.xticks(fontsize=10)
    ax.yaxis.set_major_formatter(mtick.StrMethodFormatter('{x:,.0f}'))
    sns.despine()
    plt.tight_layout()
    plt.show()

    # Number of properties in each city
    city_counts = df['PropertySplitCity'].value_counts()
    city_counts = city_counts[:10]  # Limit to top 10 cities
    plt.figure(figsize=(10,6))
    ax = sns.barplot(x=city_counts.index, y=city_counts.values, palette="viridis")
    plt.title('Number of Properties in Each City (Top 10)', fontsize=16)
    plt.ylabel('Number of Properties', fontsize=14)
    plt.xticks(rotation=45, ha='right', fontsize=10)
    ax.yaxis.set_major_formatter(mtick.StrMethodFormatter('{x:,.0f}'))
    sns.despine()
    plt.tight_layout()
    plt.show()
    
except Exception as e:
    print("Unable to connect to the database")
    print(e)
