CREATE TABLE Dim_Category (
    category_key SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Dim_Coin (
    coin_key SERIAL PRIMARY KEY,
    category_key INT REFERENCES Dim_Category(category_key),
    coin_id VARCHAR(50) NOT NULL,
    symbol VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week INT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    week_of_year INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL
);

CREATE TABLE Fact_Market_Performance (
    date_key INT NOT NULL REFERENCES Dim_Date(date_key),
    coin_key INT NOT NULL REFERENCES Dim_Coin(coin_key),
    
    open_price DECIMAL(24, 8),
    high_price DECIMAL(24, 8),
    low_price DECIMAL(24, 8),
    close_price DECIMAL(24, 8),
    volume DECIMAL(24, 8),
    market_cap DECIMAL(24, 8),
    market_cap_rank INT,
    
    data_source VARCHAR(20) NOT NULL, 
    ingestion_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (date_key, coin_key)
);