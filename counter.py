from datetime import datetime
import time


while True:
    now = datetime.now()
    print("Hello!!!")    
    print("Дата:", now.date())
    print("Время:", now.time())
    time.sleep(30)