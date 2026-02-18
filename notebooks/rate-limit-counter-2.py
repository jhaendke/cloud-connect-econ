# Process in chunks and save progress
CHUNK_SIZE = 100

for chunk_start in range(0, len(df_mun), CHUNK_SIZE):
    chunk_end = min(chunk_start + CHUNK_SIZE, len(df_mun))
    
    for i in range(chunk_start, chunk_end):
        if pd.notna(df_mun.at[i, 'state']):  # Skip if already filled
            continue
            
        postal_code = df_mun.at[i, 'mun_zip']
        state = get_state_with_retry(postal_code)
        df_mun.at[i, 'state'] = state
        
        time.sleep(0.5)
    
    # Save after each chunk
    df_mun.to_csv('../data/processed/municipalities_progress.csv', 
                  index=False, encoding='utf-8')
    print(f"Saved progress: {chunk_end}/{len(df_mun)} rows")
    time.sleep(5)  # Extra pause between chunks