from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import os
import urllib.request
from urllib.parse import urlparse

def download_image(url, folder_path):
    try:
        # Header configuration
        opener = urllib.request.build_opener()
        opener.addheaders = [('User-Agent', 'Mozilla/5.0'), 
                             ('Referer', f"https://{url.split('/')[2]}")]
        
        # Request for the extention of the image
        response = opener.open(url)
        content_type = response.headers['Content-Type']
        extension = content_type.split('/')[-1]
        image_name = os.path.basename(urlparse(url).path).split('.')[0]
        
        # If there's no extensions in the image, use extension included in the image file name
        if extension == '':
            if 'jpeg' in image_name:
                image_name += '.jpeg'
            elif 'png' in image_name:
                image_name += '.png'
            else:  # default jpg
                image_name += '.jpg'
        else:
            image_name += f".{extension}"
        
        image_path = os.path.join(folder_path, image_name)
        
        # Name the image file considering it already exists
        num = 1
        while os.path.exists(image_path):
            image_name = os.path.basename(urlparse(url).path).split('.')[0] + f" ({num}).{extension}"
            image_path = os.path.join(folder_path, image_name)
            num += 1
        
        # Download the image
        urllib.request.install_opener(opener)
        urllib.request.urlretrieve(url, image_path)
        print(f"Image download successful: {image_name}")
        
    except Exception as e:
        print(f"Image download failed: {url}")
        print(e)

def crawl_images(keyword, num_images, output_path):
    # Execute Chrome driver
    driver = webdriver.Chrome()

    # Move to the Google image search page
    driver.get(f"https://www.google.com/search?tbm=isch&q={keyword}")
    time.sleep(2)

    # Scroll the page
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    
    # Collect image links
    image_links = set()
    images = driver.find_elements(By.CSS_SELECTOR, ".rg_i.Q4LuWd")
    
    num = 0
    idx = 0
    while num < num_images and idx + 1 < len(images):
        try:
            img = images[idx]
            driver.execute_script("arguments[0].click();", img)  # Select only the first image
            time.sleep(5)
            
            # Extract image links
            image_link = driver.find_element(By.XPATH, "//*[@id='Sva75c']/div[2]/div[2]/div[2]/div[2]/c-wiz/div/div/div/div/div[3]/div[1]/a/img[1]").get_attribute("src")
            if image_link:
                image_links.add(image_link)
                print(num)
                num += 1
                
        except Exception as e:
            print(e)
        
        idx += 1
            
    # If the output folder does not exist, create the folder
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    
    # Download images
    print("=" * 50, "\n", "Image Download\n", "=" * 50)
    for link in image_links:
        download_image(link, output_path)

    driver.quit()

crawl_images(keyword="phone lock screen capture", num_images=100, output_path="./data/data_raw/lock_screen")