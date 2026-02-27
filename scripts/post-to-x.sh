#!/usr/bin/env bash
# Post a tweet via X API v2
# Requires: X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_TOKEN_SECRET
# Usage: bash scripts/post-to-x.sh "Tweet text here"

set -euo pipefail

TWEET_TEXT="${1:?Usage: post-to-x.sh <tweet-text>}"

# Validate credentials exist
for var in X_API_KEY X_API_SECRET X_ACCESS_TOKEN X_ACCESS_TOKEN_SECRET; do
  if [ -z "${!var:-}" ]; then
    echo "Error: $var is not set"
    exit 1
  fi
done

# Generate OAuth 1.0a signature
# Using Python for reliable OAuth signing
python3 << 'PYEOF'
import os, sys, json, time, hmac, hashlib, base64, urllib.parse, urllib.request, secrets

tweet_text = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("TWEET_TEXT", "")

api_key = os.environ["X_API_KEY"]
api_secret = os.environ["X_API_SECRET"]
access_token = os.environ["X_ACCESS_TOKEN"]
access_secret = os.environ["X_ACCESS_TOKEN_SECRET"]

url = "https://api.x.com/2/tweets"
method = "POST"

# OAuth parameters
oauth_params = {
    "oauth_consumer_key": api_key,
    "oauth_nonce": secrets.token_hex(16),
    "oauth_signature_method": "HMAC-SHA256",
    "oauth_timestamp": str(int(time.time())),
    "oauth_token": access_token,
    "oauth_version": "1.0"
}

# Create signature base string
params_str = "&".join(f"{urllib.parse.quote(k, safe='')}={urllib.parse.quote(v, safe='')}"
                      for k, v in sorted(oauth_params.items()))
base_string = f"{method}&{urllib.parse.quote(url, safe='')}&{urllib.parse.quote(params_str, safe='')}"

# Sign
signing_key = f"{urllib.parse.quote(api_secret, safe='')}&{urllib.parse.quote(access_secret, safe='')}"
signature = base64.b64encode(
    hmac.new(signing_key.encode(), base_string.encode(), hashlib.sha256).digest()
).decode()

oauth_params["oauth_signature"] = signature

# Build Authorization header
auth_header = "OAuth " + ", ".join(
    f'{urllib.parse.quote(k, safe="")}="{urllib.parse.quote(v, safe="")}"'
    for k, v in sorted(oauth_params.items())
)

# Post tweet
payload = json.dumps({"text": tweet_text}).encode()
req = urllib.request.Request(url, data=payload, method="POST")
req.add_header("Authorization", auth_header)
req.add_header("Content-Type", "application/json")

try:
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())
        tweet_id = result.get("data", {}).get("id", "unknown")
        print(f"Tweet posted: https://x.com/i/status/{tweet_id}")
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f"Error {e.code}: {body}", file=sys.stderr)
    sys.exit(1)
PYEOF
