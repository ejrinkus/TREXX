import twitter
import sys
from twitter.api import Twitter

# Parser for command-line arguments.
parser = argparse.ArgumentParser(
    description=__doc__,
    formatter_class=argparse.RawDescriptionHelpFormatter,
    parents=[tools.argparser])

def main(argv):
twitter = Twitter('username','password')
twitter.statuses.update(status='I am tweeting from Python!')
