from io import BytesIO
import sys
from docx import Document
import fitz
import requests

def read_pdf_from_url(url):
    # Fetch the content of the PDF from the URL
    response = requests.get(url)
    
    # Check if the request was successful
    if response.status_code == 200:
        # Initialize an empty string to store the text
        text = ''
        
        # Open the PDF file using PyMuPDF
        pdf_document = fitz.open(stream=response.content, filetype="pdf")
        
        # Iterate through each page and extract text
        for page_num in range(pdf_document.page_count):
            page = pdf_document.load_page(page_num)
            text += page.get_text().encode("utf-8").decode("utf-8") 
        text = text.encode('utf-8', 'ignore').decode('utf-8') 
        cleaned_str = remove_non_ascii_chars(text)
        return cleaned_str.encode('utf-8')
    else:
        # print(f"Failed to fetch PDF from URL. Status code: {response.status_code}")
        return "None"
    
def read_online_word_document(url):
    # Send a GET request to fetch the Word document
    response = requests.get(url)
    
    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Read the content of the Word document
        docx_content = response.content
        
        # Create a BytesIO object to work with in-memory binary data
        docx_file = BytesIO(docx_content)
        
        # Load the Word document using python-docx
        doc = Document(docx_file)
        
        # Extract text from the Word document
        text = ""
        for paragraph in doc.paragraphs:
            text += paragraph.text + "\n"
        
        cleaned_str = remove_non_ascii_chars(text)
        return cleaned_str.encode('utf-8')
    else:
        # print(f"Failed to fetch Word document. Status code: {response.status_code}")
        return None


def remove_non_ascii_chars(input_str):
    """
    Remove non-ASCII characters from the input string.
    """
    return ''.join(char for char in input_str if ord(char) < 128)


if __name__ == "__main__":
    document_path = sys.argv[1]
    # print("Document path is " + document_path)  # Replace with the path to your document
    
    # # Split the filename by '.' and get the last part as the file extension
    extracted_text = ""

    filename = document_path.split('/')[-1]
    
    # Split the filename by '.' and get the last part as the file extension
    file_extension = filename.split('.')[-1]
    file_extension = file_extension[0:4]
    
    # file_extension =  file_extension.lower()
    # print("File extension is " + file_extension)
    if file_extension == 'pdf?':
        extracted_text = read_pdf_from_url(document_path)
    elif file_extension == 'docx':
        extracted_text = read_online_word_document(document_path)
    elif file_extension == 'xlsx':
        # print("The URL points to an Excel file.")
        demo = ''
    else:
        # print("The file type is unknown.")
        error = ''

    print(extracted_text)