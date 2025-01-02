import sys
import time
import numpy as np
import pandas as pd
import praw
from praw import Reddit

from utils.constants import POST_FIELDS


def connect_reddit(client_id, client_secret, user_agent) -> Reddit:
    try:
        reddit = praw.Reddit(client_id=client_id,
                             client_secret=client_secret,
                             user_agent=user_agent)
        print("connected to reddit!")
        return reddit
    except Exception as e:
        print(e)
        print("failed to connect")
        sys.exit(1)


def extract_posts(reddit_instance: Reddit, subreddit: str, time_filter: str, limit=None):
    subreddit = reddit_instance.subreddit(subreddit)
    posts = subreddit.top(time_filter=time_filter, limit=limit)
    print(list(posts))
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


def transform_data(post_df: pd.DataFrame):
    post_df['created_utc'] = pd.to_datetime(post_df['created_utc'], unit='s')
    post_df['over_18'] = np.where((post_df['over_18'] == True), True, False)
    post_df['author'] = post_df['author'].astype(str)
    edited_mode = post_df['edited'].mode()
    post_df['edited'] = np.where(post_df['edited'].isin([True, False]),
                                 post_df['edited'], edited_mode).astype(bool)
    post_df['num_comments'] = post_df['num_comments'].astype(int)
    post_df['score'] = post_df['score'].astype(int)
    post_df['title'] = post_df['title'].astype(str)
    print(post_df.info())


    return post_df


def load_data_to_csv(data: pd.DataFrame, path: str):
    data.to_csv(path, index=False)
    print("completed tasks!!!!!")

# replace saving data to memory with temporary files
# def load_data_to_s3(data: pd.DataFrame, s3: s3fs.S3FileSystem, bucket: str, s3_file_name: str):
#     # Create a temporary file
#     with tempfile.NamedTemporaryFile(suffix='.csv', delete=True) as temp_file:
#         temp_file_path = temp_file.name
#
#         # Save data to the temporary file
#         data.to_csv(temp_file_path, index=False)
#         print(f"Data written to temporary file: {temp_file_path}")
#
#         # Upload the temporary file to S3
#         s3.put(temp_file_path, f'{bucket}/raw/{s3_file_name}')
#         print(f"File uploaded to S3: {bucket}/raw/{s3_file_name}")