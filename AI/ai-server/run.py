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
        # get host and port from config.json
        import json
        with open("config.json", "r") as f:
            ai_ip = json.load(f)['ai']
        
        uvicorn.run("app.main:app", host=ai_ip['ip'], port=ai_ip['port'])