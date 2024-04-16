# Argument
import argparse
parser = argparse.ArgumentParser(description="Choose host of AI server")
parser.add_argument('--localhost', '-l', action='store_true', help='Option selected, it runs as localhost')
args = parser.parse_args()


if __name__ == "__main__":
    import uvicorn
    
    if args.localhost:  # localhost
        uvicorn.run("app.main:app", host="127.0.0.1", port=8080)
    else:  # AWS host
        uvicorn.run("app.main:app", host="0.0.0.0", port=8080)