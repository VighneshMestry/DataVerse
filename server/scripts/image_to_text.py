# import requests
# from PIL import Image
# from io import BytesIO
# import pytesseract

# # URL of the online image
# image_url = "https://i.stack.imgur.com/IvV2y.png"

# # Send a GET request to the URL to fetch the image
# response = requests.get(image_url)

# # Check if the request was successful
# if response.status_code == 200:
#     # Open the image from the response content
#     image = Image.open(BytesIO(response.content))

#     # Use pytesseract to do OCR on the image
#     text = pytesseract.image_to_string(image)

#     # Print the extracted text
#     print(text)
# else:
#     print("Failed to fetch the image:", response.status_code)

import cv2
import requests
import numpy as np
import pytesseract

# URL of the online image
image_url = "https://i.stack.imgur.com/IvV2y.png"

# Send a GET request to the URL to fetch the image
response = requests.get(image_url)

# Check if the request was successful
if response.status_code == 200:
    # Convert the image content to a numpy array
    image_array = np.asarray(bytearray(response.content), dtype=np.uint8)
    
    # Decode the numpy array into an OpenCV image
    image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)

    # Use pytesseract to do OCR on the image
    text = pytesseract.image_to_string(image)

    # Print the extracted text
    print(text)
else:
    print("Failed to fetch the image:", response.status_code)
