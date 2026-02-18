import requests
import time

def get_state_with_retry(postal_code, max_retries=3):
    for attempt in range(max_retries):
        try:
            url = f'https://openplzapi.org/de/Localities?postalCode={postal_code}'
            response = requests.get(url, timeout=10)
            
            if response.status_code == 429:  # Rate limit hit
                wait_time = (2 ** attempt) * 2  # 2, 4, 8 seconds
                print(f"Rate limited. Waiting {wait_time}s...")
                time.sleep(wait_time)
                continue
                
            response.encoding = 'utf-8'
            data = response.json()
            
            if data and len(data) > 0:
                return data[0]['federalState']['name']
            return None
            
        except Exception as e:
            if attempt == max_retries - 1:
                return None
            time.sleep(2 ** attempt)
    
    return None

# Use it
states = []
for i, postal_code in enumerate(df_mun['mun_zip']):
    state = get_state_with_retry(postal_code)
    states.append(state)
    
    if i < len(df_mun) - 1:
        time.sleep(0.5)
    
    if (i + 1) % 100 == 0:
        print(f"Processed {i + 1}/{len(df_mun)} rows...")