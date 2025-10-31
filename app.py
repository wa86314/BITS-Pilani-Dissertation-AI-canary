from fastapi import FastAPI
from transformers import pipeline
from fastapi.responses import HTMLResponse

app = FastAPI()
fill_mask = pipeline("fill-mask", model="bert-base-uncased")

@app.get("/")
def root():
    return {"status": "Service is up and running"}

@app.get("/predict",response_class=HTMLResponse)
def predict(text: str):
    dataset = fill_mask(text)
    html = "<body>"
    for data in dataset:
        html += f"<p>Sequence: {data['sequence']}, Score: {data['score']}</p>"
    html += "</body>"
    return html
