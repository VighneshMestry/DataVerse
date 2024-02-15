import sys
from PyPDF2 import PdfReader
from docx import Document
from pptx import Presentation
import openpyxl
import os

# Function to extract text from a PDF file
def extract_text_from_pdf(pdf_path):
    try:
        with open(pdf_path, 'rb') as file:
            pdf_reader = PdfReader(file)
            text = ''
            for page in pdf_reader.pages:
                text += page.extract_text()
            return text
    except Exception as e:
        print(f'Error extracting text from PDF: {e}')
        return ''

# Function to extract text from a DOCX file
def extract_text_from_docx(docx_path):
    try:
        doc = Document(docx_path)
        text = ''
        for paragraph in doc.paragraphs:
            text += paragraph.text
        return text
    except Exception as e:
        print(f'Error extracting text from DOCX: {e}')
        return ''

# Function to extract text from a PPTX file
def extract_text_from_pptx(pptx_path):
    try:
        presentation = Presentation(pptx_path)
        text = ''
        for slide in presentation.slides:
            for shape in slide.shapes:
                if hasattr(shape, 'text'):
                    text += shape.text
        return text
    except Exception as e:
        print(f'Error extracting text from PPTX: {e}')
        return ''

# Function to extract text from an Excel file
def extract_text_from_excel(excel_path):
    try:
        wb = openpyxl.load_workbook(excel_path)
        text = ''
        for sheet_name in wb.sheetnames:
            sheet = wb[sheet_name]
            for row in sheet.iter_rows():
                for cell in row:
                    if cell.value:
                        text += str(cell.value) + '\n'
            text += '\n'
        return text
    except Exception as e:
        print(f'Error extracting text from Excel: {e}')
        return ''

# Function to extract text from any supported document type
def extract_text_from_document(document_path):
    file_extension = os.path.splitext(document_path)[1].lower()
    if file_extension == '.pdf':
        return extract_text_from_pdf(document_path)
    elif file_extension == '.docx':
        return extract_text_from_docx(document_path)
    elif file_extension == '.pptx':
        return extract_text_from_pptx(document_path)
    elif file_extension in ['.xlsx', '.xls']:
        return extract_text_from_excel(document_path)
    else:
        print('Unsupported document type')
        return ''


if __name__ == "__main__":
    document_path = sys.argv[1]  # Replace with the path to your document
    extracted_text = extract_text_from_document(document_path)
    print(extracted_text)


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