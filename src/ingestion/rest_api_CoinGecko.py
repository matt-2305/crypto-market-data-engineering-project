import requests
import pandas as pd
import time

def get_coin_metadata():
    """
    Fetch top cryptocurrency metadata from CoinGecko.

    Input:
        None. The function uses fixed API query parameters
        (`vs_currency='usd'`, first page, top 250 by market cap).

    Output:
        pandas.DataFrame | None:
        - DataFrame with `id`, `symbol`, `name`, `market_cap_rank`,
          and `circulating_supply` when the request succeeds.
        - None when an error occurs.
    """
    # CoinGecko endpoint returning market data for top coins.
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {
        "vs_currency": "usd",
        "order": "market_cap_desc",
        "per_page": 250, # Fetch top 250 coins.
        "page": 1,
        "sparkline": False
    }
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status() # Raise an exception for HTTP errors.
        data = response.json()
        
        # Convert API response list to a DataFrame.
        df = pd.DataFrame(data)
        
        # Keep only required fields for the coin dimension table.
        metadata = df[['id', 'symbol', 'name', 'market_cap_rank', 'circulating_supply']]
        return metadata
    
    except Exception as e:
        print(f"Error while fetching coin metadata: {e}")
        return None

# Run extraction and save to CSV as an intermediate file before loading to SQL.
metadata_df = get_coin_metadata()
if metadata_df is not None:
    metadata_df.to_csv("data/raw/dim_coin.csv", index=False)
    print("Dim_Coin saved successfully.")