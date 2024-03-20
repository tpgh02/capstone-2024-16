import matplotlib.pyplot as plt
from easyocr import Reader
import cv2
import os

def image_show(image):
    plt.figure(figsize=(16,10))
    plt.xticks([]), plt.yticks([])
    plt.imshow(image[:,:,::-1])
    plt.show()

def data_reframing(input_folder, output_folder):
    """ Crop only the digital clock part from raw data"""
    
    # Check the input data folder 
    if not os.path.exists(input_folder):
        raise Exception("Data Folder does not exist")
    
    # For all images in the input_folder
    for file in os.listdir(input_folder):
        file_path = os.path.join(input_folder, file)
        image = cv2.imread(file_path)

        # Read text in the image using EasyOCR
        langs = ['ko', 'en']
        reader = Reader(lang_list=langs, gpu=False)
        results = reader.readtext(image)
        
        image_copy = image.copy()
        for i, (bbox, text, prob) in enumerate(results):
            (tl, tr, br, bl) = bbox
            tl = (int(tl[0]), int(tl[1])) # top-left
            br = (int(br[0]), int(br[1])) # bottom-right
            
            # Draw a square in the extracted text area & Numbering index
            cv2.rectangle(image_copy, tl, br, (0, 255, 0), 2)
            cv2.putText(image_copy, str(i), (tl[0]-5, tl[1]-5), 2, 1, (0, 0, 255))

        image_show(image_copy)
        
        num = int(input("number : ")) # Select the box number to crop
        
        # If the text area is not read correctly, skip by entering -1
        if num == -1: continue
        
        # Crop the image
        bbox, _, _ = results[num]
        (tl, tr, br, bl) = bbox
        tl = (int(tl[0]), int(tl[1]))
        br = (int(br[0]), int(br[1]))
        cropped_image = image[tl[1]:br[1], tl[0]:br[0]]
        
        # Save the image
        cv2.imwrite(os.path.join(output_folder, file), cropped_image)       

data_reframing(input_folder="./data/data_time/data/data_reframing.py", output_folder="./data/data_reframed/")