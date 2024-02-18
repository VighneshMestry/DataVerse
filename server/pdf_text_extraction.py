# import io
from io import BytesIO
import sys
from docx import Document
# from PyPDF2 import PdfFileReader, PdfReader
# from docx import Document
# from pptx import Presentation
# import openpyxl
# import os
import fitz
import pdfplumber

import requests

# Function to extract text from a PDF file
# def extract_text_from_pdf(pdf_path):
#     # try:
#     #     with open(pdf_path, 'rb') as file:
#     #         pdf_reader = PdfReader(file)
#     #         text = ''
#     #         for page in pdf_reader.pages:
#     #             text += page.extract_text()
#     #         return text
#     # except Exception as e:
#     #     print(f'Error extracting text from PDF: {e}')
#     #     return ''
#     try:
#         response = requests.get(pdf_path)
#         with io.BytesIO(response.content) as stream:
#             pdf_reader = PdfReader(stream)
#             text = ''
#             for page in pdf_reader.pages:
#                 text += page.extract_text()
#             return text
#     except Exception as e:
#         print(f'Error extracting text from PDF: {e}')
#         return ''

# # Function to extract text from a DOCX file
# def extract_text_from_docx(docx_path):
#     try:
#         doc = Document(docx_path)
#         text = ''
#         for paragraph in doc.paragraphs:
#             text += paragraph.text
#         return text
#     except Exception as e:
#         print(f'Error extracting text from DOCX: {e}')
#         return ''

# # Function to extract text from a PPTX file
# def extract_text_from_pptx(pptx_path):
#     try:
#         presentation = Presentation(pptx_path)
#         text = ''
#         for slide in presentation.slides:
#             for shape in slide.shapes:
#                 if hasattr(shape, 'text'):
#                     text += shape.text
#         return text
#     except Exception as e:
#         print(f'Error extracting text from PPTX: {e}')
#         return ''

# # Function to extract text from an Excel file
# def extract_text_from_excel(excel_path):
#     try:
#         wb = openpyxl.load_workbook(excel_path)
#         text = ''
#         for sheet_name in wb.sheetnames:
#             sheet = wb[sheet_name]
#             for row in sheet.iter_rows():
#                 for cell in row:
#                     if cell.value:
#                         text += str(cell.value) + '\n'
#             text += '\n'
#         return text
#     except Exception as e:
#         print(f'Error extracting text from Excel: {e}')
#         return ''
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
            text += page.get_text().encode("utf-8").decode("utf-8") #
        text = text.encode('utf-8', 'ignore').decode('utf-8') #
        # print(text)
        # cleaned_text = ''.join(char for char in text if char.isprintable())
        cleaned_str = remove_non_ascii_chars(text)
        return cleaned_str.encode('utf-8')
        
        # send_text_to_nodejs_api(cleaned_text)
        # return cleaned_text

        # return text
    else:
        print(f"Failed to fetch PDF from URL. Status code: {response.status_code}")
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
        print(f"Failed to fetch Word document. Status code: {response.status_code}")
        return None


def remove_non_ascii_chars(input_str):
    """
    Remove non-ASCII characters from the input string.
    """
    return ''.join(char for char in input_str if ord(char) < 128)

    
# Function to extract text from any supported document type
# def extract_text_from_document(document_path):
#     file_extension = os.path.splitext(document_path)[1].lower()
#     if file_extension == '.pdf':
#         return extract_text_from_pdf(document_path)
#     elif file_extension == '.docx':
#         return extract_text_from_docx(document_path)
#     elif file_extension == '.pptx':
#         return extract_text_from_pptx(document_path)
#     elif file_extension in ['.xlsx', '.xls']:
#         return extract_text_from_excel(document_path)
#     else:
#         print('Unsupported document type')
#         return ''


if __name__ == "__main__":
    document_path = sys.argv[1]
    print("Extension")  # Replace with the path to your document

    filename = document_path.split('/')[-1]
    
    # Split the filename by '.' and get the last part as the file extension
    file_extension = filename.split('.')[-1]
    file_extension = file_extension[0:4]
    print(file_extension)
    extracted_text = ""

    if file_extension == 'pdf?':
        extracted_text = read_pdf_from_url(document_path)
    elif file_extension == 'docx':
        extracted_text = read_online_word_document(document_path)
    elif file_extension == 'xlsx':
        print("The URL points to an Excel file.")
    else:
        print("The file type is unknown.")
    # print(document_path)
    # extracted_text = extract_text_from_document(document_path)
    # extracted_text = read_pdf_from_url(document_path)
    


    # extracted_text = extracted_text.encode('utf-8', 'ignore').decode('utf-8')
    # print("Exectued")
    print(extracted_text)
    # if extracted_text is not None:
    # # Print the extracted text, ignoring encoding errors
    #     print(extracted_text.encode('utf-8', 'ignore').decode('utf-8'))
    # else:
    #     print("Failed to read PDF from URL.")


# from PyPDF2 import PdfReader
# from docx import Document
# from pptx import Presentation
# import openpyxl
# import requests
# import io

# # Function to extract text from a PDF file
# def extract_text_from_pdf(pdf_url):
#     try:
#         response = requests.get(pdf_url)
#         with io.BytesIO(response.content) as stream:
#             pdf_reader = PdfReader(stream)
#             text = ''
#             for page in pdf_reader.pages:
#                 text += page.extract_text()
#             return text
#     except Exception as e:
#         print(f'Error extracting text from PDF: {e}')
#         return ''

# # Function to extract text from a DOCX file
# def extract_text_from_docx(docx_url):
#     try:
#         response = requests.get(docx_url)
#         with io.BytesIO(response.content) as stream:
#             doc = Document(stream)
#             text = ''
#             for paragraph in doc.paragraphs:
#                 text += paragraph.text
#             return text
#     except Exception as e:
#         print(f'Error extracting text from DOCX: {e}')
#         return ''

# # Function to extract text from a PPTX file
# def extract_text_from_pptx(pptx_url):
#     try:
#         response = requests.get(pptx_url)
#         with io.BytesIO(response.content) as stream:
#             presentation = Presentation(stream)
#             text = ''
#             for slide in presentation.slides:
#                 for shape in slide.shapes:
#                     if hasattr(shape, 'text'):
#                         text += shape.text
#             return text
#     except Exception as e:
#         print(f'Error extracting text from PPTX: {e}')
#         return ''

# # Function to extract text from an Excel file
# def extract_text_from_excel(excel_url):
#     try:
#         response = requests.get(excel_url)
#         with io.BytesIO(response.content) as stream:
#             wb = openpyxl.load_workbook(stream)
#             text = ''
#             for sheet_name in wb.sheetnames:
#                 sheet = wb[sheet_name]
#                 for row in sheet.iter_rows():
#                     for cell in row:
#                         if cell.value:
#                             text += str(cell.value) + '\n'
#                 text += '\n'
#             return text
#     except Exception as e:
#         print(f'Error extracting text from Excel: {e}')
#         return ''

# # Function to extract text from any supported document type
# def extract_text_from_document(document_url):
#     file_extension = document_url.split('.')[-1].lower()
#     if file_extension == 'pdf':
#         return extract_text_from_pdf(document_url)
#     elif file_extension == 'docx':
#         return extract_text_from_docx(document_url)
#     elif file_extension == 'pptx':
#         return extract_text_from_pptx(document_url)
#     elif file_extension in ['xlsx', 'xls']:
#         return extract_text_from_excel(document_url)
#     else:
#         print('Unsupported document type')
#         return ''