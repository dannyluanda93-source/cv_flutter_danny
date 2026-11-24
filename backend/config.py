import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:MON_MOT_DE_PASSE@aws-0-eu-central-1.pooler.supabase.com:6543/postgres",
)
SECRET_KEY = os.getenv("SECRET_KEY", "SECRET_KEY_TEST_A_REMPLACER")
JWT_EXPIRATION_HOURS = 24
