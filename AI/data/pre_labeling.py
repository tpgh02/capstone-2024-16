from easyocr import Reader
import cv2
import os
from tqdm import tqdm

def pre_labeling(folder):
    """
        Pre-labeling using EasyOCR
        The images must be in folder/images/
    """
    
    # Prepare gt.txt
    txt_path = os.path.join(folder, "gt.txt")
    if os.path.exists(txt_path):
        os.remove(txt_path)
    
    for file in tqdm(os.listdir(os.path.join(folder, "images/"))):
        file_path = os.path.join(folder, "images/", file)
        image = cv2.imread(file_path)

        # Read text in the image using EasyOCR
        reader = Reader(lang_list=['en'], gpu=False)
        results = reader.readtext(image)
        
        # Write the text file in LMDB format.
        if len(results) > 0:
            _, text, _ = results[0]
            with open(txt_path, "a") as f:
                f.write(f"images/{file}\t{text}\n")
        else:  # If the OCR failed 
            with open(txt_path, "a") as f:
                f.write(f"images/{file}\t????\n")  # Write "???"

pre_labeling(folder="./data/data_lmdb/train/")           
pre_labeling(folder="./data/data_lmdb/test/")