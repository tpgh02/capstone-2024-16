import os
from PIL import Image
from tqdm import tqdm


class YoloPreprocess():
    def __init__(self, img_folder, img_size):
        self.folder = img_folder
        self.size = img_size
        
        self.PIL_images = []
        self.save_folder = ""
        
    def run(self):
        print("(>^.^)> START Preprocess (>^.^)>")
        
        self.get_images_as_PIL()
        self.create_save_folder()
        self.resize_images()
        
        print("=" * 50)
        print(f"(>^.^)> Success preprocessing {len(os.listdir(self.save_folder))} images in {self.save_folder}")
        print("=" * 50)
    
    def get_images_from_folder(self):
        image_paths = []
        
        for file in os.listdir(self.folder):
            file_path = os.path.join(self.folder, file)
            if os.path.isfile(file_path):
                image_paths.append(file_path)

        return image_paths
                
    def get_images_as_PIL(self):
        image_paths = self.get_images_from_folder()
        print(f"(>^.^)> image paths in {self.folder} : {len(image_paths)}")
        
        for img_path in image_paths:
            try:
                image = Image.open(img_path).convert("RGB")
            except:
                print(f"Can't open the image {img_path}")
                continue
            
            self.PIL_images.append((img_path, image))
        
        print(f"(>^.^)> PIL images : {len(self.PIL_images)}")
            
    def resize_images(self):
        for img_path, image in tqdm(self.PIL_images):
            width, height = image.size
            ratio = width / height
            
            if width > height:
                new_width = self.size
                new_height = int(self.size / ratio)
            else:
                new_height = self.size
                new_width = int(self.size * ratio)
                
            new_image = Image.new("RGB", (self.size, self.size), "white")
            
            position = ((self.size - new_width) // 2, (self.size - new_height) // 2)
            
            method = Image.Resampling.LANCZOS
            new_image.paste(image.resize((new_width, new_height), method), position)
            
            img_name = os.path.basename(img_path)
            new_image_path = os.path.join(self.save_folder, os.path.splitext(img_name)[0] + ".jpg")
            new_image.save(new_image_path, "jpeg")
        
    def create_save_folder(self):
        if self.folder.endswith("/"):
            self.folder = self.folder[:-1]
        
        dir_name, folder_name = os.path.split(self.folder)
        new_folder_name = folder_name + " preprocessed"
        
        cnt = 1
        while os.path.exists(os.path.join(dir_name, new_folder_name)):
            new_folder_name = f"{folder_name} preprocessed ({cnt})"
            cnt += 1
        
        try:
            save_folder = os.path.join(dir_name, new_folder_name)
            os.mkdir(os.path.join(dir_name, new_folder_name))
            self.save_folder = save_folder
        except Exception as e:
            print(e)
        
        print(f"(>^.^)> The result will be saved in {self.save_folder}")


if __name__ == "__main__":
    yp = YoloPreprocess(img_folder="./treadmill/", img_size=640)
    yp.run()