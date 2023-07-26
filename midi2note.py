import os
import subprocess
import shlex
from music21 import *


def run_command(command):
    try:
        result = subprocess.run(
            shlex.split(command),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Command execution failed: {e.stderr.strip()}")

def midi_to_musicxml(midi_file_path, xml_file_path):
    # Load MIDI file
    mf = midi.MidiFile()
    mf.open(midi_file_path)
    mf.read()
    mf.close()

    # Create a stream from the MIDI data
    midi_stream = midi.translate.midiFileToStream(mf)

    # Convert MIDI stream to MusicXML
    midi_stream.write("musicxml", xml_file_path)