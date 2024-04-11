from flask import Flask

def create_app():
    app = Flask(__name__)

    from app.study import study_bp
    app.register_blueprint(study_bp, url_prefix='/ai')

    return app