import datetime
import os
import argparse
import uuid
import subprocess
import shlex
from music21 import *

import firebase_admin
from basic_pitch.inference import predict_and_save
from fastapi import FastAPI, File, HTTPException, UploadFile, APIRouter
from fastapi.responses import FileResponse, HTMLResponse
from firebase_admin import credentials, storage
from pydantic import BaseModel
from werkzeug.utils import secure_filename
from fastapi.staticfiles import StaticFiles
import mido
from midi2note import midi_to_musicxml, run_command
import requests
from pathlib import Path
from synthesize_midi_file import main as synthesize_midi
from datetime import datetime



cred = credentials.Certificate("serviceAccountKey.json")

firebase_admin.initialize_app(cred, {"storageBucket": "auen-6d3a0.appspot.com"})
bucket = storage.bucket()

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

class ConvertedFile(BaseModel):
    id: str
    url: str
    pdf_url: str

class ConvertedFilesResponse(BaseModel):
    converted_files: list[ConvertedFile]

def home():
    return HTMLResponse(content="<h1>Welcome to the Home Page</h1>", status_code=200)

def delete_files_before_conversion():
    try:
       
        static_path = "static"
        files_path = "static/files"
        converted_path = "static/files/converted"

        for file_path in os.listdir(static_path):
            file_path = os.path.join(static_path, file_path)
            if os.path.isfile(file_path):
                os.remove(file_path)

        for file_path in os.listdir(files_path):
            file_path = os.path.join(files_path, file_path)
            if os.path.isfile(file_path):
                os.remove(file_path)

        for file_path in os.listdir(converted_path):
            file_path = os.path.join(converted_path, file_path)
            if os.path.isfile(file_path):
                os.remove(file_path)

        print("All files in static, static/files, and static/files/converted directories deleted.")
    except Exception as e:
        print(f"Error deleting files: {str(e)}")


def convert_midi_to_pdf(midi_path: str) -> str:
    try:
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        pdf_filename = f"output_{timestamp}.pdf"

        midi_to_musicxml(midi_path, "output.xml")
        run_command("musicxml2ly output.xml")
        run_command("lilypond -o static/files/output output.ly")

        pdf_blob_name = f"pdf/{os.path.basename(pdf_filename)}"
        pdf_blob = bucket.blob(pdf_blob_name)
        pdf_blob.upload_from_filename("static/files/output.pdf")
        print(f"PDF {pdf_blob_name} uploaded to Firebase Storage.")

        pdf_url = pdf_blob.public_url

        os.remove("static/files/output.pdf")
        os.remove("output.xml")
        os.remove("output.ly")

        return pdf_url
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/convert", response_model=ConvertedFile)
async def upload_file(request: UploadFile = File(...)):
    
    delete_files_before_conversion()

    contents = await request.read()
    filename = secure_filename(request.filename)
    file_path = os.path.join("static/files", filename)
    with open(file_path, "wb") as f:
        f.write(contents)

    output_directory = os.path.abspath(os.path.join("static/files", "converted"))
    os.makedirs(output_directory, exist_ok=True)

    save_midi = True
    sonify_midi = False
    save_model_outputs = False
    save_notes = False

    predict_and_save(
        [file_path],
        output_directory,
        save_midi,
        sonify_midi,
        save_model_outputs,
        save_notes,
    )

    
    converted_files = os.listdir(output_directory)
    converted_file_paths = [
        os.path.join(output_directory, filename) for filename in converted_files if filename.endswith('.mid')
    ]

    if len(converted_file_paths) == 0:
        raise HTTPException(status_code=500, detail="Conversion failed. No MIDI file found.")

    converted_file_path = converted_file_paths[0] 

    midi_path = Path(converted_file_path)
    output_audio_path = os.path.splitext(midi_path.name)[0] + ".wav"

    synthesize_command = [
        "python3", "synthesize_midi_file.py",
        "--midi_file", str(midi_path),
        "--out_file", output_audio_path,
    ]

    subprocess.run(synthesize_command, check=True)

    pdf_url = convert_midi_to_pdf(converted_file_path)

    audio_blob_name = f"synthesized/{os.path.basename(converted_file_path)}.wav"
    audio_blob = bucket.blob(audio_blob_name)
    audio_blob.upload_from_filename(output_audio_path)
    print(f"Audio {audio_blob_name} uploaded to Firebase Storage.")

    os.remove(output_audio_path)

    audio_url = audio_blob.public_url

    os.remove(file_path)
    os.remove(converted_file_path)

    return ConvertedFile(id=str(uuid.uuid4()), url=audio_url, pdf_url=pdf_url)


@app.get("/files/")
async def get_all_files():
    try:
        blobs = bucket.list_blobs(prefix="converted/")
        files = [blob.name for blob in blobs]
        return {"files": files}
    except Exception as e:
        raise HTTPException(status_code=404, detail="File not found")


@app.get("/files/{file_name}")
async def get_file_by_name(file_name: str):
    blobs = bucket.list_blobs(prefix="converted/")
    files = [blob.name for blob in blobs]
    if f"converted/{file_name}" not in files:
        raise HTTPException(status_code=404, detail="File not found")
    blob = bucket.blob(f"converted/{file_name}")
    file_url = blob.generate_signed_url(
        version="v4", expiration=datetime.timedelta(minutes=15), method="GET"
    )
    return {"file_name": file_name, "file_url": file_url}


@app.post("/synthesize_midi/")
async def synthesize_midi_endpoint(file: UploadFile = File(...)):
    
    temp_midi_path = "static/files/temp_midi.mid"
    with open(temp_midi_path, "wb") as f:
        f.write(await file.read())

     
    try:
        mido.MidiFile(temp_midi_path)
    except Exception as e:
        os.remove(temp_midi_path)  
        raise HTTPException(status_code=400, detail="Invalid MIDI file. Please upload a valid MIDI file.")

    
    try:
        
        midi_path = Path(temp_midi_path)
        output_path = "static/files/synthesized_audio.wav"

         
        synthesize_command = [
            "python3", "synthesize_midi_file.py",
            "--midi_file", str(midi_path),
            "--out_file", output_path,
        ]

         
        subprocess.run(synthesize_command, check=True)

        
        os.remove(temp_midi_path)

        return output_path

    except Exception as e:
        os.remove(temp_midi_path)  
        raise HTTPException(status_code=500, detail="An error occurred during MIDI synthesis.")




if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)