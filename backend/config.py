import os
from dotenv import load_dotenv
from pathlib import Path
from urllib.parse import quote

load_dotenv(Path(__file__).resolve().parent / ".env")


def normalize_database_url(url: str) -> str:
    """Encode les caractères spéciaux du mot de passe PostgreSQL."""
    if "://" not in url:
        return url
    prefix, remainder = url.split("://", 1)
    if "/" not in remainder:
        return url

    netloc, path = remainder.rsplit("/", 1)
    if "@" not in netloc:
        return url

    userinfo, host = netloc.rsplit("@", 1)
    if ":" not in userinfo:
        return url

    user, password = userinfo.split(":", 1)
    return f"{prefix}://{quote(user, safe='')}:{quote(password, safe='')}@{host}/{path}"


DATABASE_URL = normalize_database_url(
    os.getenv("DATABASE_URL", "")
)
SECRET_KEY = os.getenv("SECRET_KEY", "CHANGEZ_CETTE_CLE_SECRETE")
JWT_EXPIRATION_HOURS = 24
