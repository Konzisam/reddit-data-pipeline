# import praw
# from dotenv import load_dotenv
# import os
#
# load_dotenv()
#
# client_id = os.getenv('REDDIT_CLIENT_ID')
# client_secret = os.getenv('REDDIT_SECRET_KEY')
# user_agent = os.getenv('REDDIT_USER_AGENT')
#
# try:
#     reddit = praw.Reddit(client_id=client_id,
#                          client_secret=client_secret,
#                          user_agent='samkons')
#     print("Connected to Reddit!")
#     for submission in reddit.subreddit('python').top(limit=5):
#         print(submission.title)
# except Exception as e:
#     print(f"Error connecting to Reddit: {e}")
import praw
from dotenv import load_dotenv
import os
import time

load_dotenv()

POST_FIELDS = (
    'id',
    'title',
    'score',
    'num_comments',
    'author',
    'created_utc',
    'url',
    'over_18',
    'edited',
    'spoiler',
    'stickied'
)
# Load Reddit credentials from environment variables
client_id = os.getenv('REDDIT_CLIENT_ID')
client_secret = os.getenv('REDDIT_SECRET_KEY')
user_agent = os.getenv('REDDIT_USER_AGENT')

def extract_posts(reddit_instance, subreddit: str, time_filter: str, limit=None):
    subreddit = reddit_instance.subreddit(subreddit)
    posts = subreddit.top(time_filter=time_filter, limit=limit)

    post_lists = []

    for post in posts:
        try:
            post_dict = vars(post)
            post = {key: post_dict[key] for key in POST_FIELDS}
            post_lists.append(post)
        except Exception as e:
            print(f"Error processing post: {e}")
            time.sleep(10)  # Sleep for 10 seconds before retrying to avoid hitting rate limit
    return post_lists

    return post_lists

# Example usage:
if __name__ == "__main__":
    try:
        reddit = praw.Reddit(client_id=client_id,
                             client_secret=client_secret,
                             user_agent='samkons')
        print("Connected to Reddit!")

        # Call the extract_posts function with the desired parameters
        posts = extract_posts(reddit, 'python', 'day', limit=5)
        print(posts)

    except Exception as e:
        print(f"Error connecting to Reddit: {e}")

