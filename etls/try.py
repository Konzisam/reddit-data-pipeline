import praw
from dotenv import load_dotenv
import os

load_dotenv()

client_id = os.getenv('REDDIT_CLIENT_ID')
client_secret = os.getenv('REDDIT_SECRET_KEY')
user_agent = os.getenv('REDDIT_USER_AGENT')

try:
    reddit = praw.Reddit(client_id=client_id,
                         client_secret=client_secret,
                         user_agent='samkons')
    print("Connected to Reddit!")
    for submission in reddit.subreddit('python').top(limit=5):
        print(submission.title)
except Exception as e:
    print(f"Error connecting to Reddit: {e}")
